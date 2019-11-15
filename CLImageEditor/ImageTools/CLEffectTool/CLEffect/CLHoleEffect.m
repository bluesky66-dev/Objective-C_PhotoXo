//
//  CLHoleEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLHoleEffect.h"
#import "UIView+Frame.h"

@interface CLHoleCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLHoleEffect()
<UIGestureRecognizerDelegate>
@end

@implementation CLHoleEffect
{
    UIView *_containerView;
    CLHoleCircle *_circleView;
    
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
    
    NSDate *lastCallPan;
    NSDate *lastCallPin;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLHoleEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Hole", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 11;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:frame];
        [superview addSubview:_containerView];
        _X = 0.5;
        _Y = 0.5;
        _R = 0.5;
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
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHoleDistortion" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * 0.5 * (_R + 0.1);
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width * _X Y:image.size.height * (1 - _Y)];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return result;
}


- (void)setUserInterface
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContainerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainerView:)];
    
    pan.maximumNumberOfTouches = 1;
    
    tap.delegate = self;
    //pan.delegate = self;
    pinch.delegate = self;
    
    [_containerView addGestureRecognizer:tap];
    [_containerView addGestureRecognizer:pan];
    [_containerView addGestureRecognizer:pinch];
    
    _circleView = [[CLHoleCircle alloc] init];
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
    [self.delegate effectParameterDidChange:self];
}

- (void)tapContainerView:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:_containerView];
    _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
    _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
    
    [self drawCircleView];
    
    if (sender.state == UIGestureRecognizerStateEnded){
        [self.delegate effectParameterDidChange:self];
    }
}
- (void)panContainerView:(UIPanGestureRecognizer*)sender
{
    NSDate *nowCallPan = [NSDate date];// timestamp
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastCallPan = nowCallPan;
    } else {
        if ([nowCallPan timeIntervalSinceDate:lastCallPan] > 0.11) {
            CGPoint point = [sender locationInView:_containerView];
            _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
            _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
            [self drawCircleView];
        }
    }
}

- (void)pinchContainerView:(UIPinchGestureRecognizer*)sender
{
    static CGFloat initialScale;
    NSDate *nowCallPin = [NSDate date];// timestamp
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastCallPin = nowCallPin;
        initialScale = (_R + 0.1);
    } else {
        if ([nowCallPin timeIntervalSinceDate:lastCallPin] > 0.11) {
            _R = MIN(1.1, MAX(0.1, initialScale * sender.scale)) - 0.1;
            [self drawCircleView];
            lastCallPin = nowCallPin;
        }
    }
}

@end

#pragma mark- UI components

@implementation CLHoleCircle

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