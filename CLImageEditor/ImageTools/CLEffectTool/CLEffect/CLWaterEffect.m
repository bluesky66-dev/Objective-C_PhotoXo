//
//  CLWaterEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLWaterEffect.h"

#import "UIView+Frame.h"

@implementation CLWaterEffect
{
    UIView *_containerView;
    CIFilter *filter;
    UISlider *_textureScaleSlider;
    UISlider *_scaleSlider;
    UISlider *_cropSlider;
    UIImage *uiTextureImage;
    UIImage * upperImage;
    UIImage * lowerImage;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLWaterEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Water", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 8.0);
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
    uiTextureImage = [UIImage imageNamed:@"w01.jpg"];
    
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyEffect:(UIImage*)image
{
    float cropsize = _cropSlider.value;
    
    lowerImage = image;
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    CGRect cropRect = CGRectMake (0, cropsize*(image.size.height/2), image.size.width, image.size.height/2);
    
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect ([image CGImage], cropRect);
    
    // Create new cropped UIImage
    upperImage = [UIImage imageWithCGImage: imageRef];
    
    CGImageRelease (imageRef);
    
    [upperImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height/2)];
    
    upperImage = [UIImage imageWithCGImage:upperImage.CGImage scale:upperImage.scale orientation:UIImageOrientationDownMirrored];
    
    [upperImage drawInRect:CGRectMake(0,newSize.height/2,newSize.width,newSize.height)];
    
    // Resize Texture
    UIGraphicsBeginImageContext( CGSizeMake(upperImage.size.width, upperImage.size.height) );
    [uiTextureImage drawInRect:CGRectMake(0, 0, upperImage.size.width, upperImage.size.height*_textureScaleSlider.value)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIImage *ciTextureImage = [[CIImage alloc] initWithImage:resizedImage];
    
    filter = [CIFilter filterWithName:@"CIGlassDistortion"];
    [filter setValue:[CIImage imageWithCGImage:upperImage.CGImage] forKey:kCIInputImageKey];
    [filter setValue:ciTextureImage forKey:@"inputTexture"];
    [filter setValue:[CIVector vectorWithX:image.size.width/2 Y:image.size.height/2] forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithDouble:_scaleSlider.value] forKey:@"inputScale"];
    ciTextureImage = filter.outputImage;
    
    /*filter = [CIFilter filterWithName:@"CITemperatureAndTint" keysAndValues:kCIInputImageKey, ciTextureImage, nil];
    [filter setDefaults];
    [filter setValue:[CIVector vectorWithX:7500 Y:100] forKey:@"inputNeutral"];
    [filter setValue:[CIVector vectorWithX:11500 Y:100] forKey:@"inputTargetNeutral"];
    ciTextureImage = filter.outputImage;*/
    
    filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciTextureImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithDouble:2] forKey:@"inputRadius"];
    ciTextureImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciTextureImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height/2)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    lowerImage = [UIImage imageWithCGImage:imageResult.CGImage scale:imageResult.scale orientation:UIImageOrientationDownMirrored];
    CGImageRelease(cgImage);
    
    [lowerImage drawInRect:CGRectMake(0,image.size.height/2,newSize.width,image.size.height)];
    
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
    _scaleSlider = [self sliderWithValue:2000 minimumValue:1 maximumValue:4000];
    _scaleSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    _cropSlider = [self sliderWithValue:0.5 minimumValue:0 maximumValue:1];
    _cropSlider.superview.center = CGPointMake(20, _scaleSlider.superview.top - 150);
    _cropSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 270 / 180.0f);
    
    _textureScaleSlider = [self sliderWithValue:1.25 minimumValue:1 maximumValue:2];
    _textureScaleSlider.superview.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width-20, _scaleSlider.superview.top - 150);
    _textureScaleSlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
}

- (void)sliderDidChange:(UISlider*)sender
{
        [self.delegate effectParameterDidChange:self];
}

@end
