//
//  GLRouter.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

/** :
## 简要使用说明

#### 快速使用
    * 极简方案
        可直接在需要使用路由的地方调用`rto_dsp()`,`rto_ivk()`,`rto_dsp_clv()`然后传入对应参数即可
        传入的内容可参考`#调用`
 
#### 详细使用
    * 普通URL方案
        在所有路由方法前,率先定义用于过滤和验证`scheme`的关键字;
        就好像在`极简方案`中,可以不定义该项,那么将表示不进行相应验证,只要符合规范,则直接调用;
        例如:只允许使用`abc`为`scheme`的`URL`通过路由,则进行`[GLRouterManager setVerifyScheme:@"abc"]`的定义

    * 普通注册表(路由表)方案
        在所有路由方法前,给路由注册路由表文件;只需传入文件名即可,如使用plist后缀,则可省略后缀,暂不支持无后缀文件;
        例1:`[GLRouterManager managerWithRegisterFile:@"route"];`,需要`router.plist`文件存在于`mainBundle`中
        例2:`[GLRouterManager managerWithRegisterFile:@"xyz.abc"];`,需要`xyz.abc`文件存在于`mainBundle`中

#### 调用
    * rto_ivk(str, handle)
        - str : 符合路由规范的URL 或 已存在路由表中的Key, 可参考`#路由URL规范`
        - handle : 调用方法结束后的block包含返回值
 
    * rto_dsp(str, (BOOL)handle)
        - str : 符合路由规范的URL 或 已存在路由表中的Key, 可参考`#路由URL规范`
        - handle ->BOOL : 调用方法前,可再一次确定是否继续执行当前操作;返回`YES`或`不定义`则为继续
 
    * rto_dsp_clv(str, (BOOL)handle)
        - str : 符合路由规范的URL 或 已存在路由表中的Key, 可参考`#路由URL规范`
        - handle ->BOOL : 调用方法前,可再一次确定是否继续执行当前操作;返回`YES`或`不定义`则为继续

#### 处理意外
    在使用过程中,由于很多内容都采用硬编码模式,所以难免出现单词输入错误等问题;
    基于此增加了相应的错误回调方法,示例如下：
    ```
        [GLRouterManager failure:^(NSError *error, NSString *detail) {
            NSLog(@"%@ - %@", error, detail);
        }];
    ```

#### 路由URL规则
    * 用于呈现页面:
        `SCHEME://[push|present]/CLASS_NAME?P1=VA&P2=VB&P3=VC`
        `SCHEME` : 校验用字符串
        `[push|present]` : 必写项，选其一
        `CLASS_NAME` : 要呈现的目标类名，多为xxxViewController
        `P1=VA&P2=VB&P3=VC` : 参数部分，可在目标类的路由协议方法中实现对应key进行接收

    * 用于方法调用:
        `SCHEME://invoke/CLASS_NAME/FUNC_NAME?P1=VA&P2=VB&P3=VC`
        `SCHEME` : 校验用字符串
        `invoke` : 必写项
        `CLASS_NAME` : 目标类名
        `FUNC_NAME` : 目标方法名(必须且只能是类方法)
        `P1=VA&P2=VB&P3=VC` : 参数部分, 按照顺序填入, key中必须含有数字序列，如果某个参数为空，可跳过该key的数字

#### 路由表关键字
        Root|
            |- KEY_1
            |   |- mode 类型，可用值 : push | present | invoke
            |   |- target 目标类名
            |   |- method 目标方法名(必须且只能是类方法)
            |   |- K1 参数
            |   |- K2 参数
            |   |- ....
            |
            |- KEY_2
            |   |- mode
            |   |- ....
 */


#import <GLRouterManager.h>
#import <GLRouterProtocol.h>
#import <UIViewController+RExt.h>

static void __rto(NSString *str , BOOL(^ch)(id tgt) , void(^rh)(id ret), UIViewController *from) {
    NSURL *u = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(u && u.scheme) {
        [GLRouterManager ToRouterURL:str from:from conditionHandle:ch returnHandle:rh];
    }else{
        [GLRouterManager ToRouterKey:str from:from conditionHandle:ch returnHandle:rh];
    }
}

/** 通过路由进行页面的 [push | present] 跳转; handle:跳转前的条件判断 */
static void rto_dsp(NSString *str, BOOL(^handle)(id tgt)) {
    __rto(str, handle, NULL, NULL);
}

/** 通过路由进行页面的 [push | present] 跳转; handle:跳转前的条件判断; from:容器层级*/
static void rto_dsp_clv(NSString *str, BOOL(^handle)(id tgt), UIViewController *from) {
    __rto(str, handle, NULL, from);
}

/** 通过路由进行方法的调用 [invoke]; handle:方法返回值 */
static void rto_ivk(NSString *str, void(^handle)(id ret)) {
    __rto(str, NULL, handle, NULL);
}
