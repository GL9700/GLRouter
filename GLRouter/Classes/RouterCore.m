//
//  RouterCore.m
//  RouterCore
//
//  Created by liguoliang on 2018/1/9.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "RouterCore.h"
#import "RouterProtocol.h"
#import <objc/message.h>

#define kURLTypeInfoBundleURLName @"router"

typedef enum : NSUInteger {
    RouterTypePush,
    RouterTypePresent,
    RouterTypeInvoke
} RouterType;

@interface RouterCore ()
@property (nonatomic, strong) NSArray<NSString *> *schemes;
@property (nonatomic) RouterType type;
@end

static RouterCore *routerInstance;
static BOOL rsenable;
@implementation RouterCore

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL = @selector(application:openURL:options:);
        SEL newSEL = @selector(_application:openURL:options:);
        [self swizzleExchangeInstanceMethod:newSEL toMethod:originSEL toClass:NSClassFromString(@"AppDelegate")];
    });
}

- (BOOL)_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if(routerInstance.schemes!=nil && [routerInstance.schemes containsObject:[url.scheme lowercaseString]]){
        [RouterCore openURL:url.absoluteString form:app.keyWindow.rootViewController before:nil after:nil];
    }else{
        if([app canOpenURL:url]){
            if(@available(iOS 10.0, *)){
                [routerInstance _application:app openURL:url options:@{@"UIApplicationOpenURLOptionUniversalLinksOnly":[NSNumber numberWithBool:NO]}];
            }
        }
    }
    return YES;
}

+ (void)swizzleExchangeInstanceMethod:(SEL)newMethod toMethod:(SEL)originMethod toClass:(Class)class{
    method_exchangeImplementations(class_getInstanceMethod(class, originMethod), class_getInstanceMethod([self class], newMethod));
}

+ (instancetype)sharedRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerInstance = [[RouterCore alloc]init];
        NSBundle *bundle = [NSBundle mainBundle];
        NSArray<NSDictionary *> *info = bundle.infoDictionary[@"CFBundleURLTypes"];
        [info enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.allKeys containsObject:@"CFBundleURLName"] && [obj.allKeys containsObject:@"CFBundleURLSchemes"]){
                if([[obj[@"CFBundleURLName"] lowercaseString] isEqualToString:kURLTypeInfoBundleURLName]){
                    NSMutableArray *arr = [NSMutableArray array];
                    [obj[@"CFBundleURLSchemes"] enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [arr addObject: [obj lowercaseString]];
                    }];
                    routerInstance.schemes = [arr copy];
                }
            }
        }];
        NSAssert(routerInstance.schemes, @"请先定义URLType (使用%@作为identifier)", kURLTypeInfoBundleURLName);
    });
    return routerInstance;
}

+ (void)openURL:(NSString *)urlstr form:(UIViewController *)from before:(BOOL (^)(id targetController))before after:(void (^)(id ret))invokeAfter {
    NSAssert(routerInstance, @"需要先进行初始化，使用+ RouterWithScheme: 方法");
    
    NSString *tempStr = [urlstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *urlc = [NSURLComponents componentsWithString:tempStr];
    NSString *type, *clsname;
    __block NSString *funcname;
    NSMutableArray<NSURLQueryItem *> *querys = [urlc.queryItems mutableCopy];
    
    
    if([routerInstance.schemes containsObject:[urlc.scheme lowercaseString]]) {
//    if([urlc.scheme isEqualToString:routerInstance.scheme]) {
        type = [urlc.host lowercaseString];
        NSArray<NSString *> *path = [[urlc.path substringFromIndex:1] componentsSeparatedByString:@"/"];
        clsname = path[0];
        if([type isEqualToString:@"invoke"]) {
            if(path.count>1) {
                funcname = path[1];
            }else{
                [querys enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([[obj.name lowercaseString] isEqualToString:@"method"] || [[obj.name lowercaseString] isEqualToString:@"func"]) {
                        *stop = YES;
                        funcname = obj.value;
                        [querys removeObjectAtIndex:idx];
                    }
                }];
            }
            routerInstance.type = RouterTypeInvoke;
            [self willInvokeFuncName:funcname WithClsName:clsname querys:querys afterHandle:invokeAfter];
        }
        else if([type isEqualToString:@"present"] || [type isEqualToString:@"push"]) {
            __block NSUInteger i = UINT_MAX;
            [querys enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.value hasPrefix:@"http://"] || [obj.value hasPrefix:@"https://"]) {
                    *stop = YES;
                    i = idx;
                }
            }];
            if(i<UINT_MAX && querys.count>i+1){
                NSMutableString *t = [NSMutableString stringWithFormat:@"%@=%@", querys[i].name, querys[i].value];
                for(NSUInteger j = i; j<querys.count; j++){
                    [t appendFormat:@"&%@=%@", querys[i].name, querys[i].value];
                }
                querys[i] = [NSURLQueryItem queryItemWithName:querys[i].name value:t];
            }
            if ([type isEqualToString:@"push"]) {
                routerInstance.type = RouterTypePush;
                [self willShowType:routerInstance.type onContainer:from beforeHandle:before ClsName:clsname querys:querys];
            }
            else if ([type isEqualToString:@"present"]) {
                routerInstance.type = RouterTypePresent;
                [self willShowType:routerInstance.type onContainer:from beforeHandle:before ClsName:clsname querys:querys];
            }
        }
    }else{
        NSLog(@"-------------Warning : Scheme 无效-------------");
    }
}

/** MARK: 查找匹配的容器 */
+ (UIViewController *)matchContainerWithViewController:(UIViewController *)viewController routerType:(RouterType)RT {
    UIViewController *tgt = viewController;
    switch (RT) {
        case RouterTypePush:
            if (tgt) {
                while((![tgt isKindOfClass:[UIViewController class]] || tgt.navigationController == nil) && tgt!=nil){
                    tgt = (UIViewController *)tgt.nextResponder;
                }
                if(tgt==nil){
                    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                    if([root isKindOfClass:[UITabBarController class]]) {
                        tgt = ((UITabBarController *)root).selectedViewController;
                    }else if([root isKindOfClass:[UINavigationController class]]) {
                        tgt = ((UINavigationController *)root).topViewController;
                    }
                    if([tgt isKindOfClass:[UINavigationController class]]) {
                        tgt = ((UINavigationController *)tgt).topViewController;
                    }
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

/** router push present */
+ (void)willShowType:(RouterType)showType onContainer:(UIViewController *)container beforeHandle:(BOOL (^)(UIViewController *targetVC))beforeHandle ClsName:(NSString *)clsname querys:(NSArray<NSURLQueryItem *> *)querys {
    if (clsname == nil || ![NSClassFromString(clsname) conformsToProtocol:@protocol(RouterProtocol)]) {
        return;
    }
    
    NSMutableDictionary *pars = [NSMutableDictionary dictionary];
    [querys enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pars[obj.name] = obj.value;
    }];
    UIViewController *target = [[NSClassFromString(clsname) alloc]initWithRouterWithParams:pars];
    BOOL continueRouter = beforeHandle ? beforeHandle(target) : YES;
    if (continueRouter) {
        switch (showType) {
            case RouterTypePresent:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *realContainer = [self matchContainerWithViewController:container routerType:showType];
                    // 如果 present 的viewcontroller 没有nav 则创建一个用于关闭页面
                    if(target.navigationController == nil){
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:target];
                        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        class_addMethod([target class], NSSelectorFromString(@"dismis"), imp_implementationWithBlock(^{
                            [(UIViewController *)target dismissViewControllerAnimated:YES completion:nil];
                        }), "@v:");
                        target.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:target action:NSSelectorFromString(@"dismis")];
                        [realContainer presentViewController:nav animated:YES completion:nil];
                    }
                    else{
                        [realContainer presentViewController:target animated:YES completion:nil];
                    }
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
/** router invoke */
+ (void)willInvokeFuncName:(NSString *)func WithClsName:(NSString *)cls querys:(NSArray<NSURLQueryItem *> *)querys afterHandle:(void(^)(id returnValue))afterhandle {
    id target = NSClassFromString(cls); // Class OR NSObject
    if([func hasPrefix:@"-"]){
        func = [func substringFromIndex:1];
        target = [[target alloc]init];
    }
    NSMethodSignature *methodsignature = [target methodSignatureForSelector:NSSelectorFromString(func)];
    if (!methodsignature) {
        NSLog(@"---warning--在[%@]中未找到:[%@]", cls,func);
        return;
    }
    const char *rt = methodsignature.methodReturnType;
    NSUInteger rl = methodsignature.methodReturnLength;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodsignature];
    NSUInteger i = 2;
    NSMutableArray<NSURLQueryItem *> *mquerys = [querys mutableCopy];
    while(i < methodsignature.numberOfArguments && mquerys.count>0){
        id obj = mquerys[0].value;
        [mquerys removeObjectAtIndex:0];
        const char *at = [methodsignature getArgumentTypeAtIndex:i];
        if ( !strcmp(at, @encode(uint)) || !strcmp(at, @encode(int))  || !strcmp(at, @encode(NSUInteger))) {
            uint temp = [obj intValue];
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
        else if (!strcmp(at, @encode(NSInteger))) {
            NSInteger temp = [obj integerValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(BOOL))) {
            BOOL temp = [obj boolValue];
            [invocation setArgument:&temp atIndex:i++];
        }
        else if (!strcmp(at, @encode(char))) {
            char temp = [obj characterAtIndex:0];
            [invocation setArgument:&temp atIndex:i++];
        }
        else {
            [invocation setArgument:&obj atIndex:i++];
        }
    };
    invocation.target = target;
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
