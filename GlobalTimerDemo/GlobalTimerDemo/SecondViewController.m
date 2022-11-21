//
//  SecondViewController.m
//  GlobalTimerTest
//
//  Created by chuxiao on 2022/11/22.
//

#import "SecondViewController.h"
#import "NSObject+CXGlobalTimer.h"

@interface CXView : UIView <CXGlobalTimerProtocol>

@end

@implementation CXView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)startTimer {
    self.globalTimerDelegate = self;
}

- (void)globalTimeDidChange:(id)sender {
    NSLog(@"view 计时器回调");
}

- (void)dealloc
{
    NSLog(@"view 释放了！！");
}

@end


@interface SecondViewController ()<CXGlobalTimerProtocol>

@property(strong, nonatomic) CXView *aView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.aView = [CXView new];
    [self.view addSubview:self.aView];
    self.aView.frame = CGRectMake(100, 100, 100, 100);
    
    [self startTimer];
}

- (void)startTimer {
    // 同时启动view和vc的定时器
    [self.aView startTimer];
    self.globalTimerDelegate = self;
    
    self.globalTimeInterval = 2;
}

- (void)globalTimeDidChange:(id)sender {
    NSLog(@"vc 计时器回调");
}

- (void)dealloc
{
    NSLog(@"vc 释放了！！");
}

@end
