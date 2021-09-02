# CXGlobalTimer

### 功能特色

* 一句代码定义、暂停、取消、设置定时器
* 自动处理定时器循环引用问题
* 自动处理框架强引用sender问题
* 颗粒度自定义
* 实现最低成本定时器重复调用问题
* 定时器适时停止、启动，性能完美

### 使用方法：



1. 在UIViewController 或 UIView中调用如下代码：

```c
#import "NSObject+CXGlobalTimer.h"
self.globalTimerDelegate = self;
```

这个时候定时器将自动启动并关联对象，您无需关心启动、释放、循环引用甚至是性能问题。



2. 遵循协议并实现协议方法即可实时获取回调：

```c
ViewController ()<CXGlobalTimerProtocol>
  
- (void)globalTimeDidChange:(id)sender
{
  
}
```



3. 如果定时器是应用在控制器或view的整个生命周期，那您无需关心释放问题，CXGlobalTimer将自动释放计时器。如果在生命周期内需要停止计时器，只需调用如下方法：

```c
self.globalTimerDelegate = nil;
```



4. 通过一句代码可以设置定时器的repeat时间，设置这个时间不会影响其他业务定时器的时间间隔。设置的时间需要遵循最小颗粒度的倍数，如果不是最小颗粒度的倍数，将会默认取最接近的时间间隔。最小颗粒度可以根据项目进行自定义：

```c
// 对不同控制器、view进行时间设定
vc_1.globalTimeInterval = 5;
vc_2.globalTimeInterval = 1;
view_1.globalTimeInterval = 3;
view_2.globalTimeInterval = 10;
```



5. 提供定时器暂停功能，也是一句代码：

```c
self.globalTimerPause = YES;
```



6. 如果您在定时器回调中希望获取更多数据信息，可以将数据携带userInfo：

```
self.globalTimeUserInfo = @{};
```



