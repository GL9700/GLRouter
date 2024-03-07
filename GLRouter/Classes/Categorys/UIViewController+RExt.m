//
//  UIViewController+RExt.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/12.
//

#import <GLRouter/UIViewController+RExt.h>

@implementation UIViewController (RExt)

- (void)routerParams:(NSDictionary *)params {
	// 这里接收路由中的Query参数
}

- (void)setNilValueForKey:(NSString *)key {
	NSLog(@" --- --- GLRouter : 给一个Key赋空值了 --- --- ");
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	NSLog(@" --- --- GLRouter : 给一个未知的Key赋值了 --- --- ");
}
@end
