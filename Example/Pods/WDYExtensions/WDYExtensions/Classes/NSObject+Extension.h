//
//  NSObject+Extension.h
//  WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//  Copyright © 2018年 liguoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define weak(o)      autoreleasepool{} __weak typeof(o) o##Weak = o;
#define strong(o)    autoreleasepool{} __strong typeof(o) o = o##Weak;

/** 异步执行 ，主线更新 */
UIKIT_STATIC_INLINE void dispatch_async_work_ui(dispatch_block_t workblock , dispatch_block_t uiblock) {
    if(workblock){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            workblock();
            if(uiblock){
                dispatch_async(dispatch_get_main_queue() , uiblock);
            }
        });
    }else if(uiblock){
        dispatch_async(dispatch_get_main_queue() , uiblock);
    }
}

@interface NSObject (Extension)

/** 转换内容至JSON格式 */
- (NSString *)JSONString;

/** 以字典模式输出对象(不包含不可转换内容) ; 另见- subDictDesc */
- (NSDictionary *)dictDesc;

/** 如果需要跟随持有者转换Dictionary，需要重写此方法 */
- (NSDictionary *)subDictDesc;


/** 设置关联的一个参数对象 (retain) */
- (void)setAssociatedObjectRetain:(id)object;

/** 获取关联的一个参数对象 */
- (id)associatedObjectRetain;

/** 设置关联的一个类型参数对象 (weak , assign) */
- (void)setAssociatedObject:(id)object;

/** 获取关联的一个参数对象weak */
- (id)associatedObject;


@end
