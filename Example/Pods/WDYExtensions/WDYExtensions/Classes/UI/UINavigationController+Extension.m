//
//  UINavigationController+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "UINavigationController+Extension.h"
#import "UIButton+Extension.h"
#import "UIView+Extension.h"
#import "UIImage+Extension.h"

@implementation UINavigationController (Extension)

- (void)hidden:(BOOL)hidden {
    [self setNavigationBarHidden:hidden animated:NO];
}

- (void)titleItemContent:(id)content {
    if([content isKindOfClass:[NSString class]]) {
        [self.topViewController.navigationItem setTitle:(NSString *)content];
        
    }else if([content isKindOfClass:[UIView class]]) {
        [self.topViewController.navigationItem setTitleView:(UIView *)content];
        
    }else if([content isKindOfClass:[UIImage class]]) {
        UIImageView *imgView = [[UIImageView alloc]initWithImage:content];
        [self.topViewController.navigationItem setTitleView:imgView];
    }
}

- (void)leftItemContent:(id)content withspace:(float)space action:(SEL)action {
    NSAssert(content, @"UINavigationItem LeftItem param is NULL");
    self.topViewController.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *item = [self createBarButtonItemWithContent:content action:action];
    UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    sp.width = -16 + space;
    if (@available(iOS 11.0, *)) {
        self.topViewController.navigationItem.leftBarButtonItems = @[item];
    }else{
        self.topViewController.navigationItem.leftBarButtonItems = @[sp , item];
    }
}

- (void)rightItemContent:(id)content withspace:(float)space action:(SEL)action {
    NSAssert(content, @"UINavigationItem RightItem param is NULL");
    UIBarButtonItem *item = [self createBarButtonItemWithContent:content action:action];
    UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    sp.width = -16 + space ;
    if (@available(iOS 11.0, *)) {
        self.topViewController.navigationItem.rightBarButtonItems = @[item];
    }else{
        self.topViewController.navigationItem.rightBarButtonItems = @[sp , item];
    }
}

- (UIBarButtonItem *)createBarButtonItemWithContent:(id)content action:(SEL)action {
    UIBarButtonItem *barItem;
    if([content isKindOfClass:[UIImage class]]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:content forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
        barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }else if([content isKindOfClass:[NSString class]]){
        barItem = [[UIBarButtonItem alloc] initWithTitle:content style:UIBarButtonItemStylePlain
                                                  target:self.topViewController action:action];
        
    }else if([content isKindOfClass:[UIButton class]]){
        if(action){
            UIButton *btn = [content copy];
            barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            [btn addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            barItem = [[UIBarButtonItem alloc] initWithCustomView:content];
            [content addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else if([content isKindOfClass:[UIView class]]) {
        barItem = [[UIBarButtonItem alloc] initWithCustomView:content];
        
    }
    return barItem;
}

- (void)underLineColor:(UIColor *)color {
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = color;
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.frame = [self underLine].bounds;
    [[self underLine] addSubview:lineView];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (UIImageView *)underLine {
    return [self underLineView:self.navigationBar];
}

- (UIImageView *)underLineView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self underLineView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
