//
//  UIApplication+Extension.m
//  WCExtensions
//
//  Created by liguoliang on 2018/9/17.
//

#import "UIApplication+Extension.h"
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>
#import <UIAlertController+Extension.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCellularData.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation UIApplication (Extension)

//MARK: 获得PhotoLibrary授权
+ (BOOL)privacyPhotoLibraryAuthorizedWithHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    PHAuthorizationStatus aStatus = [PHPhotoLibrary authorizationStatus];
    if (aStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization: ^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                               authorized = (BOOL)(status == PHAuthorizationStatusAuthorized);
                           });
        }];
    }
    else {
        authorized = (BOOL)(aStatus == PHAuthorizationStatusAuthorized);
    }
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

//MARK: 获得Camera授权
+ (BOOL)privacyCameraWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                               authorized = granted;
                           });
        }];
    }
    else {
        authorized = (BOOL)(status == PHAuthorizationStatusAuthorized);
    }
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

//MARK: 获得Microphone授权
+ (BOOL)privacyMicrophoneWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    AVAudioSessionRecordPermission status = [[AVAudioSession sharedInstance] recordPermission];
    if (status == AVAudioSessionRecordPermissionUndetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission: ^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                               authorized = granted;
                           });
        }];
    }
    else {
        authorized = (BOOL)(status == AVAudioSessionRecordPermissionDenied);
    }
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

//MARK: 获得AddressBook授权
+ (BOOL)privacyAddressBookWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler: ^(BOOL granted, NSError *_Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                               authorized = granted;
                           });
        }];
    }
    else {
        authorized = (BOOL)(authStatus == CNAuthorizationStatusAuthorized);
    }
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

//MARK: 获得PushNotification授权
+ (BOOL)privacyPushNotificationWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler: ^(BOOL granted, NSError *_Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                               authorized = granted;
                           });
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        if (handle) {
            handle(authorized);
        }
        return authorized;
    }
    else {
        NSLog(@"!! PushNotification授权 暂时仅支持 iOS10+ 版本");
        return NO;
    }
}

//MARK: 获得Calendar授权
+ (BOOL)privacyCalendarWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    NSLog(@"!! 获得Calendar授权 暂时未实现");
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

//MARK: 获得Location授权
+ (BOOL)privacyLocationInUseWithAuthorizedHandle:(void (^)(BOOL authorized))handle {
    __block BOOL authorized = NO;
    BOOL enable = [CLLocationManager locationServicesEnabled];
    int status = [CLLocationManager authorizationStatus];
    if (!enable || status == 1 || status == 2) {
        authorized = NO;
    }
    else {
        authorized = YES;
    }
    if (handle) {
        handle(authorized);
    }
    return authorized;
}

@end
