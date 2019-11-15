//
//  CLGradientTool.m
//
//  Created by Kevin Siml - Appzer.de on 2014/06/20.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLGradientTool.h"

@implementation CLGradientTool
{
    UIImageView *_GradientingView;
    CGSize _originalImageSize;
    
    CGPoint _prevDraggingPosition;
    UIView *_menuView;
    UISlider *_colorSlider;
    UISlider *_colorSlider2;
    UISlider *_widthSlider;
    UISlider *_widthSlider2;
    UISlider *_heightSlider;
    UISlider *_heightSlider2;
    UIView *_strokePreview;
    UIView *_strokePreviewBackground;
    UIColor *GradientTopColor;
    UIColor *GradientBottomColor;
    UIImageView *_eraserIcon;
    CAGradientLayer *gradientLayer;
    CLToolbarMenuItem *_colorBtn;
    CGFloat location1;
    CGFloat location2;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLGradientTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Gradient", @"");
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 7;
}

#pragma mark- implementation

- (void)setup
{
    _originalImageSize = self.editor.imageView.image.size;
    
    _GradientingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    
    UIColor *topColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
    UIColor *bottomColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.75];
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.editor.imageView.bounds;
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    [_GradientingView.layer insertSublayer:gradientLayer atIndex:0];

    
    [self.editor.imageView addSubview:_GradientingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    _menuView = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    _menuView.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view addSubview:_menuView];
    
    [self setMenu];
    
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformIdentity;
                     }];
    
}

- (void)cleanup
{
    [_GradientingView removeFromSuperview];
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (UISlider*)defaultSliderWithWidth:(CGFloat)width
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, width, 34)];
    
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage new] forState:UIControlStateNormal];
    slider.thumbTintColor = [UIColor whiteColor];
    
    return slider;
}

- (UIImage*)colorSliderBackground
{
    CGSize size = _colorSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect frame = CGRectMake(5, (size.height-10)/2, size.width-5, 10);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:5].CGPath;
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {
        0.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 1.0f, 1.0f,
        1.0f, 0.0f, 0.0f, 1.0f,
        1.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 0.0f, 1.0f,
        0.0f, 1.0f, 1.0f, 1.0f,
        0.0f, 0.0f, 1.0f, 1.0f
    };
    
    size_t count = sizeof(components)/ (sizeof(CGFloat)* 4);
    CGFloat locations[] = {0.0f, 0.9/3.0, 1/3.0, 1.5/3.0, 2/3.0, 2.5/3.0, 1.0};
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(size.width, 0);
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)widthSliderBackground3
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [[[CLImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
    
    CGFloat endRadius = 1;
    CGFloat strRadius = size.height/2 * 0.4;
    
    CGFloat endRadius2 = size.height/2 * 0.4;
    CGFloat strRadius2 = 1;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2);
    CGPoint endPoint = CGPointMake(size.width/2-endRadius - 1, strPoint.y);
    
    CGPoint strPoint2 = CGPointMake(size.width/2-endRadius2, size.height/2);
    CGPoint endPoint2 = CGPointMake(size.width-endRadius2 - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    CGPathAddArc(path, NULL, strPoint2.x, strPoint2.y, strRadius2, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint2.x, endPoint2.y + endRadius2);
    CGPathAddArc(path, NULL, endPoint2.x, endPoint2.y, endRadius2, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint2.x, strPoint2.y - strRadius2);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)widthSliderBackground2
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [[[CLImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
    
    CGFloat endRadius = 1;
    CGFloat strRadius = size.height/2 * 0.4;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2);
    CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)widthSliderBackground
{
    CGSize size = _widthSlider.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [[[CLImageEditorTheme theme] toolbarTextColor] colorWithAlphaComponent:0.5];
    
    CGFloat strRadius = 1;
    CGFloat endRadius = size.height/2 * 0.4;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2);
    CGPoint endPoint = CGPointMake(size.width-endRadius - 1, strPoint.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, strPoint.x, strPoint.y, strRadius, -M_PI/2, M_PI-M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y + endRadius);
    CGPathAddArc(path, NULL, endPoint.x, endPoint.y, endRadius, M_PI/2, M_PI+M_PI/2, YES);
    CGPathAddLineToPoint(path, NULL, strPoint.x, strPoint.y - strRadius);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIColor*)colorForValue:(CGFloat)value
{
    if(value<1/3.0){
        return [UIColor colorWithWhite:value/0.3 alpha:1];
    }
    return [UIColor colorWithHue:((value-1/3.0)/0.7)*2/3.0 saturation:1 brightness:1 alpha:1];
}

- (UIColor*)colorForValue1:(CGFloat)value
{
    if(value<1/3.0){
        return [UIColor colorWithWhite:value/0.3 alpha:_widthSlider.value];
    }
    return [UIColor colorWithHue:((value-1/3.0)/0.7)*2/3.0 saturation:1 brightness:1 alpha:_widthSlider.value];
}

- (UIColor*)colorForValue2:(CGFloat)value
{
    if(value<1/3.0){
        return [UIColor colorWithWhite:value/0.3 alpha:_widthSlider2.value];
    }
    return [UIColor colorWithHue:((value-1/3.0)/0.7)*2/3.0 saturation:1 brightness:1 alpha:_widthSlider2.value];
}

- (void)setMenu
{
    CGFloat W = 70;
    
    _colorSlider = [self defaultSliderWithWidth:_menuView.width / 2.2];
    _colorSlider.left = 15;
    _colorSlider.top  = -11;
    [_colorSlider addTarget:self action:@selector(colorSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _colorSlider.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    _colorSlider.value = 0.484020;
    [_menuView addSubview:_colorSlider];
    
    _colorSlider2 = [self defaultSliderWithWidth:_menuView.width / 2.2];
    _colorSlider2.left = _colorSlider.right+5;
    _colorSlider2.top  = -11;
    [_colorSlider2 addTarget:self action:@selector(colorSliderDidChange2:) forControlEvents:UIControlEventValueChanged];
    _colorSlider2.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    _colorSlider2.value = 0.349004;
    [_menuView addSubview:_colorSlider2];
    
    _widthSlider = [self defaultSliderWithWidth:_colorSlider.width];
    _widthSlider.left = 15;
    _widthSlider.top = _colorSlider.bottom-7;
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.5;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_widthSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"opacity"] forState:UIControlStateNormal];
    [_widthSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"opacity"] forState:UIControlStateHighlighted];
    [_menuView addSubview:_widthSlider];
    
    _widthSlider2 = [self defaultSliderWithWidth:_colorSlider.width];
    _widthSlider2.left = _colorSlider.right+5;
    _widthSlider2.top = _colorSlider.bottom-7;
    [_widthSlider2 addTarget:self action:@selector(widthSliderDidChange2:) forControlEvents:UIControlEventValueChanged];
    _widthSlider2.value = 0.5;
    _widthSlider2.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_widthSlider2 setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"opacity"] forState:UIControlStateNormal];
    [_widthSlider2 setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"opacity"] forState:UIControlStateHighlighted];
    [_menuView addSubview:_widthSlider2];
    
    _heightSlider = [self defaultSliderWithWidth:_colorSlider.width];
    _heightSlider.left = 15;
    _heightSlider.top = _widthSlider.bottom-7;
    [_heightSlider addTarget:self action:@selector(heightSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _heightSlider.value = 0;
    _heightSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground2]];
    [_heightSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gradient1"] forState:UIControlStateNormal];
    [_heightSlider setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gradient1"] forState:UIControlStateHighlighted];
    [_menuView addSubview:_heightSlider];
    
    _heightSlider2 = [self defaultSliderWithWidth:_colorSlider.width];
    _heightSlider2.left = _colorSlider.right+5;
    _heightSlider2.top = _widthSlider2.bottom-7;
    [_heightSlider2 addTarget:self action:@selector(heightSliderDidChange2:) forControlEvents:UIControlEventValueChanged];
    _heightSlider2.value = 0.5;
    _heightSlider2.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground3]];
    [_heightSlider2 setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gradient2"] forState:UIControlStateNormal];
    [_heightSlider2 setThumbImage:[CLImageEditorTheme imageNamed:[self class] image:@"gradient2"] forState:UIControlStateHighlighted];
    [_menuView addSubview:_heightSlider2];

    _strokePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 5, W - 5)];
    _strokePreview.layer.cornerRadius = _strokePreview.height/2;
    _strokePreview.layer.borderWidth = 1;
    _strokePreview.layer.borderColor = [[[CLImageEditorTheme theme] toolbarTextColor] CGColor];
    _strokePreview.center = CGPointMake(_menuView.width-W/2, _menuView.height/2);
    _strokePreview.hidden = YES;
    [_menuView addSubview:_strokePreview];
    
    _strokePreviewBackground = [[UIView alloc] initWithFrame:_strokePreview.frame];
    _strokePreviewBackground.layer.cornerRadius = _strokePreviewBackground.height/2;
    _strokePreviewBackground.alpha = 0.3;
    _strokePreviewBackground.hidden = YES;
    [_strokePreviewBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strokePreviewDidTap:)]];
    [_menuView insertSubview:_strokePreviewBackground aboveSubview:_strokePreview];
    
    _eraserIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _eraserIcon.image  =  [CLImageEditorTheme imageNamed:[self class] image:@"btn_eraser.png"];
    _eraserIcon.hidden = YES;
    [_menuView addSubview:_eraserIcon];
    
    [self colorSliderDidChange:_colorSlider];
    [self colorSliderDidChange2:_colorSlider2];
    [self widthSliderDidChange:_widthSlider];
    [self widthSliderDidChange2:_widthSlider2];
    [self heightSliderDidChange:_heightSlider];
    [self heightSliderDidChange2:_heightSlider2];
    
    _menuView.clipsToBounds = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _menuView.bounds;
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuView.layer insertSublayer:gradient atIndex:0];
}

- (void)colorSliderDidChange:(UISlider*)sender
{
    //NSLog(@"Color %f",_colorSlider.value);
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    _colorSlider.thumbTintColor = [self colorForValue:_colorSlider.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];
}

- (void)colorSliderDidChange2:(UISlider*)sender
{
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    _colorSlider2.thumbTintColor = [self colorForValue:_colorSlider2.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];

}

- (void)widthSliderDidChange:(UISlider*)sender
{
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];

}

- (void)widthSliderDidChange2:(UISlider*)sender
{
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];
    
}

- (void)heightSliderDidChange:(UISlider*)sender
{
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];
    
}

- (void)heightSliderDidChange2:(UISlider*)sender
{
    GradientTopColor = [self colorForValue1:_colorSlider.value];
    GradientBottomColor = [self colorForValue2:_colorSlider2.value];
    [gradientLayer removeFromSuperlayer];
    [self changeGradientSubLayer];
    
}

- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender
{
    _eraserIcon.hidden = !_eraserIcon.hidden;
    
    if(_eraserIcon.hidden){
        [self colorSliderDidChange:_colorSlider];
    }
    else{
        _strokePreview.backgroundColor = [[CLImageEditorTheme theme] toolbarTextColor];
        _strokePreviewBackground.backgroundColor = _strokePreview.backgroundColor;
    }
}


- (void)changeGradientSubLayer {
    
    location1 = (_heightSlider.value/2)+(_heightSlider2.value-0.5);
    location2 = (1-(_heightSlider.value/2))+(_heightSlider2.value-0.5);
    
    if(location1<0){ location1=0; }
    if(location2>1){ location2=1; }
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)GradientTopColor.CGColor, (id)GradientBottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location1],[NSNumber numberWithFloat:location2], nil];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.editor.imageView.bounds;
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    [_GradientingView.layer insertSublayer:gradientLayer atIndex:0];
}

- (UIImage*)buildImage
{
    UIGraphicsBeginImageContext(_originalImageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CFArrayRef colors = CFBridgingRetain([NSArray arrayWithObjects:(id)GradientTopColor.CGColor, (id)GradientBottomColor.CGColor,nil]);
    
    CGFloat gradientLocations[2] = { location1, location2 };
    
    CGGradientRef gradient = CGGradientCreateWithColors ( colorspace, colors, gradientLocations );
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, _originalImageSize.height), 0);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    [image drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end
