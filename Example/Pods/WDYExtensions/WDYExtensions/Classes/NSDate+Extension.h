//
//  NSDate+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/21.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/** date1与date2相差几个单位(不分先后) */
+ (NSDateComponents *)componentsDate1:(NSDate *)d1 withDate2:(NSDate *)d2 unit:(NSCalendarUnit)unit;

/** format:默认yyyy-MM-dd HH:mm:ss | locale:默认用户设置语言地区*/
- (NSString *)stringWithFormat:(NSString *)format inLocale:(NSLocale *)locale;

@end

