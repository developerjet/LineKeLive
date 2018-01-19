//
//  LKSettingViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/7.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKSettingViewController.h"
#import "LKLoginViewController.h"
#import <SDImageCache.h>

static NSString *const Identifier = @"SettingCell";

@interface LKSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *dataSource;
@property (nonatomic, copy) void(^clearBlock)();
@end

@implementation LKSettingViewController

#pragma mark - lazyLoad
- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.rowHeight = 44.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorBackGroundColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

#pragma mark - view Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - data && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        if (indexPath.row == 0) {
            cell.textLabel.text = [self getCaches];
            self.clearBlock = ^{
                cell.textLabel.text = @"0.0KB";
            };
        }else {
            cell.textLabel.text = @"退出登录";
        }
    }
    
    return cell;
}

- (void)animClear {
    
    [XDProgressHUD showHUDWithIndeterminate:@"正在清理..."];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XDProgressHUD hideHUD];
        
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            [weakSelf.tableView reloadData];
        }];
        weakSelf.clearBlock();
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self animClear];
    }else {
        [self loginOut];
    }
}

- (void)loginOut {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"退出登录不会删除任何历史数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [kAppDelegate animationRoot:AnimServiceLoginOut];
    }];
    
    UIAlertAction *clean = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:confirm];
    [alert addAction:clean];
    [self presentViewController:alert animated:YES completion:nil];
}

///计算当前缓存大小
- (NSString *)getCaches {
    NSInteger caches = [[SDImageCache sharedImageCache] getSize];
    
    if (caches) {
        if (caches>1024.0*1024.0) {
            return [NSString stringWithFormat:@"当前缓存：%.2fMB", caches/1024.0/1024.0];
        }else if (caches>1024.0) {
            return [NSString stringWithFormat:@"当前缓存：%.2fKB", caches/1024.0];
        }else if (caches>0) {
            return [NSString stringWithFormat:@"当前缓存：%.2luB", caches];
        }
    }
    return @"当前缓存：0KB";
}

@end
