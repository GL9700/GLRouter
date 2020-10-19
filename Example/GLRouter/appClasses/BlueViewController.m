//
//  BlueViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/10/12.
//  Copyright © 2020 36617161@qq.com. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController ()

@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", self.presentedViewController);
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
