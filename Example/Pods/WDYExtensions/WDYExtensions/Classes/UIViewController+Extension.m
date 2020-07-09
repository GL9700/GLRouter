//
//  UIViewController+Extension.m
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)
- (void)showLoading:(UIColor *)background {
    showActivity(self , background);
}
- (void)hideLoading {
    hideActivity();
}
@end
