//
//  CLCircleView.h
//
//  Created by Kevin Siml - Appzer.de on 2015/12/11.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCircleView : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@end
