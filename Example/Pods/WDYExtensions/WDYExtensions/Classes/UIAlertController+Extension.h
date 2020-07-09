//
//  UIAlertController+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg singleButton:(NSString *)btnTitle action:(void (^)(NSString *buttonTitle))actblk;
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray<NSString *> *)btnTitles action:(void (^)(NSString *buttonTitle))actblk;

/** show alert */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)btnTitle action:(void(^)(NSString *buttonTitle))actblk;

/** Alert Show ** */
- (void)show;
- (void)dismiss;
- (void)showWithTime:(NSUInteger)sec timeup:(void(^)(void))timeup;

/** Toast ** 2秒后自动关闭 ** */
+ (void)showToastWithMessage:(NSString *)msg;


@end
