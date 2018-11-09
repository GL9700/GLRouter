//
//  UIAlertController+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "UIAlertController+Extension.h"

#define kToastShowTime 2

@implementation UIAlertController (Extension)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg singleButton:(NSString *)btnTitle event:(void(^)(void))eventBLK {
    UIAlertController *instance = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if(btnTitle!=nil) {
        [instance addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(eventBLK!=nil)
                eventBLK();
        }]];
    }
    return instance;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray<NSString *> *)btnTitles event:(void(^)(NSUInteger index))eventBLK {
    UIAlertController *instance = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if(btnTitles!=nil) {
        for (int i=0; i<btnTitles.count; i++) {
            UIAlertAction *act = [UIAlertAction actionWithTitle:btnTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(eventBLK!=nil)
                    eventBLK(i);
            }];
            [instance addAction:act];
        }
    }
    return instance;
}

- (void)show {
    if(self.view.superview==nil){
        [self showAfterAutoDismissSec:0 withComplete:nil];
    }
}

- (void)dismiss {
    if(self.view.superview) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showAfterAutoDismissSec:(NSUInteger)sec withComplete:(void(^)(void))complete {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:YES completion:^{
        if(sec>0){
            /*
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                sleep((int)sec);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.view.superview) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            if(complete)
                                complete();
                        }];
                    }
                });
            });
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.view.superview) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        if(complete)
                            complete();
                    }];
                }
            });
        }
    }];
}

+ (void)showToastWithMessage:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = msg;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/5*4, 0);
        [label sizeToFit];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,
                                   [UIScreen mainScreen].bounds.size.height/4*3);
        label.frame = CGRectInset(label.frame, -10, -8);
        label.layer.cornerRadius = label.frame.size.height/2;
        label.layer.masksToBounds = YES;
        label.alpha = 0;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:label];
        [UIView animateWithDuration:0.25 animations:^{
            label.alpha = 1;
            label.frame = CGRectOffset(label.frame, 0, 5);
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                sleep(kToastShowTime);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        label.alpha = 0;
                        label.frame = CGRectOffset(label.frame, 0, -5);
                    } completion:^(BOOL finished) {
                        if(label.superview)
                            [label removeFromSuperview];
                    }];
                });
            });
        }];
    });
}

@end
