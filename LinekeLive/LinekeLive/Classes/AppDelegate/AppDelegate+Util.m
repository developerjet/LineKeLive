//
//  AppDelegate+Util.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/30.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "AppDelegate+Util.h"
#import "LKLaunchBrowseView.h"
#import "LKLocationManager.h"
#import <Bugly/Bugly.h>
#import <UIColor+YYAdd.h>
#import "YYFPSLabel.h"

@implementation AppDelegate (Util)

#pragma mark - Reachability Handle status
/** 初始化网络状态监听 */
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
    
    if (self.SatusFinishedBlock) {
        self.SatusFinishedBlock(status);
    }
    
    if (status == NotReachable)
    {
        [self showNote];
    }
    else
    {
        
    }
}

#pragma mark -
#pragma mark - Init Utils
- (void)initAppUtil {
    
    // 腾讯Bugly
    [Bugly startWithAppId:@"dcb5a15014"];
    
    [self appearanceSet];
    [self initReachNote];
    [self initNewFeature];
    [self initLoaction];
}

- (void)appearanceSet {
    
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight =0;
        [UITableView appearance].estimatedSectionFooterHeight =0;
        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

/** 设置新特性&广告界面 */
- (void)initNewFeature {

    if ([self isFirstLaunch]) {
        NSArray *imageArray1 = @[
                                 @"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg",
                                 @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png",
                                 @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg",
                                 @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg",
                                 @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517393953794&di=e254bca583929d0bc6adaedd7a75cb5d&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01af5a55f959226ac7251df8250c99.jpg"
                                 ];
        
        LKLaunchBrowseView *browseView = [[LKLaunchBrowseView alloc] initWithConfigImageGroups:imageArray1
                                                                                   isCache:YES];
        [browseView show];
    }
}

/** 检测是否是第一次启动 */
- (BOOL)isFirstLaunch {
    NSString *launchCheckVersionNum = [NSString stringWithFormat:@"LaunchVersion%@", kVersionNum];
    BOOL isFirstLaunch = [UD boolForKey:launchCheckVersionNum];
    if (!isFirstLaunch) {
        [UD setBool:YES forKey:launchCheckVersionNum];
        [UD synchronize];
    }
    return !isFirstLaunch;
}

/** 开启定位 */
- (void)initLoaction {
    
    [[LKLocationManager sharedManager] achieveLocation:^(NSString *lat, NSString *lon) {
    
        NSLog(@"%@, %@", lat, lon);
    }];
}

- (void)showNote {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前网络已断开,请检查网络连接设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
