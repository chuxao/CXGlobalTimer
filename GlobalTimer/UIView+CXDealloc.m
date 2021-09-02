//
//  UIView+CXDealloc.m
//  CXGlobalTimer
//
//  Created by chuxiao on 2020/9/25.
//  Copyright © 2020 yunzhanghu. All rights reserved.
//

#import "UIView+CXDealloc.h"
#import "NSObject+CXGlobalTimer.h"
#import "NSObject+Protect.h"

@implementation UIView (CXDealloc)

+ (void)load
{
    [self exchangeInstanceMethod:[self class] originalSel:NSSelectorFromString(@"dealloc") swizzledSel:@selector(cx_dealloc)];
}

- (void)cx_dealloc
{
    if (!self) {
        return;
    }
    if ([self conformsToProtocol:@protocol(CXGlobalTimerProtocol)]) {
        self.globalTimerDelegate = nil;
    }
    [self cx_dealloc];
}


@end
