//
//  GLTools.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/10/14.
//  Copyright © 2020 36617161@qq.com. All rights reserved.
//

#import "GLTools.h"

@implementation GLTools
+ (NSString *)sayHello:(NSString *)user1 to:(NSString *)user2 message:(NSString *)msg {
    NSLog(@"%@对%@说：%@", user1 , user2, msg);
    return [NSString stringWithFormat:@"%@对%@说：%@", user1 , user2, msg];
}
@end
