//
//  CLFilterBase.h
//
//  Created by Kevin Siml - Appzer.de on 2015/11/26.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"

#import "GPUImage.h"

@protocol CLFilterBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;
+ (UIImage*)applyFilter2:(UIImage*)image;
@end

NSString *currentFilter;
extern float _alphavalue;

@interface CLFilterBase : NSObject<CLImageToolProtocol, CLFilterBaseProtocol>
@end
