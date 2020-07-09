//
//  UIApplication+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/17.
//

#import "UIApplication+Extension.h"
//#import <UIAlertController+Extension.h>
//#import <Photos/Photos.h>
//#import <UserNotifications/UserNotifications.h>
//#import <CoreLocation/CoreLocation.h>

@implementation UIApplication (Extension)
/*
+ (void)enterOptionSetting {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (BOOL)privacyAuthorizedForPhotoLibraryWithAlert:(BOOL)alert {
    BOOL authorized = NO;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch(status){
        case PHAuthorizationStatusNotDetermined:// 未选择
            if(alert){
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {}];
            }
            break;
        case PHAuthorizationStatusRestricted:// 不能选
        case PHAuthorizationStatusDenied: // 被拒绝
            if(alert){
                NSString *str = [NSString stringWithFormat:@"请在“设置->隐私->相册”选项中,允许%@访问相册。", appName()];
                [UIAlertController showAlertWithTitle:@"提示" message:str buttonTitle:@"好的" action:^(NSString *buttonTitle) {
                    [self enterOptionSetting];
                }];
            }
            break;
        case PHAuthorizationStatusAuthorized:   // 已授权
            authorized = YES;
            break;
    }
    return authorized;
}
 */
@end
