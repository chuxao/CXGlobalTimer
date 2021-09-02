//
//  NSObject+CXGlobalTimer.h
//  MarsonryTest
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 chuxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXGlobalTimerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CXGlobalTimer)

/// 设置代理
/// 目前如下类型实现自动释放 ：UIView、UIViewController，其他不予支持也不会出现，提高性能
/// 如果在对象生命周期内不使用定时器，讲代理置为 nil 即可，即 self.globalTimerDelegate = nil;
/// ！该属性需要在下面属性设置前进行设置，否则会被下面属性覆盖默认值
@property (nonatomic, weak) id<CXGlobalTimerProtocol> globalTimerDelegate;

/// 计时器 timeInterval，默认为1秒
@property (nonatomic, assign) NSTimeInterval globalTimeInterval;

/// globalTimeRepeat，默认为YES
@property (nonatomic, assign) BOOL globalTimerRepeat;

/// 暂停，默认为启动
@property (nonatomic, assign, getter=isGlobalTimerPause) BOOL globalTimerPause;

/// 附带信息
@property (nonatomic, strong) id globalTimeUserInfo;

@end

NS_ASSUME_NONNULL_END
