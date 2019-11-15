//
//  CLCrystallizeEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLCrystallizeEffect.h"

#import "UIView+Frame.h"

@implementation CLCrystallizeEffect
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_textureScaleSlider;
    UISlider *_sizeSlider;
    UISlider *_rotationSlider;
    NSDate *lastCallSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLCrystallizeEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Crystallize", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 9.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 9.2;
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
    
    
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    filter = [CIFilter filterWithName:@"CICrystallize"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:(int)_sizeSlider.value] forKey:@"inputRadius"];
    ciImage = filter.outputImage;
    
    CIContext *context2 = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context2 createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    [img drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    [imageResult drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
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
    
     _sizeSlider = [self sliderWithValue:50 minimumValue:1 maximumValue:100];
     _sizeSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
     
     /*_rotationSlider = [self sliderWithValue:0.5 minimumValue:0.2 maximumValue:1];
     _rotationSlider.superview.center = CGPointMake(20, _sizeSlider.superview.top - 150);
     _rotationSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 270 / 180.0f);
     
     _textureScaleSlider = [self sliderWithValue:1.3 minimumValue:1 maximumValue:2];
     _textureScaleSlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _sizeSlider.superview.top - 150);
     _textureScaleSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);*/
    
    
}

- (void)sliderDidChange:(UISlider*)sender
{
        [self.delegate effectParameterDidChange:self];
}

@end