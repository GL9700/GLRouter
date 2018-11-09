//
//  UIView+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/message.h>

@implementation UIView (Extension)

#pragma mark - Setter
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (void)setBottom:(CGFloat)bottom {
    self.frame = CGRectMake(self.x, bottom - self.height, self.width, self.height);
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setSize:(CGSize)size {
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}

#pragma mark - Getter
- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (CGFloat)right {
    return self.x + self.width;
}


+ (instancetype)defaultViewForActivityWithFrame:(CGRect)frame {
    static dispatch_once_t onceToken;
    static UIView *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UIView alloc]initWithFrame:CGRectZero];
        instance.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        instance.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        instance.activity.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        instance.activity.layer.cornerRadius = 10;
        instance.activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [instance addSubview:instance.activity];
        [instance.activity startAnimating];
    });
    if(!CGRectEqualToRect(frame, CGRectZero)){
        instance.frame = frame;
    }
    return instance;
}

- (void)showActivity {
    self.activity.center = self.center;
    [self.activity startAnimating];
}

- (void)hideActivity {
    [self.activity stopAnimating];
}

- (void)setActivity:(UIActivityIndicatorView *)activity {
    objc_setAssociatedObject(self, @selector(activity), activity, OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView *)activity {
    return objc_getAssociatedObject(self, _cmd);
}

@end
