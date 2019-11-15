//
//  CLEffectBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/10/23.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLEffectBase.h"

@implementation CLEffectBase

#pragma mark-

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/CLEffectTool/%@.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // Effect tools are sorted according to the dockedNumber in tool bar.
    // Override point for tool bar customization
    NSArray *effects = @[
                         @"CLEffectBase",
                         @"CLNewEffect",
                         @"CLSpotEffect",
                         @"CLHueEffect",
                         @"CLHighlightShadowEffect",
                         @"CLBloomEffect",
                         @"CLGloomEffect",
                         @"CLHazeEffect",
                         @"CLSepiaEffect",
                         @"CLOilEffect",
                         @"CLEmbossEffect",
                         @"CLPosterizeEffect",
                         @"CLPixellateEffect",
                         @"CLColorDotsEffect",
                         @"CLHoleEffect",
                         @"CLSwirlEffect",
                         @"CLBulgeEffect",
                         @"CLPinchEffect",
                         @"CLStretchEffect",
                         @"CLZoomBlurEffect",
                         @"CLSharpenEffect",
                         @"CLUnsharpMaskEffect",
                         @"CIToonEffect",
                         @"CIToonHardEffect",
                         @"CISketchEffect",
                         @"CISketchHardEffect",
                         @"CIDotEffect",
                         @"CIHalftoneEffect",
                         @"CIHatchEffect",
                         @"CICrossHatchEffect",
                         @"CIBlackWhiteEffect",
                         @"CIEdgeEffect",
                         @"CIOpacityEffect",
                         ];
    return [effects indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLEffectBase_DefaultTitle", nil, [CLImageEditorTheme bundle], @"None", @"");
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
