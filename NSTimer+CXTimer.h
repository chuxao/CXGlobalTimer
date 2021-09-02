//
//  NSTimer+CXTimer.h
//  Vova
//
//  Created by chuxiao on 2018/8/2.
//  Copyright © 2018年 iOS. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (CXAUUnCycle)
/**
 普通定时器，自动加入Default类型的runloop中
 */
+ (NSTimer *)cx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)target
                                         repeat:(BOOL)repeat
                                          block:(void(^)(NSTimer *timer))block;

/**
 普通定时器
 */
+ (NSTimer *)cx_timerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)target
                                repeat:(BOOL)repeat
                                 block:(void(^)(NSTimer *timer))block;

/**
 普通定时器，可以进行暂停，重启操作
 */
+ (NSTimer *)cx_timerWithTimeInterval:(NSTimeInterval)interval
                                target:(id)target
                              selector:(SEL)selector
                              userInfo:(nullable id)userInfo
                               repeats:(BOOL)repeat;

@end


NS_ASSUME_NONNULL_END
