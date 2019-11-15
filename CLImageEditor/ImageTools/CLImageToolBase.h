//
//  CLImageToolBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/17.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "_CLImageEditorViewController.h"
#import "CLImageToolSettings.h"

static const CGFloat kCLImageToolAnimationDuration = 0.5;
static const CGFloat kCLImageToolFadeoutDuration   = 0.5;



@interface CLImageToolBase : NSObject<CLImageToolProtocol>
{
    
}
@property (nonatomic, weak) _CLImageEditorViewController *editor;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;

- (id)initWithImageEditor:(_CLImageEditorViewController*)editor withToolInfo:(CLImageToolInfo*)info;

- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;

@end
