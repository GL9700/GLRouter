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

#define kRouter [Router manager]

@interface Router()
@property (nonatomic , strong) NSMutableDictionary *routerList;
@property (nonatomic , strong) NSString *scheme;
@end

@implementation Router
+ (instancetype)manager {
    static Router *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Router alloc]init];
    });
    return instance;
}

+ (void)openURL:(NSString *)url form:(UIResponder *)from before:(void(^)(id targetController))handle {
    
    NSURLComponents *comp = [NSURLComponents componentsWithString:url];
    if(comp==nil) return;
    NSString *type = comp.host;
    NSString *className = [comp.path substringFromIndex:1];
    if(className==nil) return;
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *queryItem in comp.queryItems) {
        [variables setObject:queryItem.value forKey:queryItem.name];
    }
    
    if([[type lowercaseString] isEqualToString:@"push"] || [[type lowercaseString] isEqualToString:@"present"]) {
        if(className==nil || ![NSClassFromString(className) conformsToProtocol:@protocol(RouterProtocol)]) return;
        UIViewController *target = [[NSClassFromString(className) alloc]initWithRouterWithParams:variables];
        if(handle) handle(target);
            if([[type lowercaseString] isEqualToString:@"push"]) {
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
                        }else{
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
        
    } else if([[type lowercaseString] isEqualToString:@"invoke"]) {
        Class targetClass = NSClassFromString(className);
        NSString *method = variables[@"method"];
        if(!method) return;
        [variables removeObjectForKey:@"method"];
        NSMethodSignature *methodsignature = [targetClass methodSignatureForSelector:NSSelectorFromString(method)];
        if(!methodsignature) return;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodsignature];
        __block int i=2;
        [variables enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [invocation setArgument:&obj atIndex:i++];
        }];
        invocation.target = targetClass;
        invocation.selector = NSSelectorFromString(method);
        [invocation invoke];
        
    }
}
@end
