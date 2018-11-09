//
//  GLTabBarController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLTabBarController.h"

@interface GLTabBarController ()

@end

@implementation GLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NavigationForTabbar";
    
    UIViewController *first = [[NSClassFromString(@"GLFirstViewController") alloc]init];
    UINavigationController *navFirst = [[UINavigationController alloc]initWithRootViewController:first];
    UIViewController *second = [[NSClassFromString(@"GLSecondViewController") alloc]init];
    UINavigationController *navSecond = [[UINavigationController alloc]initWithRootViewController:second];
    UIViewController *third = [[NSClassFromString(@"GLThirdViewController") alloc]init];
    UINavigationController *navThird = [[UINavigationController alloc]initWithRootViewController:third];
    
    
    [self addChildViewController:navFirst];
    [self addChildViewController:navSecond];
    [self addChildViewController:navThird];
}


@end
