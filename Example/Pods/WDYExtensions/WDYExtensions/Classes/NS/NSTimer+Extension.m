//
//  NSTimer+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)startWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat withBlock:(void(^)(void))block{
    NSTimer *_t = [self timerWithTimeInterval:interval
                                       target:self
                                     selector:@selector(setBlock:)
                                     userInfo:[block copy]
                                      repeats:repeat];
    [[NSRunLoop currentRunLoop] addTimer:_t forMode:NSRunLoopCommonModes];
    return _t;
}

+ (void)setBlock:(NSTimer *)timer {
    void(^blk)(void)=timer.userInfo;
    if (blk) {
        blk();
    }
}

+ (void)stopTime:(NSTimer *)timer {
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
