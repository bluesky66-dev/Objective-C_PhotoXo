//
//  CLHalftoneCMYKEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLHalftoneCMYKEffect.h"

#import "UIView+Frame.h"

@implementation CLHalftoneCMYKEffect
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
    return NSLocalizedStringWithDefaultValue(@"CLHalftoneCMYKEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Halftone CMYK", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 9.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 22.6;
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
    
    filter = [CIFilter filterWithName:@"CICMYKHalftone"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:image.size.width/2 Y:image.size.height/2] forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:_redSlider.value] forKey:@"inputWidth"];
    [filter setValue:[NSNumber numberWithFloat:_greenSlider.value] forKey:@"inputAngle"];
    [filter setValue:[NSNumber numberWithFloat:_blueSlider.value] forKey:@"inputSharpness"];
    [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputGCR"];
    [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputUCR"];

    ciImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return imageResult;
}

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.33];
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
    
     _redSlider = [self sliderWithValue:50.0 minimumValue:1.0 maximumValue:100.0];
     _redSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
     
     _greenSlider = [self sliderWithValue:0.0 minimumValue:0.0 maximumValue:1.0];
     _greenSlider.superview.center = CGPointMake(20, _redSlider.superview.top - 150);
     _greenSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 270 / 180.0f);
     
     _blueSlider = [self sliderWithValue:0.7 minimumValue:0.0 maximumValue:1];
     _blueSlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _redSlider.superview.top - 150);
     _blueSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    
}

- (void)sliderDidChange:(UISlider*)sender
{
        [self.delegate effectParameterDidChange:self];
}

@end