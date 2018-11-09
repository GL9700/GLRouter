//
//  UITableView+Extension.m
//  Pods-WCExtensions_Example
//
//  Created by liguoliang on 2018/9/6.
//

#import "UITableView+Extension.h"
#import <objc/message.h>

typedef void (* VoidIMP) (id , SEL , ...);

@interface UITableView (Extension)
@property (nonatomic , strong) UIView *emptyView;
@property (nonatomic , strong) NSObject *data;
@end

@implementation UITableView (Extension)

- (void)setEmptyView:(UIView *)emptyView {
    objc_setAssociatedObject(self, @selector(emptyView), emptyView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setData:(NSObject *)data {
    objc_setAssociatedObject(self, @selector(data), data, OBJC_ASSOCIATION_RETAIN);
}
- (NSObject *)data {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)bindingArrayDatasource:(NSObject *)data withEmptyView:(UIView *)emptyView {
    self.data = data;
    if(emptyView && [data mutableArrayValueForKey:@"array"].count==0) {
        self.emptyView = emptyView;
        self.backgroundView = [[UIView alloc]init];
        [self.backgroundView addSubview:self.emptyView];
        self.emptyView.center = self.backgroundView.center;
    }
    [self.data addObserver:self forKeyPath:@"array" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"array"]) {
        if(self.emptyView && [object mutableArrayValueForKey:keyPath].count==0){
            self.backgroundView = self.emptyView;
        }else{
            self.backgroundView = nil;
        }
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    if(self.tableFooterView==nil)
        self.tableFooterView = [UIView new];
    uint count;
    Method *ms = class_copyMethodList(self.class, &count);
    while (count>0) {
        if(method_getName(ms[count]) == @selector(setDataSource:)){
            VoidIMP p = (VoidIMP)method_getImplementation(ms[count]);
            count = 0;
            p(self , @selector(setDataSource:) , dataSource);
        }else
            count--;
    }
}

- (void)dealloc {
    [self.data removeObserver:self forKeyPath:@"array"];
}

@end
