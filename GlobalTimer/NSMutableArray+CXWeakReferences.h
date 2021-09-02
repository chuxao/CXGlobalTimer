//
//  NSMutableArray+CXWeakReferences.h
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 弱引用容器
 */
@interface NSMutableArray (CXWeakReferences)

+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end

NS_ASSUME_NONNULL_END
