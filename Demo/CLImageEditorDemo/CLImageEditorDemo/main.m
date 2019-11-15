//
//  main.m
//  CLImageEditorDemo
//
//  Created by Kevin Siml - Appzer.de on 2015/11/14.
//  Copyright (c) 2015 Appzer.de. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        // Only for testing the languages -> not for live -> for changeing to default > delete and reinstall the app
        //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"de", @"en", @"fr", nil] forKey:@"AppleLanguages"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
