//
//  Header.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/16.
//

/// ErrorCode -600
/// Scheme 无效
#define kRSchemeError \
    [NSError errorWithDomain:@"Invilde Scheme" code:-600 userInfo:nil]

/// ErrorCode -601
/// 目标未找到
#define kRTargetError \
    [NSError errorWithDomain:@"Target Not Found" code:-601 userInfo:nil]

/// ErrorCode -602
/// 路由表解析失败或为空值
#define kRRPListError \
    [NSError errorWithDomain:@"R-Plist Unavailable" code:-602 userInfo:nil]

/// ErrorCode -603
/// URL与路由规则不匹配
#define kRURLError     \
    [NSError errorWithDomain:@"URL not conform to [GLRouter URL Rule]" code:-603 userInfo:nil]

/// ErrorCode -604
/// 目标视图未使用路由协议
#define kRProtocolError \
    [NSError errorWithDomain:@"Target Class Not Use [GLRouter Protocol]" code:-604 userInfo:nil]

/// ErrorCode -610
/// 在当前视图向上查找以及从根向下查找2级，未能找到匹配push操作的NavigationController
#define kRTargetNavigationError \
    [NSError errorWithDomain:@"Can not Find Navigation to match Router push target" code:-610 userInfo:nil]
