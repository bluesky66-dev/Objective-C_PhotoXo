//
//  CLMirrorBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLMirrorBase.h"

@implementation CLMirrorBase

#pragma mark-

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/CLMirrorTool/%@.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // Mirror tools are sorted according to the dockedNumber in tool bar.
    // Override point for tool bar customization
    NSArray *Mirrors = @[
                         @"CLMirrorBase",
                         @"CLNewMirror",
                         @"CLVerticalMirror",
                         @"CLVertical2Mirror",
                         @"CLHorizontalMirror",
                         @"CLHorizontal2Mirror",
                         ];
    return [Mirrors indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return @"";
}

+ (BOOL)isAvailable
{
    return YES;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.toolInfo = info;
    }
    return self;
}

- (void)cleanup
{
    
}

- (BOOL)needsThumnailPreview
{
    return YES;
}

- (UIImage*)applyMirror:(UIImage*)image
{
    return image;
}

@end
