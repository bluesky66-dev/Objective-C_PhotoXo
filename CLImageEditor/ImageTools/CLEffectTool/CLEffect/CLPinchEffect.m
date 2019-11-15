//
//  CLPinchEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLPinchEffect.h"
#import "UIView+Frame.h"

@interface CLPinchCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLPinchEffect()
<UIGestureRecognizerDelegate>
@end

@implementation CLPinchEffect
{
    UIView *_containerView;
    UIView *_container;
    CLPinchCircle *_circleView;
    UILabel* circleLabel;
    
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
    NSDate *lastCallPan;
    NSDate *lastCallPin;

}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLPinchEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Pinch", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 14;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:frame];
        [superview addSubview:_containerView];
        _X = 0.5;
        _Y = 0.5;
        _R = 1;
        [self setUserInterface];
    }
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyEffect:(UIImage*)image
{
    NSLog(@"%f",_R);

    GPUImagePinchDistortionFilter *stillImageFilter = [[GPUImagePinchDistortionFilter alloc] init];
    [stillImageFilter setScale: _R];
    [stillImageFilter setRadius:1];
    [stillImageFilter setCenter:CGPointMake(_X,_Y)];
    UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
    return quickFilteredImage;
}

#pragma mark-

- (void)setUserInterface
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContainerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainerView:)];
    
    pan.maximumNumberOfTouches = 1;
    
    tap.delegate = self;
    pan.delegate = self;
    pinch.delegate = self;
    
    [_containerView addGestureRecognizer:tap];
    [_containerView addGestureRecognizer:pan];
    [_containerView addGestureRecognizer:pinch];
    
    _circleView = [[CLPinchCircle alloc] init];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor whiteColor];
    [_containerView addSubview:_circleView];
    
    [self drawCircleView];
}

- (void)drawCircleView
{
    CGFloat R = MIN(_containerView.width, _containerView.height) * (_R + 0.1) * 1.2;
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_containerView.width * _X, _containerView.height * _Y);
    [_circleView setNeedsDisplay];
    
    //NSLog(@"drawCircle");
    
   [self.delegate effectParameterDidChange:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapContainerView:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint point = [sender locationInView:_containerView];
        _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
        _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
        [self drawCircleView];
    }
}
- (void)panContainerView:(UIPanGestureRecognizer*)sender
{
    NSDate *nowCallPan = [NSDate date];// timestamp
    static CGFloat initialScale;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastCallPan = nowCallPan;
        initialScale = (_R + 0.1);
    } else {
        if ([nowCallPan timeIntervalSinceDate:lastCallPan] > 0.11) {
            CGPoint point = [sender locationInView:_containerView];
            _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
            _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
            [self drawCircleView];
            lastCallPan = nowCallPan;
        }
    }
}

- (void)pinchContainerView:(UIPinchGestureRecognizer*)sender
{
    
    NSDate *nowCallPin = [NSDate date];// timestamp
    static CGFloat initialScale;

    if (sender.state == UIGestureRecognizerStateBegan) {
        lastCallPin = nowCallPin;
        initialScale = (_R + 0.1);
    } else {
        if ([nowCallPin timeIntervalSinceDate:lastCallPin] > 0.11) {
            _R = MIN(2.1, MAX(-2.1, initialScale * sender.scale)) - 0.1;
            [self drawCircleView];
            lastCallPin = nowCallPin;
        }
    }
}

@end

#pragma mark- UI components

@implementation CLPinchCircle

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
    
    [UIView animateWithDuration:kCLEffectToolAnimationDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}
@end