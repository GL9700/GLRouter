//
//  GLRouterManager.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/10.
//

#import <UIKit/UIKit.h>

@interface GLRouterManager : NSObject
+ (void)setVerifyScheme:(NSString *)scheme;
+ (void)failure:(void(^)(NSError *error, NSString *detail))handle;
@end

@interface GLRouterManager(URLExt)
+ (void)ToRouterURL:(NSString *)url from:(UIViewController *)from conditionHandle:(BOOL(^)(id tgt))conHandle returnHandle:(void(^)(id ret))retHandle;
@end

@interface GLRouterManager(FileExt)
+ (instancetype)managerWithRegisterFile:(NSString *)name withFromBundle:(NSBundle *)bundle;
+ (void)ToRouterKey:(NSString *)key from:(UIViewController *)from conditionHandle:(BOOL(^)(id tgt))conHandle returnHandle:(void(^)(id ret))retHandle;
@end
