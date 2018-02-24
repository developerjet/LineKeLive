//
//  LKBasicNavigationController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBasicNavigationController.h"
#import "LKNavigationBar.h"

@interface LKBasicNavigationController ()<UINavigationControllerDelegate>

@end

@implementation LKBasicNavigationController

- (UIStatusBarStyle)preferredStatusBarStyle {
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleDefault;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏背景颜色
    self.navigationBar.barTintColor = [UIColor colorNavThemeColor];
    //设置导航栏两侧文字&图片颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    //禁用系统自带的返回手势
    self.interactivePopGestureRecognizer.enabled = NO;
    //捕获返回手势的代理
    id target = self.interactivePopGestureRecognizer.delegate;
    // 添加全屏滑动返回手势
    SEL backGestureSelector = NSSelectorFromString(@"handleNavigationTransition:");
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:backGestureSelector];
    [self.view addGestureRecognizer:self.pan];
    
    self.delegate = self;
}

- (void)pop {
    
    [self popViewControllerAnimated:YES];
}

#pragma mark - <UIGestureRecognizerDelegate>
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count) {
        self.pan.enabled = YES;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"global_back"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(popViewControllerAnimated:)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }else {
        
        self.pan.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
    if (@available(iOS 11.0, *)){
        // 修改tabBar的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.navigationController.viewControllers.count > 1) {
        self.pan.enabled = YES;
    }else {
        self.pan.enabled = NO;
    }
}



@end
