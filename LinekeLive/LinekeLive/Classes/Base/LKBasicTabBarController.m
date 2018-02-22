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
@property (nonatomic, strong) LKBasicTabBar *configTabBar;

@end

@implementation LKBasicTabBarController

#pragma mark - Lazy
- (LKBasicTabBar *)configTabBar {
    
    if (!_configTabBar) {
        _configTabBar = [[LKBasicTabBar alloc] initWithFrame:self.tabBar.bounds];
        _configTabBar.delegate = self;
    }
    return _configTabBar;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载控制器
    [self insertControllers];
    
    //加载tabBar
    [self.tabBar addSubview:self.configTabBar];
    
    //解决tabBar的阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            //此处注意设置 y的值 不要使用屏幕高度 - 49 ，因为还有tabbar的高度 ，用当前tabbarController的View的高度 - 49即可
            view.frame = CGRectMake(view.frame.origin.x, self.view.bounds.size.height-49, view.frame.size.width, 49);
        }
    }
    // 此处是自定义的View的设置 如果使用了约束 可以不需要设置下面,_bottomView的frame
    self.configTabBar.frame = self.tabBar.bounds;
}

- (void)insertControllers {
    
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


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}


@end
