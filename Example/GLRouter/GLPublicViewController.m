//
//  GLPublicViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLPublicViewController.h"

@interface GLPublicViewController (){
    UIButton *btn;
    UILabel *label;
    UIImageView *imageview;
}
@end

@implementation GLPublicViewController

- (instancetype)initWithRouterWithParams:(NSDictionary *)params {
    if((self = [super init])){
        self.content = params[@"content"];
        self.message = params[@"message"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    label = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:label];
    imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:imageview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [btn setTitle:self.message forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(10, self.view.bounds.size.height-40, self.view.bounds.size.width-20, 30);
    imageview.image = self.icon;
    imageview.frame = CGRectMake(0, 0, 256, 256);
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.center = self.view.center;
    [self.view addSubview:imageview];
    label.text = self.content;
    [label sizeToFit];
    label.center = CGPointMake(self.view.center.x, self.view.center.y+imageview.bounds.size.height/2+10);
}

- (void)onClickBtn:(id)sender {
    if(self.handle){
        self.handle();
    }
}


@end
