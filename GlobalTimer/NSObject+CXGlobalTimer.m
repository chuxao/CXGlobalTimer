//
//  NSObject+CXGlobalTimer.m
//  MarsonryTest
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 chuxiao. All rights reserved.
//

#import "NSObject+CXGlobalTimer.h"
#import "CXGlobalTimerManager.h"
#import "objc/runtime.h"

static const void * CX_GLOBALTIMER_USERINFO = &"k_CX_GLOBALTIMER_USERINFO";

/**
 代理分类
 */
@implementation NSObject (CXGlobalTimer)

- (void)setGlobalTimerDelegate:(id<CXGlobalTimerProtocol>)globalTimerDelegate
{
    if (!globalTimerDelegate && [self.globalTimerDelegate_private conformsToProtocol:@protocol(CXGlobalTimerProtocol)]) [[CXGlobalTimerManager share] removeGlobalTimerDelegate:(id<CXGlobalTimerProtocol>)self];
    else [[CXGlobalTimerManager share] addGlobalTimerDelegate:self delegate:(id<CXGlobalTimerProtocol>)globalTimerDelegate];
    
    self.globalTimerDelegate_private = globalTimerDelegate;
}

- (id<CXGlobalTimerProtocol>)globalTimerDelegate
{
    return self.globalTimerDelegate_private;
}

- (void)setGlobalTimeInterval:(NSTimeInterval)globalTimeInterval
{
    self.globalTimeInterval_private = globalTimeInterval;
}

- (NSTimeInterval)globalTimeInterval
{
    return self.globalTimeInterval_private;
}

- (void)setGlobalTimerRepeat:(BOOL)globalTimeRepeat
{
    self.globalTimerRepeat_private = globalTimeRepeat;
}

- (BOOL)globalTimerRepeat
{
    return self.globalTimerRepeat_private;
}

- (void)setGlobalTimerPause:(BOOL)globalTimerPause
{
    self.globalTimerPause_private = globalTimerPause;
    [[CXGlobalTimerManager share] pauseOrResumeTimer];
}

- (BOOL)isGlobalTimerPause
{
    return self.globalTimerPause_private;
}

- (void)setGlobalTimeUserInfo:(id)globalTimeUserInfo
{
    if (globalTimeUserInfo) objc_setAssociatedObject(self, CX_GLOBALTIMER_USERINFO, globalTimeUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)globalTimeUserInfo
{
    return (NSObject *)objc_getAssociatedObject(self, CX_GLOBALTIMER_USERINFO);
}

@end

