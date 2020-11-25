//
//  GLRouterURLParser.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <GLRouter/GLRouterURLParser.h>
#import <GLRouter/GLRouterFileManager.h>

@interface GLRouterURLParser ()
@property (nonatomic) GLRCoreEntry *entry;
@end

@implementation GLRouterURLParser

+ (instancetype)sharedParser {
    static dispatch_once_t onceToken;
    static GLRouterURLParser *instance;
    dispatch_once(&onceToken, ^{
        instance = [GLRouterURLParser new];
    });
    return instance;
}

/*
 urlc -> scheme=_ | host=_ | path=abc/def/ghi | query=xxxxxx
 */
- (GLRCoreEntry *)parseURL:(NSString *)url {
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLComponents *urlc = [NSURLComponents componentsWithString:url];
    if ([urlc.path hasPrefix:@"/"]) {
        urlc.path = [urlc.path substringFromIndex:1];
    }
    NSArray *paths = [urlc.path componentsSeparatedByString:@"/"];
    if ([self verifyWithScheme:urlc.scheme]) {
        GLRCoreEntry *entry = [GLRCoreEntry new];
        entry.failureHandle = self.failureHandle;
        entry.className = paths[0];
        entry.container = nil;
        entry.params = [self paramsFromQuerys:urlc.queryItems];
        if ([[urlc.host lowercaseString] isEqualToString:@"push"]) {
            entry.entryMode = RouterEntryPush;
        }
        else if ([[urlc.host lowercaseString] isEqualToString:@"present"]) {
            entry.entryMode = RouterEntryPresent;
        }
        else if ([[urlc.host lowercaseString] isEqualToString:@"key"]) {
            return [[GLRouterFileManager sharedManager] routerKey:entry.className];
        }
        else if ([[urlc.host lowercaseString] isEqualToString:@"invoke"]) {
            if (paths.count <= 1) {
                self.failureHandle == nil ? : self.failureHandle(kRouterErrorWith(RouterErrorUnabilableURL, @"URL not conform to [GLRouter URL Rule]"), url);

                return nil;
            }
            entry.entryMode = RouterEntryInvoke;
            entry.invokeMethodName = paths[1];
        }
        else {
            self.failureHandle == nil ? : self.failureHandle(kRouterErrorWith(RouterErrorUnabilableURL, @"URL not conform to [GLRouter URL Rule]"), url);

            return nil;
        }
        entry.handleCondition = nil;
        entry.handleReturn = nil;
        return entry;
    }
    return nil;
}

- (NSDictionary *)paramsFromQuerys:(NSArray<NSURLQueryItem *> *)querys {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < querys.count; i++) {
        NSString *key = querys[i].name;
        NSString *value = [querys[i].value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        dict[key] = value;
    }
    return [dict copy];
}

/// 验证Scheme
- (BOOL)verifyWithScheme:(NSString *)scheme {
    if ([scheme isEqualToString:self.scheme] || self.scheme == nil) {
        return YES;
    }
    self.failureHandle == nil ? NSLog(@"## [GLRouter] ## Has Error !! More info at [GLRouterManager failure:]") : self.failureHandle(kRouterErrorWith(RouterErrorInvalidScheme, @"Invalid Scheme"), scheme);

    return NO;
}

@end
