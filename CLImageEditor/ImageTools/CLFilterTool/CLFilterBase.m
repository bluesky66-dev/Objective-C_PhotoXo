//
//  CLFilterBase.m
//
//  Created by Kevin Siml - Appzer.de on 2015/11/26.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLFilterBase.h"

float _alphavalue = 1.0f;

@implementation CLFilterBase

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (NSArray*)subtools
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return @"CLFilterBase";
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

+ (UIImage*)applyFilter:(UIImage*)image
{
    return image;
}

+ (UIImage*)applyFilter2:(UIImage*)image
{
    return image;
}

@end




#pragma mark- Default Filters


@interface CLDefaultEmptyFilter : CLFilterBase

@end

@implementation CLDefaultEmptyFilter

+ (NSDictionary*)defaultFilterInfo
{
    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
     defaultFilterInfo =
      @{
        @"CLDefaultEmptyFilter"    :@{@"name":@"CLDefaultEmptyFilter",   @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEmptyFilter_DefaultTitle",     nil,[CLImageEditorTheme bundle],@"None", @""),        @"version":@(0.0), @"dockedNum":@(0.0)},
        @"CLDefaultLinearFilter"   :@{@"name":@"CISRGBToneCurveToLinear",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLinearFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Linear", @""),      @"version":@(7.0), @"dockedNum":@(1.0)},
        @"CLDefaultVignetteFilter" :@{@"name":@"CIVignetteEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultVignetteFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Vignette", @""),    @"version":@(7.0), @"dockedNum":@(2.0)},
        @"CLDefaultAmatorkaFilter" :@{@"name":@"CIAmatorkaEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultAmatorkaFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Amatorka", @""),    @"version":@(5.0), @"dockedNum":@(3.0)},
        @"CLDefaultEtikateFilter"  :@{@"name":@"CIEtikateEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEtikateFilter_DefaultTitle",   nil,[CLImageEditorTheme bundle],@"Etikate", @""),     @"version":@(5.0), @"dockedNum":@(4.0)},
        @"CLDefaultEleganceFilter" :@{@"name":@"CIEleganceEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEleganceFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Elegance", @""),    @"version":@(5.0), @"dockedNum":@(5.0)},
        @"CLDefaultInstantFilter"  :@{@"name":@"CIPhotoEffectInstant",   @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultInstantFilter_DefaultTitle",   nil,[CLImageEditorTheme bundle],@"Instant", @""),     @"version":@(7.0), @"dockedNum":@(6.0)},
        @"CLDefaultProcessFilter"  :@{@"name":@"CIPhotoEffectProcess",   @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultProcessFilter_DefaultTitle",   nil,[CLImageEditorTheme bundle],@"Process", @""),     @"version":@(7.0), @"dockedNum":@(7.0)},
        @"CLDefaultTransferFilter" :@{@"name":@"CIPhotoEffectTransfer",  @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTransferFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Transfer", @""),    @"version":@(7.0), @"dockedNum":@(8.0)},
        @"CLDefaultChromeFilter"   :@{@"name":@"CIPhotoEffectChrome",    @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultChromeFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Chrome", @""),      @"version":@(7.0), @"dockedNum":@(9.0)},
        @"CLDefaultFadeFilter"     :@{@"name":@"CIPhotoEffectFade",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFadeFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Fade", @""),        @"version":@(7.0), @"dockedNum":@(10.0)},
        @"CLDefaultVibranceFilter" :@{@"name":@"CIVibrance",             @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCIVibranceFilter_DefaultTitle",nil,[CLImageEditorTheme bundle],@"Vibrance", @""),    @"version":@(5.0), @"dockedNum":@(11.0)},
        @"CLDefaultCurveFilter"    :@{@"name":@"CILinearToSRGBToneCurve",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCurveFilter_DefaultTitle",     nil,[CLImageEditorTheme bundle],@"Curve", @""),       @"version":@(7.0), @"dockedNum":@(12.0)},
        @"CLDefaultUnsharpFilter"  :@{@"name":@"CIUnsharpMask",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultUnsharpFilter_DefaultTitle",   nil,[CLImageEditorTheme bundle],@"Unsharp Mask", @""),@"version":@(6.0), @"dockedNum":@(13.0)},
        
        @"CLDefaultK1Filter"       :@{@"name":@"CIK1Effect",            @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultK1Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"K1", @""),    @"version":@(5.0), @"dockedNum":@(13.1)},
        @"CLDefaultK2Filter"       :@{@"name":@"CIK2Effect",            @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultK2Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"K2", @""),    @"version":@(5.0), @"dockedNum":@(13.2)},
        @"CLDefaultK6Filter"       :@{@"name":@"CIK6Effect",            @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultK6Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"K6", @""),    @"version":@(5.0), @"dockedNum":@(13.3)},
        @"CLDefaultKDynamicFilter" :@{@"name":@"CIKDynamicEffect",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultKDynamicFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"KDynamic", @""),    @"version":@(5.0), @"dockedNum":@(13.4)},
        @"CLDefaultPola669Filter"  :@{@"name":@"CIPola669Effect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPola669Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Pola669", @""),    @"version":@(5.0), @"dockedNum":@(13.41)},
        @"CLDefaultPolaSXFilter"   :@{@"name":@"CIPolaSXEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPolaSXFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"PolaSX", @""),    @"version":@(5.0), @"dockedNum":@(13.42)},
        @"CLDefaultLomoFilter"     :@{@"name":@"CILomoEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLomoFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Lomo", @""),    @"version":@(5.0), @"dockedNum":@(13.43)},
        @"CLDefaultLomo100Filter"  :@{@"name":@"CILomo100Effect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLomo100Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Lomo100", @""),    @"version":@(5.0), @"dockedNum":@(13.44)},
        @"CLDefaultPro400Filter"   :@{@"name":@"CIPro400Effect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPro400Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Pro400", @""),    @"version":@(5.0), @"dockedNum":@(13.45)},

        @"CLDefaultFridgeFilter"   :@{@"name":@"CIFridgeEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFridgeFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Fridge", @""),    @"version":@(5.0), @"dockedNum":@(13.5)},
        @"CLDefaultBreezeFilter"   :@{@"name":@"CIBreezeEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultBreezeFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Breeze", @""),    @"version":@(5.0), @"dockedNum":@(13.6)},
        @"CLDefaultOrchidFilter"   :@{@"name":@"CIOrchidEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultOrchidFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Orchid", @""),    @"version":@(5.0), @"dockedNum":@(13.7)},
        @"CLDefaultChestFilter"    :@{@"name":@"CIChestEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultChestFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Chest", @""),    @"version":@(5.0), @"dockedNum":@(13.8)},
        @"CLDefaultFrontFilter"    :@{@"name":@"CIFrontEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFrontFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Front", @""),    @"version":@(5.0), @"dockedNum":@(13.9)},
        @"CLDefaultFixieFilter"    :@{@"name":@"CIFixieEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFixieFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Fixie", @""),    @"version":@(5.0), @"dockedNum":@(14.0)},
        @"CLDefaultLeninFilter"    :@{@"name":@"CILeninEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLeninFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Lenin", @""),    @"version":@(5.0), @"dockedNum":@(14.1)},
        @"CLDefaultQuoziFilter"    :@{@"name":@"CIQuoziEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultQuoziFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Quozi", @""),    @"version":@(5.0), @"dockedNum":@(14.2)},
        @"CLDefaultFoodFilter"     :@{@"name":@"CIFoodEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFoodFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Food", @""),    @"version":@(5.0), @"dockedNum":@(14.5)},
        @"CLDefaultGlamFilter"     :@{@"name":@"CIGlamEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultGlamFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Glam", @""),    @"version":@(5.0), @"dockedNum":@(14.6)},
        @"CLDefaultCelsiusFilter"  :@{@"name":@"CICelsiusEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCelsiusFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Celsius", @""),    @"version":@(5.0), @"dockedNum":@(14.7)},
        @"CLDefaultTexasFilter"    :@{@"name":@"CITexasEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTexasFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Texas", @""),    @"version":@(5.0), @"dockedNum":@(14.9)},
        @"CLDefaultGoblinFilter"   :@{@"name":@"CIGoblinEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultGoblinFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Goblin", @""),    @"version":@(5.0), @"dockedNum":@(15.0)},
        @"CLDefaultMellowFilter"   :@{@"name":@"CIMellowEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultMellowFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Mellow", @""),    @"version":@(5.0), @"dockedNum":@(15.1)},
        @"CLDefaultSoftFilter"     :@{@"name":@"CISoftEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSoftFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Soft", @""),    @"version":@(5.0), @"dockedNum":@(15.2)},
        @"CLDefaultBluesFilter"    :@{@"name":@"CIBluesEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultBluesFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Blues", @""),    @"version":@(5.0), @"dockedNum":@(15.3)},
        @"CLDefaultElderFilter"    :@{@"name":@"CIElderEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultElderFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Elder", @""),    @"version":@(5.0), @"dockedNum":@(15.4)},
        
        @"CLDefaultSteelFilter"    :@{@"name":@"CISteelEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSteelFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Steel", @""),    @"version":@(5.0), @"dockedNum":@(15.8)},
        @"CLDefaultBleachedFilter" :@{@"name":@"CIBleachedEffect",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultBleachedFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Bleached", @""),    @"version":@(5.0), @"dockedNum":@(16.0)},
        @"CLDefaultBleachedBlueFilter" :@{@"name":@"CIBleachedBlueEffect", @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultBleachedBlueFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Bleached Blue", @""),    @"version":@(5.0), @"dockedNum":@(16.1)},
        
        @"CLDefaultHighContrastFilter" :@{@"name":@"CIHighContrastEffect",@"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultHighContrastFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"HighContrast", @""),  @"version":@(5.0), @"dockedNum":@(16.2)},
        @"CLDefaultHighcarbFilter" :@{@"name":@"CIHighcarbEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultHighcarbFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Highcarb", @""),    @"version":@(5.0), @"dockedNum":@(16.3)},
        @"CLDefaultSeventiesFilter":@{@"name":@"CISeventiesEffect",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSeventiesFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Seventies", @""),    @"version":@(5.0), @"dockedNum":@(16.4)},
        @"CLDefaultEightiesFilter" :@{@"name":@"CIEightiesEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEightiesFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Eighties", @""),    @"version":@(5.0), @"dockedNum":@(16.5)},
        @"CLDefaultColorfulFilter" :@{@"name":@"CIColorfulEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultColorfulFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Colorful", @""),    @"version":@(5.0), @"dockedNum":@(16.6)},
        @"CLDefaultTwilightFilter" :@{@"name":@"CITwilightEffect",       @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTwilightFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Twilight", @""),    @"version":@(5.0), @"dockedNum":@(16.9)},
        @"CLDefaultCottonCandyFilter" :@{@"name":@"CICottonCandyEffect", @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCottonCandyFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"CottonCandy", @""),    @"version":@(5.0), @"dockedNum":@(17.0)},
        @"CLDefaultPaleFilter"     :@{@"name":@"CIPaleEffect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPaleFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Pale", @""),    @"version":@(5.0), @"dockedNum":@(17.1)},
        @"CLDefaultSettledFilter"  :@{@"name":@"CISettledEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSettledFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Settled", @""),    @"version":@(5.0), @"dockedNum":@(17.2)},
        @"CLDefaultCoolFilter"     :@{@"name":@"CICoolEffect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCoolFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Cool", @""),    @"version":@(5.0), @"dockedNum":@(17.3)},
        @"CLDefaultLithoFilter"    :@{@"name":@"CILithoEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLithoFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Litho", @""),    @"version":@(5.0), @"dockedNum":@(17.4)},
        @"CLDefaultAncientFilter"  :@{@"name":@"CIAncientEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultAncientFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Ancient", @""),    @"version":@(5.0), @"dockedNum":@(17.5)},
        @"CLDefaultPitchedFilter"  :@{@"name":@"CIPitchedEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPitchedFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Pitched", @""),    @"version":@(5.0), @"dockedNum":@(17.6)},
        @"CLDefaultLucidFilter"    :@{@"name":@"CILucidEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultLucidFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Lucid", @""),    @"version":@(5.0), @"dockedNum":@(17.7)},
        @"CLDefaultCreamyFilter"   :@{@"name":@"CICreamyEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCreamyFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Creamy", @""),    @"version":@(5.0), @"dockedNum":@(17.8)},
        @"CLDefaultKeenFilter"     :@{@"name":@"CIKeenEffect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultKeenFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Keen", @""),    @"version":@(5.0), @"dockedNum":@(17.9)},
        @"CLDefaultTenderFilter"   :@{@"name":@"CITenderEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTenderFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Tender", @""),    @"version":@(5.0), @"dockedNum":@(18.0)},
        @"CLDefaultClassicFilter"  :@{@"name":@"CIClassicEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultClassicFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Classic", @""),    @"version":@(5.0), @"dockedNum":@(18.1)},
        @"CLDefaultNoGreenFilter"  :@{@"name":@"CINoGreenEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultNoGreenFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"NoGreen", @""),    @"version":@(5.0), @"dockedNum":@(18.2)},
        @"CLDefaultNeatFilter"     :@{@"name":@"CINeatEffect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultNeatFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Neat", @""),    @"version":@(5.0), @"dockedNum":@(18.3)},
        @"CLDefaultPlateFilter"    :@{@"name":@"CIPlateEffect",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPlateFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Plate", @""),    @"version":@(5.0), @"dockedNum":@(18.4)},
        
        @"CLDefaultSummerFilter"   :@{@"name":@"CISummerEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSummerFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Summer", @""),        @"version":@(5.0), @"dockedNum":@(18.5)},
        @"CLDefaultFallFilter"     :@{@"name":@"CIFallEffect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFallFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Fall", @""),            @"version":@(5.0), @"dockedNum":@(18.6)},
        @"CLDefaultWinterFilter"   :@{@"name":@"CIWinterEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultWinterFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Winter", @""),        @"version":@(5.0), @"dockedNum":@(18.7)},
        @"CLDefaultSunsetFilter"   :@{@"name":@"CISunsetEffect",         @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSunsetFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Sunset", @""),        @"version":@(5.0), @"dockedNum":@(18.8)},
        @"CLDefaultEveningFilter"  :@{@"name":@"CIEveningEffect",        @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEveningFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Evening", @""),      @"version":@(5.0), @"dockedNum":@(18.9)},
        
        @"CLDefaultX400Filter"     :@{@"name":@"CIX400Effect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultX400Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"X400", @""),            @"version":@(5.0), @"dockedNum":@(19.0)},
        @"CLDefaultNoirFilter"     :@{@"name":@"CIPhotoEffectNoir",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultNoirFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Noir", @""),        @"version":@(7.0), @"dockedNum":@(19.1)},
        @"CLDefaultTonalFilter"    :@{@"name":@"CIPhotoEffectTonal",     @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTonalFilter_DefaultTitle",     nil,[CLImageEditorTheme bundle],@"Tonal", @""),       @"version":@(7.0), @"dockedNum":@(19.2)},
        @"CLDefaultMonoFilter"     :@{@"name":@"CIPhotoEffectMono",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultMonoFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Mono", @""),        @"version":@(7.0), @"dockedNum":@(19.3)},

        @"CLDefaultSinFilter"      :@{@"name":@"CISinEffect",            @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSinFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Sin Red", @""),          @"version":@(5.0), @"dockedNum":@(20.1)},
        @"CLDefaultSin1Filter"     :@{@"name":@"CISin1Effect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSin1Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Sin Green", @""),       @"version":@(5.0), @"dockedNum":@(20.2)},
        @"CLDefaultSin2Filter"     :@{@"name":@"CISin2Effect",           @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSin2Filter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Sin Blue", @""),        @"version":@(5.0), @"dockedNum":@(20.3)},
        @"CLDefaultNightFilter"    :@{@"name":@"CINightVision",          @"FV":@"1", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultNightFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Nightvision", @""),  @"version":@(6.0), @"dockedNum":@(21.0)},
        @"CLDefaultPredatorFilter" :@{@"name":@"CIPredatorVision",       @"FV":@"1", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultPredatorFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Predator", @""),  @"version":@(6.0), @"dockedNum":@(22.0)},
        @"CLDefaultArcadeFilter"   :@{@"name":@"CIArcadeVision",         @"FV":@"1", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultArcadeFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Arcade", @""),      @"version":@(6.0), @"dockedNum":@(22.5)},
        @"CLDefaultXRayFilter"     :@{@"name":@"CIXRayVision",           @"FV":@"1", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultXRayFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"X-Ray", @""),         @"version":@(6.0), @"dockedNum":@(23.0)},
        
        @"CLDefaultInvertFilter"   :@{@"name":@"CIColorInvert",          @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultInvertFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Invert", @""),      @"version":@(6.0), @"dockedNum":@(25.0)},
        @"CLDefaultSepiaFilter"    :@{@"name":@"CISepiaTone",            @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSepiaFilter_DefaultTitle",     nil,[CLImageEditorTheme bundle],@"Sepia", @""),       @"version":@(5.0), @"dockedNum":@(26.0)},
        @"CLDefaultSepiaHighFilter":@{@"name":@"CISepiaHighEffect",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSepiaHighFilter_DefaultTitle", nil,[CLImageEditorTheme bundle],@"SepiaHigh",@""),    @"version":@(5.0), @"dockedNum":@(27.0)},

        @"CLDefaultGoldFilter"     :@{@"name":@"CIColorMonochrome",      @"FV":@"5", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultGoldFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Gold", @""),        @"version":@(5.0), @"dockedNum":@(28.0)},
        @"CLDefaultBronceFilter"   :@{@"name":@"CIColorMonochrome",      @"FV":@"0", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultBronceFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle],@"Bronce", @""),      @"version":@(5.0), @"dockedNum":@(29.0)},
        @"CLDefaultRubyFilter"     :@{@"name":@"CIColorMonochrome",      @"FV":@"1", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultRubyFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Ruby", @""),        @"version":@(5.0), @"dockedNum":@(30.0)},
        @"CLDefaultEmeraldFilter"  :@{@"name":@"CIColorMonochrome",      @"FV":@"2", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultEmeraldFilter_DefaultTitle",   nil,[CLImageEditorTheme bundle],@"Emerald", @""),     @"version":@(5.0), @"dockedNum":@(31.0)},
        @"CLDefaultAmethystFilter" :@{@"name":@"CIColorMonochrome",      @"FV":@"3", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultAmethystFilter_DefaultTitle",  nil,[CLImageEditorTheme bundle],@"Amethyst", @""),    @"version":@(5.0), @"dockedNum":@(32.0)},
        @"CLDefaultAquaFilter"     :@{@"name":@"CIColorMonochrome",      @"FV":@"4", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultAquaFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Aqua", @""),        @"version":@(5.0), @"dockedNum":@(33.0)},
        @"CLDefaultRoseFilter"     :@{@"name":@"CIColorMonochrome",      @"FV":@"6", @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultRoseFilter_DefaultTitle",      nil,[CLImageEditorTheme bundle],@"Rose", @""),        @"version":@(5.0), @"dockedNum":@(34.0)},
      };
    }
    return defaultFilterInfo;
}

+ (id)defaultInfoForKey:(NSString*)key
{
    return self.defaultFilterInfo[NSStringFromClass(self)][key];
}

+ (NSString*)filterName
{
    return [self defaultInfoForKey:@"name"];
}

+ (NSString*)filterVersion2
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

+ (UIImage*)applyFilter:(UIImage *)image
{
    UIImage *filterImage = [self filteredImage:image withFilterName:self.filterName withFilterVersion2:self.filterVersion2];
    
    UIGraphicsBeginImageContextWithOptions(filterImage.size, NO, filterImage.scale);
    [image drawAtPoint:CGPointZero];
    [filterImage drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:_alphavalue];
    filterImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return filterImage;
}


+ (UIImage*)applyFilter2:(UIImage *)image
{
    return [self filteredImage:image withFilterName:self.filterName withFilterVersion2:self.filterVersion2];
}

+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName withFilterVersion2:(NSString*)filterVersion2
{
    
    if([currentFilter isEqualToString:@""]){
        currentFilter = @"CLDefaultEmptyFilter";
    }
    
    if(filterName == currentFilter){
        filterName = @"CLDefaultEmptyFilter";
        currentFilter = filterName;
        return image;
    }
    
    if([filterName isEqualToString:@"CLDefaultEmptyFilter"]){
        currentFilter = filterName;
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    //NSLog(@"%@", filterVersion2);
    
    if([filterName isEqualToString:@"CIVignetteEffect"]){
        // parameters for CIVignetteEffect
        CGFloat R = MIN(image.size.width, image.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    
    if([filterName isEqualToString:@"CIVibrance"]){
        // parameters for CIVibrance
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputAmount"];
    }
    
    if([filterName isEqualToString:@"CIUnsharpMask"]){
        // parameters for CIUnsharpMask
        [filter setValue:[NSNumber numberWithFloat:3] forKey:@"inputRadius"];
        [filter setValue:[NSNumber numberWithFloat:1.5] forKey:@"inputIntensity"];
    }

    if([filterName isEqualToString:@"CINightVision"]){
        
        filterName = @"CIColorControls";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setValue: [NSNumber numberWithFloat:-0.2] forKey: @"inputBrightness"];
        [filter setValue: [NSNumber numberWithFloat:0.5] forKey: @"inputContrast"];
        CIImage *outputImage = [filter outputImage];
        
        filterName = @"CIColorMonochrome";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        [filter setValue: [CIColor colorWithRed:0.5f green:1.0f blue:0.1f alpha:1.0f] forKey: @"inputColor"];
        outputImage = [filter outputImage];
        
        filterName = @"CIVignetteEffect";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        CGFloat R = MIN(image.size.width, image.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
        outputImage = [filter outputImage];
        
        filterName = @"CIExposureAdjust";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        [filter setValue:[NSNumber numberWithFloat:1.3] forKey: @"inputEV"];
        outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage =  [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        currentFilter = filterName;
        
        return result;
    }
    
    if([filterName isEqualToString:@"CIXRayVision"]){
        
        filterName = @"CIColorControls";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setValue: [NSNumber numberWithFloat:0.5] forKey: @"inputBrightness"];
        CIImage *outputImage = [filter outputImage];
        
        filterName = @"CIColorInvert";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        outputImage = [filter outputImage];
        
        filterName = @"CIPhotoEffectNoir";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage =  [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        currentFilter = filterName;
        
        return result;
    }
    
    if([filterName isEqualToString:@"CIArcadeVision"]){
        
        filterName = @"CIColorControls";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setValue: [NSNumber numberWithFloat:0.5] forKey: @"inputBrightness"];
        CIImage *outputImage = [filter outputImage];
        
        filterName = @"CIColorInvert";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        outputImage = [filter outputImage];
        
        CIColor *color = [CIColor colorWithRed:0.45 green:1.0 blue:0.1 alpha:1.0];
        filter = [CIFilter filterWithName:@"CIColorMonochrome"];
        [filter setValue:outputImage forKey:@"inputImage"];
        [filter setValue:[NSNumber numberWithFloat:(int)1] forKey:@"inputIntensity"];
        [filter setValue:color forKey:@"inputColor"];
        outputImage = filter.outputImage;
        
        filterName = @"CIVignetteEffect";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        CGFloat R = MIN(image.size.width, image.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.75] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
        outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage =  [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        GPUImageEightiesFilter *stillImageFilter = [[GPUImageEightiesFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:result];
        currentFilter = filterName;
        return quickFilteredImage;
        
    }
    
    if([filterName isEqualToString:@"CIPredatorVision"]){
        
        CIContext *context = [CIContext contextWithOptions:nil];
        NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:context options:opts];
        NSArray *features = [detector featuresInImage:ciImage];
        
        filterName = @"CIToneCurve";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
        [filter setValue:[CIVector vectorWithX:0 Y:0] forKey:@"inputPoint0"];
        [filter setValue:[CIVector vectorWithX:0.25 Y:0.25] forKey:@"inputPoint1"];
        [filter setValue:[CIVector vectorWithX:0.5 Y:0] forKey:@"inputPoint2"];
        [filter setValue:[CIVector vectorWithX:0.75 Y:0.5] forKey:@"inputPoint3"];
        [filter setValue:[CIVector vectorWithX:1 Y:0.5] forKey:@"inputPoint4"];
        context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
            
        filterName = @"CIColorMonochrome";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        [filter setValue: [CIColor colorWithRed:1.0f green:0.1f blue:0.1f alpha:1.0f] forKey: @"inputColor"];
        context = [CIContext contextWithOptions:nil];
        outputImage = [filter outputImage];
        
        filterName = @"CIExposureAdjust";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        [filter setValue:[NSNumber numberWithFloat:0.75] forKey: @"inputEV"];
        context = [CIContext contextWithOptions:nil];
        outputImage = [filter outputImage];
        
        filterName = @"CIColorControls";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        [filter setValue: [NSNumber numberWithFloat:1.5] forKey: @"inputSaturation"];
        context = [CIContext contextWithOptions:nil];
        outputImage = [filter outputImage];
        
        filterName = @"CIVignetteEffect";
        filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, outputImage, nil];
        CGFloat R = MIN(image.size.width, image.size.height)/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.75] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
        context = [CIContext contextWithOptions:nil];
        outputImage = [filter outputImage];
        CGImageRef cgImage =  [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        
        UIImage *predator_txtimage = [UIImage imageNamed:@"predator_txt.png"];
        float max_height = image.size.height/1.5;
        float max_width = (image.size.width/1.5)/(image.size.width/1.5/predator_txtimage.size.width);
        CGSize newSize = CGSizeMake(max_width,max_height);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [predator_txtimage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, result.scale);
        [result drawAtPoint:CGPointZero];
        if(image.size.width>150){ // do not show in thumbnails
            [newImage drawAtPoint:CGPointMake(5, 5) blendMode:kCGBlendModeNormal alpha:0.66];
        }
        
        if(image.size.width>150){ // do not show in thumbnails
            UIImage *predator_target = [UIImage imageNamed:@"predator_target.png"];
            for (CIFaceFeature *f in features)
            {
                //[predator_target drawInRect:CGRectMake(f.bounds.origin.x, f.bounds.origin.y,f.bounds.size.width,f.bounds.size.height) blendMode:kCGBlendModeNormal alpha:0.66];
                [predator_target drawInRect:CGRectMake(f.bounds.origin.x-(f.bounds.size.width/4), image.size.height-f.bounds.origin.y-(f.bounds.size.height*1.4),f.bounds.size.width*1.5,f.bounds.size.height*1.5) blendMode:kCGBlendModeNormal alpha:0.66];

                NSLog(@"Bound: %@",CGRectCreateDictionaryRepresentation(f.bounds));
            }
        }
        
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRelease(cgImage);

        currentFilter = filterName;
            
        return result;
    }
    
    
    if([filterName isEqualToString:@"CIColorMonochrome"]){
        if([filterVersion2  isEqualToString: @"1"]){
            [filter setValue: [CIColor colorWithRed:0.8f green:0.1f blue:0.1f alpha:0.8f] forKey: @"inputColor"];
        }
        if([filterVersion2  isEqualToString: @"2"]){
            [filter setValue: [CIColor colorWithRed:0.1f green:0.7f blue:0.4f alpha:0.8f] forKey: @"inputColor"];
        }
        if([filterVersion2  isEqualToString: @"3"]){
            [filter setValue: [CIColor colorWithRed:0.4f green:0.3f blue:0.7f alpha:0.8f] forKey: @"inputColor"];
        }
        if([filterVersion2  isEqualToString: @"4"]){
            [filter setValue: [CIColor colorWithRed:0.6f green:0.7f blue:1.0f alpha:1.0f] forKey: @"inputColor"];
        }
        if([filterVersion2  isEqualToString: @"5"]){
            [filter setValue: [CIColor colorWithRed:0.9f green:0.8f blue:0.3f alpha:1.0f] forKey: @"inputColor"];
        }
        if([filterVersion2  isEqualToString: @"6"]){
            [filter setValue: [CIColor colorWithRed:0.8f green:0.5f blue:0.5f alpha:1.0f] forKey: @"inputColor"];
        }
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        currentFilter = filterName;

        return result;
    }
    
    
    if([filterName isEqualToString:@"CIAmatorkaEffect"]){
        GPUImageAmatorkaFilter *stillImageFilter = [[GPUImageAmatorkaFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIK1Effect"]){
        GPUImageK1Filter *stillImageFilter = [[GPUImageK1Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIK2Effect"]){
        GPUImageK2Filter *stillImageFilter = [[GPUImageK2Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIK6Effect"]){
        GPUImageK6Filter *stillImageFilter = [[GPUImageK6Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIKDynamicEffect"]){
        GPUImageKDynamicFilter *stillImageFilter = [[GPUImageKDynamicFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIFridgeEffect"]){
        GPUImageFridgeFilter *stillImageFilter = [[GPUImageFridgeFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIBreezeEffect"]){
        GPUImageBreezeFilter *stillImageFilter = [[GPUImageBreezeFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIOrchidEffect"]){
        GPUImageOrchidFilter *stillImageFilter = [[GPUImageOrchidFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIChestEffect"]){
        GPUImageChestFilter *stillImageFilter = [[GPUImageChestFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIFrontEffect"]){
        GPUImageFrontFilter *stillImageFilter = [[GPUImageFrontFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIFixieEffect"]){
        GPUImageFixieFilter *stillImageFilter = [[GPUImageFixieFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CILeninEffect"]){
        GPUImageLeninFilter *stillImageFilter = [[GPUImageLeninFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIQuoziEffect"]){
        GPUImageQuoziFilter *stillImageFilter = [[GPUImageQuoziFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPola669Effect"]){
        GPUImagePola669Filter *stillImageFilter = [[GPUImagePola669Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPolaSXEffect"]){
        GPUImagePolaSXFilter *stillImageFilter = [[GPUImagePolaSXFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIFoodEffect"]){
        GPUImageFoodFilter *stillImageFilter = [[GPUImageFoodFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIGlamEffect"]){
        GPUImageGlamFilter *stillImageFilter = [[GPUImageGlamFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CICelsiusEffect"]){
        GPUImageCelsiusFilter *stillImageFilter = [[GPUImageCelsiusFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CITexasEffect"]){
        GPUImageTexasFilter *stillImageFilter = [[GPUImageTexasFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CILomoEffect"]){
        GPUImageLomoFilter *stillImageFilter = [[GPUImageLomoFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIGoblinEffect"]){
        GPUImageGoblinFilter *stillImageFilter = [[GPUImageGoblinFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISinEffect"]){
        GPUImageSinFilter *stillImageFilter = [[GPUImageSinFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISin1Effect"]){
        GPUImageSin1Filter *stillImageFilter = [[GPUImageSin1Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISin2Effect"]){
        GPUImageSin2Filter *stillImageFilter = [[GPUImageSin2Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIHighContrastEffect"]){
        GPUImageHighContrastFilter *stillImageFilter = [[GPUImageHighContrastFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIHighcarbEffect"]){
        GPUImageHighcarbFilter *stillImageFilter = [[GPUImageHighcarbFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIEightiesEffect"]){
        GPUImageEightiesFilter *stillImageFilter = [[GPUImageEightiesFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIColorfulEffect"]){
        GPUImageColorfulFilter *stillImageFilter = [[GPUImageColorfulFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CILomo100Effect"]){
        GPUImageLomo100Filter *stillImageFilter = [[GPUImageLomo100Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPro400Effect"]){
        GPUImagePro400Filter *stillImageFilter = [[GPUImagePro400Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CITwilightEffect"]){
        GPUImageTwilightFilter *stillImageFilter = [[GPUImageTwilightFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CICottonCandyEffect"]){
        GPUImageCottonCandyFilter *stillImageFilter = [[GPUImageCottonCandyFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPaleEffect"]){
        GPUImagePaleFilter *stillImageFilter = [[GPUImagePaleFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISettledEffect"]){
        GPUImageSettledFilter *stillImageFilter = [[GPUImageSettledFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CICoolEffect"]){
        GPUImageCoolFilter *stillImageFilter = [[GPUImageCoolFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CILithoEffect"]){
        GPUImageLithoFilter *stillImageFilter = [[GPUImageLithoFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIAncientEffect"]){
        GPUImageAncientFilter *stillImageFilter = [[GPUImageAncientFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPitchedEffect"]){
        GPUImagePitchedFilter *stillImageFilter = [[GPUImagePitchedFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CILucidEffect"]){
        GPUImageLucidFilter *stillImageFilter = [[GPUImageLucidFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CICreamyEffect"]){
        GPUImageCreamyFilter *stillImageFilter = [[GPUImageCreamyFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIKeenEffect"]){
        GPUImageKeenFilter *stillImageFilter = [[GPUImageKeenFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CITenderEffect"]){
        GPUImageTenderFilter *stillImageFilter = [[GPUImageTenderFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIFallEffect"]){
        GPUImageFallFilter *stillImageFilter = [[GPUImageFallFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIWinterEffect"]){
        GPUImageWinterFilter *stillImageFilter = [[GPUImageWinterFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISepiaHighEffect"]){
        GPUImageSepiaHighFilter *stillImageFilter = [[GPUImageSepiaHighFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISummerEffect"]){
        GPUImageSummerFilter *stillImageFilter = [[GPUImageSummerFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIClassicEffect"]){
        GPUImageClassicFilter *stillImageFilter = [[GPUImageClassicFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CINoGreenEffect"]){
        GPUImageNoGreenFilter *stillImageFilter = [[GPUImageNoGreenFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CINeatEffect"]){
        GPUImageNeatFilter *stillImageFilter = [[GPUImageNeatFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIPlateEffect"]){
        GPUImagePlateFilter *stillImageFilter = [[GPUImagePlateFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIX400Effect"]){
        GPUImageX400Filter *stillImageFilter = [[GPUImageX400Filter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIMellowEffect"]){
        GPUImageMellowFilter *stillImageFilter = [[GPUImageMellowFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISoftEffect"]){
        GPUImageSoftFilter *stillImageFilter = [[GPUImageSoftFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIBluesEffect"]){
        GPUImageBluesFilter *stillImageFilter = [[GPUImageBluesFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIElderEffect"]){
        GPUImageElderFilter *stillImageFilter = [[GPUImageElderFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISunsetEffect"]){
        GPUImageSunsetFilter *stillImageFilter = [[GPUImageSunsetFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIEveningEffect"]){
        GPUImageEveningFilter *stillImageFilter = [[GPUImageEveningFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISteelEffect"]){
        GPUImageSteelFilter *stillImageFilter = [[GPUImageSteelFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CISeventiesEffect"]){
        GPUImageSeventiesFilter *stillImageFilter = [[GPUImageSeventiesFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIBleachedEffect"]){
        GPUImageBleachedFilter *stillImageFilter = [[GPUImageBleachedFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIBleachedBlueEffect"]){
        GPUImageBleachedBlueFilter *stillImageFilter = [[GPUImageBleachedBlueFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIEtikateEffect"]){
        GPUImageMissEtikateFilter *stillImageFilter = [[GPUImageMissEtikateFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else if([filterName isEqualToString:@"CIEleganceEffect"]){
        GPUImageSoftEleganceFilter *stillImageFilter = [[GPUImageSoftEleganceFilter alloc] init];
        UIImage *quickFilteredImage = [stillImageFilter imageByFilteringImage:image];
        currentFilter = filterName;
        return quickFilteredImage;
    } else {
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *result = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        currentFilter = filterName;
        return result;
    }
}
@end


@interface CLDefaultLinearFilter : CLDefaultEmptyFilter @end @implementation CLDefaultLinearFilter @end
@interface CLDefaultVignetteFilter : CLDefaultEmptyFilter @end @implementation CLDefaultVignetteFilter  @end
@interface CLDefaultAmatorkaFilter : CLDefaultEmptyFilter @end @implementation CLDefaultAmatorkaFilter  @end
@interface CLDefaultEtikateFilter : CLDefaultEmptyFilter @end @implementation CLDefaultEtikateFilter   @end
@interface CLDefaultEleganceFilter : CLDefaultEmptyFilter @end @implementation CLDefaultEleganceFilter  @end
@interface CLDefaultInstantFilter : CLDefaultEmptyFilter @end @implementation CLDefaultInstantFilter   @end
@interface CLDefaultProcessFilter : CLDefaultEmptyFilter @end @implementation CLDefaultProcessFilter   @end
@interface CLDefaultTransferFilter : CLDefaultEmptyFilter @end @implementation CLDefaultTransferFilter  @end
@interface CLDefaultChromeFilter : CLDefaultEmptyFilter @end @implementation CLDefaultChromeFilter @end
@interface CLDefaultFadeFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFadeFilter @end
@interface CLDefaultVibranceFilter : CLDefaultEmptyFilter @end @implementation CLDefaultVibranceFilter @end
@interface CLDefaultCurveFilter : CLDefaultEmptyFilter @end @implementation CLDefaultCurveFilter @end
@interface CLDefaultUnsharpFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultUnsharpFilter  @end
@interface CLDefaultK1Filter : CLDefaultEmptyFilter @end @implementation CLDefaultK1Filter @end
@interface CLDefaultK2Filter : CLDefaultEmptyFilter @end @implementation CLDefaultK2Filter @end
@interface CLDefaultK6Filter : CLDefaultEmptyFilter @end @implementation CLDefaultK6Filter @end
@interface CLDefaultKDynamicFilter : CLDefaultEmptyFilter @end @implementation CLDefaultKDynamicFilter @end
@interface CLDefaultPola669Filter  : CLDefaultEmptyFilter @end @implementation CLDefaultPola669Filter  @end
@interface CLDefaultPolaSXFilter : CLDefaultEmptyFilter @end @implementation CLDefaultPolaSXFilter @end
@interface CLDefaultLomoFilter : CLDefaultEmptyFilter @end @implementation CLDefaultLomoFilter @end
@interface CLDefaultLomo100Filter  : CLDefaultEmptyFilter @end @implementation CLDefaultLomo100Filter  @end
@interface CLDefaultPro400Filter : CLDefaultEmptyFilter @end @implementation CLDefaultPro400Filter @end
@interface CLDefaultFridgeFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFridgeFilter @end
@interface CLDefaultBreezeFilter : CLDefaultEmptyFilter @end @implementation CLDefaultBreezeFilter @end
@interface CLDefaultOrchidFilter : CLDefaultEmptyFilter @end @implementation CLDefaultOrchidFilter @end
@interface CLDefaultChestFilter : CLDefaultEmptyFilter @end @implementation CLDefaultChestFilter @end
@interface CLDefaultFrontFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFrontFilter @end
@interface CLDefaultFixieFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFixieFilter @end
@interface CLDefaultLeninFilter : CLDefaultEmptyFilter @end @implementation CLDefaultLeninFilter @end
@interface CLDefaultQuoziFilter : CLDefaultEmptyFilter @end @implementation CLDefaultQuoziFilter @end
@interface CLDefaultFoodFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFoodFilter @end
@interface CLDefaultGlamFilter : CLDefaultEmptyFilter @end @implementation CLDefaultGlamFilter @end
@interface CLDefaultCelsiusFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultCelsiusFilter  @end
@interface CLDefaultTexasFilter : CLDefaultEmptyFilter @end @implementation CLDefaultTexasFilter @end
@interface CLDefaultGoblinFilter : CLDefaultEmptyFilter @end @implementation CLDefaultGoblinFilter @end
@interface CLDefaultMellowFilter : CLDefaultEmptyFilter @end @implementation CLDefaultMellowFilter @end
@interface CLDefaultSoftFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSoftFilter @end
@interface CLDefaultBluesFilter : CLDefaultEmptyFilter @end @implementation CLDefaultBluesFilter @end
@interface CLDefaultElderFilter : CLDefaultEmptyFilter @end @implementation CLDefaultElderFilter @end
@interface CLDefaultSteelFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSteelFilter @end
@interface CLDefaultBleachedFilter : CLDefaultEmptyFilter @end @implementation CLDefaultBleachedFilter @end
@interface CLDefaultBleachedBlueFilter : CLDefaultEmptyFilter @end @implementation CLDefaultBleachedBlueFilter @end
@interface CLDefaultHighContrastFilter : CLDefaultEmptyFilter @end @implementation CLDefaultHighContrastFilter @end
@interface CLDefaultHighcarbFilter : CLDefaultEmptyFilter @end @implementation CLDefaultHighcarbFilter @end
@interface CLDefaultSeventiesFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSeventiesFilter @end
@interface CLDefaultEightiesFilter : CLDefaultEmptyFilter @end @implementation CLDefaultEightiesFilter @end
@interface CLDefaultColorfulFilter : CLDefaultEmptyFilter @end @implementation CLDefaultColorfulFilter @end
@interface CLDefaultTwilightFilter : CLDefaultEmptyFilter @end @implementation CLDefaultTwilightFilter @end
@interface CLDefaultCottonCandyFilter : CLDefaultEmptyFilter @end @implementation CLDefaultCottonCandyFilter @end
@interface CLDefaultPaleFilter : CLDefaultEmptyFilter @end @implementation CLDefaultPaleFilter @end
@interface CLDefaultSettledFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultSettledFilter  @end
@interface CLDefaultCoolFilter : CLDefaultEmptyFilter @end @implementation CLDefaultCoolFilter @end
@interface CLDefaultLithoFilter : CLDefaultEmptyFilter @end @implementation CLDefaultLithoFilter @end
@interface CLDefaultAncientFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultAncientFilter  @end
@interface CLDefaultPitchedFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultPitchedFilter  @end
@interface CLDefaultLucidFilter : CLDefaultEmptyFilter @end @implementation CLDefaultLucidFilter @end
@interface CLDefaultCreamyFilter : CLDefaultEmptyFilter @end @implementation CLDefaultCreamyFilter @end
@interface CLDefaultKeenFilter : CLDefaultEmptyFilter @end @implementation CLDefaultKeenFilter @end
@interface CLDefaultTenderFilter : CLDefaultEmptyFilter @end @implementation CLDefaultTenderFilter @end
@interface CLDefaultClassicFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultClassicFilter  @end
@interface CLDefaultNoGreenFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultNoGreenFilter  @end
@interface CLDefaultNeatFilter : CLDefaultEmptyFilter @end @implementation CLDefaultNeatFilter @end
@interface CLDefaultPlateFilter : CLDefaultEmptyFilter @end @implementation CLDefaultPlateFilter @end
@interface CLDefaultSummerFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSummerFilter @end
@interface CLDefaultFallFilter : CLDefaultEmptyFilter @end @implementation CLDefaultFallFilter @end
@interface CLDefaultWinterFilter : CLDefaultEmptyFilter @end @implementation CLDefaultWinterFilter @end
@interface CLDefaultSunsetFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSunsetFilter @end
@interface CLDefaultEveningFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultEveningFilter  @end
@interface CLDefaultX400Filter : CLDefaultEmptyFilter @end @implementation CLDefaultX400Filter @end
@interface CLDefaultNoirFilter : CLDefaultEmptyFilter @end @implementation CLDefaultNoirFilter @end
@interface CLDefaultTonalFilter : CLDefaultEmptyFilter @end @implementation CLDefaultTonalFilter @end
@interface CLDefaultMonoFilter : CLDefaultEmptyFilter @end @implementation CLDefaultMonoFilter @end
@interface CLDefaultSinFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultSinFilter  @end
@interface CLDefaultSin1Filter : CLDefaultEmptyFilter @end @implementation CLDefaultSin1Filter @end
@interface CLDefaultSin2Filter : CLDefaultEmptyFilter @end @implementation CLDefaultSin2Filter @end
@interface CLDefaultNightFilter : CLDefaultEmptyFilter @end @implementation CLDefaultNightFilter @end
@interface CLDefaultPredatorFilter : CLDefaultEmptyFilter @end @implementation CLDefaultPredatorFilter @end
@interface CLDefaultArcadeFilter : CLDefaultEmptyFilter @end @implementation CLDefaultArcadeFilter @end
@interface CLDefaultXRayFilter : CLDefaultEmptyFilter @end @implementation CLDefaultXRayFilter @end
@interface CLDefaultInvertFilter : CLDefaultEmptyFilter @end @implementation CLDefaultInvertFilter @end
@interface CLDefaultSepiaFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSepiaFilter @end
@interface CLDefaultSepiaHighFilter : CLDefaultEmptyFilter @end @implementation CLDefaultSepiaHighFilter @end
@interface CLDefaultGoldFilter : CLDefaultEmptyFilter @end @implementation CLDefaultGoldFilter @end
@interface CLDefaultBronceFilter : CLDefaultEmptyFilter @end @implementation CLDefaultBronceFilter @end
@interface CLDefaultRubyFilter : CLDefaultEmptyFilter @end @implementation CLDefaultRubyFilter @end
@interface CLDefaultEmeraldFilter  : CLDefaultEmptyFilter @end @implementation CLDefaultEmeraldFilter  @end
@interface CLDefaultAmethystFilter : CLDefaultEmptyFilter @end @implementation CLDefaultAmethystFilter @end
@interface CLDefaultAquaFilter : CLDefaultEmptyFilter @end @implementation CLDefaultAquaFilter @end
@interface CLDefaultRoseFilter : CLDefaultEmptyFilter @end @implementation CLDefaultRoseFilter @end
