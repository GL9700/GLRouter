//
//  UIDevice+Extension.h
//  WCExtensions
//
//  Created by liguoliang on 2018/9/10.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Extension)

/**
 iPhone X       1125    2436    0.46182     375 812     5.8
 iPhone 8 Plus  1080    1920    0.56250     414 736     5.5
 iPhone 8       750     1334    0.56222     375 667     4.8
 iPhone 7 Plus  1080    1920    0.56250     414 736     5.5
 iPhone 7       750     1334    0.56222     375 667     4.8
 iPhone 6s Plus 1080    1920    0.56250     414 736     5.5
 iPhone 6s      750     1334    0.56222     375 667     4.8
 iPhone 6 Plus  1080    1920    0.56250     414 736     5.5
 iPhone 6       750     1334    0.56222     375 667     4.8
 iPhone SE      640     1136    0.56338     320 568     4.0
 */

/** 依据屏幕尺寸 iPhoneSE 4.0 | iPhone 4.8 | iPhonePlus 5.5 | iPhoneX 5.8 */
+ (CGFloat)deviceScreen;

/** 系统详细信息 iphone N,X */
+ (NSString *)deviceDetail;
@end
