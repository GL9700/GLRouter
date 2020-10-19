//
//  UIColor+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/** 文本颜色,标记支持[ # | 0x | 0X ]和无标记,色值支持[ RGB | ARGB | RRGGBB | AARRGGBB];例如"#F0F"=="0xFF00FF"*/
+ (instancetype)colorFromHexStr:(NSString *)hexStr;

/** 文本颜色,色值支持[ RGB | ARGB | RRGGBB | AARRGGBB],自定义匹配标记,默认无标记 */
+ (instancetype)colorFromHexStr:(NSString *)hexStr headStr:(NSString *)str;

/** 标准16进制数值表示颜色 支持 0x000000 ~ 0xFFFFFF */
+ (instancetype)colorFromHexValue:(uint32_t)hex;
@end
