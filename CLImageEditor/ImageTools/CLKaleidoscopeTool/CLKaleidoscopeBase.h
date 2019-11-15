//
//  CLKaleidoscopeBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"


static const CGFloat kCLKaleidoscopeToolAnimationDuration = 0.2;


@protocol CLKaleidoscopeDelegate;

@interface CLKaleidoscopeBase : NSObject<CLImageToolProtocol>

@property (nonatomic, weak) id<CLKaleidoscopeDelegate> delegate;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumnailPreview;
- (UIImage*)applyKaleidoscope:(UIImage*)image;

@end



@protocol CLKaleidoscopeDelegate <NSObject>
@required
- (void)KaleidoscopeParameterDidChange:(CLKaleidoscopeBase*)Kaleidoscope;
@end
