//
//  NSFileManager+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Extension)

/** 计算文件尺寸 */
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;

/** 计算文件夹尺寸 */
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;

@end
