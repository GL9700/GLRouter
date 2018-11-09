//
//  GLThirdViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLThirdViewController.h"

@interface GLThirdViewController ()

@end

@implementation GLThirdViewController
- (instancetype)init {
    if((self = [super init])) {
        self.tabBarItem.title = [NSString stringWithFormat:@"Third"];
        self.tabBarItem.image = [UIImage imageNamed:@"item3"];
        self.tabBarItem.image = [[UIImage alloc]initWithCIImage:[[CIImage alloc]initWithImage:[UIImage imageNamed:@"item3"]] scale:15 orientation:UIImageOrientationUp];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CALayer *lay = [CALayer layer];
    lay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:.2].CGColor;
    [self.view.layer addSublayer:lay];
}

@end
