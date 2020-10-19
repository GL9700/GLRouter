//
//  NSString+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 快速格式化文字 stringWithFormat: */
#define SF(str, ...) [NSString stringWithFormat:str, ## __VA_ARGS__]

//#define kRegexStringForEmail @"(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$"
//#define kRegexStringForPhone @"^1\\d{10}$"

#define kRegexForPhone @"1+\\d{10}"
#define kRegexForURL   @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
#define kRegexForEmail @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

/** 判空 */
UIKIT_STATIC_INLINE BOOL isEmptyString(NSString *str)
{
    return (str == nil || str.length == 0 || [[str lowercaseString] isEqualToString:@"<null>"] || [str isEqual:[NSNull null]]);
}

@interface NSString (Extension)

/** 表情符号的判断 */
- (BOOL)stringContainsEmoji;

/** 判断是不是九宫格拼音键盘 */
- (BOOL)isNineKeyBoard;

/** 包含中文 */
- (BOOL)hasChinese;

/** 包含字符 */
- (BOOL)isContain:(NSString *)str;

/** 去除所有空格和回车 */
- (NSString *)trim;

/** URL 编码 */
- (NSString *)URLEncode;

/** URL 解码 */
- (NSString *)URLDecode;

/** 使用MD5编码 */
- (NSString *)md5;

/** 使用Base64编码 */
- (NSData *)base64Decode;

/** 使用正则 (已定义 kRegexForPhone kRegexForURL kRegexForEmail) */
- (NSString *)stringForRegular:(NSString *)regular;

/*** 去掉html标签*/
- (NSString *)removeHtmlTag;

/** 计算字符串size */
- (CGSize)boundingRectWithWidth:(float)width Font:(UIFont *)font;
@end
