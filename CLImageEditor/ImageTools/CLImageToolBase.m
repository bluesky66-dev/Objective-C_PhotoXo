//
//  CLImageToolBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/17.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageToolBase.h"

@implementation CLImageToolBase

- (id)initWithImageEditor:(_CLImageEditorViewController*)editor withToolInfo:(CLImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.editor   = editor;
        self.toolInfo = info;
    }
    return self;
}

+ (NSString*)defaultIconImagePath
{
	CLImageEditorTheme *theme = [CLImageEditorTheme theme];
    return [NSString stringWithFormat:@"%@.bundle/%@/%@/icon.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class]), theme.toolIconColor];
}

+ (CGFloat)defaultDockedNumber
{
    // Image tools are sorted according to the dockedNumber in tool bar.
    // Override point for tool bar customization
    NSArray *tools = @[

                       ];
    /*NSArray *tools = @[
                       @"CLAdjustmentTool",
                       @"CLAdjustmentTool2",
                       @"CLFilterTool",
                       @"CLEffectTool",
                       @"CLMirrorTool",
                       @"CLKaleidoscopeTool",
                       @"CLGradientTool",
                       //@"CLColorClampTool",
                       @"CLBlurTool",
                       @"CLRotateTool",
                       @"CLClippingTool",
                       @"CLToneCurveTool",
                       @"CLSplashTool",
                       ];*/
    
    return [tools indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return @"DefaultTitle";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

- (void)setup
{
    
}

- (void)cleanup
{
    
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}

@end
