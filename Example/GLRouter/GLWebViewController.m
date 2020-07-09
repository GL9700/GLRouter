//
//  GLWebViewController.m
//  GLRouter_Example
//
//  Created by liguoliang on 2020/6/8.
//  Copyright © 2020 liandyii@msn.com. All rights reserved.
//

#import "GLWebViewController.h"
#import <WebKit/WebKit.h>

@interface GLWebViewController ()
@property (nonatomic) WKWebView *webView;
@property (nonatomic) NSString *url;
@end

@implementation GLWebViewController

- (instancetype)initWithRouterWithParams:(NSDictionary *)params {
    if((self = [super init])) {
        self.url = params[@"url"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    return _webView;
}
@end
