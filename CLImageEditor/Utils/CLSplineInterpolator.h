//
//  CLSplineInterpolator.h
//
//  Created by Kevin Siml - Appzer.de on 2015/10/24.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//  Reference: http://www5d.biglobe.ne.jp/%257estssk/maze/spline.html
//

#import <Foundation/Foundation.h>

@interface CLSplineInterpolator : NSObject

- (id)initWithPoints:(NSArray*)points;          // points: array of CIVector
- (CIVector*)interpolatedPoint:(CGFloat)t;      // {t | 0 ≤ t ≤ 1}

@end
