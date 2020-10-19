//
//  NSObject+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

static char kAssociatedObjectRetainKey;
static char kAssociatedObjectKey;

@implementation NSObject (Extension)

- (void)setAssociatedObjectRetain:(id)object {
    objc_setAssociatedObject(self, &kAssociatedObjectRetainKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObjectRetain {
    return objc_getAssociatedObject(self, &kAssociatedObjectRetainKey);
}

- (void)setAssociatedObject:(id)object {
    objc_setAssociatedObject(self, &kAssociatedObjectKey, object, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedObject {
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

- (NSString *)JSONString {
    NSString *result = nil;
    @try {
        if ([NSJSONSerialization isValidJSONObject:self]) {
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
            if (data && error == nil) {
                result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            }
        }
    } @catch (NSException *exception) {
    }
    return result;
}

@end
