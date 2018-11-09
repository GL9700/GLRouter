//
//  NSDate+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/21.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDateComponents *)componentsDate1:(NSDate *)d1 Date2:(NSDate *)d2 unit:(NSCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:unit fromDate:d1 toDate:d2 options:0];
}


- (NSString *)stringDateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    if(format!=nil)
        formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end
