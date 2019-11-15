//
//  CLImageEditorTheme+Private.h
//
//  Created by Kevin Siml - Appzer.de on 2015/12/07.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageEditorTheme.h"

#import "CLToolbarMenuItem.h"

@interface CLImageEditorTheme (Private)

+ (NSString*)bundleName;
+ (NSBundle*)bundle;
+ (UIImage*)imageNamed:(Class)path image:(NSString*)image;

+ (UIColor*)backgroundColor;
+ (UIColor*)toolbarColor;
+ (UIColor*)toolbarTextColor;
+ (UIColor*)toolbarSelectedButtonColor;

+ (UIFont*)toolbarTextFont;

+ (UIActivityIndicatorView*)indicatorView;
+ (CLToolbarMenuItem*)menuItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(CLImageToolInfo*)toolInfo;

@end
