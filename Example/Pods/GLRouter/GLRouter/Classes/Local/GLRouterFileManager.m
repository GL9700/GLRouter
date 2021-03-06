//
//  GLRouterFileManager.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import "GLRouterFileManager.h"

@interface GLRouterFileManager()
@property (nonatomic) NSMutableDictionary<NSString *, NSDictionary *> *rlist;
@end

@implementation GLRouterFileManager
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static GLRouterFileManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [GLRouterFileManager new];
    });
    return instance;
}

- (void)loadRouterFileName:(NSString *)fileName {
    NSString *name = fileName.lastPathComponent.stringByDeletingPathExtension;
    NSString *ext = fileName.lastPathComponent.pathExtension;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType: ext.length==0 ? @"plist" : ext ];
    [self.rlist addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    if(self.rlist.allKeys.count==0 && self.failureHandle){
        self.failureHandle(kRRPListError, path);
    }
}

- (GLRCoreEntry *)routerKey:(NSString *)key {
    if([self.rlist.allKeys containsObject:key]){
        NSMutableDictionary *item = [self.rlist[key] mutableCopy];
        GLRCoreEntry *entry = [[GLRCoreEntry alloc] init];
        entry.className = item[@"target"];
        if([[item[@"mode"] lowercaseString] isEqualToString:@"invoke"]) {
            entry.entryMode = RouterEntryInvoke;
            entry.invokeMethodName = item[@"method"];
        }
        else if([[item[@"mode"] lowercaseString] isEqualToString:@"push"]) {
            entry.entryMode = RouterEntryPush;
        }
        else if([[item[@"mode"] lowercaseString] isEqualToString:@"present"]) {
            entry.entryMode = RouterEntryPresent;
        }
        
        item[@"target"] = nil;
        item[@"method"] = nil;
        item[@"mode"] = nil;
        entry.container = nil;
        entry.params = [item copy];
        entry.handleCondition = nil;
        entry.handleReturn = nil;
        return entry;
    }
    return nil;
}

- (NSMutableDictionary<NSString *,NSDictionary *> *)rlist {
    if(!_rlist) {
        _rlist = [NSMutableDictionary dictionary];
    }
    return _rlist;
}
@end
