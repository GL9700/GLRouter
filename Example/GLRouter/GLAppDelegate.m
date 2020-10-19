//
//  GLAppDelegate.m
//  GLRouter
//
//  Created by 36617161@qq.com on 10/10/2020.
//  Copyright (c) 2020 36617161@qq.com. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLViewController.h"

@implementation GLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[GLViewController new]];
    self.window.rootViewController = nav;
    return YES;
}
@end
