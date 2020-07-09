//
//  UIViewController+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+Extension.h>
#import <UIAlertController+Extension.h>

UIKIT_STATIC_INLINE void hideActivity() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *actView = [UIView defaultViewForActivityWithFrame:CGRectZero];
        if(actView.superview){
            [actView removeFromSuperview];
        }
        [actView performSelectorOnMainThread:NSSelectorFromString(@"hideActivity") withObject:nil waitUntilDone:NO];
    });
}

UIKIT_STATIC_INLINE void showActivity(id vc , UIColor *background) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [UIApplication sharedApplication].keyWindow;
        if([vc isKindOfClass:[UIViewController class]])
            view = ((UIViewController *)vc).view;
        UIView *actView = [UIView defaultViewForActivityWithFrame:view.bounds];
        if(background)
            actView.backgroundColor = background;
        [actView performSelectorOnMainThread:NSSelectorFromString(@"showActivity") withObject:nil waitUntilDone:NO];
        if(actView.superview)
            [actView removeFromSuperview];
        [view addSubview:actView];
    });
}

UIKIT_STATIC_INLINE void showToast(NSString *message) {
    [UIAlertController showToastWithMessage:message];
}

@interface UIViewController (Extension)
- (void)showLoading:(UIColor *)background;
- (void)hideLoading;
@end
