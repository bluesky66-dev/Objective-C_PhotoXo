//
//  CLEnhanceBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/11/26.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"

#import "GPUImage.h"

@protocol CLEnhanceBaseProtocol <NSObject>

@required
+ (UIImage*)applyEnhance:(UIImage*)image;
+ (UIImage*)applyEnhance2:(UIImage*)image;
@end

NSString *currentEnhance;
extern float _alphavalueEnhance;

@interface CLEnhanceBase : NSObject<CLImageToolProtocol, CLEnhanceBaseProtocol>
@end
