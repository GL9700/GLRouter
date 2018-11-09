//
//  UINavigationController+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)

- (void)hidden:(BOOL)hidden;

/** Title // NSString || UIImage || UIView */
- (void)titleItemContent:(id)content;

/** LeftItem from 0 // NSString || UIImage || UIButton || UIVew(NoEvent) // 在iOS11+会有无效 */
- (void)leftItemContent:(id)content withspace:(float)space action:(SEL)action;

/** RightItem from right 0 // UIImage || NSString || UIButton || UIVew(NoEvent) // 在iOS11+会有无效 */
- (void)rightItemContent:(id)content withspace:(float)space action:(SEL)action;

/** NavigationBar UnderLine */
- (UIImageView *)underLine;

/** NavigationBar Under 颜色 */
- (void)underLineColor:(UIColor *)color;

@end
