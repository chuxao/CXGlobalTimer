//
//  CXGlobalTimerManager.h
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXGlobalTimerProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CXGlobalTimer_private)

@property (nonatomic, weak) id<CXGlobalTimerProtocol> globalTimerDelegate_private;
@property (nonatomic, assign) NSTimeInterval globalTimeInterval_private;
@property (nonatomic, assign) BOOL globalTimerRepeat_private;
@property (nonatomic, assign) BOOL globalTimerPause_private;

@end

/**
 全局定时器管理类
 */
@interface CXGlobalTimerManager : NSObject

+ (instancetype) share;
- (void)addGlobalTimerDelegate:(id)sender delegate:(id<CXGlobalTimerProtocol>)globalTimerDelegate;
- (void)removeGlobalTimerDelegate:(id)sender;
- (void)pauseOrResumeTimer;

@end

NS_ASSUME_NONNULL_END
