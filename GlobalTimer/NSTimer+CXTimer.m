//
//  NSTimer+CXTimer.m
//  Vova
//
//  Created by chuxiao on 2018/8/2.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "NSTimer+CXTimer.h"

@interface CXTimerTarget : NSObject

@property (nonatomic,weak) id sourceTarget;
@property (nonatomic,copy) void(^actionBlock)(NSTimer *timer);
@property (nonatomic, assign) SEL actionSelector;

@end

@interface CXTimerProxy : NSProxy

@property (weak, nonatomic) id target;

@end

@implementation CXTimerTarget

- (instancetype)initWithSelector:(SEL)aSelector  sourceTarget:(id)sourceTarget{
    self = [super init];
    if (self) {
        self.actionBlock = nil;
        self.sourceTarget = sourceTarget;
        self.actionSelector = aSelector;
    }
    return self;
}

- (instancetype)initWithBlock:(void(^)(NSTimer *timer))block sourceTarget:(id)sourceTarget{
    self = [super init];
    if (self) {
        self.actionBlock = block;
        self.sourceTarget =sourceTarget;
    }
    return self;
}

- (void)timerAction:(NSTimer *)timer{
    if (self.sourceTarget == nil) {
        [timer invalidate];
        timer = nil;
    }else{
        if (self.actionBlock) {
            self.actionBlock(timer);
        }else{
            IMP imp = [self.sourceTarget methodForSelector:self.actionSelector];
            void (*func)(id, SEL,NSTimer *) = (void *)imp;
            func(self.sourceTarget, self.actionSelector,timer);
        }
    }
}

@end

@implementation NSTimer(CXAUUnCycle)

+ (NSTimer *)cx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)target
                                         repeat:(BOOL)repeat
                                          block:(void(^)(NSTimer *timer))block
{
    CXTimerTarget *timerTarget = [[CXTimerTarget alloc] initWithBlock:block sourceTarget:target];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timerTarget selector:@selector(timerAction:) userInfo:nil repeats:YES];
    return timer;
}

+ (NSTimer *)cx_timerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)target
                                repeat:(BOOL)repeat
                                 block:(void(^)(NSTimer *timer))block
{
    CXTimerTarget *timerTarget = [[CXTimerTarget alloc] initWithBlock:block sourceTarget:target];
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(timerAction:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (NSTimer *)cx_timerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)target
                              selector:(SEL)selector
                              userInfo:(nullable id)userInfo
                               repeats:(BOOL)repeat
{
    CXTimerTarget *timerTarget = [[CXTimerTarget alloc] initWithSelector:selector sourceTarget:target];
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:timerTarget selector:@selector(timerAction:) userInfo:userInfo repeats:repeat];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

@end

@implementation CXTimerProxy

+ (instancetype)proxyWithTarget:(id)target
{
    CXTimerProxy *proxy = [CXTimerProxy alloc];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end



