//
//  LKBasicTabBarController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBasicTabBarController.h"
#import "LKBasicNavigationController.h"
#import "LKLaunchLiveViewController.h"
#import "LKMainViewController.h"
#import "LKMeViewController.h"
#import "LKBasicTabBar.h"

@interface LKBasicTabBarController ()<LKBasicTabBarDelegate>
@property (nonatomic, strong) LKBasicTabBar *lkTabBar;

@end

@implementation LKBasicTabBarController

#pragma mark - LazyLoad

- (LKBasicTabBar *)lkTabBar {
    
    if (!_lkTabBar) {
        _lkTabBar = [[LKBasicTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _lkTabBar.delegate = self;
    }
    return _lkTabBar;
}

#pragma mark - EventMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载控制器
    [self configViewController];
    
    //加载tabBar
    [self.tabBar addSubview:self.lkTabBar];
    
    //解决tabBar的阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}


/**
 加载控制器
 */
- (void)configViewController {
    
    NSMutableArray *viewControllerMs = [NSMutableArray arrayWithArray:
                               @[@"LKMainViewController",
                                 @"LKMeViewController"]];
    
    for (NSInteger idx=0; idx<viewControllerMs.count; idx++) {
        
        NSString *vcName = viewControllerMs[idx];
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        LKBasicNavigationController *nav = [[LKBasicNavigationController alloc]
                                            initWithRootViewController:vc];
        [viewControllerMs replaceObjectAtIndex:idx withObject:nav];
    }
    
    self.viewControllers = viewControllerMs;
}


#pragma mark - LKBasicTabBarDelegate

- (void)tabBar:(LKBasicTabBar *)tabBar didSelectItemIndex:(LKTabBarItemType)index {
    
    if (index != LKItemTypeLaunch) {
        self.selectedIndex = index - LKItemTypeLive;
        return;
    }
    
    //开启直播
    LKLaunchLiveViewController *launchLive = [[LKLaunchLiveViewController alloc] init];
    [self presentViewController:launchLive animated:YES completion:nil];
}


@end
