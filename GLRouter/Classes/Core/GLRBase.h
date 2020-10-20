//
//  GLRBase.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/16.
//

#import <Foundation/Foundation.h>
#import <GLRouter/GLRouterErrorList.h>
@interface GLRBase : NSObject
@property (nonatomic) void(^failureHandle)(NSError *error, NSString *detail);
@end
