# WDYExtensions

[![CI Status](https://img.shields.io/travis/liandyii@msn.com/WDYExtensions.svg?style=flat)](https://travis-ci.org/liandyii@msn.com/WDYExtensions)
[![Version](https://img.shields.io/cocoapods/v/WDYExtensions.svg?style=flat)](https://cocoapods.org/pods/WDYExtensions)
[![License](https://img.shields.io/cocoapods/l/WDYExtensions.svg?style=flat)](https://cocoapods.org/pods/WDYExtensions)
[![Platform](https://img.shields.io/cocoapods/p/WDYExtensions.svg?style=flat)](https://cocoapods.org/pods/WDYExtensions)

## Introduce
### ---- NSFundation ----
### NSData+Extension

> `- (NSString *)string;` /** 转换成为NSString 编码为 UTF-8 */
>
> `- (NSString *)base64Encode;` /** 从Base64转换成为NSString */

### NSDate+Extension

> `+ (NSDateComponents *)componentsDate1:(NSDate *)d1 withDate2:(NSDate *)d2 unit:(NSCalendarUnit)unit;` /** date1与date2相差几个单位(不分先后) */
>
> `- (NSString *)stringWithFormat:(NSString *)format inLocale:(NSLocale *)locale;`  /** format:默认yyyy-MM-dd HH:mm:ss | locale:默认用户设置语言地区*/


### NSFileManager+Extension

> `+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;`/** 计算文件尺寸 */
>
> `+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;`/** 计算文件夹尺寸 */

### NSObject+Extension

> `dispatch_async_work_ui(WorkBlock , UIBlock)`/** 异步执行 ，主线更新 */
> 
> `- (NSString *)JSONString;`/** 转换内容至JSON格式 */
> 
> `- (NSDictionary *)dictDesc;`/** 以字典模式输出对象(不包含不可转换内容) ; 另见- subDictDesc */
> 
> `- (NSDictionary *)subDictDesc;`/** 如果需要将不可转换Dictionary也进行转换，需要重写此方法 */
> 
> `- (void)setAssociatedObjectRetain:(id)object;`/** [category]设置关联的一个参数对象 (retain) */
> 
> `- (id)associatedObjectRetain;`/** [category]获取关联的一个参数对象 */
> 
> `- (void)setAssociatedObject:(id)object;`/** [category]设置关联的一个类型参数对象 (weak , assign) */
> 
> `- (id)associatedObject;`/** [category]获取关联的一个参数对象weak */

### NSString+Extension

> `SF(str, ...)`/** 快速格式化文字 stringWithFormat: */
> 
> `isEmptyString(NSString *str)`/** 判空 */
> 
> `- (BOOL)stringContainsEmoji;`/** 表情符号的判断 */
> 
> `- (BOOL)isNineKeyBoard;`/** 判断是不是九宫格拼音键盘 */
> 
> `- (BOOL)hasChinese;`/** 包含中文 */
> 
> `- (BOOL)isContain:(NSString *)str;`/** 包含字符 */
> 
> `- (NSString *)trim;`/** 去除所有空格和回车 */
> 
> `- (NSString *)URLEncode;`/** URL 编码 */
> 
> `- (NSString *)URLDecode;`/** URL 解码 */
> 
> `- (NSString *)md5;`/** 使用MD5编码 */
> 
> `- (NSData *)base64Decode;`/** 使用Base64编码 */
> 
> `- (NSString *)stringForRegular:(NSString *)regular;`/** 使用正则 (已定义 kRegexForPhone kRegexForURL kRegexForEmail) */
> 
> `- (NSString *)removeHtmlTag;`/*** 去掉html标签*/
>
> `- (CGSize)boundingRectWithWidth:(float)width Font:(UIFont *)font;`/** 计算字符串size */

### NSTimer+Extension

> `+ (NSTimer *)startWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat withBlock:(void(^)(void))block;`/** 开始计时器 */
>
> `+ (void)stopTime:(NSTimer *)timer;`/** 结束计时器(如果weak则立刻释放) */

### NSURL+Extension

> `- (NSDictionary *)querys;`/** 获取参数部分 */
> 
> `- (NSArray *)ipAdress;`/** 获取网址指向 IP 地址 */

### UIAlertController+Extension 

> `+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg singleButton:(NSString *)btnTitle action:(void > `(^)(NSString *buttonTitle))actblk;`/** 初始化单个按钮的Alert窗 */
> 
> `+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)msg buttonTitles:(NSArray<NSString *> *)btnTitles > `action:(void (^)(NSString *buttonTitle))actblk;`/** 初始化多按钮的Alert窗 */
> 
> `+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)btnTitle > `action:(void(^)(NSString *buttonTitle))actblk;`/** 自动show alert */
> 
> `- (void)showWithTime:(NSUInteger)sec timeup:(void(^)(void))timeup;`/** 多少秒后自动关闭，自动关闭后干什么 */
>
> `- (void)show;`
> `- (void)dismiss;`
> 
> `+ (void)showToastWithMessage:(NSString *)msg;`/** Toast ** 2秒后自动关闭 ** */

### UIApplication+Extension

> `NSString *appName()`/** app显示的名字 */
>
> `NSArray *releaseVersion()`/** app版本 */
>
> `NSArray *buildVersion()`/** build版本 */
>
> `NSString *bundleID()`/** App BundleId */

### UIColor+Extension

> `+ (UIColor *)colorWithHexString:(NSString *)hexString;`/** 使用16进制颜色进行设置 支持 #aaa,#aabb,#aabbcc,#aabbccdd */

### UIDevice+Extension

> `BOOL kXSeries`/** 是否属于iPhone X 系列 */
>
> `+ (NSString *)deviceDetail;`/** 系统详细信息 iphone N,X */
>
> `+ (void)listenNetStatusUseHandler:(void(^)(WDYNetworkStatus netStatus))block;`/** 开始网络监听 */
>
> `+ (WDYNetworkStatus)currentNetStatus;`/** 获取当前网络状态 */
>
> `+ (NSString *)nameStringWithWIFI;`/** 获取当前WIFI的SSID */
>
> `+ (uint64_t)diskByteSizeWithTotal;`/** 获取总空间 */
>
> `+ (uint64_t)diskByteSizeWithFree;`/** 获取可用磁盘空间 */
>
> `+ (uint64_t)memoryByteSizeWithPhysicalTotal;`/** 内存的物理总大小 */
>
> `+ (uint64_t)memoryByteSizeWithAvailableTotal;`/** 系统分配后的可用内存总量 */
>
> `+ (uint64_t)memoryByteSizeWithUsed;`/** 内存已使用大小 */

### UIImage+Extension

> `+ (instancetype)imageNamedWithOriganlMode:(NSString *)imageName;`/** 加载原始图片 */
> 
> `+ (NSData *)compressWithLengthLimit:(NSUInteger)maxLength withOrignImg:(UIImage *)orignImg;`/** 压缩图片 */

### UINavigation+Extension

> `- (void)titleItemContent:(id)content;`/** Title // NSString || UIImage || UIView */
>
> `- (void)leftItemContent:(id)content withspace:(float)space action:(SEL)action;`/** LeftItem from 0 // NSString || UIImage || UIButton || UIVew(NoEvent) */
>
> `- (void)rightItemContent:(id)content withspace:(float)space action:(SEL)action;`/** RightItem from right 0 // UIImage || NSString || UIButton || UIVew(NoEvent) */
>
> `- (void)underLineColor:(UIColor *)color;`/** NavigationBar Under 颜色 */
>
> `- (void)backgroundColor:(UIColor *)color;`/** NavigationBar 背景颜色 */

### UIResponder+Extension

> `- (void)sendEvent:(id)event from:(UIResponder *)from param:(id)param`/** 发送消息给自己的父视图*/

### UIViewController+Extension 

> `hideActivity()`/** 隐藏Activity */
> 
> `showActivity(id vc , UIColor *background)`/** 显示Activity */
>
> `showToast(NSString *message) `/** 显示Toast */
>
> `- (void)showLoading:(UIColor *)background;`/** 显示Loading */
>
> `- (void)hideLoading;`/** 隐藏Loading */

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* platform : `iOS` 
* version : `8+`
* Language : `Objective-C`

## Installation

WDYExtensions is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WDYExtensions'
```

## Author
LiGuoliang
email:ligl@wdcloud.cc, wx:13581529700

## License

WDYExtensions is available under the MIT license. See the LICENSE file for more info.
