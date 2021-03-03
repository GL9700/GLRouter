//
//  BaseViewController.m
//  ObjCDemo
//
//  Created by liguoliang on 2021/3/1.
//

#import "BaseViewController.h"

@interface BaseViewController () <GLRouterProtocol>

@end

@implementation BaseViewController
- (void)routerParams:(NSDictionary *)params {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass(self.class);
}
@end
