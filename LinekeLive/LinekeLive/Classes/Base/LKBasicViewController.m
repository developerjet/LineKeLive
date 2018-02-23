//
//  LKBasicViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBasicViewController.h"

@interface LKBasicViewController ()<UINavigationControllerDelegate>

@end

@implementation LKBasicViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleDefault;
}


#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRandom];
}

- (void)viewSafeAreaInsetsDidChange {
    // 补充：顶部的危险区域就是距离刘海10points，（状态栏不隐藏）
    // 也可以不写，系统默认是UIEdgeInsetsMake(10, 0, 34, 0);
    [super viewSafeAreaInsetsDidChange];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(10, 0, 34, 0);
}

#pragma mark -
#pragma mark - <UINavigationControllerDelegate iPhoneX适配处理>
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![[[UIDevice currentDevice] model] isEqualToString: @"iPhone X"]) {
        return;
    }
    CGRect frame = self.tabBarController.tabBar.frame;
    if (frame.origin.y < ([UIScreen mainScreen].bounds.size.height - 83)) {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 83;
        self.tabBarController.tabBar.frame = frame;
    }
}

@end
