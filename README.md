![logo](https://gl9700.gitee.io/assets/images/logo800.png)
# GLRouter

[![Version](https://img.shields.io/cocoapods/v/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![License](https://img.shields.io/cocoapods/l/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)
[![Platform](https://img.shields.io/cocoapods/p/GLRouter.svg?style=flat)](https://cocoapods.org/pods/GLRouter)

## 快速开始
### 基本概念
1. Router支持，三种路由方式
    * `push` 页面跳转
    * `present` 页面弹出
    * `invoke` 方法调用
2. 目标如果需要被展示(`push`,`present`)，则需要实现<GLRouterProtocol>中的相应内容。
3. 目标如果需要被调用(`invoke`)，则调用的目标方法必须是`类方法`。

### 使用(页面跳转)
1. 在跳转目标`TargetViewController`中引入接口`<GLRouterProtocol>`，并实现相应的指定方法
2. 使用如下代码
    ```objc
    /*
    * C函数，无需类名，直接调用
    * rto_dsp(NSString *str, BOOL (^handle)(id tgt))
    */

    // 从当前页面跳转至TargetViewController
    rto_dsp(@"SCHEME://push/TargetViewController", nil);

    // 在当前页面弹出TargetViewController
    rto_dsp(@"SCHEME://present/TargetViewController", nil);
    ```
### 使用(方法调用)
1. 确认在目标Class存在该函数，例如
    ```objc
    // <Tools.h>
    @interface Tools : NSObject
    @end

    // <Tools.m>
    @implementation Tools
    - (BOOL)sendMessage:(NSString *)msg from:(NSString *)from to:(NSString *)to {
        BOOL success = (msg!=nil && from!=nil && to!=nil);
        if(success){
            NSLog(@"%@ 给 %@ 发送了消息: %@", from, to, msg);
        }else{
            NSLog(@"发送失败");
        }
        return success;
    }
    @end
    ```
2. 使用如下代码进行调用
    ```objc
    /*
    * C函数，无需类名，直接调用
    * rto_ivk(NSString *str, void (^handle)(id ret))
    */

    // 无返回值
    rto_ivk(@"SCHEME://invoke/Tools/sendMessage:from:to:?p1=Hello World&p2=Tom&p3=Jerry", nil); // output “Tom 给 Jerry 发送了消息: Hello World”

    // 有返回值
    rto_ivk(@"SCHEME://invoke/Tools/sendMessage:from:to:?p1=Hello World&p2=Tom&p3=Jerry", ^(id ret){
        // ret 为返回值
        BOOL result = [ret BoolValue];
    }); // output “Tom 给 Jerry 发送了消息: Hello World”

    ```

## RouterURL的构成
<img src="https://gl9700.gitee.io/assets/images/router_url_info.jpg" width="600px">

## 安装

GLRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod 'GLRouter'
```

## 题外 

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
## History
* 2.1.1
    * 优化了路由参数传递`url`时参数可能被截断。如传递`url`,请将其置为最后一个路由参数。
        例如：
        ```
        rto_dsp(@"App://push/MyWebViewController?title=标题&url=http://www.home.com/page.html?a=1&b=2&c=3&d=4", nil);
        ```
* 2.1.0
    * 增加了便捷初始化方案: rto_init_tab( scheme, routingTableName, routingTableBundle )


## Author

LiGuoliang 36617161@qq.com

## License

GLRouter is available under the MIT license. See the LICENSE file for more info.
