//
//  CLPIPEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLPIPEffect.h"

#import "UIView+Frame.h"

@implementation CLPIPEffect
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_opacitySlider;
    UISlider *_blurSlider;
    UISlider *_sizeSlider;
    NSDate *lastCallSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLPIPEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"PIP", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 10.1;
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
    
    filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:_blurSlider.value] forKey:@"inputRadius"];
    ciImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *Background = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    [Background drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [Background drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [Background drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [Background drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [Background drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    float pointx = image.size.width-image.size.width*_sizeSlider.value;
    float pointy = image.size.height-image.size.height*_sizeSlider.value;
    
    
    [image drawInRect:CGRectMake(pointx/2,pointy/2,image.size.width*_sizeSlider.value,image.size.height*_sizeSlider.value) blendMode:kCGBlendModeNormal alpha:_opacitySlider.value];
    UIImage *imageResult = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
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
    
     _blurSlider = [self sliderWithValue:50.0 minimumValue:0.0 maximumValue:150.0];
     _blurSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
     
     _sizeSlider = [self sliderWithValue:0.8 minimumValue:0.3 maximumValue:0.95];
     _sizeSlider.superview.center = CGPointMake(20, _blurSlider.superview.top - 150);
     _sizeSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 270 / 180.0f);
     
     _opacitySlider = [self sliderWithValue:1.0 minimumValue:0.0 maximumValue:1];
     _opacitySlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _blurSlider.superview.top - 150);
     _opacitySlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
}

- (void)sliderDidChange:(UISlider*)sender
{
        [self.delegate effectParameterDidChange:self];
}

@end