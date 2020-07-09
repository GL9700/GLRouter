//
//  UIApplication+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/17.
//

#import <UIKit/UIKit.h>

/** app显示的名字 */
UIKIT_STATIC_INLINE NSString *appName(){
    return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
}

/** app版本 */
UIKIT_STATIC_INLINE NSArray *releaseVersion() {
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return [str componentsSeparatedByString:@"."];
}

/** build版本 */
UIKIT_STATIC_INLINE NSArray *buildVersion() {
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    return [str componentsSeparatedByString:@"."];
}

/** application bundle id */
UIKIT_STATIC_INLINE NSString *bundleID() {
    return [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
}

@interface UIApplication (Extension)

/** 检查相册使用权限  alert：是否开启让用户选择和拒绝权限后的弹窗 */
/*
+ (BOOL)privacyAuthorizedForPhotoLibraryWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForCameraWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForMicrophoneWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForCalendarsWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForRemindersWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForNotificationWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForLocationWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForLocationAlwaysWithAlert:(BOOL)alert;
+ (BOOL)privacyAuthorizedForLocationWhenInUseWithAlert:(BOOL)alert;
+ (void)enterOptionSetting;
 */
@end
