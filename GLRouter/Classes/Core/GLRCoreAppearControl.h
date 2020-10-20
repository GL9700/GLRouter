//
//  GLRCoreAppearControl.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import <UIKit/UIKit.h>
#import <GLRouter/GLRBase.h>

@interface GLRCoreAppearControl : GLRBase
/// push页面
/// @param cls 页面名称
/// @param params 可选参数。初始化以后，进行的参数设置
/// @param container 可选父级容器。为空则使用root向下查找两级是否存在导航进行push。如果没找到，则返回空，push失败
/// @param handle 可选必要条件。为空则无条件进行
- (void)pushTargetClass:(Class)cls
             withParams:(NSDictionary *)params
              container:(UIViewController *)container
            inCondition:(BOOL(^)(UIViewController *target))handle;

/// present页面
/// @param cls 页面名称
/// @param params 可选参数。初始化以后，进行的参数设置
/// @param container 可选父级容器。为空则使用Keywindow的RootViewController
/// @param handle 可选必要条件。为空则无条件进行
- (void)presentTargetClass:(Class)cls
                withParams:(NSDictionary *)params
                 container:(UIViewController *)container
               inCondition:(BOOL(^)(UIViewController *target))handle;

@end
