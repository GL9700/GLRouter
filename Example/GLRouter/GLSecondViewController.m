//
//  GLSecondViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLSecondViewController.h"
#import <Router.h>

@interface GLSecondViewController ()

@end

@implementation GLSecondViewController
- (instancetype)init {
    if((self = [super init])) {
        self.tabBarItem.title = [NSString stringWithFormat:@"Second"];
        self.tabBarItem.image = [UIImage imageNamed:@"item2"];
        self.tabBarItem.image = [[UIImage alloc]initWithCIImage:[[CIImage alloc]initWithImage:[UIImage imageNamed:@"item2"]] scale:15 orientation:UIImageOrientationUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NavigationForSecond";
}

- (IBAction)onEnterNextNavigation:(UIButton *)sender {
    UIViewController *four = [[NSClassFromString(@"GLFourViewController") alloc]init];
    UINavigationController *navFour = [[UINavigationController alloc]initWithRootViewController:four];
}
@end
