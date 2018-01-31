//
//  LKLaunchLiveViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLaunchLiveViewController.h"
#import "LKLocationManager.h"
#import "LFLivePreview.h"

@interface LKLaunchLiveViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (nonatomic, strong) LFLivePreview *livePreview;
@end

@implementation LKLaunchLiveViewController

#pragma mark - lazy

- (LFLivePreview *)livePreview {
    
    if (!_livePreview) {
        _livePreview = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    }
    return _livePreview;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorBackGroundWhiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setCurrentCity];
}

- (void)setCurrentCity {
    
    LKLocationManager *manager = [LKLocationManager sharedManager];
    [self.cityBtn setTitle:manager.city forState:UIControlStateNormal];
}

- (IBAction)closeLaunch:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //收起键盘
    [self.view endEditing:YES];
}

#pragma mark - living
//开始直播
- (IBAction)startLive:(id)sender {
    [self.view endEditing:YES];
    
    WeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        weakSelf.livePreview.vc = self;
        [weakSelf.view addSubview:self.livePreview];
        [weakSelf.livePreview startLive];
    }];
}

@end
