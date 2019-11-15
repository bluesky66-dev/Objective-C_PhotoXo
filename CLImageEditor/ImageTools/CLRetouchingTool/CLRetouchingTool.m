//
//  CLRetouchingTool.m
//
//  Created by Kevin Siml - Appzer.de on 2014/06/20.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLRetouchingTool.h"
#import "UIImage+ImageEffects.h"
#import "GPUImage.h"

@interface CLRetouchingCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@implementation CLRetouchingTool
{
    UIImageView *_retouchingView;
    CGSize _originalImageSize;
    CGPoint _prevDraggingPosition;
    UIView *_menuView;
    UISlider *_widthSlider;
    UISlider *_colorSlider;
    UIScrollView *_menuScroll;
    float RetouchingID;
    CLRetouchingCircle *_circleView;
    CGFloat _R;
    CGFloat _X;
    CGFloat _Y;
    UIView *selectedMenu;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLRetouchingTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Retouching", @"");
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 8.1;
}

#pragma mark- implementation

- (void)setup
{
    _originalImageSize = self.editor.imageView.image.size;
    
    _retouchingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];

    panGesture.maximumNumberOfTouches = 1;
    
    _retouchingView.userInteractionEnabled = YES;
    [_retouchingView addGestureRecognizer:panGesture];
    [_retouchingView addGestureRecognizer:tapGesture];
    
    [self.editor.imageView addSubview:_retouchingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    _menuView = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    _menuView.backgroundColor = self.editor.menuView.backgroundColor;
    _menuView.top = self.editor.menuView.top-9;
    _menuView.height = self.editor.menuView.height+20;
    [self.editor.view addSubview:_menuView];
    
    [self setMenu];
    
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformIdentity;
                     }];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(-300, 0, 1600, 180);
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuView.layer insertSublayer:gradient atIndex:0];
   
    _circleView = [[CLRetouchingCircle alloc] init];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    [_retouchingView addSubview:_circleView];
    
    _R = 0.175;
    _X = _retouchingView.width/2;
    _Y= _retouchingView.height/2;
    [self drawCircleView];
}

- (void)drawCircleView
{
    CGFloat R = MIN(_retouchingView.width, _retouchingView.height) * (_R*_widthSlider.value) * 1.2;
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
}

- (void)moveCircleView
{
    CGFloat R = MIN(_retouchingView.width, _retouchingView.height) * (_R*_widthSlider.value) * 1.2;
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
}

- (void)moveCircleViewTap
{
    CGFloat R = MIN(_retouchingView.width, _retouchingView.height) * (_R*_widthSlider.value) * 1.2;
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
    
    [UIView animateWithDuration:0.05
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _circleView.width  = R*1.1;
                         _circleView.height = R*1.1;
                         _circleView.center = CGPointMake(_X, _Y);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)cleanup
{
    [_retouchingView removeFromSuperview];
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
    
    CGRect frame = CGRectMake(5, (size.height-10)/2, size.width-10, 5);
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
    
    CGPoint startPoint = CGPointMake(5, 0);
    CGPoint endPoint = CGPointMake(size.width-5, 0);
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, count);
    
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
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
    CGFloat endRadius = size.height/2 * 0.6;
    
    CGPoint strPoint = CGPointMake(strRadius + 5, size.height/2 - 2);
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

- (void)setFilterMenu
{
    RetouchingID=1;
    
    CLImageToolInfo *toolInfo = [self.editor.toolInfo subToolInfoWithToolName:@"CLRetouchingTool" recursive:NO];
    toolInfo.available = YES;

    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingBlur_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Blur", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingBlur" ofType:@"png"];
    CLToolbarMenuItem *btn1 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(10, 0, 60, 70) target:self action:@selector(tappedMenu1:) toolInfo:toolInfo];
    selectedMenu = btn1;
    [_menuScroll addSubview:btn1];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingSharpen_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Sharpen", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingSharpen" ofType:@"png"];
    CLToolbarMenuItem *btn2 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(70, 0, 60, 70) target:self action:@selector(tappedMenu2:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn2];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingBrighten_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Brighten", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingBrighten" ofType:@"png"];
    CLToolbarMenuItem *btn3 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(130, 0, 60, 70) target:self action:@selector(tappedMenu3:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn3];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingDarken_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Darken", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingDarken" ofType:@"png"];
    CLToolbarMenuItem *btn4 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(190, 0, 60, 70) target:self action:@selector(tappedMenu4:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn4];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingContrastP_DefaultTitle", nil, [CLImageEditorTheme bundle], @"+Contrast", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingContrastPlus" ofType:@"png"];
    CLToolbarMenuItem *btn5 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(250, 0, 60, 70) target:self action:@selector(tappedMenu5:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn5];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingContrastM_DefaultTitle", nil, [CLImageEditorTheme bundle], @"-Contrast", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingContrastMinus" ofType:@"png"];
    CLToolbarMenuItem *btn6 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(310, 0, 60, 70) target:self action:@selector(tappedMenu6:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn6];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingSaturationP_DefaultTitle", nil, [CLImageEditorTheme bundle], @"+Saturation", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingSaturation" ofType:@"png"];
    CLToolbarMenuItem *btn7 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(370, 0, 60, 70) target:self action:@selector(tappedMenu7:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn7];

    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingSaturationM_DefaultTitle", nil, [CLImageEditorTheme bundle], @"-Saturation", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingSaturationMinus" ofType:@"png"];
    CLToolbarMenuItem *btn8 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(430, 0, 60, 70) target:self action:@selector(tappedMenu8:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn8];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingExposureP_DefaultTitle", nil, [CLImageEditorTheme bundle], @"+Exposure", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingExposurePlus" ofType:@"png"];
    CLToolbarMenuItem *btn9 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(490, 0, 60, 70) target:self action:@selector(tappedMenu9:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn9];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingExposureM_DefaultTitle", nil, [CLImageEditorTheme bundle], @"-Exposure", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingExposureMinus" ofType:@"png"];
    CLToolbarMenuItem *btn10 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(550, 0, 60, 70) target:self action:@selector(tappedMenu10:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn10];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingInk_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Ink", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingInk" ofType:@"png"];
    CLToolbarMenuItem *btn11 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(610, 0, 60, 70) target:self action:@selector(tappedMenu11:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn11];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingWarm_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Warm", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingWarm" ofType:@"png"];
    CLToolbarMenuItem *btn12 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(670, 0, 60, 70) target:self action:@selector(tappedMenu12:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn12];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingCold_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Cold", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingWarm" ofType:@"png"];
    CLToolbarMenuItem *btn13 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(730, 0, 60, 70) target:self action:@selector(tappedMenu13:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn13];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingSepia_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Sepia", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingSepia" ofType:@"png"];
    CLToolbarMenuItem *btn14 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(790, 0, 60, 70) target:self action:@selector(tappedMenu14:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn14];
    
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingPixel_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Pixel", @"");
    toolInfo.iconImagePath = [[NSBundle mainBundle] pathForResource:@"CLRetouchingPixel" ofType:@"png"];
    CLToolbarMenuItem *btn15 = [CLImageEditorTheme menuItemWithFrame:CGRectMake(850, 0, 60, 70) target:self action:@selector(tappedMenu15:) toolInfo:toolInfo];
    [_menuScroll addSubview:btn15];

    //Header
    toolInfo.title = NSLocalizedStringWithDefaultValue(@"CLRetouchingTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Retouching", @"");
    _menuScroll.contentSize = CGSizeMake(910, 60);
    
    [self setSelectedMenu];
}

- (void) showColorSlider
{
    if(_colorSlider.hidden==YES){
        [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
            _widthSlider.width = _widthSlider.width/2;
            _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
            _colorSlider.left = _widthSlider.right+10;
            _colorSlider.hidden=NO;
        }];
    }
}

- (void) hideColorSlider
{
    if(_colorSlider.hidden==NO){
        [UIView animateWithDuration:kCLImageToolAnimationDuration
            animations:^{
            _widthSlider.width = _widthSlider.width*2;
            _colorSlider.left = _menuScroll.frame.size.width+50;
            _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
        }
            completion:^(BOOL finished) {
                _colorSlider.hidden=YES;
            }
        ];
    }
}


- (void)tappedMenu1:(UITapGestureRecognizer*)sender
{
    RetouchingID=1;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu2:(UITapGestureRecognizer*)sender
{
    RetouchingID=2;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu3:(UITapGestureRecognizer*)sender
{
    RetouchingID=3;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu4:(UITapGestureRecognizer*)sender
{
    RetouchingID=4;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu5:(UITapGestureRecognizer*)sender
{
    RetouchingID=5;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu6:(UITapGestureRecognizer*)sender
{
    RetouchingID=6;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu7:(UITapGestureRecognizer*)sender
{
    RetouchingID=7;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu8:(UITapGestureRecognizer*)sender
{
    RetouchingID=8;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu9:(UITapGestureRecognizer*)sender
{
    RetouchingID=9;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu10:(UITapGestureRecognizer*)sender
{
    RetouchingID=10;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu11:(UITapGestureRecognizer*)sender
{
    RetouchingID=11;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self showColorSlider];
}
- (void)tappedMenu12:(UITapGestureRecognizer*)sender
{
    RetouchingID=12;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu13:(UITapGestureRecognizer*)sender
{
    RetouchingID=13;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu14:(UITapGestureRecognizer*)sender
{
    RetouchingID=14;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)tappedMenu15:(UITapGestureRecognizer*)sender
{
    RetouchingID=15;
    selectedMenu = sender.view;
    [self setSelectedMenu];
    [self hideColorSlider];
}
- (void)setSelectedMenu
{
    
    for(UIView * subView in _menuScroll.subviews ) // here write Name of you ScrollView.
    {
        subView.backgroundColor = [UIColor clearColor];
    }
    selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
    selectedMenu.layer.cornerRadius = 5.0;
    selectedMenu.layer.masksToBounds = YES;
    
    selectedMenu.alpha=0;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         selectedMenu.alpha = 1;
                     }];
    
}

- (void)setMenu
{
    _widthSlider = [self defaultSliderWithWidth:_menuView.width - 20];
    _widthSlider.left = 5;
    _widthSlider.top = -7;
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.5;
    _widthSlider.maximumValue = 0.75;
    _widthSlider.minimumValue = 0.1;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_menuView addSubview:_widthSlider];
    [self widthSliderDidChange:_widthSlider];
    
    _colorSlider = [self defaultSliderWithWidth:_menuView.width/2 - 20];
    _colorSlider.left = _widthSlider.right+10;
    _colorSlider.top  = _widthSlider.top;
    [_colorSlider addTarget:self action:@selector(colorSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _colorSlider.backgroundColor = [UIColor colorWithPatternImage:[self colorSliderBackground]];
    _colorSlider.value = 0;
    [_menuView addSubview:_colorSlider];
    _colorSlider.hidden=YES;
    [self colorSliderDidChange:_colorSlider];

    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    _menuScroll.top = _widthSlider.bottom-9;
    _menuScroll.left = -10;
    _menuScroll.width = _menuScroll.width+10;
    [_menuView addSubview:_menuScroll];
    
    [self setFilterMenu];
    
    _menuView.clipsToBounds = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _menuView.bounds;
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuView.layer insertSublayer:gradient atIndex:0];
    
    _widthSlider.layer.zPosition = 1;
    _colorSlider.layer.zPosition = 1;


}

- (void)colorSliderDidChange:(UISlider*)sender
{
    _colorSlider.thumbTintColor = [self colorForValue:_colorSlider.value];
}

- (void)widthSliderDidChange:(UISlider*)sender
{
    _X = _retouchingView.width/2;
    _Y = _retouchingView.height/2;
    [self drawCircleView];
}

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_retouchingView];
    _X = currentDraggingPosition.x;
    _Y = currentDraggingPosition.y;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:currentDraggingPosition];
    }
    _prevDraggingPosition = currentDraggingPosition;
    
    [self moveCircleView];
    
}

- (void)drawingViewDidTap:(UITapGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_retouchingView];
    _X = currentDraggingPosition.x;
    _Y = currentDraggingPosition.y;
    
    [self drawLine:currentDraggingPosition];
    [self moveCircleViewTap];
    
}

#pragma mark - Cropping the Image
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

#pragma mark - Marge two Images

- (UIImage *) addImageToImage:(UIImage *)img withImage2:(UIImage *)img2 andRect:(CGRect)cropRect{
    
    CGSize size = CGSizeMake(self.editor.imageView.image.size.width, self.editor.imageView.image.size.height);
    UIGraphicsBeginImageContext(size);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [img drawAtPoint:pointImg1];
    
    CGPoint pointImg2 = cropRect.origin;
    [img2 drawAtPoint: pointImg2];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

-(void)drawLine:(CGPoint)from
{
    
    UIImage *croppedImg = nil;
    
    CGPoint currentPoint = from;
    
    double ratioW=self.editor.imageView.image.size.width/_retouchingView.frame.size.width ;
    double ratioH=self.editor.imageView.image.size.height/_retouchingView.frame.size.height;
    
    currentPoint.x *= ratioW;
    currentPoint.y *= ratioH;
    
    double circleSizeW = _widthSlider.value*80 * ratioW;
    double circleSizeH = _widthSlider.value*80 * ratioH;
    
    currentPoint.x = ((int)currentPoint.x - (int)circleSizeW/2<0)? 0 : (int)currentPoint.x - (int)circleSizeW/2;
    currentPoint.y = ((int)currentPoint.y - (int)circleSizeH/2<0)? 0 : (int)currentPoint.y - (int)circleSizeH/2;
    
    if((currentPoint.x+circleSizeW)>=self.editor.imageView.image.size.width){
        circleSizeW = self.editor.imageView.image.size.width-currentPoint.x;
        currentPoint.x = currentPoint.x-1;
        if(circleSizeW<=0){
            circleSizeW = 1;
            currentPoint.x = self.editor.imageView.image.size.width-1;
        }
    }
    if((currentPoint.y+circleSizeH)>=self.editor.imageView.image.size.height){
        circleSizeH = self.editor.imageView.image.size.height-currentPoint.y;
        currentPoint.y = currentPoint.y-1;
        if(circleSizeH<=0){
            circleSizeH = 1;
            currentPoint.y = self.editor.imageView.image.size.height-1;
        }
    }
    
    CGRect cropRect = CGRectMake((int)currentPoint.x , (int)currentPoint.y,   (int)circleSizeW,  (int)circleSizeH);
    
    NSLog(@"x %0.000f, y %0.000f, width %0.000f, height %0.000f, circleW %0.000f", cropRect.origin.x, cropRect.origin.y,   cropRect.size.width,  cropRect.size.height, circleSizeH/5 );
    
    croppedImg = [self croppIngimageByImageName:self.editor.imageView.image toRect:cropRect];
    
    // Make Blur
    if(RetouchingID==1){
        GPUImageGaussianBlurFilter *stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];
        [stillImageFilter setBlurRadiusInPixels:2.0];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Sharpen
    } else if (RetouchingID==2) {
        GPUImageSharpenFilter *stillImageFilter = [[GPUImageSharpenFilter alloc] init];
        [stillImageFilter setSharpness:0.02];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Brighten
    } else if (RetouchingID==3) {
        GPUImageBrightnessFilter *stillImageFilter = [[GPUImageBrightnessFilter alloc] init];
        [stillImageFilter setBrightness:0.01];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Darken
    } else if (RetouchingID==4) {
        GPUImageBrightnessFilter *stillImageFilter = [[GPUImageBrightnessFilter alloc] init];
        [stillImageFilter setBrightness:-0.01];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Contrast+
    } else if (RetouchingID==5) {
        GPUImageContrastFilter *stillImageFilter = [[GPUImageContrastFilter alloc] init];
        [stillImageFilter setContrast:1.007];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Contrast-
    } else if (RetouchingID==6) {
        GPUImageContrastFilter *stillImageFilter = [[GPUImageContrastFilter alloc] init];
        [stillImageFilter setContrast:0.993];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Saturation +
    } else if (RetouchingID==7) {
        GPUImageSaturationFilter *stillImageFilter = [[GPUImageSaturationFilter alloc] init];
        [stillImageFilter setSaturation:1.05];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Saturation-
    } else if (RetouchingID==8) {
        GPUImageSaturationFilter *stillImageFilter = [[GPUImageSaturationFilter alloc] init];
        [stillImageFilter setSaturation:0.95];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Exposure+
    } else if (RetouchingID==9) {
        GPUImageExposureFilter *stillImageFilter = [[GPUImageExposureFilter alloc] init];
        [stillImageFilter setExposure:0.005];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Exposure-
    } else if (RetouchingID==10) {
        GPUImageExposureFilter *stillImageFilter = [[GPUImageExposureFilter alloc] init];
        [stillImageFilter setExposure:-0.005];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Ink
    } else if (RetouchingID==11) {
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [_colorSlider.thumbTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
        GPUImageMonochromeFilter *stillImageFilter = [[GPUImageMonochromeFilter alloc] init];
        [stillImageFilter setIntensity:0.025];
        [stillImageFilter setColor:(GPUVector4){red, green, blue, 1.0f}];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Warm
    } else if (RetouchingID==12) {
        GPUImageWhiteBalanceFilter *stillImageFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        [stillImageFilter setTemperature:5200];
        [stillImageFilter setTint:2];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Cold
    } else if (RetouchingID==13) {
        GPUImageWhiteBalanceFilter *stillImageFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        [stillImageFilter setTemperature:4925];
        [stillImageFilter setTint:-2];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Sepia
    } else if (RetouchingID==14) {
        GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
        [stillImageFilter setIntensity:0.2];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    // Make Pixel
    } else if (RetouchingID==15) {
        GPUImagePixellateFilter *stillImageFilter = [[GPUImagePixellateFilter alloc] init];
        [stillImageFilter setFractionalWidthOfAPixel:0.1];
        croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    }

    // Make circle
    UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, (int)circleSizeW, (int)circleSizeH) cornerRadius:(int)circleSizeW/2];
    CGRect imageRect = CGRectMake(0, 0, (int)circleSizeW, (int)circleSizeH);
    [path addClip];
    [croppedImg drawInRect:imageRect];
    croppedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Make Circle smoother
    GPUImageGaussianBlurFilter *stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [stillImageFilter setBlurRadiusInPixels:0.005];
    croppedImg = [stillImageFilter imageByFilteringImage:croppedImg];
    
    // Draw result on original
    self.editor.imageView.image = [self addImageToImage:self.editor.imageView.image withImage2:croppedImg andRect:cropRect];

}


- (UIImage*)buildImage
{
    UIGraphicsBeginImageContext(_originalImageSize);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    [_retouchingView.image drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end

#pragma mark- UI components

@implementation CLRetouchingCircle

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect

{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rct = self.bounds;
    rct.origin.x += 1;
    rct.origin.y += 1;
    rct.size.width -= 2;
    rct.size.height -= 2;
    
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextStrokeEllipseInRect(context, rct);
    
    self.alpha = 1;
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                          delay:0.33
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}
@end
