//
//  Router.h
//  Router
//
//  Created by liguoliang on 2018/1/9.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kRouter [Router manager]

typedef enum : NSUInteger {
    push,
    present,
    invoke
} routerType;

@interface Router : NSObject

/*
 *
 * [Router openURL:@"router://[ROUTER_TYPE]/[TARGET]?[VK1=VV1&VK2=VV2]"];
 *
 * [Router openURL:@"router://present/ViewController?name=liguoliang&password=guoliang.li"];
 * [Router openURL:@"router://push/ViewController?name=liguoliang&password=guoliang.li"];
 * [Router openURL:@"router://invoke/ViewController?methodName=sayMessage&msg=ThisContentMessage"];
 *
 */

+ (instancetype)RouterWithScheme:(NSString *)scheme;
+ (void)openURL:(NSString *)url form:(UIResponder *)from before:(void(^)(id targetController))handle after:(void(^)(id ret))after;

@end
