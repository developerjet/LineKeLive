//
//  LKBasicNavigationController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBasicNavigationController.h"

@interface LKBasicNavigationController ()

@end

@implementation LKBasicNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeNav];
}

- (void)initializeNav {
    
    //设置导航栏背景颜色
    self.navigationBar.barTintColor = [UIColor colorNavThemeColor];
    
    //设置导航栏两侧文字&图片颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
