//
//  CLKaleidoscope2Kaleidoscope.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLKaleidoscope2Kaleidoscope.h"

#import "UIView+Frame.h"

@implementation CLKaleidoscope2Kaleidoscope
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_sizeSlider;
    UISlider *_rotationSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLKaleidoscope2Kaleidoscope_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Standard", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 9.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 1;
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
    filter = [CIFilter filterWithName:@"CIKaleidoscope"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:image.size.width/2 Y:image.size.height/2] forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithDouble:_sizeSlider.value] forKey:@"inputCount"];
    [filter setValue:[NSNumber numberWithDouble:_rotationSlider.value] forKey:@"inputAngle"];
    CIImage *result = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    UIImage *bottomImage = image;
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [imageResult drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
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
    _sizeSlider = [self sliderWithValue:6 minimumValue:1 maximumValue:50];
    _sizeSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    _rotationSlider = [self sliderWithValue:1.5 minimumValue:-3.14 maximumValue:3.14];
    _rotationSlider.superview.center = CGPointMake(20, _sizeSlider.superview.top - 150);
    _rotationSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
}

- (void)sliderDidChange:(UISlider*)sender
{
   [self.delegate KaleidoscopeParameterDidChange:self];
}

@end
