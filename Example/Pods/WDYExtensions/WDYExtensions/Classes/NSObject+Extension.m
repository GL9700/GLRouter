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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
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
    id obj = self;
    if (![NSJSONSerialization isValidJSONObject:obj]){
        obj = [self dictDesc];
    }
    if ([NSJSONSerialization isValidJSONObject:obj]){
        NSError * error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
        if (data && error==nil) {
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return result;
}

- (NSDictionary *)dictDesc {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    uint ct;
    objc_property_t *props = class_copyPropertyList([self class], &ct);
    for(int i=0; i<ct; i++){
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        NSString *propAttr = [NSString stringWithUTF8String: property_getAttributes(prop)];
        if([propAttr rangeOfString:@"*"].length>0){
            continue;
        }
        id value = [self valueForKey:propName];
        if(value){
            value = [self objectWithInternal:value];
        }
        dic[propName] = value;
    }
    return dic;
}
- (id)objectWithInternal:(id)value {
    if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNull class]]) {
        return [value description];
    }
    
    if([value isKindOfClass:[NSArray class]]) {
        @synchronized (value) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:((NSArray *)value).count];
            for(int i=0; i<((NSArray *)value).count; i++){
                [arr addObject:[self objectWithInternal:[((NSArray *)value) objectAtIndex:i]]];
            }
            return arr;
        }
    }else if([value isKindOfClass:[NSDictionary class]]) {
        @synchronized (value) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[((NSDictionary *)value) count]];
            for(NSString *key in ((NSDictionary *)value).allKeys){
                dict[key] = [self objectWithInternal:[((NSDictionary *)value) objectForKey:key]];
            }
            return dict;
        }
    }else if([value isKindOfClass:[NSDate class]]) {
        return [((NSDate *)value) description];
    }else{
        if([value respondsToSelector:NSSelectorFromString(@"subDictDesc")]){
            return [value subDictDesc];
        }else{
            return nil;
        }
    }
    return [self objectWithInternal:value];
}
@end
#pragma clang diagnostic pop
