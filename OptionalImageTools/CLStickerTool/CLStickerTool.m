//
//  CLStickerTool.m
//
//  Created by Kevin Siml - Appzer.de on 2015/12/11.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLStickerTool.h"

#import "CLCircleView.h"

static NSString* const kCLStickerToolStickerPathKey = @"stickerPath";

@interface _CLStickerView : UIView
+ (void)setActiveStickerView:(_CLStickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end


@implementation CLStickerTool
{
    UIImage *_originalImage;
    
    UIView *_workingView;
    
    UIScrollView *_menuScroll;
    UIScrollView *_submenuScroll;
    
    NSString *_StickerType;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLStickerTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Sticker", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

+ (CGFloat)defaultDockedNumber
{
    return 4.5;
}

#pragma mark- optional info

+ (NSString*)defaultStickerPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers", NSStringFromClass(self)]];
}

+ (NSString*)defaultStickerPathThumb
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/stickers/thumb", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kCLStickerToolStickerPathKey:[self defaultStickerPath]};
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    //_menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.editor.view.height-70, self.editor.view.width, 70)];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    //_submenuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _submenuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(self.editor.view.width/2, self.editor.view.height-70, self.editor.view.width/2, 70)];
    _submenuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _submenuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_submenuScroll];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    [self setStickerMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    _submenuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _submenuScroll.transform = CGAffineTransformIdentity;
                     }];
    
    _submenuScroll.hidden = YES;
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _submenuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_submenuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_submenuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_CLStickerView setActiveStickerView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

#pragma mark-

- (void)setStickerMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSString *stickerPath = [[self class] defaultStickerPath];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPath]; }
    
    stickerPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLStickerTool/stickers"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    for(NSString *path in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        NSString *SubMenuName = [NSString stringWithFormat:@"%@", path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanel:) toolInfo:nil];
            view.iconImage = [image aspectFit:CGSizeMake(100, 100)];
            view.userInfo = @{@"filePath" : SubMenuName};
            
            [_menuScroll addSubview:view];
            x += W;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)setStickerSubMenu
{
    
    for(UIView *subview in [_submenuScroll subviews]) {
        [subview removeFromSuperview];
    }
    [_submenuScroll setContentOffset:CGPointMake(0, 0) animated:NO];
    
    // set main sticker menu width to the half
    [_menuScroll setFrame:CGRectMake(0, self.editor.view.height-70, self.editor.view.width/2, 70)];
    
    CGFloat W = 70;
    CGFloat H = _submenuScroll.height;
    CGFloat x = 0;
    
    NSString *stickerPath = [[self class] defaultStickerPathThumb];
    if(stickerPath==nil){ stickerPath = [[self class] defaultStickerPathThumb]; }
    
    stickerPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/CLStickerTool/stickers/thumb"];
    stickerPath = [stickerPath stringByReplacingOccurrencesOfString:@"stickers" withString:_StickerType];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:stickerPath error:&error];
    
    for(NSString *path in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", stickerPath, path];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if(image){
            CLToolbarMenuItem *subview = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedStickerPanelSub:) toolInfo:nil];
            subview.iconImage = [image aspectFit:CGSizeMake(100, 100)];
            subview.userInfo = @{@"filePath" : filePath};
            
            [_submenuScroll addSubview:subview];
            x += W;
        }
    }
    _submenuScroll.contentSize = CGSizeMake(MAX(x, _submenuScroll.frame.size.width+1), 0);
    _submenuScroll.hidden = NO;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _CLStickerView *view = [[_CLStickerView alloc] initWithImage:image];
    CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
    
    [_workingView addSubview:view];
    [_CLStickerView setActiveStickerView:view];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) openSheetImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"TXT_Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TXT_Camera", nil), NSLocalizedString(@"TXT_PhotoLibrary", nil), nil];
    CGRect cellRect = _workingView.bounds;
    cellRect.size.width = _workingView.frame.size.width * 2;
    cellRect.origin.x = -(_workingView.frame.size.width)-80;
    cellRect.origin.y = (_workingView.frame.size.height + 30);
    [sheet showFromRect:cellRect inView: _workingView animated:YES];
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
        if(buttonIndex==0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            type = UIImagePickerControllerSourceTypeCamera;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self.editor presentViewController:picker animated:YES completion:nil];
    }
}


- (void)tappedStickerPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSString *SubMenuName = view.userInfo[@"filePath"];
    if(SubMenuName){
        if([SubMenuName isEqualToString:@"001-Device.png"]){ // image from device or camera
            [self openSheetImage];
        } else {
            NSArray* SubMenuNameArray = [SubMenuName componentsSeparatedByString: @"."];
            NSString* SubMenuName = [SubMenuNameArray objectAtIndex: 0];
            _StickerType = SubMenuName;
            [self setStickerSubMenu];
        }
    }
}

- (void)tappedStickerPanelSub:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    NSString *filePath = view.userInfo[@"filePath"];
    if(filePath){
        filePath = [filePath stringByReplacingOccurrencesOfString:@"/thumb" withString:@""];
        _CLStickerView *view = [[_CLStickerView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
        CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
        [view setScale:ratio];
        view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        
        [_workingView addSubview:view];
        [_CLStickerView setActiveStickerView:view];
    }
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}

@end


@implementation _CLStickerView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
    UIButton *_opacityButton;
    UIButton *_mirrorButton;
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _scalex;
    CGFloat _scaley;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    CGFloat _MaininitialScale;
}

+ (void)setActiveStickerView:(_CLStickerView*)view
{
    static _CLStickerView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+32, image.size.height+32)];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 5;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[CLImageEditorTheme imageNamed:[CLStickerTool class] image:@"btn_delete.png"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _opacityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_opacityButton setImage:[CLImageEditorTheme imageNamed:[CLStickerTool class] image:@"btn_opacity.png"] forState:UIControlStateNormal];
        _opacityButton.frame = CGRectMake(0, 0, 32, 32);
        _opacityButton.center = CGPointMake(_imageView.width+_imageView.frame.origin.x, _imageView.frame.origin.y);
        _opacityButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:_opacityButton];
        
        _mirrorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mirrorButton setImage:[CLImageEditorTheme imageNamed:[CLStickerTool class] image:@"btn_mirror.png"] forState:UIControlStateNormal];
        _mirrorButton.frame = CGRectMake(0, 0, 32, 32);
        _mirrorButton.center = CGPointMake(_imageView.frame.origin.x, _imageView.frame.origin.y+_imageView.height);
        _mirrorButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_mirrorButton addTarget:self action:@selector(pushedMirrorBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mirrorButton];
        
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor blackColor];
        _circleView.borderWidth = 5;
        [self addSubview:_circleView];
        
        _scale = 1;
        _scalex = 1;
        _scaley = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    [_opacityButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(opacityButtonViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedMirrorBtn:(id)sender
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{ _imageView.transform = CGAffineTransformMakeScale(_scalex*-1, _scale);}];
    _scalex=_scalex*-1;
}

- (void)pushedDeleteBtn:(id)sender
{
    _CLStickerView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLStickerView class]]){
            nextTarget = (_CLStickerView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLStickerView class]]){
                nextTarget = (_CLStickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _opacityButton.hidden = !active;
    _mirrorButton.hidden = !active;
    _circleView.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    if(_scalex<0){
        _scalex=scale*-1;
    } else {
        _scalex = scale;
    }
    _scaley = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scalex, _scaley);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
    _opacityButton.center = CGPointMake(_imageView.width+16, _imageView.frame.origin.y);
    
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    _opacityButton.center = CGPointMake(_imageView.width+16, _imageView.frame.origin.y);
    _mirrorButton.center = CGPointMake(_imageView.frame.origin.x, _imageView.frame.origin.y+_imageView.height);
    
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    if(_MaininitialScale<=0){
        _MaininitialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    
    //[self setScale:MAX(_initialScale * R / tmpR, 0.1)];
    [self setScale:MAX(_initialScale * R / tmpR, (_MaininitialScale*0.3))];
}

- (void)opacityButtonViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    _imageView.alpha = 1-(p.y/100);
    //NSLog(@"Pan: %f",_imageView.alpha);
}
@end
