//
//  GLRouterEntry.m
//  GLRouter
//
//  Created by liguoliang on 2020/10/13.
//

#import <GLRouter/GLRCoreEntry.h>
#import <GLRouter/GLRCoreAppearControl.h>
#import <GLRouter/GLRCoreInvokeControl.h>

@interface GLRCoreEntry ()
@property (nonatomic) GLRCoreAppearControl *appearControl;
@property (nonatomic) GLRCoreInvokeControl *invokeControl;
@end

@implementation GLRCoreEntry
- (void)enter {
    Class classRef = NSClassFromString(self.className);
    if  (classRef == nil) {
        // 可能是由于Swift的原因
        NSString *work = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
        NSString *swiftClassName = [NSString stringWithFormat:@"%@.%@", work, self.className];
        self.className = swiftClassName;
        classRef = NSClassFromString(self.className);
    }
    if (classRef == nil) {
        self.failureHandle == nil ? NSLog(@"## [GLRouter] ## Has Error !! More info at [GLRouterManager failure:]") : self.failureHandle(kRouterErrorWith(RouterErrorNotFoundTarget, @"Target Class Not Found"), self.className);
    }
    else {
        switch (self.entryMode) {
            case RouterEntryPush:
                [self.appearControl pushTargetClass:classRef
                                         withParams:self.params
                                          container:self.container
                                        inCondition:self.handleCondition];
                break;
            case RouterEntryPresent:
                [self.appearControl presentTargetClass:classRef
                                            withParams:self.params
                                             container:self.container
                                           inCondition:self.handleCondition];
                break;
            case RouterEntryInvoke:
                [self.invokeControl
                 invokeMethodFromSelector:NSSelectorFromString(self.invokeMethodName)
                                  inClass:classRef
                               withParams:self.params
                                      ret:self.handleReturn];
                break;
        }
    }
}

- (GLRCoreAppearControl *)appearControl {
    if (!_appearControl) {
        _appearControl = [GLRCoreAppearControl new];
    }
    _appearControl.failureHandle = self.failureHandle;
    return _appearControl;
}

- (GLRCoreInvokeControl *)invokeControl {
    if (!_invokeControl) {
        _invokeControl = [GLRCoreInvokeControl new];
    }
    _invokeControl.failureHandle = self.failureHandle;
    return _invokeControl;
}

@end
