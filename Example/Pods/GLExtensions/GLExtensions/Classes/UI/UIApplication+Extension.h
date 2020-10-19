//
//  UIApplication+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/17.
//

#import <UIKit/UIKit.h>

/** app版本 */
UIKIT_STATIC_INLINE NSArray * releaseVersion()
{
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return [str componentsSeparatedByString:@"."];
}

/** build版本 */
UIKIT_STATIC_INLINE NSArray * buildVersion()
{
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    return [str componentsSeparatedByString:@"."];
}

/** application bundle id */
UIKIT_STATIC_INLINE NSString * bundleID()
{
    return [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
}

@interface UIApplication (Extension)

/** 获得PhotoLibrary授权 */
+ (BOOL)privacyPhotoLibraryAuthorizedWithHandle:(void (^)(BOOL authorized))handle;
/** 获得Camera授权 */
+ (BOOL)privacyCameraWithAuthorizedHandle:(void (^)(BOOL authorized))handle;
/** 获得Microphone授权 */
+ (BOOL)privacyMicrophoneWithAuthorizedHandle:(void (^)(BOOL authorized))handle;
/** 获得AddressBook授权 */
+ (BOOL)privacyAddressBookWithAuthorizedHandle:(void (^)(BOOL authorized))handle;
/** 获得PushNotification授权 */
+ (BOOL)privacyPushNotificationWithAuthorizedHandle:(void (^)(BOOL authorized))handle;
/** 获得Calendar授权 */
+ (BOOL)privacyCalendarWithAuthorizedHandle:(void (^)(BOOL authorized))handle;
/** 获得Location授权 */
+ (BOOL)privacyLocationInUseWithAuthorizedHandle:(void (^)(BOOL authorized))handle;

@end
