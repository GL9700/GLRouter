//
//  UIColor+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/** 使用16进制颜色进行设置 支持 #aaa,#aabb,#aabbcc,#aabbccdd */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
