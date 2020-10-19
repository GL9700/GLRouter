//
//  GLRCoreInvokeControl.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import <Foundation/Foundation.h>
#import <GLRBase.h>

@interface GLRCoreInvokeControl : GLRBase
/// 通过参数调用指定的类方法，必须是类方法
/// @param select 方法名
/// @param cls 所在类
/// @param params 参数，key中必须包含从1起始的数字，以便排序。如果某个参数为空，可跳过空参数的key
/// @param handle 返回值
- (void)invokeMethodFromSelector:(SEL)select
                         inClass:(Class)cls
                      withParams:(NSDictionary *)params
                             ret:(void (^)(id ret))handle;
@end
