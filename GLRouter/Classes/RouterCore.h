//
//  RouterCore.h
//  RouterCore
//
//  Created by liguoliang on 2018/1/9.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RouterCore : NSObject

/** 针对外部跳转入进app的方案
 *  方式大致分为两种：
 *      a) schema (iOS all)
 *          例如：weixin://dl/scan
 *          优势：调用简单
 *          劣势：部分浏览器无法跳入，例如微信中的网页浏览；无法通过JS判断app是否启动
 *      b) Universal Link (iOS9+)
 *          必须：iOS开发时配置一个与app相关联的域名
 *
 *
 */

/*
 * [RouterCore openURL:@"RS://RT/TGT?[k=v&k=v]";
 *  RS : Router Scheme
 *  RT : Router Type [ push | present | invoke ]
 *  TGT: Method name (Only in invoke Type)
 *
 *** push
 * 使用before方便传入非明文参数例如 image data date 等
 * [Router openURL:@"RS://present/vc?name=liguoliang&password=guoliang" before:BOOL(UIViewController *target){...}];
 * [Router openURL:@"RS://push/vc?name=liguoliang&password=guoliang" before:BOOL(UIViewController *target){...}];
 *
 ***  invoke
 * 允许方法名写在path中
 * 允许需求参数多于传入参数，取默认值(nil 或 0)
 * 允许需求参数少于传入参数, 抛弃多传进来的参数
 * 返回值采用after回调来拿
 * [Router openURL:@"RS://invoke/ViewController/saymsg1:msg2:?p1=arg1&p2=arg2" after:void(id Return){...}];
 * [Router openURL:@"RS://invoke/ViewController?method=sayMsg1:msg2:&p=arg" after:void(id Return){...}];
 * [Router openURL:@"RS://invoke/ViewController?method=sayMessage&msg=ThisContentMessage" after:void(id Return){...}];
 */

+ (instancetype)sharedRouter;
+ (void)openURL:(NSString *)urlstr form:(UIViewController *)from before:(BOOL (^)(id targetController))before after:(void (^)(id ret))invokeAfterr;

@end
