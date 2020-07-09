//
//  NSTimer+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

/**
 备注:
    定义 NSTimer 如果使用 Strong，  则生命周期跟随自身的持有者
    定义 NSTimer 如果使用 weak，    则生命周期不受限制，执行 -StopTimer 后立即被释放
 */

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

/** 开始计时器 */
+ (NSTimer *)startWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat withBlock:(void(^)(void))block;

/** 结束计时器(如果weak则立刻释放) */
+ (void)stopTime:(NSTimer *)timer;

@end
