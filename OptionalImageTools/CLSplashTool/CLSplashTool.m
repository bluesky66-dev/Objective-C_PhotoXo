//
//  CLSplashTool.m
//
//  Created by Kevin Siml - Appzer.de on 2014/06/21.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLSplashTool.h"

@interface CLSplashToolCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@implementation CLSplashTool
{
    UIImageView *_drawingView;
    UIImage *_maskImage;
    UIImage *_grayImage;
    CGSize _originalImageSize;
    CLSplashToolCircle *_circleView;
    CGPoint _prevDraggingPosition;
    UIView *_menuView;
    UISlider *_widthSlider;
    UIView *_strokePreview;
    UIView *_backPreview;
    UIImageView *_eraserIcon;
    UIImageView *_backIcon;
    CGFloat _R;
    CGFloat _X;
    CGFloat _Y;
    float backgroundNo;
    CLToolbarMenuItem *_colorBtn;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLSplashTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Splash", @"");
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (CGFloat)defaultDockedNumber
{
    return 9;
}

#pragma mark- implementation

- (void)setup
{
    backgroundNo = 1;
    
    _originalImageSize = self.editor.imageView.image.size;
    
    _drawingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    
    _grayImage = [[self.editor.imageView.image resize:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] grayScaleImage];
    _drawingView.image = _grayImage;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidPan:)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidTap:)];

    panGesture.maximumNumberOfTouches = 1;
    
    _drawingView.userInteractionEnabled = YES;
    [_drawingView addGestureRecognizer:panGesture];
    [_drawingView addGestureRecognizer:tapGesture];
    
    [self.editor.imageView addSubview:_drawingView];
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
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
    
    _R = 0.166;
    _circleView = [[CLSplashToolCircle alloc] init];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    [_drawingView addSubview:_circleView];
}

- (void)drawCircleView
{
    CGFloat R = MIN(_drawingView.width, _drawingView.height) * (_R*_widthSlider.value);
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
}

- (void)moveCircleView
{
    CGFloat R = MIN(_drawingView.width, _drawingView.height) * (_R*_widthSlider.value);
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
}

- (void)moveCircleViewTap
{
    CGFloat R = MIN(_drawingView.width, _drawingView.height) * (_R*_widthSlider.value);
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_X, _Y);
    [_circleView setNeedsDisplay];
    
    [UIView animateWithDuration:0.05
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _circleView.width  = R;
                         _circleView.height = R;
                         _circleView.center = CGPointMake(_X, _Y);
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)cleanup
{
    [_drawingView removeFromSuperview];
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

- (void)setMenu
{
    CGFloat W = 70;
    
    _widthSlider = [self defaultSliderWithWidth:_menuView.width - (W*2) - 15];
    _widthSlider.left = 10;
    _widthSlider.top = _menuView.height/2 - _widthSlider.height/2;
    [_widthSlider addTarget:self action:@selector(widthSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    _widthSlider.value = 0.5;
    _widthSlider.minimumValue = 0.066;
    _widthSlider.maximumValue = 1.0;
    _widthSlider.backgroundColor = [UIColor colorWithPatternImage:[self widthSliderBackground]];
    [_menuView addSubview:_widthSlider];
    
    _strokePreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 7, W - 7)];
    _strokePreview.layer.cornerRadius = 10;
    _strokePreview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    _strokePreview.center = CGPointMake(_menuView.width-W/2, _menuView.height/2);
    [_strokePreview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(strokePreviewDidTap:)]];
    [_menuView addSubview:_strokePreview];
    
    _backPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W - 7, W - 7)];
    _backPreview.layer.cornerRadius = 10;
    _backPreview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    _backPreview.center = CGPointMake(_strokePreview.left-38, _menuView.height/2);
    [_backPreview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backPreviewDidTap:)]];
    [_menuView addSubview:_backPreview];
    
    _eraserIcon = [[UIImageView alloc] initWithFrame:_strokePreview.frame];
    _eraserIcon.image  =  [CLImageEditorTheme imageNamed:[self class] image:@"btn_eraser.png"];
    _eraserIcon.alpha = 0.5;
    [_menuView addSubview:_eraserIcon];
    
    _backIcon = [[UIImageView alloc] initWithFrame:_backPreview.frame];
    _backIcon.image  =  [CLImageEditorTheme imageNamed:[self class] image:@"btn_background.png"];
    _backIcon.alpha = 0.5;
    [_menuView addSubview:_backIcon];
    
    [self widthSliderDidChange:_widthSlider];
    
    _menuView.clipsToBounds = NO;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _menuView.bounds;
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuView.layer insertSublayer:gradient atIndex:0];
}

- (void)widthSliderDidChange:(UISlider*)sender
{
    //CGFloat scale = MAX(0.05, _widthSlider.value);
    //_strokePreview.transform = CGAffineTransformMakeScale(scale, scale);
    //_strokePreview.layer.borderWidth = 2/scale;
    
    _X = _drawingView.width/2;
    _Y = _drawingView.height/2;
    [self drawCircleView];
}

- (void)strokePreviewDidTap:(UITapGestureRecognizer*)sender
{
    if(_eraserIcon.alpha==0.5){
        _eraserIcon.alpha=1;
    } else {
        _eraserIcon.alpha=0.5;
    }
    //_eraserIcon.hidden = !_eraserIcon.hidden;
}

- (void)backPreviewDidTap:(UITapGestureRecognizer*)sender
{
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         _backIcon.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              _backIcon.alpha = 0.5;
                                          }
                                          completion:^(BOOL finished) {
                                              _backIcon.alpha = 0.5;
                                          }
                          ];                     }
     ];
    
    if(backgroundNo==1){
        backgroundNo=2;
        _grayImage = [[self.editor.imageView.image resize:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] sepiaImage];
    } else if(backgroundNo==2) {
        backgroundNo=3;
        _grayImage = [[self.editor.imageView.image resize:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] bwImage];
    } else if(backgroundNo==3) {
        backgroundNo=4;
        _grayImage = [[self.editor.imageView.image resize:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] posterImage];
    } else {
        backgroundNo=1;
        _grayImage = [[self.editor.imageView.image resize:CGSizeMake(_drawingView.width*2, _drawingView.height*2)] grayScaleImage];
    }
    
    if(_maskImage.size.width>0){
        _drawingView.image = [_grayImage maskedImage:_maskImage];
    } else {
        _drawingView.image = _grayImage;
    }
}

- (void)drawingViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    _X = currentDraggingPosition.x;
    _Y = currentDraggingPosition.y;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _prevDraggingPosition = currentDraggingPosition;
    }
    
    if(sender.state != UIGestureRecognizerStateEnded){
        [self drawLine:_prevDraggingPosition to:currentDraggingPosition];
        _drawingView.image = [_grayImage maskedImage:_maskImage];
    }
    _prevDraggingPosition = currentDraggingPosition;
    
    [self moveCircleView];
}

- (void)drawingViewDidTap:(UITapGestureRecognizer*)sender
{
    CGPoint currentDraggingPosition = [sender locationInView:_drawingView];
    CGPoint currentDraggingPositionNew;
    currentDraggingPositionNew.x = currentDraggingPosition.x+1;
    currentDraggingPositionNew.y = currentDraggingPosition.y+1;
    _X = currentDraggingPosition.x;
    _Y = currentDraggingPosition.y;
    
    [self drawLine:currentDraggingPosition to:currentDraggingPositionNew];
    _drawingView.image = [_grayImage maskedImage:_maskImage];
    
    [self moveCircleViewTap];
    
}

-(void)drawLine:(CGPoint)from to:(CGPoint)to
{
    CGSize size = _drawingView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat strokeWidth = MAX(1, _widthSlider.value * 65);
    
    if(_maskImage==nil){
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    }
    else{
        [_maskImage drawAtPoint:CGPointZero];
    }
    
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    if(_eraserIcon.alpha!=0.5){
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    }
    else{
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    }
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
    
    _maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (UIImage*)buildImage
{
    
    if(backgroundNo==2){
        _grayImage = [self.editor.imageView.image sepiaImage];
    } else if(backgroundNo==3){
        _grayImage = [self.editor.imageView.image bwImage];
    } else if(backgroundNo==4){
        _grayImage = [self.editor.imageView.image posterImage];
    } else {
        _grayImage = [self.editor.imageView.image grayScaleImage];
    }
    
    UIGraphicsBeginImageContext(_originalImageSize);
    
    [self.editor.imageView.image drawAtPoint:CGPointZero];
    
    if(_maskImage.size.width>0){
        [[_grayImage maskedImage:_maskImage] drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    } else {
        [_grayImage drawInRect:CGRectMake(0, 0, _originalImageSize.width, _originalImageSize.height)];
    }
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end

#pragma mark- UI components

@implementation CLSplashToolCircle

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

