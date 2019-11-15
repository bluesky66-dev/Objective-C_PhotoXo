//
//  CLAdjustmentTool.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLAdjustmentTool.h"

@implementation CLAdjustmentTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UISlider *_saturationSlider;
    UISlider *_brightnessSlider;
    UISlider *_contrastSlider;
    UIActivityIndicatorView *_indicatorView;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLAdjustmentTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Lighting", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    //_thumnailImage = [_originalImage resize:self.editor.imageView.frame.size];
    _thumnailImage = [_originalImage resize:CGSizeMake(self.editor.imageView.frame.size.width*2,self.editor.imageView.frame.size.height*2)];

    
    //[self.editor fixZoomScaleWithAnimated:YES];
    
    [self setupSlider];
}

- (void)cleanup
{
    [_indicatorView removeFromSuperview];
    [_saturationSlider.superview removeFromSuperview];
    [_brightnessSlider.superview removeFromSuperview];
    [_contrastSlider.superview removeFromSuperview];
    
    //[self.editor resetZoomScaleWithAnimated:YES];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [CLImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark- 

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 240, 35)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.view addSubview:container];
    
    return slider;
}

- (void)setupSlider
{
    _saturationSlider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1 action:@selector(sliderDidChange:)];
    _saturationSlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.view.height-30);
    [_saturationSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"exposure"] forState:UIControlStateNormal];
    [_saturationSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"exposure"] forState:UIControlStateHighlighted];
    
    _brightnessSlider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1 action:@selector(sliderDidChange:)];
    _brightnessSlider.superview.center = CGPointMake(20, _saturationSlider.superview.top - 150);
    _brightnessSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    [_brightnessSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"brightness.png"] forState:UIControlStateNormal];
    [_brightnessSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"brightness.png"] forState:UIControlStateHighlighted];
    
    _contrastSlider = [self sliderWithValue:1 minimumValue:0.5 maximumValue:1.5 action:@selector(sliderDidChange:)];
    _contrastSlider.superview.center = CGPointMake(self.editor.view.width-20, _brightnessSlider.superview.center.y);
    _contrastSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    [_contrastSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"contrast.png"] forState:UIControlStateNormal];
    [_contrastSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"contrast.png"] forState:UIControlStateHighlighted];
}

- (void)sliderDidChange:(UISlider*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_thumnailImage];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_saturationSlider.value] forKey:@"inputEV"];
    
    NSLog(@"Bright: %f",_brightnessSlider.value/5);
    NSLog(@"Contrast: %f",_contrastSlider.value);
    NSLog(@"Exposure: %f",_saturationSlider.value);
    
    filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:(_brightnessSlider.value/5)] forKey:@"inputBrightness"];
    
    filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = _contrastSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end
