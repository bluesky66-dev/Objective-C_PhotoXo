//
//  UIDevice+SystemVersion.m
//
//  Created by Kevin Siml - Appzer.de on 2015/11/06.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

+ (CGFloat)iosVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
