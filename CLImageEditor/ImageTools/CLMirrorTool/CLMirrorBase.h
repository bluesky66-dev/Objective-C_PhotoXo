//
//  CLMirrorBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"


static const CGFloat kCLMirrorToolAnimationDuration = 0.2;


@protocol CLMirrorDelegate;

@interface CLMirrorBase : NSObject<CLImageToolProtocol>

@property (nonatomic, weak) id<CLMirrorDelegate> delegate;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumnailPreview;
- (UIImage*)applyMirror:(UIImage*)image;

@end



@protocol CLMirrorDelegate <NSObject>
@required
- (void)MirrorParameterDidChange:(CLMirrorBase*)Mirror;
@end
