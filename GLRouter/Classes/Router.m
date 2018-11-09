//
//  Router.m
//  Router
//
//  Created by liguoliang on 2018/1/9.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "Router.h"
#import "RouterProtocol.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>

@interface Router()
@property (nonatomic , strong) NSString *scheme;
@end

static Router *instance;
@implementation Router

+ (instancetype)RouterWithScheme:(NSString *)scheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Router alloc]init];
        instance.scheme = scheme;
    });
    return instance;
}

+ (void)openURL:(NSString *)url form:(UIResponder *)from before:(void(^)(id targetController))handle after:(void(^)(id ret))after {
    NSAssert(instance, @"need [+ RouterWithScheme:] before invoke this method");
    
    NSString *scheme, *host, *path;
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    NSScanner *scan = [NSScanner scannerWithString:url];
    [scan scanUpToString:@"://" intoString:&scheme];
    [scan scanString:@"://" intoString:nil];
    [scan scanUpToString:@"/" intoString:&host];
    [scan scanString:@"/" intoString:nil];
    [scan scanUpToString:@"?" intoString:&path];
    [scan scanString:@"?" intoString:nil];
    while (!scan.isAtEnd) {
        NSString *key, *value;
        [scan scanUpToString:@"=" intoString:&key];
        [scan scanString:@"=" intoString:nil];
        [scan scanUpToString:@"&" intoString:&value];
        [scan scanString:@"&" intoString:nil];
        variables[key] = value;
    }
    host = [host lowercaseString];
    
    if([host isEqualToString:@"push"] || [host isEqualToString:@"present"])
    {
        if(path==nil || ![NSClassFromString(path) conformsToProtocol:@protocol(RouterProtocol)]) return;
        UIViewController *target = [[NSClassFromString(path) alloc]initWithRouterWithParams:variables];
        if(handle) handle(target);
            if([host isEqualToString:@"push"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIResponder *nav;
                if(from) {
                    nav = from;
                    while(![nav isKindOfClass:[UINavigationController class]] && nav.nextResponder!=nil) {
                        nav = nav.nextResponder;
                    }
                }else{
                    UIViewController *rootvc = [UIApplication sharedApplication].keyWindow.rootViewController;
                    while (rootvc.navigationController==nil) {
                        if([rootvc isKindOfClass:[UITabBarController class]]) {
                            rootvc = ((UITabBarController *)rootvc).selectedViewController;
                        }else if([rootvc isKindOfClass:[UINavigationController class]]){
                            rootvc = ((UINavigationController *)rootvc).topViewController;
                        }else {
                            break;
                        }
                    }
                    nav = rootvc.navigationController;
                }
                if(nav==nil) return;
                    [((UINavigationController *)nav) pushViewController:target animated:YES];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIResponder *vc = from;
                if(from){
                    while(![vc isKindOfClass:[UIViewController class]] && vc.nextResponder!=nil) {
                        vc = vc.nextResponder;
                    }
                }else{
                    vc = [UIApplication sharedApplication].keyWindow.rootViewController;
                }
                if(vc==nil) return;
                [((UIViewController *)vc) presentViewController:target animated:YES completion:nil];
            });
        }
        
    }
    else if([host isEqualToString:@"invoke"])
    {
        Class targetClass = NSClassFromString(path);
        NSString *method = variables[@"method"];
        if(!method) return;
        [variables removeObjectForKey:@"method"];
        NSMethodSignature *methodsignature = [targetClass methodSignatureForSelector:NSSelectorFromString(method)];
        if(!methodsignature) return;
        const char *rt = methodsignature.methodReturnType;
        NSUInteger rl = methodsignature.methodReturnLength;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodsignature];
        __block int i=2;
        [variables enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            const char *at = [methodsignature getArgumentTypeAtIndex:i];
            if(!strcmp(at, @encode(uint))){
                uint temp = [obj unsignedIntValue];
               [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(int))){
                int temp = [obj intValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(float))){
                float temp = [obj floatValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(double))){
                double temp = [obj doubleValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(NSUInteger))){
                NSUInteger temp = [obj unsignedIntegerValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(NSInteger))){
                NSInteger temp = [obj integerValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(BOOL))){
                BOOL temp = [obj boolValue];
                [invocation setArgument:&temp atIndex:i++];
            }else if(!strcmp(at, @encode(char))){
                char temp = [obj charValue];
                [invocation setArgument:&temp atIndex:i++];
            }else{
                [invocation setArgument:&obj atIndex:i++];
            }
        }];
        invocation.target = targetClass;
        invocation.selector = NSSelectorFromString(method);
        [invocation invoke];
        
        id ret;
        if (!strcmp(rt, @encode(void))){
            ret = nil;
        }else if (!strcmp(rt, @encode(id))){
            [invocation getReturnValue:&ret];
        }else{
            void *temp = (void *)malloc(rl);
            [invocation getReturnValue:temp];
            if (!strcmp(rt, @encode(BOOL))) {
                ret = [NSNumber numberWithBool:*((BOOL *)temp)];
            }else if(!strcmp(rt, @encode(NSInteger))){
                ret = [NSNumber numberWithInteger:*((NSInteger *)temp)];
            }else if(!strcmp(rt, @encode(int))){
                ret = [NSNumber numberWithInteger:*((int *)temp)];
            }else if(!strcmp(rt, @encode(float))){
                ret = [NSNumber numberWithInteger:*((float *)temp)];
            }else if(!strcmp(rt, @encode(double))){
                ret = [NSNumber numberWithInteger:*((double *)temp)];
            }
        }
        if(after){
            after(ret);
        }
    }
}
@end
