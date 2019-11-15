//
//  CLRippleEffect.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLRippleEffect.h"
#import "UIView+Frame.h"

@interface CLRippleCircle : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLRippleEffect()
<UIGestureRecognizerDelegate>
@end

@implementation CLRippleEffect
{
    UIView *_containerView;
    UIView *_container;
    CLRippleCircle *_circleView;
    UILabel* circleLabel;
    
    CIImage *ciImage;
    CIImage *ciImageShading;
    
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
    CGFloat _Ro;
    CGFloat _Rotation;
    NSDate *lastCallPan;
    NSDate *lastCallRot;
    NSDate *lastCallPin;
    CIFilter *filter;
    CGFloat _Distortion;

}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLRippleEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Ripple", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 9.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 15.3;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:frame];
        [superview addSubview:_containerView];
        _X = 0.5;
        _Y = 0.5;
        _R = 0.25;
        _Ro = 0.5;
        [self setUserInterface];
    }
    ciImageShading = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"Shading.png"]];
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyEffect:(UIImage*)image
{
    ciImage = [[CIImage alloc] initWithImage:image];
    filter = [CIFilter filterWithName:@"CIRippleTransition"];
    [filter setValue:ciImage forKey:@"inputImage"];
    [filter setValue:ciImage forKey:@"inputTargetImage"];
    [filter setValue:ciImageShading forKey:@"inputShadingImage"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:image.size.height W:image.size.height] forKey:@"inputExtent"];
    [filter setValue:[CIVector vectorWithX:_X*image.size.width Y:(1-_Y)*image.size.height] forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:_R] forKey:@"inputTime"];
    [filter setValue:[NSNumber numberWithFloat:_Ro*200] forKey:@"inputScale"];
    [filter setValue:[NSNumber numberWithFloat:_Ro*200] forKey:@"inputWidth"];
    ciImage = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return imageResult;
}

#pragma mark-

- (void)setUserInterface
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContainerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchContainerView:)];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateContainerView:)];
    
    pan.maximumNumberOfTouches = 1;
    
    tap.delegate = self;
    pan.delegate = self;
    pinch.delegate = self;
    rotation.delegate = self;
    
    [_containerView addGestureRecognizer:tap];
    [_containerView addGestureRecognizer:pan];
    [_containerView addGestureRecognizer:pinch];
    [_containerView addGestureRecognizer:rotation];
    
    _circleView = [[CLRippleCircle alloc] init];
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
            _R = MIN(1.1, MAX(0.1, initialScale * sender.scale)) - 0.1;
            [self drawCircleView];
            lastCallPin = nowCallPin;
        }
    }
    
}

- (void)rotateContainerView:(UIRotationGestureRecognizer*)sender
{
    static CGFloat initialScale;
    NSDate *nowCallRot = [NSDate date];// timestamp
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastCallRot = nowCallRot;
        initialScale = (_Ro + 0.1)*-1;
        _Rotation=0;
        _Ro = (sender.rotation*-1);
    } else {
        if ([nowCallRot timeIntervalSinceDate:lastCallRot] > 0.11) {
            _Ro = (sender.rotation*-1);
            [self drawCircleView];
            lastCallRot = nowCallRot;
        }
    }
}

@end

#pragma mark- UI components

@implementation CLRippleCircle

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