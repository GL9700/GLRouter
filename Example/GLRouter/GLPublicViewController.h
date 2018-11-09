//
//  GLPublicViewController.h
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RouterProtocol.h>
typedef void(^BLKHandle)(void);

@interface GLPublicViewController : UIViewController <RouterProtocol>
@property (nonatomic , strong) UIImage *icon;
@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *message;
@property (nonatomic , strong) BLKHandle handle;
@end
