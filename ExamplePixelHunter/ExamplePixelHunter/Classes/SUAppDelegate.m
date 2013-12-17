//
//  SUAppDelegate.m
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 11/1/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUAppDelegate.h"
#import "SUPixelHunter.h"


@implementation SUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SUPixelHunter setup];
    
    return YES;
}

@end
