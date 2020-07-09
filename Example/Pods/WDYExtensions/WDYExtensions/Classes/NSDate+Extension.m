//
//  NSDate+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/21.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDateComponents *)componentsDate1:(NSDate *)d1 withDate2:(NSDate *)d2 unit:(NSCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:unit fromDate:d1 toDate:d2 options:0];
}


- (NSString *)stringWithFormat:(NSString *)format inLocale:(NSLocale *)locale {
    NSString *result = nil;
    @autoreleasepool {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        formatter.locale = [NSLocale autoupdatingCurrentLocale];
        if(format!=nil){
            formatter.dateFormat = format;
        }
        if(locale!=nil){
            formatter.locale = locale;
        }
        result = [formatter stringFromDate:self];
    }
    return result;
}

@end
