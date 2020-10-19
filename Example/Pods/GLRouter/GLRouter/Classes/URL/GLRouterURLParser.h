//
//  GLRouterURLParser.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import <GLRCoreEntry.h>
#import <GLRBase.h>

@interface GLRouterURLParser : GLRBase
@property (nonatomic) NSString *scheme;
+ (instancetype)sharedParser;
- (GLRCoreEntry *)parseURL:(NSString *)url;
@end
