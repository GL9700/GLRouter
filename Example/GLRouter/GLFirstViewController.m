//
//  GLFirstViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLFirstViewController.h"
#import <NSObject+Extension.h>
#import <UIAlertController+Extension.h>

@interface GLFirstViewController ()
{
    
    __weak IBOutlet UILabel *aswer;
}
@end

@implementation GLFirstViewController

- (instancetype)init {
    if((self = [super init])) {
        self.tabBarItem.title = [NSString stringWithFormat:@"First"];
        self.tabBarItem.image = [UIImage imageNamed:@"item1"];
        self.tabBarItem.image = [[UIImage alloc]initWithCIImage:[[CIImage alloc]initWithImage:[UIImage imageNamed:@"item1"]] scale:15 orientation:UIImageOrientationUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NavigationForFirst";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)onPush:(UIButton *)sender {
    NSLog(@"willPush----%@", self);
    [RouterCore openURL:@"GLRT://push/GLPublicViewController?content=this Is Push&message=back" form:self before:^(id targetController) {
        NSLog(@"before----%@", targetController);
        [targetController setValue:[UIImage imageNamed:@"a.jpg"] forKey:@"icon"];
        @weak(targetController);
        [targetController setValue:^{
            @strong(targetController);
            [((UIViewController *)targetController).navigationController popViewControllerAnimated:YES];
        } forKey:@"handle"];
        return YES;
    } after:^(id ret) {
        NSLog(@"after----%@", ret);
    }];
}

- (IBAction)onPushXIB:(UIButton *)sender {
//    NSString *url = @"GLRT://push/GLXIBPublicViewController?tipInfo=你好，你需要登录&imgURL=https://www.baidu.com/img/flexible/logo/pc/result@2.png";
    
    NSString *url = @"GLRT://push/GLXIBPublicViewController?tipInfo=你好，你需要登录&imgURL=https://oimagec6.ydstatic.com/image?id=-7352554208008629997&product=adpublish&w=520&h=347";
    [RouterCore openURL:url form:self before:^BOOL(id targetController) {
        @weak(targetController)
        [targetController setValue:^{
            @strong(targetController)
            [((UIViewController *)targetController).navigationController popViewControllerAnimated:YES];
        } forKey:@"onHandleClose"];
        [targetController setValue:^(NSString *username, NSString *password){
            [UIAlertController showToastWithMessage:[NSString stringWithFormat:@"register\nname:%@, password:%@", username, password]];
        } forKey:@"onHandleRegister"];
        [targetController setValue:^(NSString *username, NSString *password){
            [UIAlertController showToastWithMessage:[NSString stringWithFormat:@"logint\nname:%@, password:%@", username, password]];
        } forKey:@"onHandleLogin"];
        return YES;
    } after:nil];
}


- (IBAction)onPresent:(UIButton *)sender {
    [RouterCore openURL:@"GLRT://present/GLPublicViewController?content=Present这是一个图片&message=消失" form:self before:^(id targetController) {
        UIViewController *tc = (UIViewController *)targetController;
        [tc setValue:[UIImage imageNamed:@"b.jpg"] forKey:@"icon"];
        [tc setValue:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } forKey:@"handle"];
        tc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        return YES;
    } after:nil];
}

- (IBAction)onInvoke:(UIButton *)sender {
//    [Router openURL:@"GLRT://invoke/GLFuncTools?method=toastTime" form:nil before:nil after:nil];
    
    [RouterCore openURL:@"GLRT://invoke/GLFuncTools?method=whatistheTime" form:nil before:nil after:^(id ret) {
        NSLog(@"ret:%@", ret);
        [UIAlertController showToastWithMessage:[NSString stringWithFormat:@"%@" , ret]];
    }];
}

- (IBAction)onInvokeMessage:(UIButton *)sender {
    [RouterCore openURL:@"GLRT://invoke/GLFuncTools?method=toastMessage:&msg=从前有座⛰️，山里有个🏠，🏠里有个👨‍🦲" form:nil before:nil after:nil];
}

- (IBAction)onInvokeCount:(UIButton *)sender {
    [RouterCore openURL:@"GLRT://invoke/GLFuncTools?method=toastCountA:B:C:&a=3&b=5&c=7" form:nil before:nil after:^(id ret) {
        aswer.text = [NSString stringWithFormat:@"%@" , ret];
    }];
}

- (IBAction)onPushWeb:(UIButton *)sender {
    [RouterCore openURL:@"GLRT://push/GLWebViewController?url=http://www.jianshu.com" form:self before:nil after:nil];
}

@end
