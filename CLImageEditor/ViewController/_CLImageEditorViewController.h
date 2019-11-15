//
//  _CLImageEditorViewController.h
//
//  Created by Kevin Siml - Appzer.de on 2015/11/05.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageEditor.h"

@interface _CLImageEditorViewController : CLImageEditor
<UIScrollViewDelegate, UIBarPositioningDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate>
{
    IBOutlet __weak UINavigationBar *_navigationBar;
    IBOutlet __weak UIScrollView *_scrollView;
    UIImageView *bgImageView;
    NSUserDefaults *prefs;
}
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, weak) IBOutlet UIScrollView *menuView;
@property (nonatomic, readonly) UIScrollView *scrollView;

- (IBAction)pushedCloseBtn:(id)sender;
- (IBAction)pushedFinishBtn:(id)sender;


- (id)initWithImage:(UIImage*)image;


- (void)fixZoomScaleWithAnimated:(BOOL)animated;
- (void)resetZoomScaleWithAnimated:(BOOL)animated;

@end
