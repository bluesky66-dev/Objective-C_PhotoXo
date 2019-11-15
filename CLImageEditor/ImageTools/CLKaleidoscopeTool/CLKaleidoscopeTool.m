//
//  CLKaleidoscopeTool.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLKaleidoscopeTool.h"


@interface CLKaleidoscopeTool()
@property (nonatomic, strong) UIView *selectedMenu;
@property (nonatomic, strong) CLKaleidoscopeBase *selectedKaleidoscope;
@end


@implementation CLKaleidoscopeTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UIScrollView *_menuScroll;
    UIActivityIndicatorView *_indicatorView;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLKaleidoscopeBase class]];
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLKaleidoscopeTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Kaleidoscope", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 6;
}

#pragma mark- 

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    _thumnailImage = self.editor.imageView.image;
    //_thumnailImage = [_originalImage resize:self.editor.imageView.frame.size];

    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setKaleidoscopeMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cleanup
{
    [self.selectedKaleidoscope cleanup];
    [_indicatorView removeFromSuperview];
    
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [CLImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self.selectedKaleidoscope applyKaleidoscope:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark- 

- (void)setKaleidoscopeMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenu:) toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
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

- (void)tappedMenu:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    self.selectedMenu = view;
}

- (void)setSelectedMenu:(UIView *)selectedMenu
{
    if(selectedMenu != _selectedMenu){
        _selectedMenu.backgroundColor = [UIColor clearColor];
        _selectedMenu = selectedMenu;
        _selectedMenu.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
        _selectedMenu.layer.cornerRadius = 5.0;
        _selectedMenu.layer.masksToBounds = YES;
        
        Class KaleidoscopeClass = NSClassFromString(_selectedMenu.toolInfo.toolName);
        self.selectedKaleidoscope = [[KaleidoscopeClass alloc] initWithSuperView:self.editor.imageView.superview imageViewFrame:self.editor.imageView.frame toolInfo:_selectedMenu.toolInfo];
    }
}

- (void)setSelectedKaleidoscope:(CLKaleidoscopeBase *)selectedKaleidoscope
{
    if(selectedKaleidoscope != _selectedKaleidoscope){
        [_selectedKaleidoscope cleanup];
        _selectedKaleidoscope = selectedKaleidoscope;
        _selectedKaleidoscope.delegate = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumnailImage];
        });
    }
}

- (void)buildThumnailImage
{
    UIImage *image;
    if(self.selectedKaleidoscope.needsThumnailPreview){
        image = [self.selectedKaleidoscope applyKaleidoscope:_thumnailImage];
    }
    else{
        image = [self.selectedKaleidoscope applyKaleidoscope:_originalImage];
    }
    [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

#pragma mark- CLKaleidoscope delegate

- (void)KaleidoscopeParameterDidChange:(CLKaleidoscopeBase *)Kaleidoscope
{
    if(Kaleidoscope == self.selectedKaleidoscope){
        static BOOL inProgress = NO;
        
        if(inProgress){ return; }
        inProgress = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumnailImage];
            inProgress = NO;
        });
    }
}

@end
