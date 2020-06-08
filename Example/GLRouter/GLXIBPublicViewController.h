//
//  GLXIBPublicViewController.h
//  GLRouter_Example
//
//  Created by liguoliang on 2020/6/8.
//  Copyright © 2020 liandyii@msn.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLXIBPublicViewController : UIViewController
@property (nonatomic) void(^onHandleClose)(void);
@property (nonatomic) void(^onHandleRegister)(NSString *username, NSString *password);
@property (nonatomic) void(^onHandleLogin)(NSString *username, NSString *password);
@end

NS_ASSUME_NONNULL_END
