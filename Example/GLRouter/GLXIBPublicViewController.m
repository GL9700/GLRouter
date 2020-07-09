//
//  GLXIBPublicViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/6/8.
//  Copyright © 2020 liandyii@msn.com. All rights reserved.
//

#import "GLXIBPublicViewController.h"

@interface GLXIBPublicViewController () <RouterProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;
@property (nonatomic) NSString *imgURL;
@property (nonatomic) NSString *tipInfo;
@end

@implementation GLXIBPublicViewController

- (instancetype)initWithRouterWithParams:(NSDictionary *)params {
    if((self = [super init])) {
        self.imgURL = params[@"imgURL"];
        self.tipInfo = params[@"tipInfo"];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imgURL]];
    if(self.tipInfo!=nil){
        self.tiplabel.text = self.tipInfo;
        self.tiplabel.hidden = NO;
    }else{
        self.tiplabel.hidden = YES;
    }
}

- (IBAction)onClosePage:(UIButton *)sender {
    if(self.onHandleClose){
        self.onHandleClose();
    }
}
- (IBAction)onRegistButton:(UIButton *)sender {
    if(self.onHandleRegister){
        self.onHandleRegister(self.usernameLabel.text, self.passwordLabel.text);
    }
}
- (IBAction)onLoginButton:(UIButton *)sender {
    if(self.onHandleLogin){
        self.onHandleLogin(self.usernameLabel.text, self.passwordLabel.text);
    }
}

- (void)dealloc {
    NSLog(@"--dealloc--");
}

@end
