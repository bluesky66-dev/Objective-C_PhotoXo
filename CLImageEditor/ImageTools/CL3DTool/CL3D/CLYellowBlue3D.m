//
//  CLYellowBlue3D.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLYellowBlue3D.h"

#import "UIView+Frame.h"

@implementation CLYellowBlue3D
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_sizeSlider;
    NSDate *lastCallSlider;
    GPUImageRGBFilter *stillImageFilter;
    UIImage *BlueImage;
    UIImage *redImage;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLYellowBlue3D_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Yellow-Blue", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 10;
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
    
    stillImageFilter = [[GPUImageRGBFilter alloc] init];
    
    return self;
}

- (void)cleanup
{
    BlueImage=nil;
    redImage=nil;
    stillImageFilter=nil;
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    [_containerView removeFromSuperview];
}


- (UIImage*)applyEffect:(UIImage*)image
{
    [stillImageFilter setRed: 0.0];
    [stillImageFilter setGreen:0.0];
    [stillImageFilter setBlue:1.0];
    BlueImage = [stillImageFilter imageByFilteringImage:image];

    [stillImageFilter setRed: 1.0];
    [stillImageFilter setGreen:1.0];
    [stillImageFilter setBlue:0.0];
    redImage = [stillImageFilter imageByFilteringImage:image];
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    [BlueImage drawInRect:CGRectMake(0,0,image.size.width,image.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [redImage drawInRect:CGRectMake(0,0,image.size.width-_sizeSlider.value,image.size.height) blendMode:kCGBlendModeScreen alpha:1.0];
    redImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(0, 0, image.size.width-_sizeSlider.value, image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([redImage CGImage], cropRect);
    redImage=[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return redImage;
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
    _sizeSlider = [self sliderWithValue:25 minimumValue:1 maximumValue:75];
    _sizeSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
}

- (void)sliderDidChange:(UISlider*)sender
{
    NSDate *nowCall = [NSDate date];// timestamp
    if ([nowCall timeIntervalSinceDate:lastCallSlider] > 0.1) {
        [self.delegate effectParameterDidChange:self];
        lastCallSlider = nowCall;
    }}

@end
