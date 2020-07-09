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

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg singleButton:(NSString *)btnTitle action:(void (^)(NSString *buttonTitle))actblk{
    return [self alertWithTitle:title message:msg buttonTitles:btnTitle?@[btnTitle]:nil action:actblk];
}
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray<NSString *> *)btnTitles action:(void (^)(NSString *buttonTitle))actblk{
    UIAlertController *instance = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (btnTitles != nil) {
        for (int i = 0; i < btnTitles.count; i++) {
            UIAlertAction *act = [UIAlertAction actionWithTitle:btnTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                if (actblk!= nil){
                    actblk(btnTitles[i]);
                }
            }];
            [instance addAction:act];
        }
    }
    if(title || msg)
        return instance;
    else{
        printf("\n--AlertError-- title:%s | message:%s\n ", [title UTF8String], [msg UTF8String]);
        return nil;
    }
}

- (void)show {
    if (self.view.superview == nil) {
        [self showWithTime:0 timeup:nil];
    }
}
- (void)dismiss {
    if (self.view.superview) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)showWithTime:(NSUInteger)sec timeup:(void(^)(void))timeup {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self animated:YES completion:^{
        if(sec > 0){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.view.superview){
                    [self dismissViewControllerAnimated:YES completion:^{
                        if(timeup){
                            timeup();
                        }
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
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 5 * 4, 0);
        [label sizeToFit];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2,
                                   [UIScreen mainScreen].bounds.size.height / 4 * 3);
        label.frame = CGRectInset(label.frame, -10, -8);
        label.layer.cornerRadius = label.frame.size.height>label.frame.size.width ? label.frame.size.width/5 : label.frame.size.height/2;
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
                      if (label.superview) [label removeFromSuperview];
                   }];
               });
            });
        }];
    });
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)btnTitle action:(void(^)(NSString *buttonTitle))actblk {
    [[self alertWithTitle:title message:message singleButton:btnTitle action:actblk] show];
}

@end
