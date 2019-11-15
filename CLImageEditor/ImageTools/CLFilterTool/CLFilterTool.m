//
//  CLFilterTool.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/19.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLFilterTool.h"

#import "CLFilterBase.h"

@interface CLFilterTool()
@property (nonatomic, strong) UIView *selectedMenu;
@property (nonatomic, strong) CLFilterBase *selectedEffect;
@end

@implementation CLFilterTool
{

    UIImage *_originalImage;
    UIImage *_originalImageTemp;
    UIImage *_filterImageTemp;
    
    UIScrollView *_menuScroll;
    
    UIImageView *alphaImageView;
    
    UISlider *_alphaSlider;
    UIView *container;
    
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLFilterBase class]];
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLFilterTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Filter", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 3;
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
    
    [self setFilterMenu];
    
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
    _alphavalue = _alphaSlider.value;
    
    UIImage *filterImage = _filterImageTemp;
    
    UIGraphicsBeginImageContextWithOptions(_originalImageTemp.size, NO, _originalImageTemp.scale);
    [_originalImageTemp drawAtPoint:CGPointZero];
    [filterImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:_alphaSlider.value];
    filterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [ self.editor.imageView setImage:filterImage];

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

- (void)setFilterMenu
{
    CGFloat W = 70;
    CGFloat x = 0;
    
    UIImage *iconThumnail = [_originalImage aspectFill:CGSizeMake(140, 140)];
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, _menuScroll.height) target:self action:@selector(tappedFilterPanel:) toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
        if(view.iconImage==nil){
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *iconImage = [self filteredImage2:iconThumnail withToolInfo:info];
                [view performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:YES];
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

- (void)tappedFilterPanel:(UITapGestureRecognizer*)sender
{
    [_alphaSlider setValue:1.0 animated:YES];
    _alphavalue = 1.0f;
    
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    UIView *view = sender.view;
    
    view.alpha = 0.1;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    self.selectedMenu = view;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [self filteredImage:_originalImageTemp withToolInfo:view.toolInfo];
        
        [UIView transitionWithView:self.editor.imageView
                          duration:0.66f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _originalImage = image;
                        } completion:nil];
        
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    
        _filterImageTemp = image;
        
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
- (UIImage*)filteredImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class filterClass = NSClassFromString(info.toolName);
        if([(Class)filterClass conformsToProtocol:@protocol(CLFilterBaseProtocol)]){
            return [filterClass applyFilter:image];
        }
        return nil;
    }
}


// For Main Image
- (UIImage*)filteredImage2:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class filterClass = NSClassFromString(info.toolName);
        if([(Class)filterClass conformsToProtocol:@protocol(CLFilterBaseProtocol)]){
            return [filterClass applyFilter2:image];
        }
        return nil;
    }
}

@end
