//
//  CLAdjustmentTool2.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLAdjustmentTool2.h"

@implementation CLAdjustmentTool2
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UISlider *_saturationSlider;
    UISlider *_temperaturSlider;
    UISlider *_gammaSlider;
    UIActivityIndicatorView *_indicatorView;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLAdjustmentTool2_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Color", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 1;
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
    [_temperaturSlider.superview removeFromSuperview];
    [_gammaSlider.superview removeFromSuperview];
    
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
    _saturationSlider = [self sliderWithValue:1 minimumValue:0 maximumValue:2 action:@selector(sliderDidChange:)];
    _saturationSlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.view.height-30);
    [_saturationSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"saturation"] forState:UIControlStateNormal];
    [_saturationSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"saturation"] forState:UIControlStateHighlighted];
    
    _temperaturSlider = [self sliderWithValue:1 minimumValue:0.5 maximumValue:1.5 action:@selector(sliderDidChange:)];
    _temperaturSlider.superview.center = CGPointMake(20, _saturationSlider.superview.top - 150);
    _temperaturSlider.superview.transform = CGAffineTransformMakeRotation(M_PI * 270 / 180.0f);
    [_temperaturSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"temperature.png"] forState:UIControlStateNormal];
    [_temperaturSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"temperature.png"] forState:UIControlStateHighlighted];
    
    _gammaSlider = [self sliderWithValue:1 minimumValue:0.75 maximumValue:1.25 action:@selector(sliderDidChange:)];
    _gammaSlider.superview.center = CGPointMake(self.editor.view.width-20, _temperaturSlider.superview.center.y);
    _gammaSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    [_gammaSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gamma.png"] forState:UIControlStateNormal];
    [_gammaSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gamma.png"] forState:UIControlStateHighlighted];
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
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    NSLog(@"Saturation: %f",_saturationSlider.value);
    NSLog(@"Temperature: %f",6500*_temperaturSlider.value);
    NSLog(@"Gamma: %f",_gammaSlider.value*_gammaSlider.value);
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_saturationSlider.value] forKey:@"inputSaturation"];
    
    filter = [CIFilter filterWithName:@"CITemperatureAndTint" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat temperature = (6500*_temperaturSlider.value);
    [filter setValue:[CIVector vectorWithX:6500 Y:100] forKey:@"inputNeutral"];
    [filter setValue:[CIVector vectorWithX:temperature Y:100] forKey:@"inputTargetNeutral"];
    
    filter = [CIFilter filterWithName:@"CIGammaAdjust" keysAndValues:kCIInputImageKey, [filter outputImage], nil];
    [filter setDefaults];
    CGFloat contrast   = _gammaSlider.value*_gammaSlider.value;
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputPower"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end
