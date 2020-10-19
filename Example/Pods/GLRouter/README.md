# GLRouter

[![CI Status](https://img.shields.io/travis/liandyii@msn.com/GLRouter.svg?style=flat)](https://travis-ci.org/liandyii@msn.com/GLRouter)
[![Version](https://img.shields.io/cocoapods/v/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![License](https://img.shields.io/cocoapods/l/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![Platform](https://img.shields.io/cocoapods/p/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)

### 使用
* 首先
    > 在 info.plist 中注册路由Scheme（添加URL Schemes）
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>router</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string><!--HERE SCHEME NAME--></string>
            </array>
        </dict>
    </array>
    </plist>
    ```
* 基本使用
    ```objc
    /*
    * RS : Router Scheme
    * RT : Router Type [ push | present | invoke ]
    * TGT: Method name (Only in invoke Type)
    *
    */
    [RouterCore openURL:@"RS://RT/TGT?[k=v&k=v]";
    ```

* push或present至ViewController
    ```objc
    // - 使用before方便传入非明文参数例如 image data date 等
    [Router openURL:@"RS://present/vc?name=liguoliang&password=guoliang" before:BOOL(UIViewController *target){...}];
    [Router openURL:@"RS://push/vc?name=liguoliang&password=guoliang" before:BOOL(UIViewController *target){...}];
    ```

* invoke 方法
    ```objc
    // - 允许方法名写在path中
    // - 允许需求参数多于传入参数，取默认值(nil 或 0)
    // - 允许需求参数少于传入参数, 抛弃多传进来的参数
    // - 返回值采用after回调来拿
    [Router openURL:@"RS://invoke/ViewController/saymsg1:msg2:?p1=arg1&p2=arg2" after:void(id Return){...}];
    [Router openURL:@"RS://invoke/ViewController?method=sayMsg1:msg2:&p=arg" after:void(id Return){...}];
    [Router openURL:@"RS://invoke/ViewController?method=sayMessage&msg=ThisContentMessage" after:void(id Return){...}];
    ```

### 题外 
目前市面上外部跳转入进app的方案，方式大致分为两种：
* schema (iOS all)
    ```
    例如：weixin://dl/scan
    优势：调用简单
    劣势：部分浏览器无法跳入，例如微信中的网页浏览；无法通过JS判断app是否启动
    ```
* Universal Link (iOS9+)
    ```
    必须：iOS开发时配置一个与app相关联的域名
    ```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GLRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GLRouter'
```

## Author

36617161@qq.com

## License

GLRouter is available under the MIT license. See the LICENSE file for more info.
