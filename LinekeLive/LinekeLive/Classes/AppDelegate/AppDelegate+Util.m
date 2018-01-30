//
//  AppDelegate+Util.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/30.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "AppDelegate+Util.h"

@implementation AppDelegate (Util)

#pragma mark - Reachability Handle status
- (void)initReachNote {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification
                                               object:nil];
    
    // 初始化
    self.hostReach = [Reachability reachabilityForInternetConnection];
    // 开始监听,会启动一个run loop
    [self.hostReach startNotifier];
    [self updateInterfaceWithReachability:self.hostReach];
}

- (void)reachabilityChanged:(NSNotification *)noti {
    
    Reachability * reach = [noti object];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]); //断言
    [self updateInterfaceWithReachability:reach];
}

- (void)updateInterfaceWithReachability:(Reachability *)currentReach {
    // 获取当前网路连接状态,做出响应的处理
    NetworkStatus status = [currentReach currentReachabilityStatus];
    
    if (self.netSatusBlock) {
        self.netSatusBlock(status);
    }
    
    if (status == NotReachable) {
        [self showNetStatusAlert];
    }else {
        
    }
}


- (void)showNetStatusAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前网络已断开,请检查网络连接设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
