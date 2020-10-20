//
//  aboutViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/10/12.
//  Copyright © 2020 36617161@qq.com. All rights reserved.
//

#import "aboutViewController.h"
#import <SDWebImage.h>

@interface aboutViewController () <GLRouterProtocol>
@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *imageview;
@property (nonatomic) NSURL *imgURL;
@end

@implementation aboutViewController

- (void)routerParams:(NSDictionary *)params {
    self.label.text = params[@"text"];
    self.imgURL = [NSURL URLWithString:params[@"image"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass(self.class);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.label.text.length==0) {
        self.label.text = @"this is aboutViewController";
    }
    [self.view addSubview:self.label];
    [self.label sizeToFit];
    self.label.center = self.view.center;
    
    [self.imageview sd_setImageWithURL:self.imgURL];
    [self.view addSubview:self.imageview];
    self.imageview.center = CGPointMake(self.view.center.x, self.view.center.y-80);
    
}
- (UILabel *)label {
    if(!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:22];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}
- (UIImageView *)imageview {
    if(!_imageview) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
    }
    return _imageview;
}
- (void)dealloc {
    NSLog(@"dealloc : %@", self.class);
}
@end
