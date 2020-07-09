//
//  UIButton+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/27.
//

#import "UIButton+Extension.h"
#import <objc/message.h>

@implementation UIButton (Extension)

- (instancetype)copy {
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:temp];
}

@end
