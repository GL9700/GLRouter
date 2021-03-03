//
//  PageA.m
//  ObjCDemo
//
//  Created by liguoliang on 2021/3/3.
//

#import "PageA.h"

@interface PageA ()
{
    NSString *_msg;
}
@property (nonatomic) UILabel *label;
@end

@implementation PageA

- (void)routerParams:(NSDictionary *)params {
    if(params.allKeys.count>0){
        _msg = params[@"msg"];
        NSLog(@"%@", params);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_msg) {
        self.label.text = _msg;
    }
    [self.label sizeToFit];
    self.label.center = self.view.center;
}

- (UILabel *)label {
    if(!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = @"Hello world!";
        _label.font = [UIFont systemFontOfSize:22];
        _label.textColor = [UIColor brownColor];
        [self.view addSubview:_label];
    }
    return _label;
}
@end
