//
//  UIView+CLImageToolInfo.m
//
//  Created by Kevin Siml - Appzer.de on 2015/11/26.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "UIView+CLImageToolInfo.h"

#import <objc/runtime.h>

@implementation UIView (CLImageToolInfo)

- (CLImageToolInfo*)toolInfo
{
    return objc_getAssociatedObject(self, @"UIView+CLImageToolInfo_toolInfo");
}

- (void)setToolInfo:(CLImageToolInfo *)toolInfo
{
    objc_setAssociatedObject(self, @"UIView+CLImageToolInfo_toolInfo", toolInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)userInfo
{
    return objc_getAssociatedObject(self, @"UIView+CLImageToolInfo_userInfo");
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, @"UIView+CLImageToolInfo_userInfo", userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
