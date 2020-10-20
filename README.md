# GLRouter

[![CI Status](https://img.shields.io/travis/liandyii@msn.com/GLRouter.svg?style=flat)](https://travis-ci.org/liandyii@msn.com/GLRouter)
[![Version](https://img.shields.io/cocoapods/v/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![License](https://img.shields.io/cocoapods/l/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![Platform](https://img.shields.io/cocoapods/p/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)

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

LiGuoliang 36617161@qq.com

## License

GLRouter is available under the MIT license. See the LICENSE file for more info.
