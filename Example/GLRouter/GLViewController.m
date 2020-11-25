//
//  GLViewController.m
//  GLRouter
//
//  Created by 36617161@qq.com on 10/10/2020.
//  Copyright (c) 2020 36617161@qq.com. All rights reserved.
//

#import "GLViewController.h"
#import <UIViewController+Extension.h>
@interface UISubButton : UIButton

@end
@implementation UISubButton
- (CGSize)intrinsicContentSize {
    return CGSizeMake(CGRectGetWidth(self.bounds) + 10, CGRectGetHeight(self.bounds) + 2);
}

@end

@interface GLViewController ()
@property (nonatomic) UILabel *label;
@end

@implementation GLViewController
#pragma mark- >> Build UI

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:28];
    }
    return _label;
}

- (UIStackView *)createStackViewForAxis:(UILayoutConstraintAxis)axis alignment:(UIStackViewAlignment)aligment distribution:(UIStackViewDistribution)distribution spacing:(CGFloat)spacing {
    UIStackView *__stack = [UIStackView new];
    __stack.spacing = spacing;
    __stack.axis = axis;
    __stack.alignment = aligment;
    __stack.distribution = distribution;
    return __stack;
}

- (UISubButton *)createButton:(NSString *)title action:(SEL)sel image:(UIImage *)img {
    UISubButton *b = [UISubButton buttonWithType:UIButtonTypeRoundedRect];
    if (title) {
        [b setTitle:title forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (img) {
        [b setImage:img forState:UIControlStateNormal];
    }
    [b sizeToFit];
    b.backgroundColor = [UIColor lightGrayColor];
    [b addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRouter];

    UIStackView *mainStackView = [self createStackViewForAxis:UILayoutConstraintAxisHorizontal alignment:UIStackViewAlignmentCenter distribution:UIStackViewDistributionFill spacing:10];
    mainStackView.frame = CGRectInset(self.view.bounds, 20, 20);
    [self.view addSubview:mainStackView];

    UIStackView *vstack = [self createStackViewForAxis:UILayoutConstraintAxisVertical alignment:UIStackViewAlignmentLeading distribution:UIStackViewDistributionFillProportionally spacing:10];
    [mainStackView addArrangedSubview:vstack];

    UIStackView *hs1 = [self createStackViewForAxis:UILayoutConstraintAxisHorizontal alignment:UIStackViewAlignmentCenter distribution:UIStackViewDistributionFillProportionally spacing:10];
    hs1.frame = CGRectMake(0, 0, CGRectGetWidth(mainStackView.bounds) - 20, 50);

    UIStackView *hs2 = [self createStackViewForAxis:UILayoutConstraintAxisHorizontal alignment:UIStackViewAlignmentCenter distribution:UIStackViewDistributionFillProportionally spacing:10];
    hs2.frame = CGRectMake(0, 0, CGRectGetWidth(mainStackView.bounds) - 20, 50);

    self.label.text = NSStringFromClass(self.class);
    [self.label sizeToFit];
    [vstack insertArrangedSubview:self.label atIndex:0];

    UILabel *tip = [UILabel new];
    tip.text = @"For URL:";
    [tip sizeToFit];
    [hs1 addArrangedSubview:tip];
    [hs1 addArrangedSubview:[self createButton:@"push" action:@selector(onClickPushForURL) image:nil]];
    [hs1 addArrangedSubview:[self createButton:@"Present" action:@selector(onClickPresentForURL) image:nil]];
    [hs1 addArrangedSubview:[self createButton:@"Invoke" action:@selector(onClickInvokeForURL) image:nil]];
    [vstack addArrangedSubview:hs1];

    UILabel *tip2 = [UILabel new];
    tip2.text = @"For KEY:";
    [tip2 sizeToFit];
    [hs2 addArrangedSubview:tip2];
    [hs2 addArrangedSubview:[self createButton:@"push" action:@selector(onClickPushForKey) image:nil]];
    [hs2 addArrangedSubview:[self createButton:@"Present" action:@selector(onClickPresentForKey) image:nil]];
    [hs2 addArrangedSubview:[self createButton:@"Invoke" action:@selector(onClickInvokeForKey) image:nil]];
    [vstack addArrangedSubview:hs2];
}

#pragma mark- >> About Router
/** router init */
- (void)setupRouter {
    [GLRouterManager setVerifyScheme:@"lgl1"];   // URL 跳转scheme限制(仅URL模式)
    [GLRouterManager managerWithRegisterFile:@"RouterList" withFromBundle:[NSBundle bundleForClass:self.class]]; // 路由表(仅Key模式)
//    /* 拦截路由过程中发生的错误 */
//    [GLRouterManager failure: ^(NSError *error, NSString *detail) {
//        NSLog(@"%@ - %@", error, detail);
//    }];
}

- (void)onClickPushForURL {
    rto_dsp_clv(@"lgl://push/aboutViewController?text=Hello Router&image=https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png", nil, self);
}

- (void)onClickPresentForURL {
    rto_dsp(@"lgl://present/BlueViewController?text=Hello GLRouter&v1=1&v2=2", nil);
}

- (void)onClickInvokeForURL {
    rto_ivk(@"lgl://invoke/GLTools/sayHello:to:message?v1=李雷&v2=韩梅梅&v3=Hi,Jerry I'm in GLRouter", ^(id ret) {
        showToastMsg(ret);
    });
}

- (void)onClickPushForKey {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        rto_dsp(@"toWeb", ^BOOL (id tgt) {
            [tgt setValue:@"http://www.baidu.com" forKey:@"url"];
            return YES;
        });
    });
}

- (void)onClickPresentForKey {
    rto_dsp(@"presentAbout", nil);
}

- (void)onClickInvokeForKey {
    rto_ivk(@"sayHello", ^(id ret) {
        showToastMsg(ret);
    });
}

@end
