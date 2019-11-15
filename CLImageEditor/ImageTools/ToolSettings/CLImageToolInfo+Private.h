//
//  CLImageToolInfo+Private.h
//
//  Created by Kevin Siml - Appzer.de on 2015/12/07.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageToolInfo.h"

@protocol CLImageToolProtocol;

@interface CLImageToolInfo (Private)

+ (CLImageToolInfo*)toolInfoForToolClass:(Class<CLImageToolProtocol>)toolClass;
+ (NSArray*)toolsWithToolClass:(Class<CLImageToolProtocol>)toolClass;

@end
