//
//  CLPerspectiveKaleidoscope.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLPerspectiveKaleidoscope.h"
#import "UIView+Frame.h"
#import "UIView+Quadrilateral.h"

@implementation CLPerspectiveKaleidoscope
{
    UIView *_containerView;
    CIFilter *filter;
    UIView *contentView;
    UIView *topLeftControl,*topRightControl,*bottomLeftControl,*bottomRightControl;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLPerspectiveKaleidoscope_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Perspective", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 3;
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        [superview addSubview:_containerView];
        
        [self setUserInterface];
    }
    
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyKaleidoscope:(UIImage*)image
{
    
    filter = [CIFilter filterWithName:@"CIPerspectiveTile"];
    [filter setValue:[CIImage imageWithCGImage:image.CGImage] forKey:kCIInputImageKey];
    [filter setValue:[CIVector vectorWithX:topLeftControl.frame.origin.x*3 Y:topLeftControl.frame.origin.y*3] forKey:@"inputTopLeft"];
    [filter setValue:[CIVector vectorWithX:topRightControl.frame.origin.x*3 Y:topRightControl.frame.origin.y*3] forKey:@"inputTopRight"];
    [filter setValue:[CIVector vectorWithX:bottomRightControl.frame.origin.x*3 Y:bottomRightControl.frame.origin.y*3] forKey:@"inputBottomRight"];
    [filter setValue:[CIVector vectorWithX:bottomLeftControl.frame.origin.x*3 Y:bottomLeftControl.frame.origin.y*3] forKey:@"inputBottomLeft"];
    CIImage *result = filter.outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    UIImage *bottomImage = image;
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContext( newSize );
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [imageResult drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
  }

#pragma mark-

- (void)setUserInterface
{
    
    //set some arbitrary control points (NOTE: doesn't work well with convex shapes)

    contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
    
    [contentView.layer setCornerRadius:15.0f];
    [contentView.layer setBorderColor:[UIColor blackColor].CGColor];
    [contentView.layer setBorderWidth:2.5f];
    
    //IMPORTANT: quad transform only works as expected when anchor point is (0,0)
    contentView.layer.anchorPoint = CGPointZero;
    
    [_containerView addSubview:contentView];
    
    
    //set some arbitrary control points (NOTE: doesn't work well with convex shapes)
    CGPoint bl = CGPointMake(60,129);
    CGPoint br = CGPointMake(262,75);
    CGPoint tl = CGPointMake(57,292);
    CGPoint tr = CGPointMake(265,278);
    
    topLeftControl = [self addControl:tl];
    topRightControl = [self addControl:tr];
    bottomLeftControl = [self addControl:bl];
    bottomRightControl = [self addControl:br];
    
    [self updateTranform];
}

- (UIView *)addControl:(CGPoint)p
{
    CGRect r = CGRectZero;
    r.origin = p;
    r.size = CGSizeMake(30, 30);
    
    UIView *control = [[UIView alloc] initWithFrame:r];
    control.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
    [control.layer setCornerRadius:15.0f];
    [control.layer setBorderColor:[UIColor blackColor].CGColor];
    [control.layer setBorderWidth:2.5f];
    [_containerView addSubview:control];
    
    UIPanGestureRecognizer *rec=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragMarker:)];

    [control addGestureRecognizer:rec];
    return control;
}

- (void)dragMarker:(UIPanGestureRecognizer *)recognizer
{

    UIImageView *view = (UIImageView *)[recognizer view];
    
    CGPoint translation = [recognizer translationInView:_containerView];
    CGPoint newCenter = view.center;
    newCenter.x += translation.x;
    newCenter.y += translation.y;
    
    if(newCenter.x<_containerView.frame.size.width && newCenter.x>0){
        if(newCenter.y<_containerView.frame.size.height && newCenter.y>5){
            view.center = newCenter;
            [recognizer setTranslation:CGPointZero inView:_containerView];
            [self updateTranform];
            [self.delegate KaleidoscopeParameterDidChange:self];
        }
    }
}

- (void)updateTranform
{
    
    //This is where the magic happens...
    [contentView transformToFitQuadTopLeft:topLeftControl.center
                                       topRight:topRightControl.center
                                     bottomLeft:bottomLeftControl.center
                                    bottomRight:bottomRightControl.center];
    
}

@end
