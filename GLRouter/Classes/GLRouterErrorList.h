//
//  Header.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/16.
//

typedef enum : NSInteger {
    RouterErrorInvalidScheme = -600,            // Scheme 无效
    RouterErrorNotFoundTarget = -601,           // 目标未找到
    RouterErrorNotFoundNavigation = -605,       // 在当前视图向上查找以及从根向下查找2级，未能找到匹配push操作的NavigationController
    RouterErrorUnabilableLocalPlist = -602,     // 路由表解析失败或为空值
    RouterErrorUnabilableURL = -603,            // URL与路由规则不匹配
    RouterErrorTargetNotUseProtocol = -604,     // 目标视图未使用路由协议
    RouterErrorMethodNotFound = -605,           // 尝试调用的方法未找到
} RouterError;

#define kRouterErrorWith(__err_code__, ...) \
    [NSError errorWithDomain:[NSString stringWithFormat:__VA_ARGS__] code:(__err_code__) userInfo:nil]

//#define RtAssert(__cond__, __err_code__, ...) \
// //NSAssert(__cond__, @"\n*** GLRouter Error *** \n (Tips : Not Found [GLRouterManager failure:])\n ErrorCode : %ld\n Detail :\n\t%@", __err_code__, [NSString stringWithFormat:__VA_ARGS__])
