//
//  CLEnhanceTool.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/19.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLEnhanceTool.h"

#import "CLEnhanceBase.h"

@interface CLEnhanceTool()
@property (nonatomic, strong) UIView *selectedMenu;
@property (nonatomic, strong) CLEnhanceBase *selectedEffect;
@end


@implementation CLEnhanceTool
{
    UIImage *_originalImage;
    UIImage *_originalImageTemp;
    UIImage *_EnhanceImageTemp;
    
    UIScrollView *_menuScroll;
    
    UIImageView *alphaImageView;
    
    UISlider *_alphaSlider;
    UIView *container;
    
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLEnhanceBase class]];
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLEnhanceTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Enhance", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 2;
}

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    _originalImageTemp = self.editor.imageView.image;
    //_originalImageTemp = [_originalImage resize:CGSizeMake(self.editor.imageView.frame.size.width*2,self.editor.imageView.frame.size.height*2)];

    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setEnhanceMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    _alphaSlider = [self sliderWithValue:1.0 minimumValue:0.0 maximumValue:1.0];
    _alphaSlider.superview.center = CGPointMake(_menuScroll.frame.size.width/2, _menuScroll.top-25);

}

- (void)cleanup
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                         _alphaSlider.transform = CGAffineTransformMakeTranslation(self.editor.view.width-_menuScroll.left,0);
                         container.transform = CGAffineTransformMakeTranslation(self.editor.view.width-_menuScroll.left,0);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                         [_alphaSlider removeFromSuperview];
                         [container removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

- (void)sliderDidChange:(UISlider*)sender
{
    _alphavalueEnhance = _alphaSlider.value;
    
    UIImage *EnhanceImage = _EnhanceImageTemp;
    
    UIGraphicsBeginImageContextWithOptions(_originalImageTemp.size, NO, _originalImageTemp.scale);
    [_originalImageTemp drawAtPoint:CGPointZero];
    [EnhanceImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:_alphaSlider.value];
    EnhanceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [ self.editor.imageView setImage:EnhanceImage];

}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 0, 260, 30)];
    
    container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, slider.height)];
    container.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    container.layer.cornerRadius = slider.height/2;
    
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [container addSubview:slider];
    [self.editor.view addSubview:container];
    
    return slider;
}

#pragma mark- 

- (void)setEnhanceMenu
{
    CGFloat W = 70;
    CGFloat x = 0;
    
    UIImage *iconThumnail = [_originalImage aspectFill:CGSizeMake(100, 100)];
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, _menuScroll.height) target:self action:@selector(tappedEnhancePanel:) toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
        if(view.iconImage==nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *iconImage = [self EnhanceedImage2:iconThumnail withToolInfo:info];
                [view performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:NO];
            });
        }
        
        if(self.selectedMenu==nil){
            self.selectedMenu = view;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(-300, 0, x+600, 100);
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [_menuScroll.layer insertSublayer:gradient atIndex:0];
}

- (void)tappedEnhancePanel:(UITapGestureRecognizer*)sender
{
    [_alphaSlider setValue:1.0 animated:YES];
    _alphavalueEnhance = 1.0f;
    
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    UIView *view = sender.view;
    
    self.selectedMenu = view;
    
    view.alpha = 0.1;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self EnhanceedImage:_originalImageTemp withToolInfo:view.toolInfo];
        
        [UIView transitionWithView:self.editor.imageView
                          duration:0.66f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _originalImage = image;
                        } completion:nil];
        
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
        _EnhanceImageTemp = image;
        
        inProgress = NO;
        
    });
}

- (void)setSelectedMenu:(UIView *)selectedMenu
{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        _selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
        _selectedMenu.layer.cornerRadius = 5.0;
        _selectedMenu.layer.masksToBounds = YES;
    }
}

// For Thumbnail images
- (UIImage*)EnhanceedImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class EnhanceClass = NSClassFromString(info.toolName);
        if([(Class)EnhanceClass conformsToProtocol:@protocol(CLEnhanceBaseProtocol)]){
            return [EnhanceClass applyEnhance:image];
        }
        return nil;
    }
}


// For Main Image
- (UIImage*)EnhanceedImage2:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class EnhanceClass = NSClassFromString(info.toolName);
        if([(Class)EnhanceClass conformsToProtocol:@protocol(CLEnhanceBaseProtocol)]){
            return [EnhanceClass applyEnhance2:image];
        }
        return nil;
    }
}

@end