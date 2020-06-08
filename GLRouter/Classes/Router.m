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

typedef enum : NSUInteger {
    RouterTypePush,
    RouterTypePresent,
    RouterTypeInvoke
} RouterType;

@interface Router ()
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic) RouterType type;
@end

static Router *routerInstance;
@implementation Router
+ (instancetype)RouterWithScheme:(NSString *)scheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerInstance = [[Router alloc]init];
        routerInstance.scheme = scheme;
    });
    return routerInstance;
}

+ (void)openURL:(NSString *)url form:(UIViewController *)from before:(BOOL (^)(id targetController))before after:(void (^)(id ret))invokeAfter {
    NSAssert(routerInstance, @"need [+ RouterWithScheme:] before invoke this method");

    NSURLComponents *urlc = [NSURLComponents componentsWithString:url];
    NSLog(@"%@", urlc);

    NSString *RS, *RT, *clsname, *funcname;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSScanner *scan = [NSScanner scannerWithString:url];

    // router scheme
    [scan scanString:routerInstance.scheme intoString:&RS];

    // router type
    [scan scanUpToCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:nil];
    [scan scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&RT];

    // cls name
    [scan scanUpToCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:nil];
    [scan scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&clsname];

    RT = [RT lowercaseString];
    if ([RT isEqualToString:@"invoke"]) {
        NSString *nextString = [scan.string substringWithRange:(NSRange){scan.scanLocation, 1}];
        if([nextString isEqualToString:@"/"]) {
            [scan scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"] intoString:nil];
            [scan scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&funcname];
        }
    }
    [scan scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?"] intoString:nil];
    NSArray *quersys = [[scan.string substringFromIndex:scan.scanLocation] componentsSeparatedByString:@"&"];
    for(int i=0;i<quersys.count;i++){
        NSArray *queryItem = [quersys[i] componentsSeparatedByString:@"="];
        NSString *key = queryItem[0];
        NSString *value = queryItem[1];
        if([NSURLComponents componentsWithString:value]){
            NSString *urlParam = [scan.string substringFromIndex:[scan.string rangeOfString:value].location];
            params[key] = urlParam;
            break;
        }
        else{
            params[key] = value;
        }
    }

    if ([RT isEqualToString:@"invoke"]) {
        routerInstance.type = RouterTypeInvoke;
        [self willInvokeFuncName:funcname WithClsName:clsname Params:params afterHandle:invokeAfter];
    }
    else if ([RT isEqualToString:@"push"]) {
        routerInstance.type = RouterTypePush;
        [self willShowType:routerInstance.type onContainer:from beforeHandle:before ClsName:clsname params:params];
    }
    else if ([RT isEqualToString:@"present"]) {
        routerInstance.type = RouterTypePresent;
        [self willShowType:routerInstance.type onContainer:from beforeHandle:before ClsName:clsname params:params];
    }
}

/** MARK: 查找匹配的容器 */
+ (UIViewController *)matchContainerWithViewController:(UIViewController *)viewController routerType:(RouterType)RT {
    UIViewController *tgt = viewController;
    switch (RT) {
        case RouterTypePush:
            if (tgt) {
                while(![tgt isKindOfClass:[UIViewController class]] || tgt.navigationController == nil){
                    tgt = (UIViewController *)tgt.nextResponder;
                }
            }
            else {
                tgt = [UIApplication sharedApplication].keyWindow.rootViewController;
                if([tgt isKindOfClass:[UINavigationController class]]){
                    tgt = ((UINavigationController *)tgt).topViewController;
                }
                else{
                    while (tgt.navigationController == nil) {
                        if ([tgt isKindOfClass:[UITabBarController class]]) {
                            tgt = ((UITabBarController *)tgt).selectedViewController;
                        }
                        else if ([tgt isKindOfClass:[UINavigationController class]]) {
                            tgt = ((UINavigationController *)tgt).topViewController;
                        }
                        else {
                            break;
                        }
                    }
                }
            }
            break;
        case RouterTypePresent:
            if (tgt) {
                while (![tgt isKindOfClass:[UIViewController class]]){
                    if(tgt.nextResponder==nil){
                        break;
                    }
                    tgt = (UIViewController *)tgt.nextResponder;
                }
            }
            break;
        default:
            break;
    }
    return tgt;
}

+ (void)willShowType:(RouterType)showType onContainer:(UIViewController *)container beforeHandle:(BOOL (^)(UIViewController *targetVC))beforeHandle ClsName:(NSString *)clsname params:(NSDictionary *)params {
    if (clsname == nil || ![NSClassFromString(clsname) conformsToProtocol:@protocol(RouterProtocol)]) {
        return;
    }
    UIViewController *target = [[NSClassFromString(clsname) alloc]initWithRouterWithParams:params];
    BOOL continueRouter = beforeHandle ? beforeHandle(target) : YES;
    if (continueRouter) {
        switch (showType) {
            case RouterTypePresent:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *realContainer = [self matchContainerWithViewController:container routerType:showType];
                    [realContainer presentViewController:target animated:YES completion:nil];
                });
            }
                break;
            case RouterTypePush:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *realContainer = [self matchContainerWithViewController:container routerType:showType];
                    [realContainer.navigationController pushViewController:target animated:YES];
                });
            }
                break;
            default:
                break;
        }
    }
}

+ (void)willInvokeFuncName:(NSString *)func WithClsName:(NSString *)cls Params:(NSDictionary *)params afterHandle:(void(^)(id returnValue))afterhandle {
    Class targetClass = NSClassFromString(cls);
    NSMutableDictionary *pam = [params mutableCopy];
    if(func==nil && [pam.allKeys containsObject:@"method"]){
        func = pam[@"method"];
        [pam removeObjectForKey:@"method"];
    }
    NSMethodSignature *methodsignature = [targetClass methodSignatureForSelector:NSSelectorFromString(func)];
    if (!methodsignature) return;
    const char *rt = methodsignature.methodReturnType;
    NSUInteger rl = methodsignature.methodReturnLength;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodsignature];
    __block int i = 2;
    [pam enumerateKeysAndObjectsUsingBlock: ^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        const char *at = [methodsignature getArgumentTypeAtIndex:i];
        if (!strcmp(at, @encode(uint))) {
            uint temp = [obj unsignedIntValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(int))) {
            int temp = [obj intValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(float))) {
            float temp = [obj floatValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(double))) {
            double temp = [obj doubleValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(NSUInteger))) {
            NSUInteger temp = [obj unsignedIntegerValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(NSInteger))) {
            NSInteger temp = [obj integerValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(BOOL))) {
            BOOL temp = [obj boolValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(char))) {
            char temp = [obj charValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else {
            [invocation setArgument:&obj atIndex:i++];
        }
    }];
    invocation.target = targetClass;
    invocation.selector = NSSelectorFromString(func);
    [invocation invoke];
    id ret;
    if (!strcmp(rt, @encode(void))) {
        ret = nil;
    }
    else if (!strcmp(rt, @encode(id))) {
        [invocation getReturnValue:&ret];
    }
    else {
        void *temp = (void *)malloc(rl);
        [invocation getReturnValue:temp];
        if (!strcmp(rt, @encode(BOOL))) {
            ret = [NSNumber numberWithBool:*((BOOL *)temp)];
        }
        else if (!strcmp(rt, @encode(NSInteger))) {
            ret = [NSNumber numberWithInteger:*((NSInteger *)temp)];
        }
        else if (!strcmp(rt, @encode(int))) {
            ret = [NSNumber numberWithInteger:*((int *)temp)];
        }
        else if (!strcmp(rt, @encode(float))) {
            ret = [NSNumber numberWithInteger:*((float *)temp)];
        }
        else if (!strcmp(rt, @encode(double))) {
            ret = [NSNumber numberWithInteger:*((double *)temp)];
        }
    }
    if (afterhandle) {
        afterhandle(ret);
    }
}

@end
