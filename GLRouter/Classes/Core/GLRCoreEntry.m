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
    if (NSClassFromString(self.className) == nil) {
        self.failureHandle == nil ? NSLog(@"## [GLRouter] ## Has Error !! More info at [GLRouterManager failure:]") : self.failureHandle(kRouterErrorWith(RouterErrorNotFoundTarget, @"Target Class Not Found"), self.className);
    }
    else {
        switch (self.entryMode) {
            case RouterEntryPush:
                [self.appearControl pushTargetClass:NSClassFromString(self.className)
                                         withParams:self.params
                                          container:self.container
                                        inCondition:self.handleCondition];
                break;
            case RouterEntryPresent:
                [self.appearControl presentTargetClass:NSClassFromString(self.className)
                                            withParams:self.params
                                             container:self.container
                                           inCondition:self.handleCondition];
                break;
            case RouterEntryInvoke:
                [self.invokeControl
                 invokeMethodFromSelector:NSSelectorFromString(self.invokeMethodName)
                                  inClass:NSClassFromString(self.className)
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
