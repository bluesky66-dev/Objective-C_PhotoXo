//
//  CLImageEditorTheme.m
//
//  Created by Kevin Siml - Appzer.de on 2015/12/05.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import "CLImageEditorTheme.h"

@implementation CLImageEditorTheme

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - singleton pattern

static CLImageEditorTheme *_sharedInstance = nil;

+ (CLImageEditorTheme*)theme
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CLImageEditorTheme alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.bundleName                     = @"CLImageEditor";
        self.backgroundColor                = [UIColor clearColor];
        self.toolbarColor                   = [UIColor colorWithWhite:1 alpha:0.5];
		self.toolIconColor                  = @"black";
        self.toolbarTextColor               = [UIColor blackColor];
        self.toolbarSelectedButtonColor     = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.toolbarTextFont                = [UIFont systemFontOfSize:10];
    }
    return self;
}

@end
