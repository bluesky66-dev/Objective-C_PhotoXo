//
//  CL3DBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CL3DBase.h"

@implementation CL3DBase

#pragma mark-

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/CL3DTool/%@.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // Effect tools are sorted according to the dockedNumber in tool bar.
    // Override point for tool bar customization
    NSArray *effects = @[
                         @"CL3DBase",
                         @"CLNewEffect",
                         @"CLRedCyan3D",
                         @"CLCyanRed3D",
                         ];
    return [effects indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CL3DBase_DefaultTitle", nil, [CLImageEditorTheme bundle], @"None", @"");
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

- (UIImage*)applyEffect:(UIImage*)image
{
    return image;
}

@end
