//
//  GLRCoreInvokeControl.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import <GLRouter/GLRCoreInvokeControl.h>
#import <objc/message.h>

@implementation GLRCoreInvokeControl
- (void)invokeMethodFromSelector:(SEL)select
                         inClass:(Class)cls
                      withParams:(NSDictionary *)params
                             ret:(void (^)(id ret))handle {
    NSMethodSignature *methodSign = [cls methodSignatureForSelector:select];
    NSAssert(methodSign, @"-- [%@]-Method Signature为空 --", self.class);
    if (methodSign) {
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:methodSign];
        [invoke setTarget:cls];
        [invoke setSelector:select];
        // params:
        NSArray *argments = [self argmentsFrom:params];
        for (int i = 0; i < methodSign.numberOfArguments - 2; i++) {
            if (i < argments.count) {
                if ([argments[i] isMemberOfClass:[NSNull class]]) {
                    continue;
                }
                id obj = argments[i];
                const char *at = [methodSign getArgumentTypeAtIndex:i + 2];
                if (!strcmp(at, "s") || !strcmp(at, "l")  || !strcmp(at, "q") || !strcmp(at, "i")) {
                    long long temp = [obj longLongValue];
                    [invoke setArgument:&temp atIndex:i + 2];
                }
                else if (!strcmp(at, "f")) {
                    float temp = [obj floatValue];
                    [invoke setArgument:&temp atIndex:i + 2];
                }
                else if (!strcmp(at, "d")) {
                    double temp = [obj doubleValue];
                    [invoke setArgument:&temp atIndex:i + 2];
                }
                else if (!strcmp(at, "c")) {
                    char c = [obj characterAtIndex:0];
                    [invoke setArgument:&c atIndex:i + 2];
                }
                else if (!strcmp(at, "B")) {
                    BOOL b = [obj boolValue];
                    [invoke setArgument:&b atIndex:i + 2];
                }
                else if (!strcmp(at, "@")) {
                    [invoke setArgument:&obj atIndex:i + 2];
                }
                else {
                    NSAssert(0, @"-- Error:encode Failed：%@ | %s --", obj, at);
                }
            }
        }
//        [invoke retainArguments];
        [invoke invoke];

        // return value
        const char *rt = methodSign.methodReturnType;
        __autoreleasing id ret;
        if (strcmp(rt, "v")) {
            if (!strcmp(rt, "@")) {
                [invoke getReturnValue:&ret];
            }
            else {
                void *temp = (void *)malloc(methodSign.methodReturnLength);
                [invoke getReturnValue:temp];
                if (!strcmp(rt, "B")) {
                    ret = [NSNumber numberWithBool:*((BOOL *)temp)];
                }
                else if (!strcmp(rt, "i")) {
                    ret = [NSNumber numberWithInteger:*((int *)temp)];
                }
                else if (!strcmp(rt, "f")) {
                    ret = [NSNumber numberWithFloat:*((float *)temp)];
                }
                else if (!strcmp(rt, "d")) {
                    ret = [NSNumber numberWithDouble:*((double *)temp)];
                }
                else if (!strcmp(rt, "c")) {
                    ret = [NSNumber numberWithChar:*((char *)temp)];
                }
                else if (!strcmp(rt, "Q")) {
                    ret = [NSNumber numberWithInteger:*((NSUInteger *)temp)];
                }
                else if (!strcmp(rt, "q")) {
                    ret = [NSNumber numberWithInteger:*((NSInteger *)temp)];
                }
                else if (!strcmp(rt, "I")) {
                    ret = [NSNumber numberWithUnsignedInt:*((uint *)temp)];
                }
                else if (!strcmp(rt, "C")) {
                    ret = [NSNumber numberWithUnsignedChar:*((u_char *)temp)];
                }
                free(temp);
            }
        }
        if (handle) {
            handle(ret);
        }
    }
    else {
        if (self.failureHandle) {
            self.failureHandle(kRouterErrorWith(@"Target Not Found", RouterErrorNotFoundTarget), [NSString stringWithFormat:@"+%@ in %@", NSStringFromSelector(select), NSStringFromClass(self.class)]);
        }
    }
}

// 先对params的key排序,然后截取里面数字，没有某个参数位置->空，多出的抛弃
- (NSArray *)argmentsFrom:(NSDictionary *)params {
    NSMutableArray *argments = [NSMutableArray arrayWithCapacity:params.allKeys.count];
    NSMutableArray *keys = [params.allKeys mutableCopy];
    int base = 1;
    [keys sortUsingComparator: ^NSComparisonResult (NSString *obj1, NSString *obj2) {
        return [self intFromString:obj1] < [self intFromString:obj2] ? NSOrderedAscending : NSOrderedDescending;
    }];
    for (int i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        int index = 0;
        int rlt = [self intFromString:key];
//        if (i == 0) {
//            base = rlt;
//        }
        index = rlt - base;
        while (index > argments.count)
            [argments addObject:[NSNull null]];
        argments[index] = params[key];
    }
    return [argments copy];
}

/// 方案1: 提取字符串中的数字
- (int)intFromString:(NSString *)str {
    int r = 0;
    NSScanner *s = [NSScanner scannerWithString:str];
    [s scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    [s scanInt:&r];
    return r;
}

/// 方案2: 将所有字符串转成 ASCII 然后相加
- (int)asciiFromString:(NSString *)str {
    int r = 0;
    for (int j = 0; j < str.length; j++) {
        r += [str characterAtIndex:j];
    }
    return r;
}

@end
