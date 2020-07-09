//
//  UINavigationController+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "UINavigationController+Extension.h"
#import <UIButton+Extension.h>
#import <UIView+Extension.h>
#import <UIImage+Extension.h>
#import <objc/message.h>

@interface UINavigationController (Extensions)
@property (nonatomic , strong) NSNumber *leftsp;
@property (nonatomic , strong) NSNumber *rightsp;
@end

@implementation UINavigationController (Extension)

- (void)setLeftsp:(NSNumber *)leftsp {
    objc_setAssociatedObject(self, @"leftsp", leftsp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)leftsp {
    return objc_getAssociatedObject(self, @"leftsp");
}

- (void)setRightsp:(NSNumber *)rightsp {
    objc_setAssociatedObject(self, @"rightsp", rightsp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)rightsp {
    return objc_getAssociatedObject(self, @"rightsp");
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
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate=self;
    }
    UIBarButtonItem *item = [self createBarButtonItemWithContent:content action:action];
    UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (@available(iOS 11.0, *)) {
        sp.width = space;
    }else{
        sp.width = -16 + space;
    }
    NSAssert(item, @"place check NavigationLeft content type is NSString || UIImage || UIButton || UIView ?? ");
    [self.topViewController.navigationItem setLeftBarButtonItems:@[sp , item] animated:YES];
}

- (void)rightItemContent:(id)content withspace:(float)space action:(SEL)action {
    NSAssert(content, @"UINavigationItem RightItem param is NULL");
    UIBarButtonItem *item = [self createBarButtonItemWithContent:content action:action];
    UIBarButtonItem *sp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (@available(iOS 11.0, *)) {
        sp.width = space;
    }else{
        sp.width = 16 + space;
    }
    NSAssert(item, @"place check NavigationRight content type is NSString || UIImage || UIButton || UIView ?? ");
    [self.topViewController.navigationItem setRightBarButtonItems:@[item] animated:YES];
}

- (UIBarButtonItem *)createBarButtonItemWithContent:(id)content action:(SEL)action {
    UIBarButtonItem *item;
    if([content isKindOfClass:[UIImage class]]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:content forState:UIControlStateNormal];
        [btn sizeToFit];
        if(btn.bounds.size.height>self.topViewController.navigationController.navigationBar.bounds.size.height){
            float r = self.topViewController.navigationController.navigationBar.bounds.size.height / btn.bounds.size.height;
            [btn setFrame:CGRectMake(0, 0, btn.bounds.size.width*r, btn.bounds.size.height*r)];
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
        item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else if([content isKindOfClass:[NSString class]]){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:content forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
        item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else if([content isKindOfClass:[UIView class]]){
        item = [[UIBarButtonItem alloc] initWithCustomView:content];
        if(action!=nil && [item respondsToSelector:@selector(addTarget:action:forControlEvents:)] && [self.topViewController respondsToSelector:action]){
            [(UIControl *)item addTarget:self.topViewController action:action forControlEvents:UIControlEventTouchUpInside];
        }
    }else if([content isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *bbi = content;
        bbi.action = action;
        item = bbi;
    }
    if(item.customView && item.customView.frame.size.width<30){
        CGRect rect = item.customView.frame;
        rect.size.width = 30;
        item.customView.frame = rect;
    }
    if(item.customView && item.customView.frame.size.height<30){
        CGRect rect = item.customView.frame;
        rect.size.height = 30;
        item.customView.frame = rect;
    }
    return item;
}

- (void)viewDidLayoutSubviews {
    if(@available(iOS 11.0 , *)){
        UINavigationItem *item = self.topViewController.navigationItem;
        NSArray *array = item.leftBarButtonItems;
        if (array && array.count!=0){
            UIBarButtonItem *buttonItem = array[0];
            UIView *view =[[[buttonItem.customView superview] superview] superview];
            NSArray *arrayConstraint = view.constraints;
            for (NSLayoutConstraint *constant in arrayConstraint) {
                // se 14 ,normal 16 ,puls 20 ,x 16
                if (fabs(constant.constant)==16 || fabs(constant.constant)==20) {
                    if([constant.secondItem isMemberOfClass:NSClassFromString(@"_UINavigationBarContentView")] && constant.secondAttribute==NSLayoutAttributeLeading){
                        constant.constant = self.leftsp.floatValue;
                    }else if([constant.secondItem isMemberOfClass:NSClassFromString(@"_UINavigationBarContentView")] && constant.secondAttribute==NSLayoutAttributeTrailing){
                        constant.constant = -self.rightsp.floatValue;
                    }
                }
            }
        }
    }
}

- (void)underLineColor:(UIColor *)color {
    if(color == [UIColor clearColor]){
        [self underLine].hidden = YES;
    }else{
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = color;
        lineView.translatesAutoresizingMaskIntoConstraints = NO;
        lineView.frame = [self underLine].bounds;
        [[self underLine] addSubview:lineView];
    }
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.viewControllers.count>1)
        return YES;
    return NO;
}

- (void)backgroundColor:(UIColor *)color {
    [self.navigationBar setBarTintColor:color];
}
@end
