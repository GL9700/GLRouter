//
//  Router.h
//  Router
//
//  Created by liguoliang on 2018/1/9.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Router : NSObject

/*
 * [Router openURL:@"RS://RT/TGT?[k=v&k=v]";
 *  RS : Router Scheme
 *  RT : Router Type [ push | present | invoke ]
 *  TGT: Method name (Only in invoke Type)
 *
 * [Router openURL:@"RS://present/ViewController?name=liguoliang&password=guoliang.li"];
 * [Router openURL:@"RS://push/ViewController?name=liguoliang&password=guoliang.li"];
 * [Router openURL:@"RS://invoke/ViewController?methodName=sayMessage&msg=ThisContentMessage"];
 */

+ (instancetype)RouterWithScheme:(NSString *)scheme;
+ (void)openURL:(NSString *)url form:(UIResponder *)from before:(BOOL (^)(id targetController))before after:(void (^)(id ret))invokeAfter;

@end
