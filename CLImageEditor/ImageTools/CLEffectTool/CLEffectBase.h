//
//  CLEffectBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"


static const CGFloat kCLEffectToolAnimationDuration = 0.2;


@protocol CLEffectDelegate;

@interface CLEffectBase : NSObject<CLImageToolProtocol>

@property (nonatomic, weak) id<CLEffectDelegate> delegate;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumnailPreview;
- (UIImage*)applyEffect:(UIImage*)image;

@end



@protocol CLEffectDelegate <NSObject>
@required
- (void)effectParameterDidChange:(CLEffectBase*)effect;
@end
