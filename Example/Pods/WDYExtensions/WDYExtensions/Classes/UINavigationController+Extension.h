//
//  UINavigationController+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension) <UIGestureRecognizerDelegate , UINavigationControllerDelegate>

/** Title // NSString || UIImage || UIView */
- (void)titleItemContent:(id)content;

/** LeftItem from 0 // NSString || UIImage || UIButton || UIVew(NoEvent) */
- (void)leftItemContent:(id)content withspace:(float)space action:(SEL)action;

/** RightItem from right 0 // UIImage || NSString || UIButton || UIVew(NoEvent) */
- (void)rightItemContent:(id)content withspace:(float)space action:(SEL)action;

/** NavigationBar UnderLine 推荐使用 -underLineColor: */
//- (UIImageView *)underLine;

/** NavigationBar Under 颜色 */
- (void)underLineColor:(UIColor *)color;

/** NavigationBar 背景颜色 */
- (void)backgroundColor:(UIColor *)color;

@end
