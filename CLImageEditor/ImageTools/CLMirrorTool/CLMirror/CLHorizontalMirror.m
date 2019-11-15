//
//  CLHorizontalMirror.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLHorizontalMirror.h"
#import "UIView+Frame.h"

@interface CLHorizontalCircleMirror : UIView
@property (nonatomic, strong) UIColor *color;
@end

@interface CLHorizontalMirror()
<UIGestureRecognizerDelegate>
@end

@implementation CLHorizontalMirror
{
    UIView *_containerView;
    UIView *_container;
    CLHorizontalCircleMirror *_circleView;
    UILabel* circleLabel;
    
    CGFloat _X;
    CGFloat _Y;

}

#pragma mark-

+ (NSString*)defaultTitle
{
    return @"";
}

+ (CGFloat)defaultDockedNumber
{
    return 3;
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:frame];
        [superview addSubview:_containerView];
        _X = 0.5;
        _Y = 0.5;
        [self setUserInterface];
    }
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyMirror:(UIImage*)image
{
    UIImage *lowerImage = image;
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
        
    CGRect cropRect = CGRectMake (0, _Y*(image.size.height/2), image.size.width, image.size.height/2);

    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect ([image CGImage], cropRect);
    
    // Create new cropped UIImage
    UIImage * upperImage = [UIImage imageWithCGImage: imageRef];
    
    CGImageRelease (imageRef);
    
    [upperImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height/2)];
    
    lowerImage = [UIImage imageWithCGImage:upperImage.CGImage scale:upperImage.scale orientation:UIImageOrientationDownMirrored];
    [lowerImage drawInRect:CGRectMake(0,newSize.height/2,newSize.width,newSize.height/2)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark-

- (void)setUserInterface
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContainerView:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panContainerView:)];
    
    pan.maximumNumberOfTouches = 1;
    
    tap.delegate = self;
    pan.delegate = self;
    
    [_containerView addGestureRecognizer:tap];
    [_containerView addGestureRecognizer:pan];
    
    _circleView = [[CLHorizontalCircleMirror alloc] init];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor clearColor];
    [_containerView addSubview:_circleView];
    
    [self drawCircleView];
}

- (void)drawCircleView
{
    CGFloat R = MIN(_containerView.width, _containerView.height) * (0.1 + 0.1) * 1.2;
    _circleView.width  = R;
    _circleView.height = R;
    _circleView.center = CGPointMake(_containerView.width * _X, _containerView.height * _Y);
    [_circleView setNeedsDisplay];
    
    //NSLog(@"drawCircle");
    
   [self.delegate MirrorParameterDidChange:self];
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
    static CGFloat initialScale;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialScale = (0.5 + 0.1);
    } else {
            CGPoint point = [sender locationInView:_containerView];
            _X = MIN(1.0, MAX(0.0, point.x / _containerView.width));
            _Y = MIN(1.0, MAX(0.0, point.y / _containerView.height));
            [self drawCircleView];
    }
}

@end

#pragma mark- UI components

@implementation CLHorizontalCircleMirror

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
    
    [UIView animateWithDuration:kCLMirrorToolAnimationDuration
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