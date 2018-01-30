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
@property (nonatomic, assign) kLoginStatus status;

@end

@implementation LKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - login In
- (IBAction)loginClick:(UIButton *)btn {
    self.status = btn.tag;
    
    switch (self.status) {
        case kLoginStatus_WeiBo:
            [kAppDelegate animationRoot:AnimServiceLoginIn];
            break;
        default:
            break;
    }
}

@end
