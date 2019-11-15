//
//  CLEnhanceBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/11/26.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLEnhanceBase.h"

float _alphavalueEnhance = 1.0f;
CIFilter *enhancefilter;


@implementation CLEnhanceBase


+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/CLEnhanceTool/%@.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return @"CLEnhanceBase";
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

+ (UIImage*)applyEnhance:(UIImage*)image
{
    return image;
}

+ (UIImage*)applyEnhance2:(UIImage*)image
{
    return image;
}

@end




#pragma mark- Default Enhances


@interface CLDefaultEmptyEnhance : CLEnhanceBase

@end

@implementation CLDefaultEmptyEnhance

+ (NSDictionary*)defaultEnhanceInfo
{
    NSDictionary *defaultEnhanceInfo = nil;
    if(defaultEnhanceInfo==nil){
     defaultEnhanceInfo =
      @{
        @"CLDefaultEmptyEnhance"    :@{@"name":@"CLDefaultEmptyEnhance",   @"FV":@"0",  @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEmptyEnhance_DefaultTitle", nil,[CLImageEditorTheme bundle],@"None", @""),       @"version":@(0.0), @"dockedNum":@(0.0)},
        @"CLEnhanceAutoAdjust"      :@{@"name":@"AutoAdjust",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultAutoAdjustEnhance_DefaultTitle",               nil,[CLImageEditorTheme bundle],@"AutoAdjust", @""), @"version":@(5.0), @"dockedNum":@(1.0)},
        @"CLEnhanceRedEye"          :@{@"name":@"RedEye",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultRedEyeEnhance_DefaultTitle",                   nil,[CLImageEditorTheme bundle],@"Red Eye", @""),    @"version":@(5.0), @"dockedNum":@(2.0)},
        @"CLEnhanceNight"           :@{@"name":@"Night",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultNightEnhance_DefaultTitle",                     nil,[CLImageEditorTheme bundle],@"Night", @""),      @"version":@(5.0), @"dockedNum":@(3.0)},
        @"CLEnhanceScenery"         :@{@"name":@"Scenery",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSceneryEnhance_DefaultTitle",                 nil,[CLImageEditorTheme bundle],@"Scenery", @""),    @"version":@(5.0), @"dockedNum":@(4.0)},
        @"CLEnhanceFood"            :@{@"name":@"Food",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFoodEnhance_DefaultTitle",                       nil,[CLImageEditorTheme bundle],@"Food", @""),       @"version":@(5.0), @"dockedNum":@(5.0)},
        @"CLEnhancePortrait"        :@{@"name":@"Portrait",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPortraitEnhance_DefaultTitle",               nil,[CLImageEditorTheme bundle],@"Portrait", @""),   @"version":@(5.0), @"dockedNum":@(6.0)},
        @"CLEnhanceHighDef"         :@{@"name":@"HighDef",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultHighDefEnhance_DefaultTitle",                 nil,[CLImageEditorTheme bundle],@"Portrait", @""),   @"version":@(5.0), @"dockedNum":@(6.0)},
      };
    }
    return defaultEnhanceInfo;
}

+ (id)defaultInfoForKey:(NSString*)key
{
    return self.defaultEnhanceInfo[NSStringFromClass(self)][key];
}

+ (NSString*)enhanceName
{
    return [self defaultInfoForKey:@"name"];
}

+ (NSString*)enhanceVersion2
{
    return [self defaultInfoForKey:@"FV"];
}

#pragma mark- 

+ (NSString*)defaultTitle
{
    return [self defaultInfoForKey:@"title"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= [[self defaultInfoForKey:@"version"] floatValue]);
}

+ (CGFloat)defaultDockedNumber
{
    return [[self defaultInfoForKey:@"dockedNum"] floatValue];
}

#pragma mark- 

+ (UIImage*)applyEnhance:(UIImage *)image
{
    UIImage *enhanceImage = [self enhanceedImage:image withEnhanceName:self.enhanceName withEnhanceVersion2:self.enhanceVersion2];
    
    UIGraphicsBeginImageContextWithOptions(enhanceImage.size, NO, enhanceImage.scale);
    [image drawAtPoint:CGPointZero];
    [enhanceImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:_alphavalueEnhance];
    enhanceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return enhanceImage;
}


+ (UIImage*)applyEnhance2:(UIImage *)image
{
    return [self enhanceedImage:image withEnhanceName:self.enhanceName withEnhanceVersion2:self.enhanceVersion2];
}

+ (UIImage*)enhanceedImage:(UIImage*)image withEnhanceName:(NSString*)enhanceName withEnhanceVersion2:(NSString*)enhanceVersion2
{
    
    if([currentEnhance isEqualToString:@""]){
        currentEnhance = @"CLDefaultEmptyEnhance";
    }
    
    if(enhanceName == currentEnhance){
        enhanceName = @"CLDefaultEmptyEnhance";
        currentEnhance = enhanceName;
        return image;
    }
    
    if([enhanceName isEqualToString:@"CLDefaultEmptyEnhance"]){
        currentEnhance = enhanceName;
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    if([enhanceName isEqualToString:@"RedEye"]){
        
        NSArray* adjustments = [ciImage autoAdjustmentFiltersWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIImageAutoAdjustEnhance]];
        for (CIFilter* enhance in adjustments)
        {
            [enhance setValue:ciImage forKey:kCIInputImageKey];
            ciImage = enhance.outputImage;
        }
        CIContext* ctx = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [ctx createCGImage:ciImage fromRect:[ciImage extent]];
        UIImage* final = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return final;
        
    }
    
    if([enhanceName isEqualToString:@"AutoAdjust"]){
        
        NSArray* adjustments = [ciImage autoAdjustmentFiltersWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIImageAutoAdjustRedEye]];
        for (CIFilter* enhance in adjustments)
        {
            [enhance setValue:ciImage forKey:kCIInputImageKey];
            ciImage = enhance.outputImage;
        }
        CIContext* ctx = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [ctx createCGImage:ciImage fromRect:[ciImage extent]];
        UIImage* final = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return final;
    }
    
    if([enhanceName isEqualToString:@"Night"]){
        
        enhancefilter = [CIFilter filterWithName:@"CIGammaAdjust"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.55] forKey:@"inputPower"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CIColorControls"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:1.09] forKey:@"inputContrast"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.01] forKey:@"inputBrightness"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CISharpenLuminance"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.3] forKey:@"inputSharpness"];
        ciImage = enhancefilter.outputImage;
        
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }
    
    if([enhanceName isEqualToString:@"Scenery"]){
        
        enhancefilter = [CIFilter filterWithName:@"CIColorControls"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:1.25] forKey:@"inputSaturation"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CISharpenLuminance"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.25] forKey:@"inputSharpness"];
        ciImage = enhancefilter.outputImage;
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }
    
    if([enhanceName isEqualToString:@"Food"]){
        
        enhancefilter = [CIFilter filterWithName:@"CIGammaAdjust"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.85] forKey:@"inputPower"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CIColorControls"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:1.4] forKey:@"inputSaturation"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CISharpenLuminance"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.5] forKey:@"inputSharpness"];
        ciImage = enhancefilter.outputImage;
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }

    if([enhanceName isEqualToString:@"Portrait"]){
        
        enhancefilter = [CIFilter filterWithName:@"CIGammaAdjust"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.95] forKey:@"inputPower"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CIColorControls"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:1.2] forKey:@"inputSaturation"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CISharpenLuminance"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.65] forKey:@"inputSharpness"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CIVignetteEffect"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2] forKey:@"inputCenter"];
        [enhancefilter setValue:[NSNumber numberWithFloat:MAX(image.size.width, image.size.height)*0.65] forKey:@"inputRadius"];
        ciImage = enhancefilter.outputImage;

        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }

    
    if([enhanceName isEqualToString:@"HighDef"]){
        
        enhancefilter = [CIFilter filterWithName:@"CIGammaAdjust"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.95] forKey:@"inputPower"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CIColorControls"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:1.1] forKey:@"inputSaturation"];
        ciImage = enhancefilter.outputImage;
        
        enhancefilter = [CIFilter filterWithName:@"CISharpenLuminance"];
        [enhancefilter setValue:ciImage forKey:@"inputImage"];
        [enhancefilter setValue:[NSNumber numberWithFloat:0.95] forKey:@"inputSharpness"];
        ciImage = enhancefilter.outputImage;
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *imageResult = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        return imageResult;
    }

    return image;
}
@end


@interface CLEnhanceAutoAdjust : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceAutoAdjust
@end

@interface CLEnhanceRedEye : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceRedEye
@end

@interface CLEnhanceNight : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceNight
@end

@interface CLEnhanceScenery : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceScenery
@end

@interface CLEnhanceFood : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceFood
@end

@interface CLEnhanceHighDef : CLDefaultEmptyEnhance
@end
@implementation CLEnhanceHighDef
@end

@interface CLEnhancePortrait : CLDefaultEmptyEnhance
@end
@implementation CLEnhancePortrait
@end