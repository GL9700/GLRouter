//
//  UIApplication+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/17.
//

#import <UIKit/UIKit.h>

/** app版本 */
UIKIT_STATIC_INLINE NSArray * shortVersion() {
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return [str componentsSeparatedByString:@"."];
}

/** build版本 */
UIKIT_STATIC_INLINE NSArray * buildVersion() {
    NSString *str = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    return [str componentsSeparatedByString:@"."];
}

/** application bundle id */
UIKIT_STATIC_INLINE NSString * bundleID() {
    return [[NSBundle mainBundle].infoDictionary objectForKey:(NSString *)kCFBundleIdentifierKey];
}

@interface UIApplication (Extension)

@end
