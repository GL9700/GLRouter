//
//  ViewController.m
//  ObjCDemo
//
//  Created by liguoliang on 2021/3/1.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *mainTableView;
@property (nonatomic) NSArray<NSArray<NSDictionary *> *> *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.frame = self.view.bounds;
    
    /*
     * if GLRouter happen Error , so by catch in [GLRouterManager failure]
     */
    [GLRouterManager failure:^(NSError *error, NSString *detail) {
        NSLog(@"error:%@, detail:%@", error, detail);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.text = self.datas[indexPath.section][indexPath.row][@"title"];
        cell.detailTextLabel.text = self.datas[indexPath.section][indexPath.row][@"method"];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return @"Push(跳转)";
        case 1:
            return @"Present(弹出)";
        case 2:
            return @"Invoke(调用)";
        default:
            return @"Other(其他)";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = NSSelectorFromString(self.datas[indexPath.section][indexPath.row][@"method"]);
    [self performSelector:sel];
}

/// PUSH
- (void)pushNormal {
    rto_dsp(@"GL://push/PageA", nil);
}
- (void)pushParam1 {
    rto_dsp(@"GL://push/PageA?msg=I have a pen&author=lgl", nil);
}
- (void)pushParam2 {
    rto_dsp(@"GL://push/PageA", ^BOOL(id tgt) {
        [tgt setValue:@"Wow, I'm from ViewController" forKey:@"msg"];   // KVC
        return YES;    // >> This line Detail in pushNeedTrue()
    });
}
    
//    rto_dsp_clv("URL", 拦截器, 使用某个ViewController的Nav作为Container)
- (void)pushFromOtherNav {
    rto_dsp_clv(@"GL://push/PageA", nil, nil);  // nil: current Container
}
    
- (void)pushNeedTrue {
    rto_dsp(@"GL://push/PageA" ,^BOOL(id tgt) {
        NSLog(@"return NO , Cancel current Router Task");
        return NO;    // `NO`: cancel current Router Task  | `YES` : normal to Launch
    });
}


/// PRESENT
- (void)presentNormal {
    rto_dsp(@"GL://present/PageA", nil);
}
- (void)presentFromOtherContainer {
    rto_dsp(@"GL://present/PageA?msg=I have a pen&author=lgl", nil);
}
- (void)presentNeedTrue {
    rto_dsp(@"GL://present/PageA" ,^BOOL(id tgt) {
        NSLog(@"return NO , Cancel current Router Task");
        return NO;    // `NO`: cancel current Router Task  | `YES` : normal to Launch
    });
}

/// INVOKE

- (void)invokeMethod_NoParams {
    rto_ivk(@"GL://invoke/Tools/sendMessage", nil);
}

- (void)invokeMethod_hasParams {
/* normal */
//    rto_ivk(@"GL://invoke/Tools/sendMessage:from:to:?p1=Hello World!&p2=jerry&p3=tom", nil);
    
/* the second params is <nil> */
    rto_ivk(@"GL://invoke/Tools/sendMessage:from:to:?p1=Hello World!&p3=tom", nil);
}

- (void)invokeMethod_hasReturn {
    rto_ivk(@"GL://invoke/Tools/sumA:B:?p1=12&p2=6", ^(id ret) {
        int sum = [ret intValue];
        NSLog(@"结果是->%d", sum);
    });
}



- (UITableView *)mainTableView {
    if(!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (NSArray<NSArray<NSDictionary *> *> *)datas {
    if(!_datas) {
        _datas =
        @[
            @[
                @{@"title":@"普通跳转",@"method":@"pushNormal"},
                @{@"title":@"普通跳转带参方式1",@"method":@"pushParam1"},
                @{@"title":@"普通跳转带参方式2",@"method":@"pushParam2"},
                @{@"title":@"从其他容器跳转",@"method":@"pushFromOtherNav"},
                @{@"title":@"条件跳转",@"method":@"pushNeedTrue"}
            ],
            @[
                @{@"title":@"普通显示",@"method":@"presentNormal"},
                @{@"title":@"从其他容器跳转",@"method":@"presentFromOtherContainer"},
                @{@"title":@"条件跳转",@"method":@"presentNeedTrue"}
            ],
            @[
                @{@"title":@"普通调用",@"method":@"invokeMethod_NoParams"},
                @{@"title":@"含有多参调用及空参调用",@"method":@"invokeMethod_hasParams"},
                @{@"title":@"获取返回值",@"method":@"invokeMethod_hasReturn"}
            ],
            @[
            ]
        ];
    }
    return _datas;
}

@end
