//
//  UIDevice+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import "UIDevice+Extension.h"
#import <sys/utsname.h>
#import "Reachability.h"

typedef void (^NStatusBlock)(NetworkStatus);
static Reachability *REACH;
static NStatusBlock NSBLK;

@implementation UIDevice (Extension)

+ (Reachability *)reachability {
    if (REACH == nil) {
        REACH = [Reachability reachabilityForInternetConnection];
    }
    return REACH;
}

+ (NetworkStatus)currentNetStatus {
    return [self reachability].currentReachabilityStatus;
}

+ (void)listenNetworkStatusUseHandler:(void (^)(NetworkStatus netStatus))block {
    NSBLK = block;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(REACHDIDChanged:) name:kReachabilityChangedNotification object:nil];
    [[self reachability] startNotifier];
}

+ (void)REACHDIDChanged:(NSNotification *)notifcation {
    if (NSBLK) {
        NSBLK([self reachability].currentReachabilityStatus);
    }
}

+ (NSString *)deviceDetail {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end

/**
 iPhone3,1 -- iPhone 4
 iPhone3,2 -- iPhone 4
 iPhone3,3 -- iPhone 4
 iPhone4,1 -- iPhone 4S
 iPhone5,1 -- iPhone 5
 iPhone5,2 -- iPhone 5 (GSM+CDMA)
 iPhone5,3 -- iPhone 5c (GSM)
 iPhone5,4 -- iPhone 5c (GSM+CDMA)
 iPhone6,1 -- iPhone 5s (GSM)
 iPhone6,2 -- iPhone 5s (GSM+CDMA)
 iPhone7,1 -- iPhone 6 Plus
 iPhone7,2 -- iPhone 6
 iPhone8,1 -- iPhone 6s
 iPhone8,2 -- iPhone 6s Plus
 iPhone8,4 -- iPhone SE
 iPhone9,1 -- 国行、日版、港行iPhone 7
 iPhone9,2 -- 港行、国行iPhone 7 Plus
 iPhone9,3 -- 美版、台版iPhone 7
 iPhone9,4 -- 美版、台版iPhone 7 Plus
 iPhone10,1 -- 国行(A1863)、日行(A1906)iPhone 8
 iPhone10,4 -- 美版(Global/A1905)iPhone 8
 iPhone10,2 -- 国行(A1864)、日行(A1898)iPhone 8 Plus
 iPhone10,5 -- 美版(Global/A1897)iPhone 8 Plus
 iPhone10,3 -- 国行(A1865)、日行(A1902)iPhone X
 iPhone10,6 -- 美版(Global/A1901)iPhone X

 iPod1,1 -- iPod Touch 1G
 iPod2,1 -- iPod Touch 2G
 iPod3,1 -- iPod Touch 3G
 iPod4,1 -- iPod Touch 4G
 iPod5,1 -- iPod Touch (5 Gen)

 iPad1,1 -- iPad
 iPad1,2 -- iPad 3G
 iPad2,1 -- iPad 2 (WiFi)
 iPad2,2 -- iPad 2
 iPad2,3 -- iPad 2 (CDMA)
 iPad2,4 -- iPad 2
 iPad2,5 -- iPad Mini (WiFi)
 iPad2,6 -- iPad Mini
 iPad2,7 -- iPad Mini (GSM+CDMA)
 iPad3,1 -- iPad 3 (WiFi)
 iPad3,2 -- iPad 3 (GSM+CDMA)
 iPad3,3 -- iPad 3
 iPad3,4 -- iPad 4 (WiFi)
 iPad3,5 -- iPad 4
 iPad3,6 -- iPad 4 (GSM+CDMA)
 iPad4,1 -- iPad Air (WiFi)
 iPad4,2 -- iPad Air (Cellular)
 iPad4,4 -- iPad Mini 2 (WiFi)
 iPad4,5 -- iPad Mini 2 (Cellular)
 iPad4,6 -- iPad Mini 2
 iPad4,7 -- iPad Mini 3
 iPad4,8 -- iPad Mini 3
 iPad4,9 -- iPad Mini 3
 iPad5,1 -- iPad Mini 4 (WiFi)
 iPad5,2 -- iPad Mini 4 (LTE)
 iPad5,3 -- iPad Air 2
 iPad5,4 -- iPad Air 2
 iPad6,3 -- iPad Pro 9.7
 iPad6,4 -- iPad Pro 9.7
 iPad6,7 -- iPad Pro 12.9
 iPad6,8 -- iPad Pro 12.9
 iPad6,11 -- iPad 5 (WiFi)
 iPad6,12 -- iPad 5 (Cellular)
 iPad7,1 -- iPad Pro 12.9 inch 2nd gen (WiFi)
 iPad7,2 -- iPad Pro 12.9 inch 2nd gen (Cellular)
 iPad7,3 -- iPad Pro 10.5 inch (WiFi)
 iPad7,4 -- iPad Pro 10.5 inch (Cellular)

 AppleTV2,1 -- Apple TV 2
 AppleTV3,1 -- Apple TV 3
 AppleTV3,2 -- Apple TV 3
 AppleTV5,3 -- Apple TV 4

 i386 -- Simulator
 x86_64 -- Simulator
 */
