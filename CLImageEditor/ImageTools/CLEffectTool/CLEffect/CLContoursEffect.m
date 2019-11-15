//
//  CLContoursEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLContoursEffect.h"

#import "UIView+Frame.h"

@implementation CLContoursEffect
{
    UIView *_containerView;
    
    //UISlider *_highlightSlider;
    UISlider *_shadowSlider;
    //UISlider *_radiusSlider;
    NSDate *lastCallSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLContoursEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Black & White", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 24;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        [superview addSubview:_containerView];
        
        [self setUserInterface];
    }
    lastCallSlider=[NSDate date];
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyEffect:(UIImage*)image
{
    GPUImageAdaptiveThresholdFilter *stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
    [stillImageFilter setBlurRadiusInPixels:_shadowSlider.value];
    UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
    return quickFilteredImage;
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
    _shadowSlider = [self sliderWithValue:10 minimumValue:0 maximumValue:13];
    _shadowSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    //_radiusSlider = [self sliderWithValue:-0.1 minimumValue:-1 maximumValue:0.5];
    //_radiusSlider.superview.center = CGPointMake(20, _shadowSlider.superview.top - 150);
    //_radiusSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    //_shadowSlider = [self sliderWithValue:0 minimumValue:-1 maximumValue:1];
    //_shadowSlider.superview.center = CGPointMake(300, _highlightSlider.superview.center.y);
    //_shadowSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
}

- (void)sliderDidChange:(UISlider*)sender
{
    NSDate *nowCall = [NSDate date];// timestamp
    if ([nowCall timeIntervalSinceDate:lastCallSlider] > 0.11) {
        [self.delegate effectParameterDidChange:self];
        lastCallSlider = nowCall;
    }
}

@end
