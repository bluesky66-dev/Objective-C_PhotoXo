//
//  CLKaleidoscopeKaleidoscope.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLKaleidoscopeKaleidoscope.h"

#import "UIView+Frame.h"

@implementation CLKaleidoscopeKaleidoscope
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_decaySlider;
    UISlider *_sizeSlider;
    UISlider *_rotationSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLKaleidoscopeKaleidoscope_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Triangle", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 2;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        [superview addSubview:_containerView];
        
        [self setUserInterface];
    }
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyKaleidoscope:(UIImage*)image
{
    filter = [CIFilter filterWithName:@"CITriangleKaleidoscope"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:image.size.width/2 Y:image.size.height/2] forKey:@"inputPoint"];
    [filter setValue:[NSNumber numberWithDouble:_sizeSlider.value] forKey:@"inputSize"];
    [filter setValue:[NSNumber numberWithDouble:_rotationSlider.value] forKey:@"inputRotation"];
    [filter setValue:[NSNumber numberWithDouble:_decaySlider.value] forKey:@"inputDecay"];
    CIImage *result = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return imageResult;
  }

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [_containerView addSubview:container];
    
    return slider;
}

- (void)setUserInterface
{
    _sizeSlider = [self sliderWithValue:700 minimumValue:1 maximumValue:3000];
    _sizeSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    _rotationSlider = [self sliderWithValue:1.5 minimumValue:-3.14 maximumValue:3.14];
    _rotationSlider.superview.center = CGPointMake(20, _sizeSlider.superview.top - 150);
    _rotationSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    _decaySlider = [self sliderWithValue:0.75 minimumValue:0 maximumValue:1];
    _decaySlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _sizeSlider.superview.top - 150);
    _decaySlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
}

- (void)sliderDidChange:(UISlider*)sender
{
   [self.delegate KaleidoscopeParameterDidChange:self];
}

@end
