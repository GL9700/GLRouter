//
//  GLFirstViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2018/11/8.
//  Copyright © 2018 liandyii@msn.com. All rights reserved.
//

#import "GLFirstViewController.h"
#import <Router.h>
#import <NSObject+Extension.h>

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
    [Router openURL:@"GLRT://push/GLPublicViewController?content=this Is Push&message=back" form:nil before:^(id targetController) {
        [targetController setValue:[UIImage imageNamed:@"a.jpg"] forKey:@"icon"];
        @weak(targetController);
        [targetController setValue:^{
            @strong(targetController);
            [((UIViewController *)targetController).navigationController popViewControllerAnimated:YES];
        } forKey:@"handle"];
    } after:nil];
}

- (IBAction)onPresent:(UIButton *)sender {
    [Router openURL:@"GLRT://present/GLPublicViewController?content=Present这是一个图片&message=消失" form:self before:^(id targetController) {
        [targetController setValue:[UIImage imageNamed:@"b.jpg"] forKey:@"icon"];
        [targetController setValue:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } forKey:@"handle"];
    } after:nil];
}

- (IBAction)onInvoke:(UIButton *)sender {
    [Router openURL:@"GLRT://invoke/GLTimeShow?method=toastTime" form:nil before:nil after:nil];
}

- (IBAction)onInvokeMessage:(UIButton *)sender {
    [Router openURL:@"GLRT://invoke/GLTimeShow?method=toastMessage:&msg=从前有座山⛰️，山里有个庙，庙里有个👨‍🦲" form:nil before:nil after:nil];
}

- (IBAction)onInvokeCount:(UIButton *)sender {
    [Router openURL:@"GLRT://invoke/GLTimeShow?method=toastCountA:B:C:&a=3&b=5&c=7" form:nil before:nil after:^(id ret) {
        aswer.text = [NSString stringWithFormat:@"%@" , ret];
    }];
}

@end
