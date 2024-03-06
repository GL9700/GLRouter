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

/// 对参数进行解析，并准备进行传递
///  - url : 原始路由地址+参数
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
		entry.params = [self paramsFromQuerys:urlc.queryItems withQueryStr:urlc.query];
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


/// 参数传递前的准备
///  - 如果遇到`key = "url"`并且`value = 以"http"开头或"https"开头`，则返回。url路由参数，应该是末尾参
- (NSDictionary *)paramsFromQuerys:(NSArray<NSURLQueryItem *> *)querys withQueryStr:(NSString *)queryStr {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	BOOL hasURL = NO;
    for (int i = 0; i < querys.count; i++) {
        NSString *key = querys[i].name;
        NSString *value = [querys[i].value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		if([key isEqualToString:@"url"] && [value hasPrefix:@"http"]) {
			hasURL = YES;
			break;
		}
        dict[key] = value;
    }
	if(hasURL) {
		NSRange range = [queryStr rangeOfString:@"&url="];
		if(range.location == NSNotFound) {
			range = [queryStr rangeOfString:@"?url="];
		}
		if(range.location != NSNotFound){
			NSString *urlStr = [queryStr substringFromIndex:range.location+range.length];
			dict[@"url"] = urlStr;
		}
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
