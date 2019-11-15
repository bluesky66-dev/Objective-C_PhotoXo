//
//  CLKaleidoscopeBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLKaleidoscopeBase.h"

@implementation CLKaleidoscopeBase

#pragma mark-

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/CLKaleidoscopeTool/%@.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // Kaleidoscope tools are sorted according to the dockedNumber in tool bar.
    // Override point for tool bar customization
    NSArray *Kaleidoscopes = @[
                         @"CLKaleidoscopeBase",
                         @"CLNewKaleidoscope",
                         ];
    return [Kaleidoscopes indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLKaleidoscopeBase_DefaultTitle", nil, [CLImageEditorTheme bundle], @"None", @"");
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

- (UIImage*)applyKaleidoscope:(UIImage*)image
{
    return image;
}

@end
