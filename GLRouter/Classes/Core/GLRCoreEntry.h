//
//  GLRCoreEntry.h
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <UIKit/UIKit.h>
#import <GLRBase.h>

typedef enum : NSUInteger {
    RouterEntryPush,
    RouterEntryPresent,
    RouterEntryInvoke
} RouterEntryMode;

@interface GLRCoreEntry : GLRBase
@property (nonatomic) RouterEntryMode entryMode;
@property (nonatomic) NSString *className;
@property (nonatomic) NSString *invokeMethodName;
@property (nonatomic) UIViewController *container;
@property (nonatomic) NSDictionary *params;
@property (nonatomic) BOOL (^handleCondition)(id target);
@property (nonatomic) void (^handleReturn)(id ret);
- (void)enter;
@end
