//
//  GLRCoreAppearControl.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import "GLRCoreAppearControl.h"
#import <GLRouter/GLRouterProtocol.h>

@implementation GLRCoreAppearControl


- (UIViewController *)upperViewControllerWithCurrent:(UIViewController *)current {
    UIResponder *responder = current.nextResponder;
    while(![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

// if container!=nil 则从container向上查找，else 从root往下查2级
- (UINavigationController *)matchNavigationFromViewController:(UIViewController *)container {
    if(container) { // up
        if(container.navigationController) {
            return container.navigationController;  // current nav
        }else {
            UIViewController *vcFineder = [self upperViewControllerWithCurrent:container];
            while (vcFineder) {
                if(vcFineder.navigationController){
                    return vcFineder.navigationController;  // upvc nav
                }else{
                    vcFineder = [self upperViewControllerWithCurrent:container];
                }
            }
        }
    }
    else { // down
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        if([root isKindOfClass:[UITabBarController class]]) {
            root = ((UITabBarController *)root).selectedViewController;
        }
        if([root isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)root;  // root navigation
        }
    }
    return nil; // none
}

- (void)pushTargetClass:(Class)cls
             withParams:(NSDictionary *)params
              container:(UIViewController *)container
            inCondition:(BOOL(^)(UIViewController *target))handle {
    if([cls conformsToProtocol:@protocol(GLRouterProtocol)]){
//        UIViewController *vc = [cls new];
        UIViewController *vc = [[cls alloc] initWithNibName:nil bundle:[NSBundle bundleForClass:cls]];
        [vc performSelector:@selector(setupRouterParams:) withObject:params];
        if(handle && handle(vc) == NO) {
            return;
        }
        UINavigationController *nav = [self matchNavigationFromViewController:container];
        if(nav == nil){
            if(self.failureHandle) {
                self.failureHandle(kRTargetNavigationError, nil);
            }
            NSLog(@"-- 未能找到可用的Navigation -- [push %@] --", cls);
        }else{
            [nav pushViewController:vc animated:YES];
        }
    }else{
        if(self.failureHandle) {
            self.failureHandle(kRProtocolError, nil);
        }
    }
}

- (void)presentTargetClass:(Class)cls
                withParams:(NSDictionary *)params
                 container:(UIViewController *)container
               inCondition:(BOOL(^)(UIViewController *target))handle {
    if([cls conformsToProtocol:@protocol(GLRouterProtocol)]){
        UIViewController *vc = [cls new];
        [vc performSelector:@selector(setupRouterParams:) withObject:params];
        if(handle && handle(vc) == NO) {
            return;
        }
        if(container==nil){
            container = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [container presentViewController:vc animated:YES completion:nil];
    }else{
        if(self.failureHandle) {
            self.failureHandle(kRProtocolError, nil);
        }
    }
}


@end
