//
//  NSMutableArray+CXWeakReferences.m
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#import "NSMutableArray+CXWeakReferences.h"

@implementation NSMutableArray (CXWeakReferences)

+ (id)mutableArrayUsingWeakReferences {
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
