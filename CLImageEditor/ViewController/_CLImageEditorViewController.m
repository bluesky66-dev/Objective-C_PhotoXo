//
//  _CLImageEditorViewController.m
//
//  Created by Kevin Siml - Appzer.de on 2015/11/05.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "_CLImageEditorViewController.h"

#import "CLImageToolBase.h"

#import "UIImage+ImageEffects.h"
#import "UIImage+Scale.h"

#import "AFNetworking.h"
#import "SSZipArchive.h"

#pragma mark- _CLImageEditorViewController

@interface _CLImageEditorViewController()
<CLImageToolProtocol>
@property (nonatomic, strong) CLImageToolBase *currentTool;
@property (nonatomic, strong, readwrite) CLImageToolInfo *toolInfo;
@property (nonatomic, strong) UIImageView *targetImageView;
@end

@implementation _CLImageEditorViewController
{
    UIImage *_originalImage;
    UIView *_bgView;
    BOOL checkZoomImage;
    //AFHTTPSessionManager *manager;
    NSURLSessionDownloadTask *downloadTask;
    
}
@synthesize toolInfo = _toolInfo;

- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.toolInfo = [CLImageToolInfo toolInfoForToolClass:[self class]];
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        _originalImage = [image deepCopy];
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithDelegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [_navigationBar removeFromSuperview];
}

#pragma mark- Custom initialization

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushedFinishBtn:)];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if(_navigationBar==nil){
        UINavigationItem *navigationItem  = [[UINavigationItem alloc] init];
        
        navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_BackBtnTitle", nil, [CLImageEditorTheme bundle], @"✘", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedCloseBtn:)];
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_OKBtnTitle", nil, [CLImageEditorTheme bundle], @"✔︎", @"") style:UIBarButtonItemStyleDone target:self action:@selector(pushedFinishBtn:)];
        
        CGFloat dy = ([UIDevice iosVersion]<7) ? 0 : [UIApplication sharedApplication].statusBarFrame.size.height;
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, dy, self.view.width, 44)];
        [navigationBar pushNavigationItem:navigationItem animated:NO];
        navigationBar.delegate = self;
        
        if(self.navigationController){
            [self.navigationController.view addSubview:navigationBar];
        }
        else{
            [self.view addSubview:navigationBar];
        }
        _navigationBar = navigationBar;
    }
    
    if(self.navigationController!=nil){
        _navigationBar.frame  = self.navigationController.navigationBar.frame;
        _navigationBar.hidden = YES;
        [_navigationBar popNavigationItemAnimated:NO];
    }
    else{
        _navigationBar.topItem.title = self.title;
    }
    
    if([UIDevice iosVersion] < 7){
        _navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
}

- (void)initMenuScrollView
{
    if(self.menuView==nil){
        UIScrollView *menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        menuScroll.top = self.view.height - menuScroll.height+5;
        menuScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        menuScroll.showsHorizontalScrollIndicator = NO;
        menuScroll.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:menuScroll];
        self.menuView = menuScroll;
    }
    //self.menuView.backgroundColor = [CLImageEditorTheme toolbarColor];
    //self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
}

- (void)initImageScrollView
{
    if(_scrollView==nil){
        UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        imageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.showsVerticalScrollIndicator = NO;
        imageScroll.delegate = self;
        imageScroll.clipsToBounds = NO;
        
        CGFloat y = 0;
        if(self.navigationController){
            if(self.navigationController.navigationBar.translucent){
                y = self.navigationController.navigationBar.bottom;
            }
            y = ([UIDevice iosVersion] < 7) ? y-[UIApplication sharedApplication].statusBarFrame.size.height : y;
        }
        else{
            y = _navigationBar.bottom;
        }
        
        imageScroll.top = y;
        imageScroll.height = self.view.height - imageScroll.top - _menuView.height;
        
        [self.view insertSubview:imageScroll atIndex:0];
        _scrollView = imageScroll;
        
        // Listen for Double Tap Zoom
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [_scrollView addGestureRecognizer:doubleTap];
    }
}

#pragma mark-

- (void)showInViewController:(UIViewController*)controller withImageView:(UIImageView*)imageView;
{
    _originalImage = imageView.image;
    
    self.targetImageView = imageView;
    
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
    
    self.view.frame = controller.view.bounds;
    [controller.view addSubview:self.view];
    [self refreshImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.toolInfo.title;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = self.theme.backgroundColor;
    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self initNavigationBar];
    [self initMenuScrollView];
    [self initImageScrollView];
    
    [self setMenuView];
    
    if(_imageView==nil){
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
        [self refreshImageView];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_scrollView.zoomScale > _scrollView.minimumZoomScale && _scrollView.zoomScale == _scrollView.maximumZoomScale){
        checkZoomImage = YES;
    }
    if (_scrollView.zoomScale < _scrollView.maximumZoomScale && _scrollView.zoomScale == _scrollView.minimumZoomScale) {
        checkZoomImage = NO;
    }
    
    
    if (checkZoomImage) {
        [_scrollView setZoomScale:_scrollView.zoomScale *0.1 animated:YES];
    }else{
        [_scrollView setZoomScale:_scrollView.zoomScale *10 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if(self.targetImageView){
        [self expropriateImageView];
    }
    else{
        [self refreshImageView];
    }
}

#pragma mark- View transition

- (void)copyImageViewInfo:(UIImageView*)fromView toView:(UIImageView*)toView
{
    CGAffineTransform transform = fromView.transform;
    fromView.transform = CGAffineTransformIdentity;
    
    toView.transform = CGAffineTransformIdentity;
    toView.frame = [toView.superview convertRect:fromView.frame fromView:fromView.superview];
    toView.transform = transform;
    toView.image = fromView.image;
    toView.contentMode = fromView.contentMode;
    toView.clipsToBounds = fromView.clipsToBounds;
    
    fromView.transform = transform;
}

- (void)expropriateImageView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:self.targetImageView toView:animateView];
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_bgView atIndex:0];
    
    _bgView.backgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    
    self.targetImageView.hidden = YES;
    _imageView.hidden = YES;
    _bgView.alpha = 0;
    _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         animateView.transform = CGAffineTransformIdentity;
                         
                         CGFloat dy = ([UIDevice iosVersion]<7) ? [UIApplication sharedApplication].statusBarFrame.size.height : 0;
                         
                         CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
                         if(size.width>0 && size.height>0){
                             CGFloat ratio = MIN(_scrollView.width / size.width, _scrollView.height / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             animateView.frame = CGRectMake((_scrollView.width-W)/2 + _scrollView.left, (_scrollView.height-H)/2 + _scrollView.top + dy, W, H);
                         }
                         
                         _bgView.alpha = 1;
                         _navigationBar.transform = CGAffineTransformIdentity;
                         _menuView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.targetImageView.hidden = NO;
                         _imageView.hidden = NO;
                         [animateView removeFromSuperview];
                     }
     ];
}

- (void)restoreImageView:(BOOL)canceled
{
    if(!canceled){
        self.targetImageView.image = _imageView.image;
    }
    self.targetImageView.hidden = YES;
    
    id<CLImageEditorTransitionDelegate> delegate = [self transitionDelegate];
    if([delegate respondsToSelector:@selector(imageEditor:willDismissWithImageView:canceled:)]){
        [delegate imageEditor:self willDismissWithImageView:self.targetImageView canceled:canceled];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:_imageView toView:animateView];
    
    _menuView.frame = [window convertRect:_menuView.frame fromView:_menuView.superview];
    _navigationBar.frame = [window convertRect:_navigationBar.frame fromView:_navigationBar.superview];
    
    [window addSubview:_menuView];
    [window addSubview:_navigationBar];
    
    self.view.userInteractionEnabled = NO;
    _menuView.userInteractionEnabled = NO;
    _navigationBar.userInteractionEnabled = NO;
    _imageView.hidden = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _bgView.alpha = 0;
                         _menuView.alpha = 0;
                         _navigationBar.alpha = 0;
                         
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         
                         [self copyImageViewInfo:self.targetImageView toView:animateView];
                     }
                     completion:^(BOOL finished) {
                         [animateView removeFromSuperview];
                         [_menuView removeFromSuperview];
                         [_navigationBar removeFromSuperview];
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         _imageView.hidden = NO;
                         self.targetImageView.hidden = NO;
                         
                         if([delegate respondsToSelector:@selector(imageEditor:didDismissWithImageView:canceled:)]){
                             [delegate imageEditor:self didDismissWithImageView:self.targetImageView canceled:canceled];
                         }
                     }
     ];
}

#pragma mark- Properties

- (id<CLImageEditorTransitionDelegate>)transitionDelegate
{
    if([self.delegate conformsToProtocol:@protocol(CLImageEditorTransitionDelegate)]){
        return (id<CLImageEditorTransitionDelegate>)self.delegate;
    }
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.toolInfo.title = title;
}

- (UIScrollView*)scrollView
{
    return _scrollView;
}

#pragma mark- ImageTool setting

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLImageEditor_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Edit", @"");
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLImageToolBase class]];
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (void)setMenuView
{
    CGFloat x = 0;
    CGFloat W = 70;
    CGFloat H = _menuView.height;
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info];
        [_menuView addSubview:view];
        x += W;
    }
    _menuView.contentSize = CGSizeMake(MAX(x, _menuView.frame.size.width+1), 0);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(-300, 0, x+600, 100);
    UIColor *startColour = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    UIColor *endColour = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[startColour CGColor], (id)[endColour CGColor], nil];
    [self.menuView.layer insertSublayer:gradient atIndex:0];
}

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
    
    // Shadow to image view
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOpacity = 1.0f;
    _imageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _imageView.layer.shadowRadius = 5.0f;
    _imageView.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_imageView.bounds];
    _imageView.layer.shadowPath = path.CGPath;
    
    // background Image with image and blurred effect
    [bgImageView removeFromSuperview];
    
    // Scale the Image for better performance
    UIImage *scaledImage = [_imageView.image scaleToSize:CGSizeMake(self.view.width/2, self.view.height/2)];
    
    // do blur effect
    bgImageView = [[UIImageView alloc] initWithImage:[scaledImage applyLightEffect]];
    
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

- (void)fixZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 1*minZoomScale;
    _scrollView.minimumZoomScale = 1*minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 0.97;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)refreshImageView
{
    _imageView.image = _originalImage;
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/*- (NSUInteger)supportedInterfaceOrientations
 {
 return UIInterfaceOrientationMaskPortrait;
 }*/

#pragma mark- Tool actions

- (void)setCurrentTool:(CLImageToolBase *)currentTool
{
    if(currentTool != _currentTool){
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
        [self swapToolBarWithEditting:(_currentTool!=nil)];
    }
}

#pragma mark- Menu actions

- (void)swapMenuViewWithEditting:(BOOL)editting
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         if(editting){
                             _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         }
                         else{
                             _menuView.transform = CGAffineTransformIdentity;
                         }
                     }
     ];
}

- (void)swapNavigationBarWithEditting:(BOOL)editting
{
    if(self.navigationController==nil){
        return;
    }
    
    if(editting){
        _navigationBar.hidden = NO;
        _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -self.navigationController.navigationBar.height-20);
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
    else{
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
                             _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         }
                         completion:^(BOOL finished) {
                             _navigationBar.hidden = YES;
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
}

- (void)swapToolBarWithEditting:(BOOL)editting
{
    [self swapMenuViewWithEditting:editting];
    [self swapNavigationBarWithEditting:editting];
    
    if(self.currentTool){
        UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:self.currentTool.toolInfo.title];
        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_OKBtnTitle", nil, [CLImageEditorTheme bundle], @"✔︎", @"") style:UIBarButtonItemStyleDone target:self action:@selector(pushedDoneBtn:)];
        item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_BackBtnTitle", nil, [CLImageEditorTheme bundle], @"✘", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
        
        //[item.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        //[item.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        
        [_navigationBar pushNavigationItem:item animated:(self.navigationController==nil)];
    }
    else{
        [_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
    }
}

- (void)setupToolWithToolInfo:(CLImageToolInfo*)info
{
    if(self.currentTool){ return; }
    
    Class toolClass = NSClassFromString(info.toolName);
    
    if(toolClass){
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]]){
            instance = [instance initWithImageEditor:self withToolInfo:info];
            self.currentTool = instance;
        }
    }
}

- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
    NSLog(@"%@",sender.view.toolInfo.toolName);
    
    prefs = [NSUserDefaults standardUserDefaults];
    // Is Sticker Tool tapped and already downloaded?
    if([sender.view.toolInfo.toolName isEqualToString: @"CLStickerTool"] && ![[prefs stringForKey:@"DownloadedStickers"] isEqualToString: @"YES"]){
        [self downloadStickers];
    } else if([sender.view.toolInfo.toolName isEqualToString: @"CLShapeTool"] && ![[prefs stringForKey:@"DownloadedShapes"] isEqualToString: @"YES"]){
        [self downloadShapes];
    } else { // otherwise start tapped tool
        UIView *view = sender.view;
        view.alpha = 0.2;
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             view.alpha = 1;
                         }
         ];
        [self setupToolWithToolInfo:view.toolInfo];
    }
}

- (IBAction)pushedCancelBtn:(id)sender
{
    _imageView.image = _originalImage;
    [self resetImageViewFrame];
    
    self.currentTool = nil;
}

- (IBAction)pushedDoneBtn:(id)sender
{
    self.view.userInteractionEnabled = NO;
    
    [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(image){
            _originalImage = image;
            _imageView.image = image;
            
            [self resetImageViewFrame];
            self.currentTool = nil;
        }
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)pushedCloseBtn:(id)sender
{
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]){
            [self.delegate imageEditorDidCancel:self];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        _imageView.image = self.targetImageView.image;
        [self restoreImageView:YES];
    }
}

- (void)pushedFinishBtn:(id)sender
{
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]){
            [self.delegate imageEditor:self didFinishEdittingWithImage:_originalImage];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        _imageView.image = _originalImage;
        [self restoreImageView:NO];
    }
}

#pragma mark- ScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}

// Download Stickers
- (void) downloadStickers {
    
    NSLog(@"Start Download Stickers");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TXT_LOADING", nil) message:NSLocalizedStringWithDefaultValue(@"CLStickerTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Sticker", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) otherButtonTitles:nil];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setUserInteractionEnabled:NO];
    [progressView setTrackTintColor:[UIColor darkGrayColor]];
    [progressView setProgressTintColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.00]];
    progressView.progress = 0.0;
    alertView.tag = 1;
    [alertView addSubview:progressView];
    [alertView setValue:progressView forKey:@"accessoryView"];
    alertView.clipsToBounds = YES;
    [alertView show];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://www.domain.de/folder/CLStickerTool.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    downloadTask = [manager downloadTaskWithRequest:request
                                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   //Update the progress view
                                                   //NSLog(@"%@",downloadProgress);
                                                   [progressView setProgress:downloadProgress.fractionCompleted];
                                               });
                                           } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                               NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                               return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                           } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                               NSLog(@"downloaded to: %@", filePath);
                                               if(filePath){
                                                   
                                                   NSString *sourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLStickerTool.zip"];
                                                   NSString *targetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                                   NSString *oldFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLStickerTool"];
                                                   
                                                   // Delete Old Sticker Folder
                                                   NSFileManager *fileManager = [NSFileManager defaultManager];
                                                   [fileManager removeItemAtPath:oldFolderPath error:&error];
                                                   
                                                   // UNZIP
                                                   NSLog(@"unziped to: %@",targetPath);
                                                   [SSZipArchive unzipFileAtPath:sourcePath toDestination:targetPath];
                                                   
                                                   // Delete ZIP File
                                                   [fileManager removeItemAtPath:sourcePath error:&error];
                                                   
                                                   // Display folder content after unzipping
                                                   //NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:&error];
                                                   //NSLog(@"%@",directoryContents);
                                                   
                                                   [prefs setObject:@"YES" forKey:@"DownloadedStickers"];
                                               }
                                               
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                               [alertView dismissWithClickedButtonIndex:0 animated:YES];
                                           }];
    [downloadTask resume];
}

// Download Shapes
- (void) downloadShapes {
    
    NSLog(@"Start Download Shapes");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TXT_LOADING", nil) message:NSLocalizedStringWithDefaultValue(@"CLShapeTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Shapes", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) otherButtonTitles:nil];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setUserInteractionEnabled:NO];
    [progressView setTrackTintColor:[UIColor darkGrayColor]];
    [progressView setProgressTintColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.00]];
    progressView.progress = 0.0;
    alertView.tag = 1;
    [alertView addSubview:progressView];
    [alertView setValue:progressView forKey:@"accessoryView"];
    alertView.clipsToBounds = YES;
    [alertView show];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://www.domain.de/folder/CLShapeTool.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    downloadTask = [manager downloadTaskWithRequest:request
                                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   //Update the progress view
                                                   //NSLog(@"%@",downloadProgress);
                                                   [progressView setProgress:downloadProgress.fractionCompleted];
                                               });
                                           } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                               NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                               return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                           } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                               NSLog(@"downloaded to: %@", filePath);
                                               if(filePath){
                                                   
                                                   NSString *sourcePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLShapeTool.zip"];
                                                   NSString *targetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                                   NSString *oldFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLShapeTool"];
                                                   
                                                   // Delete Old Shapes Folder
                                                   NSFileManager *fileManager = [NSFileManager defaultManager];
                                                   [fileManager removeItemAtPath:oldFolderPath error:&error];
                                                   
                                                   // UNZIP
                                                   NSLog(@"unziped to: %@",targetPath);
                                                   [SSZipArchive unzipFileAtPath:sourcePath toDestination:targetPath];
                                                   
                                                   // Delete ZIP File
                                                   [fileManager removeItemAtPath:sourcePath error:&error];
                                                   
                                                   // Display folder content after unzipping
                                                   //NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:&error];
                                                   //NSLog(@"%@",directoryContents);
                                                   
                                                   [prefs setObject:@"YES" forKey:@"DownloadedShapes"];
                                               }
                                               
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                               [alertView dismissWithClickedButtonIndex:0 animated:YES];
                                           }];
    [downloadTask resume];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSLog(@"Cancel Download Shapes");
            [downloadTask cancel];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
}

@end
