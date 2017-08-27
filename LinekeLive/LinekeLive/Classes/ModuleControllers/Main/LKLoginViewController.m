//
//  LKLoginViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/22.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLoginViewController.h"
#import "LKBasicTabBarController.h"

@interface LKLoginViewController ()
@property (nonatomic, assign) LKLoginStyle loginStyle; //登录方式

@end

@implementation LKLoginViewController

#pragma mark - EventMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - LoginManager

- (IBAction)loginClick:(UIButton *)btn {
    _loginStyle = btn.tag;
    
    switch (_loginStyle) {
        case WeiBoLogin:
            [self setUptabBar];
            break;
            
        default:
            break;
    }
}

//进入主界面
- (void)setUptabBar {
    
    LKBasicTabBarController *tabBar = [[LKBasicTabBarController alloc] init];
    self.view.window.rootViewController = tabBar;
}

@end
