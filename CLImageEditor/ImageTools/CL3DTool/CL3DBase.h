//
//  CL3DBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"


static const CGFloat kCLEffectToolAnimationDuration = 0.2;


@protocol CL3DDelegate;

@interface CL3DBase : NSObject<CLImageToolProtocol>

@property (nonatomic, weak) id<CL3DDelegate> delegate;
@property (nonatomic, weak) CLImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumnailPreview;
- (UIImage*)applyEffect:(UIImage*)image;

@end



@protocol CL3DDelegate <NSObject>
@required
- (void)effectParameterDidChange:(CL3DBase*)effect;
@end
