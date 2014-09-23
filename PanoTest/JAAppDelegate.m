//
//  JAAppDelegate.m
//  PanoTest
//
//  Created by Javier Alonso Gutiérrez on 16/02/12.
//  Copyright (c) 2012 NG Servicios. All rights reserved.
//

#import "JAAppDelegate.h"

#import "JAViewController.h"

@implementation JAAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[JAViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
