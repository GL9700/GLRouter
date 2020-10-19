//
//  UIAlertController+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

/** Alert ** 单按钮 ** */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)msg
                  singleButton:(NSString *)btnTitle
                         event:(void(^)(void))eventBLK;

/** Alert ** 多按钮 ** */
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)msg
                  buttonTitles:(NSArray<NSString *> *)btnTitles
                         event:(void(^)(NSUInteger index))eventBLK;

/** Alert Show ** */
- (void)show;
- (void)dismiss;
- (void)showAfterAutoDismissSec:(NSUInteger)sec withComplete:(void(^)(void))complete;

/** Toast ** 2秒后自动关闭 ** */
+ (void)showToastWithMessage:(NSString *)msg;

@end
