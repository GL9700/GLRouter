//
//  NSURL+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import <Foundation/Foundation.h>

@interface NSURL (Extension)

/** 获取参数部分 */
- (NSDictionary *)querys;

/** 获取网址指向 IP 地址 */
- (NSArray *)ipAdress;
@end
