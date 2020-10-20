//
//  WebViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/10/20.
//  Copyright © 2020 liandyii@msn.com. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (nonatomic) NSString *url;
@property (nonatomic) WKWebView *webView;
@end

@implementation WebViewController

- (void)routerParams:(NSDictionary *)params {
    self.url = params[@"url"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [WKWebView new];
    self.webView.frame = self.view.bounds;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:self.webView];
}
@end
