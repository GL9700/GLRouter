//
//  UITableView+Extension.h
//  Pods-WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)

/** 绑定数据 (!暂未完成，部分可用，具体问我) */
- (void)bindingArrayDatasource:(NSObject *)data withEmptyView:(UIView *)emptyView;

@end
