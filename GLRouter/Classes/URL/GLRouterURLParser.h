//
//  GLRouterURLParser.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import <GLRouter/GLRCoreEntry.h>
#import <GLRouter/GLRBase.h>

/**
 * 支持
 * scheme://key/xxxxx
 * scheme://push/target?xx=yy
 * scheme://present/target?xx=yy
 * scheme://invoke/target?xx=yy
 */

@interface GLRouterURLParser : GLRBase
@property (nonatomic) NSString *scheme;
+ (instancetype)sharedParser;
- (GLRCoreEntry *)parseURL:(NSString *)url;
@end
