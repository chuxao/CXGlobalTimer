//
//  CXGlobalTimerManager.m
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#import "CXGlobalTimerManager.h"
#import "NSMutableArray+CXWeakReferences.h"
#import "objc/runtime.h"
#import "NSTimer+CXTimer.h"

static const NSTimeInterval CXGlobalTimerGranularity = 0.5;  // 颗粒度，秒

static const void * CX_GLOBALTIMER_DELEGATE = &"k_CX_GLOBALTIMER_DELEGATE";
static const void * CX_GLOBALTIMEINTERVAL_PRIVATE = &"k_CX_GLOBALTIMEINTERVAL_PRIVATE";
static const void * CX_GLOBALTIMEINTERVAL_PRIVATE_COUNTTEMP = &"k_CX_GLOBALTIMEINTERVAL_PRIVATE_COUNTTEMP";
static const void * CX_GLOBALTIME_REPEAT_PRIVATE = &"k_CX_GLOBALTIME_REPEAT_PRIVATE";
static const void * CX_GLOBALTIME_PAUSE_PRIVATE = &"k_CX_GLOBALTIME_PAUSE_PRIVATE";

@interface NSObject (CXGlobalTimer_private)

@property (nonatomic, assign) int globalTimeInterval_private_countTemp;

/*
- (void)cx_globalTimer_setGlobalTimeInterval:(id)obj timeInterval:(int)timeInterval;
- (void)cx_globalTimer_getGlobalTimeInterval:(id)obj;
 */

@end

@implementation NSObject (CXGlobalTimer_private)

- (void)setGlobalTimerDelegate_private:(id<CXGlobalTimerProtocol>)globalTimerDelegate_private
{
    objc_setAssociatedObject(self, CX_GLOBALTIMER_DELEGATE, globalTimerDelegate_private, OBJC_ASSOCIATION_ASSIGN);
}

- (id<CXGlobalTimerProtocol>)globalTimerDelegate_private
{
    return objc_getAssociatedObject(self, CX_GLOBALTIMER_DELEGATE);
}

- (void)setGlobalTimeInterval_private:(NSTimeInterval)globalTimeInterval_private
{
    objc_setAssociatedObject(self, CX_GLOBALTIMEINTERVAL_PRIVATE, @(globalTimeInterval_private), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)globalTimeInterval_private
{
    NSNumber *number = objc_getAssociatedObject(self, CX_GLOBALTIMEINTERVAL_PRIVATE);
    return [number doubleValue];
}

- (void)setGlobalTimeInterval_private_countTemp:(int)globalTimeInterval_private_countTemp
{
    objc_setAssociatedObject(self, CX_GLOBALTIMEINTERVAL_PRIVATE_COUNTTEMP, @(globalTimeInterval_private_countTemp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)globalTimeInterval_private_countTemp
{
    NSNumber *number = objc_getAssociatedObject(self, CX_GLOBALTIMEINTERVAL_PRIVATE_COUNTTEMP);
    return [number intValue];
}

- (void)setGlobalTimerRepeat_private:(BOOL)globalTimeRepeat_private
{
    objc_setAssociatedObject(self, CX_GLOBALTIME_REPEAT_PRIVATE, @(globalTimeRepeat_private), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)globalTimerRepeat_private
{
    NSNumber *number = objc_getAssociatedObject(self, CX_GLOBALTIME_REPEAT_PRIVATE);
    return [number boolValue];
}

- (void)setGlobalTimerPause_private:(BOOL)globalTimerPause_private
{
    objc_setAssociatedObject(self, CX_GLOBALTIME_PAUSE_PRIVATE, @(globalTimerPause_private), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)globalTimerPause_private
{
    NSNumber *number = objc_getAssociatedObject(self, CX_GLOBALTIME_PAUSE_PRIVATE);
    return [number boolValue];
}

@end

@interface CXGlobalTimerManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, strong) NSMutableArray<NSObject *> *delegatesArray;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation CXGlobalTimerManager

+ (instancetype) share
{
    static dispatch_once_t onceToken;
    static CXGlobalTimerManager *globalTimer = nil;
    dispatch_once(&onceToken, ^{
        globalTimer = [CXGlobalTimerManager new];
    });
    return globalTimer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timerInterval = CXGlobalTimerGranularity;
        self.delegatesArray = [NSMutableArray mutableArrayUsingWeakReferences];
        self.lock = [NSLock new];
        [self startTimer];
    }
    return self;
}

- (void)addGlobalTimerDelegate:(id)sender delegate:(id<CXGlobalTimerProtocol>)globalTimerDelegate
{
    if (!globalTimerDelegate ||
        ![globalTimerDelegate conformsToProtocol:@protocol(CXGlobalTimerProtocol)] ||
        [self.delegatesArray containsObject:sender]) {
        return;
    }
    
    // 默认时间间隔为1秒
    ((NSObject *)sender).globalTimeInterval_private = 1;
    // 默认重复调用为YES
    ((NSObject *)sender).globalTimerRepeat_private = YES;
    [self.delegatesArray addObject:sender];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timerInterval]];
}

- (void)removeGlobalTimerDelegate:(id)sender
{
    if (!sender) {
        return;
    }
    ((NSObject *)sender).globalTimerDelegate_private = nil;
//    [self.lock lock];
    [self.delegatesArray removeObject:sender];
    ((NSObject *)sender).globalTimeInterval_private_countTemp = 0;
//    [self.lock unlock];
    
    [self pauseOrResumeTimer];
}

- (void)pauseOrResumeTimer
{
    __block BOOL pause = YES;
    [self.delegatesArray enumerateObjectsUsingBlock:^(NSObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.globalTimerPause_private) {
            pause = NO;
            *stop = YES;
        }
    }];
    
    if (pause) [self.timer setFireDate:[NSDate distantFuture]];
    else [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timerInterval]];
}

- (void)startTimer
{
    self.timer = [NSTimer cx_timerWithTimeInterval:self.timerInterval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerHandle
{
    NSArray *deleatesArray = self.delegatesArray.copy;
    for (NSObject *sender in deleatesArray) {
        if (!sender) {
            continue;
        }
        if ([sender.globalTimerDelegate_private respondsToSelector:@selector(globalTimeDidChange:)] &&
            [self _canPerformAction:sender]) {
            [sender.globalTimerDelegate_private globalTimeDidChange:sender];
            
            if (!sender.globalTimerRepeat_private) {
                [self removeGlobalTimerDelegate:sender];
            }
        }
    }
}

- (BOOL)_canPerformAction:(NSObject *)obj
{
    if (obj.globalTimeInterval_private < 0) {
        return NO;
    }
    if (obj.globalTimerPause_private) {
        return NO;
    }
    /*
     * 使用粒度，初始赋值时间间隔1
    if (obj.globalTimeInterval_private == 1 ||
        obj.globalTimeInterval_private == 0) {
        return YES;
    }
     */
    
    if (obj.globalTimeInterval_private <= CXGlobalTimerGranularity) {
        return YES;
    }
    
    if (obj.globalTimeInterval_private_countTemp < obj.globalTimeInterval_private / CXGlobalTimerGranularity) {
        obj.globalTimeInterval_private_countTemp = obj.globalTimeInterval_private_countTemp + 1;
        
        if (obj.globalTimeInterval_private_countTemp >= obj.globalTimeInterval_private / CXGlobalTimerGranularity) {
            obj.globalTimeInterval_private_countTemp = 0;
            return YES;
        }
        return NO;
    }
    return NO;
}

@end


