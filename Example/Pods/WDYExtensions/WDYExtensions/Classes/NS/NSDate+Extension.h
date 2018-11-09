//
//  NSDate+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/21.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** 相差几个单位(不分先后) */
+ (NSDateComponents *)componentsDate1:(NSDate *)d1 Date2:(NSDate *)d2 unit:(NSCalendarUnit)unit;

/** 默认格式 yyyy-MM-dd HH:mm:ss */
- (NSString *)stringDateWithFormat:(NSString *)format;

@end

