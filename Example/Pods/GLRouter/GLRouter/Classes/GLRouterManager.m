//
//  GLRouterManager.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import "GLRouterManager.h"
#import <GLRouterURLParser.h>
#import <GLRouterFileManager.h>

@interface GLRouterManager()
@property (nonatomic) void(^failureHandle)(NSError *error, NSString *detail);
@end

@implementation GLRouterManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static GLRouterManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [GLRouterManager new];
        if([GLRouterURLParser sharedParser].scheme==nil){
            [GLRouterURLParser sharedParser].scheme = [self getScheme];
        }
    });
    return instance;
}
+ (NSString *)getScheme {
    NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (NSDictionary *obj in urlTypes) {
        if([obj[@"CFBundleURLName"] isEqualToString:@"GLRouter"]) {
            return ((NSArray *)obj[@"CFBundleURLSchemes"]).firstObject;
        }
    }
    return nil;
}

+ (void)setVerifyScheme:(NSString *)scheme {
    [GLRouterURLParser sharedParser].scheme = scheme;
}

+ (void)failure:(void(^)(NSError *error, NSString *detail))handle {
    [GLRouterManager manager].failureHandle = handle;
}
@end

@implementation GLRouterManager(URLExt)
+ (void)ToRouterURL:(NSString *)url from:(UIViewController *)from conditionHandle:(BOOL(^)(id tgt))conHandle returnHandle:(void(^)(id ret))retHandle {
    GLRouterURLParser *parser = [GLRouterURLParser sharedParser];
    parser.failureHandle = [GLRouterManager manager].failureHandle;
    GLRCoreEntry *entry = [parser parseURL:url];
    entry.container = from;
    entry.handleCondition = conHandle;
    entry.handleReturn = retHandle;
    [entry enter];
}
@end

@implementation GLRouterManager(FileExt)
+ (instancetype)managerWithRegisterFile:(NSString *)name {
    GLRouterManager *manager = [self manager];
    [manager registerRouter:name];
    return manager;
}

- (void)registerRouter:(NSString *)routerFile {
    [[GLRouterFileManager sharedManager] loadRouterFileName:routerFile];
}

+ (void)ToRouterKey:(NSString *)key from:(UIViewController *)from conditionHandle:(BOOL(^)(id tgt))conHandle returnHandle:(void(^)(id ret))retHandle {
    GLRCoreEntry *entry = [[GLRouterFileManager sharedManager] routerKey:key];
    entry.failureHandle = [GLRouterManager manager].failureHandle;
    entry.container = from;
    entry.handleCondition = conHandle;
    entry.handleReturn = retHandle;
    [entry enter];
}
@end
