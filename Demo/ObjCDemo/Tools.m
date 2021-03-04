//
//  Tools.m
//  ObjCDemo
//
//  Created by liguoliang on 2021/3/3.
//

#import "Tools.h"

@implementation Tools

+ (void)sendMessage {
    NSLog(@"%s", __func__);
}

+ (void)sendMessage:(NSString *)msg from:(NSString *)from to:(NSString *)to {
    NSLog(@"%s, %@->%@ : %@", __func__, from, to, msg);
}

+ (int)sumA:(int)a B:(int)b {
    return a+b;
}
@end
