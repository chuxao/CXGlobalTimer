//
//  SecondViewController.m
//  GlobalTimerTest
//
//  Created by chuxiao on 2022/11/22.
//

#import "SecondViewController.h"
#import "NSObject+CXGlobalTimer.h"

@interface CXLabel : UILabel <CXGlobalTimerProtocol>

@property (assign, nonatomic) int timerInterval;
@property (assign, nonatomic) int count;

@end

@implementation CXLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)startTimerWith:(NSTimeInterval)timerInterval {
    self.timerInterval = timerInterval;
    self.globalTimerDelegate = self;
    self.globalTimeInterval = timerInterval;
}

- (void)globalTimeDidChange:(id)sender {
    self.count ++;
    self.text = [NSString stringWithFormat:@"我%ds刷新一次:  %d", self.timerInterval, self.count];
}

- (void)dealloc
{
    NSLog(@"view 释放了！！");
}

@end


@interface SecondViewController ()<CXGlobalTimerProtocol>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet CXLabel *aLabel_1;
@property (weak, nonatomic) IBOutlet CXLabel *aLabel_2;

@property (assign, nonatomic) int count;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (IBAction)startTimer:(id)sender {
    // 同时启动view和vc的定时器
    [self.aLabel_1 startTimerWith:2];
    [self.aLabel_2 startTimerWith:5];
    
    self.globalTimerDelegate = self;
    self.globalTimeInterval = 1;
}

- (IBAction)pauseTimer:(id)sender {
    self.globalTimerPause = YES;
    self.aLabel_1.globalTimerPause = YES;
    self.aLabel_2.globalTimerPause = YES;
}

- (IBAction)regainTimer:(id)sender {
    self.globalTimerPause = NO;
    self.aLabel_1.globalTimerPause = NO;
    self.aLabel_2.globalTimerPause = NO;
}



- (void)globalTimeDidChange:(id)sender {
    self.count ++;
    self.timeLabel.text = [NSString stringWithFormat:@"%d", self.count];
    
    self.label.text = [NSString stringWithFormat:@"我1s刷新一次:  %d", self.count];
}

- (void)dealloc
{
    NSLog(@"vc 释放了！！");
}

@end
