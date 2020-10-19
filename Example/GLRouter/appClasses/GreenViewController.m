//
//  GreenViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/10/12.
//  Copyright © 2020 36617161@qq.com. All rights reserved.
//

#import "GreenViewController.h"

@interface GreenViewController ()

@end

@implementation GreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:1 blue:0.5 alpha:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", self.presentedViewController);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
