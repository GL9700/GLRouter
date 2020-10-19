//
//  GLRouterFileManager.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import <GLRCoreEntry.h>
#import <GLRBase.h>
NS_ASSUME_NONNULL_BEGIN

@interface GLRouterFileManager : GLRBase

+ (instancetype)sharedManager;
- (void)loadRouterFileName:(NSString *)fileName withBundle:(NSBundle *)bundle;
- (GLRCoreEntry *)routerKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
