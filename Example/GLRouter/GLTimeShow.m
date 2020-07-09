//
//  GLTimeShow.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLTimeShow.h"
#import <UIAlertController+Extension.h>

@implementation GLTimeShow
+ (void)toastTime {
    [UIAlertController showToastWithMessage:[NSString stringWithFormat:@"%@" , [NSDate date]]];
}

+ (void)toastMessage:(NSString *)msg {
    [UIAlertController showToastWithMessage:[NSString stringWithFormat:@"%@" , msg]];
}

+ (int)toastCountA:(int)a B:(int)b C:(int)c {
    return a+b+c;
}

@end