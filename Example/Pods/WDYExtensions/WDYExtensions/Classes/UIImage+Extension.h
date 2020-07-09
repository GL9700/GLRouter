//
//  UIImage+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define _img(name) [UIImage imageNamed:name]

@interface UIImage (Extension)
/** 加载原始图片 */
+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName;
/** 压缩图片 */
+ (NSData *)compressWithLengthLimit:(NSUInteger)maxLength withOrignImg:(UIImage *)orignImg;
@end
