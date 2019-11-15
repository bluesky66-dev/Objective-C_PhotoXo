//
//  CLMonoColorEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLMonoColorEffect.h"

#import "UIView+Frame.h"

@implementation CLMonoColorEffect
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_blueSlider;
    UISlider *_redSlider;
    UISlider *_greenSlider;
    NSDate *lastCallSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLMonoColorEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Mono Color", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 8.1;
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
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIColor *color = [CIColor colorWithRed:_redSlider.value green:_greenSlider.value blue:_blueSlider.value alpha:1.0];
    
    filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:(int)1] forKey:@"inputIntensity"];
    [filter setValue:color forKey:@"inputColor"];
    ciImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return imageResult;
}

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max color:(CGFloat)thatColor
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    
    if(thatColor==1){
        container.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.33];
    } else if (thatColor==2){
        container.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.33];
    } else if (thatColor==3){
        container.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.33];
    } else {
        container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.33];
    }
    
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
    
     _redSlider = [self sliderWithValue:1.0 minimumValue:0.0 maximumValue:1.0 color:1.0];
     _redSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
     
     _greenSlider = [self sliderWithValue:0.0 minimumValue:0.0 maximumValue:1.0 color:2.0];
     _greenSlider.superview.center = CGPointMake(20, _redSlider.superview.top - 150);
     _greenSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 270 / 180.0f);
     
     _blueSlider = [self sliderWithValue:1.0 minimumValue:0.0 maximumValue:1 color:3.0];
     _blueSlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _redSlider.superview.top - 150);
     _blueSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    
}

- (void)sliderDidChange:(UISlider*)sender
{
        [self.delegate effectParameterDidChange:self];
}

@end