//
//  GLFourViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLFourViewController.h"

@interface GLFourViewController ()

@end

@implementation GLFourViewController

- (instancetype)init {
    if((self = [super init])) {
        self.tabBarItem.title = [NSString stringWithFormat:@"Four"];
        self.tabBarItem.image = [[UIImage alloc]initWithCIImage:[[CIImage alloc]initWithImage:[UIImage imageNamed:@"item4"]]
                                                          scale:15
                                                    orientation:UIImageOrientationUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CALayer *lay = [CALayer layer];
    lay.frame = self.view.layer.frame;
    lay.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.2].CGColor;
    [self.view.layer addSublayer:lay];
}

@end
