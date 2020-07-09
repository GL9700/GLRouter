//
//  UIDevice+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//



#import "UIDevice+Extension.h"
#import <sys/utsname.h>
#import <mach/mach.h>
#import <SystemConfiguration/CaptiveNetwork.h>

typedef void(^NStatusBlock)(WDYNetworkStatus);
static WDYReachability *REACH;
static NStatusBlock NSBLK;

@implementation UIDevice (Extension)

/** reachability 后 [duplicate symbol] 冲突 -- 有时间再解决 */
+ (WDYReachability *)reachability {
    if(REACH==nil){
        REACH = [WDYReachability reachabilityForInternetConnection];
    }
    return REACH;
}

+ (WDYNetworkStatus)currentNetStatus {
    return [self reachability].currentReachabilityStatus;
}

+ (void)listenNetStatusUseHandler:(void(^)(WDYNetworkStatus netStatus))block {
    NSBLK = block;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWDYReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(REACHDIDChanged:) name:kWDYReachabilityChangedNotification object:nil];
    [[self reachability] startNotifier];
}

+ (void)REACHDIDChanged:(NSNotification *)notifcation {
    if(NSBLK){
        NSBLK([self reachability].currentReachabilityStatus);
    }
}

+ (NSString *)deviceDetail {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)nameStringWithWIFI{
    id value = @"GET WiFi SSID Failed !! ";
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            value = info[@"SSID"];
        }
    }
    if(!value || [value length]==0){
        NSLog(@"\n\n Wi-Fi SSID Error!! *** in iOS 12+ Need Set [Project -> Capabilities -> Access WiFi Information Entitlement] ***\n\n");
    }
    return value;
}


#pragma mark- Memory
+ (uint64_t)memoryByteSizeWithPhysicalTotal {
    return [NSProcessInfo processInfo].physicalMemory;
}
+ (uint64_t)memoryByteSizeWithAvailableTotal {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS){
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}
+ (uint64_t)memoryByteSizeWithUsed {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size;
}

#pragma mark- Storage
+ (uint64_t)diskByteSizeWithTotal {
    NSDictionary *directory = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    if(directory[NSFileSystemSize]!=nil){
        return [directory[NSFileSystemSize] unsignedLongLongValue];
    }
    return 0;
}
+ (uint64_t)diskByteSizeWithFree {
    NSDictionary *directory = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    if(directory[NSFileSystemFreeSize]!=nil){
        return [directory[NSFileSystemFreeSize] unsignedLongLongValue];
    }
    return 0;
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
