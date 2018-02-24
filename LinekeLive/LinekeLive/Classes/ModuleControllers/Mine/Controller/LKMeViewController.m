//
//  LKMeViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMeViewController.h"
#import "LKSettingViewController.h"
#import "LKAddressListController.h"
#import "LKMeTableViewCell.h"
#import "LKMeHeaderView.h"
#import "LKMineModel.h"
#import "InputBoxBar.h"

static NSString * const kMeCellWithIdentifier = @"kMeCellWithIdentifier";

@interface LKMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LKMeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Lazy
- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[
                        @[[LKMineModel initClassWithTitle:@"映客贡献榜" detail:@""],
                          [LKMineModel initClassWithTitle:@"收益" detail:@"0映票"],
                          [LKMineModel initClassWithTitle:@"账户" detail:@"0钻石"]],
                        @[[LKMineModel initClassWithTitle:@"等级" detail:@"3级"],
                              [LKMineModel initClassWithTitle:@"实名认证" detail:@"已认证"]],
                        @[[LKMineModel initClassWithTitle:@"设置" detail:@""]]
                        ];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.rowHeight = 44.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorBackGroundColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"LKMeTableViewCell" bundle:nil] forCellReuseIdentifier:kMeCellWithIdentifier];
    }
    return _tableView;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubview];
}

- (void)initSubview {
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    WeakSelf;
    LKMeHeaderView *headerView = [[LKMeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:self.tableView];
    headerView.DidFinishedBlock = ^(kMeHeaderDidStatus status) {
        if (status == kMeHeaderDidStatus_Left) {
            LKAddressListController *address = [[LKAddressListController alloc] init];
            [weakSelf.navigationController pushViewController:address animated:YES];
        }
    };
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMeCellWithIdentifier];
    cell.accessoryType = YES;
    if ([self.dataSource[indexPath.section] count] > indexPath.row) {
        cell.model = self.dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.001;
    }else {
        return 10;
    }
}

#pragma mark - <UITableViewDataDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        LKSettingViewController *setting = [[LKSettingViewController alloc] init];
        [self.navigationController pushViewController:setting animated:YES];
    }
}

@end
