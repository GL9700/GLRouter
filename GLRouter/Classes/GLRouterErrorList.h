//
//  Header.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/16.
//

typedef enum : NSInteger {
    RouterErrorInvalidScheme = -600,        // Scheme 无效
    RouterErrorNotFoundTarget = -601,       // 目标未找到
    RouterErrorNotFoundNavigation = -605,   // 在当前视图向上查找以及从根向下查找2级，未能找到匹配push操作的NavigationController
    RouterErrorUnabilableLocalPlist = -602, // 路由表解析失败或为空值
    RouterErrorUnabilableURL = -603,        // URL与路由规则不匹配
    RouterErrorTargetNotUseProtocol = -604  // 目标视图未使用路由协议
} RouterError;

#define kRouterErrorWith(__domain__, __code__) \
    [NSError errorWithDomain:(__domain__) code:(__code__) userInfo:nil]
//
///// ErrorCode -600
///// Scheme 无效
//#define kRSchemeError \
//    [NSError errorWithDomain:@"Invilde Scheme" code:RouterErrorInvalidScheme userInfo:nil]
//
///// ErrorCode -601
///// 目标未找到
//#define kRTargetError \
//    [NSError errorWithDomain:@"Target Not Found" code:RouterErrorNotFoundTarget userInfo:nil]
//
///// ErrorCode -602
///// 路由表解析失败或为空值
//#define kRRPListError \
//    [NSError errorWithDomain:@"R-Plist Unavailable" code:RouterErrorUnabilableLocalPlist userInfo:nil]
//
///// ErrorCode -603
///// URL与路由规则不匹配
//#define kRURLError     \
//    [NSError errorWithDomain:@"URL not conform to [GLRouter URL Rule]" code:RouterErrorUnabilableURL userInfo:nil]
//
///// ErrorCode -604
///// 目标视图未使用路由协议
//#define kRProtocolError \
//    [NSError errorWithDomain:@"Target Class Not Use [GLRouter Protocol]" code:RouterErrorTargetNotUseProtocol userInfo:nil]
//
///// ErrorCode -610
///// 在当前视图向上查找以及从根向下查找2级，未能找到匹配push操作的NavigationController
//#define kRTargetNavigationError \
//    [NSError errorWithDomain:@"Can not Find Navigation to match Router push target" code:RouterErrorNotFoundNavigation userInfo:nil]
