//
//  UIDevice+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import <UIKit/UIKit.h>
#import <WDYReachability.h>

#define kXSeries ([UIScreen mainScreen].bounds.size.height>=812)
#define kSafeTopHeight (kXSeries?88.0:64.0)
#define kSafeBottomHeight (kXSeries?34.0:0)
#define kSafeContentHeight ([UIScreen mainScreen].bounds.size.height - kSafeTopHeight - kSafeBottomHeight)

@interface UIDevice (Extension)

/** 系统详细信息 iphone N,X */
+ (NSString *)deviceDetail;

/** 开始网络监听 */
+ (void)listenNetStatusUseHandler:(void(^)(WDYNetworkStatus netStatus))block;

/** 获取当前网络状态 */
+ (WDYNetworkStatus)currentNetStatus;

/** 获取当前WIFI的SSID */
+ (NSString *)nameStringWithWIFI;

/** 获取总空间 */
+ (uint64_t)diskByteSizeWithTotal;

/** 获取可用磁盘空间 */
+ (uint64_t)diskByteSizeWithFree;

/** 内存的物理总大小 */
+ (uint64_t)memoryByteSizeWithPhysicalTotal;

/** 系统分配后的可用内存总量 */
+ (uint64_t)memoryByteSizeWithAvailableTotal;

/** 内存已使用大小 */
+ (uint64_t)memoryByteSizeWithUsed;

@end

/**
 iPhone XS Max  1242    2688    0.47321
 iPhone XR      828     1792    0.46205
 iPhone XS      1125    2436    0.46182     375 812     5.8     3x
 iPhone X       1125    2436    0.46182     375 812     5.8     3x
 iPhone 8 Plus  1080    1920    0.56250     414 736     5.5     3x
 iPhone 8       750     1334    0.56222     375 667     4.8     2x
 iPhone 7 Plus  1080    1920    0.56250     414 736     5.5     3x
 iPhone 7       750     1334    0.56222     375 667     4.8     2x
 iPhone 6s Plus 1080    1920    0.56250     414 736     5.5     3x
 iPhone 6s      750     1334    0.56222     375 667     4.8     2x
 iPhone 6 Plus  1080    1920    0.56250     414 736     5.5     3x
 iPhone 6       750     1334    0.56222     375 667     4.8     2x
 iPhone SE      640     1136    0.56338     320 568     4.0     2x
 */
