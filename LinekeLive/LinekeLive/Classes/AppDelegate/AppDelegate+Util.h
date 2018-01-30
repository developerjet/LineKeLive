//
//  AppDelegate+Util.h
//  LinekeLive
//
//  Created by CoderTan on 2018/1/30.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Util)

/** 初始化网络状态监听 */
- (void)initReachNote;

/** 当前网络状态改变监听 */
- (void)reachabilityChanged:(NSNotification *)noti;

/** 捕获最新的网络状态 */
- (void)updateInterfaceWithReachability:(Reachability *)currentReach;

- (void)showNetStatusAlert;

@end
