//
//  CLFontPickerView.h
//
//  Created by Kevin Siml - Appzer.de on 2015/12/14.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLFontPickerViewDelegate;

@interface CLFontPickerView : UIView

@property (nonatomic, weak) id<CLFontPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *fontList;
@property (nonatomic, strong) NSArray *fontSizes;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL sizeComponentHidden;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *textColor;

@end


@protocol CLFontPickerViewDelegate <NSObject>
@optional
- (void)fontPickerView:(CLFontPickerView*)pickerView didSelectFont:(UIFont*)font;

@end