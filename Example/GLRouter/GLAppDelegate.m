//
//  GLAppDelegate.m
//  GLRouter
//
//  Created by liandyii@msn.com on 11/08/2018.
//  Copyright (c) 2018 liandyii@msn.com. All rights reserved.
//

#import "GLAppDelegate.h"
#import "GLTabBarController.h"

@implementation GLAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Router RouterWithScheme:kRouterScheme];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    GLTabBarController *tabbarController = [GLTabBarController new];
//    self.window.rootViewController = tabbarController;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tabbarController];
    [nav setNavigationBarHidden:YES];
    self.window.rootViewController = nav;
    
    return YES;
}
@end
