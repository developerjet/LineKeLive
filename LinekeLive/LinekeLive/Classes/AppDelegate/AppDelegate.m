//
//  AppDelegate.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/21.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "AppDelegate.h"
#import "LKLoginViewController.h"
#import "LKBasicTabBarController.h"
#import "LKLocationManager.h"
#import "LKNewFeatureView.h"
#import "AppDelegate+Util.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initWindownRoot];
    [self initAppUtil];
    
    return YES;
}

//设置根控制器
- (void)initWindownRoot {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorBackGroundWhiteColor];
    
    LKLoginViewController *LKLogin = [[LKLoginViewController alloc] init];
    self.window.rootViewController = LKLogin;
    [self.window makeKeyAndVisible];
}

- (void)animationRoot:(AnimServiceType)type {
    
    CATransition *anim  = [CATransition animation];
    anim.timingFunction = UIViewAnimationCurveEaseInOut;
    // 设置转场类型
    anim.type = @"oglFlip"; //左右翻转
    anim.duration = 0.8f;
    // 设置转场方向
    anim.subtype = type == AnimServiceLoginIn ? kCATransitionFromRight : kCATransitionFromLeft;
    // 设置动画的开始位置
    //anim.startProgress = 0.5;
    // 设置动画结束位置
    //anim.endProgress = 1;
    // 添加动画
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
    
    // 根据业务类型切换根控制器
    if (type == AnimServiceLoginIn) {
        [[UIApplication sharedApplication].keyWindow setRootViewController:[[LKBasicTabBarController alloc] init]];
    }else {
        [[UIApplication sharedApplication].keyWindow setRootViewController:[[LKLoginViewController alloc] init]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
