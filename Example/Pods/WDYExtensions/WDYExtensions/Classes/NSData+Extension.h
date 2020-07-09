//
//  NSData+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)

/** 转换成为NSString 编码为 UTF-8 */
- (NSString *)string;

/** 从Base64转换成为NSString */
- (NSString *)base64Encode;

@end
