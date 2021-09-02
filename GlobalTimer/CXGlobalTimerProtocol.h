//
//  CXGlobalTimerProtocol.h
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#ifndef CXGlobalTimerProtocol_h
#define CXGlobalTimerProtocol_h

/// 遵循定时器协议
@protocol CXGlobalTimerProtocol <NSObject>
@optional

/// 定时器执行回调
/// @param sender 计时器调用者
- (void)globalTimeDidChange:(id)sender;
@end

#endif /* CXGlobalTimerProtocol_h */
