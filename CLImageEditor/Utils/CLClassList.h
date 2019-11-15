//
//  CLClassList.h
//
//  Created by Kevin Siml - Appzer.de on 2015/11/14.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//  reference: http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html
//

#import <Foundation/Foundation.h>

@interface CLClassList : NSObject

+ (NSArray*)subclassesOfClass:(Class)parentClass;

@end
