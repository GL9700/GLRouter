//
//  NSTimer+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

/** 开始计时器 */
+ (NSTimer *)startWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat withBlock:(void(^)(void))block;

/** 结束计时器 */
+ (void)stopTime:(NSTimer *)timer;

@end
