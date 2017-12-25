//
//  LKMeViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMeViewController.h"
#import "LKSettingViewController.h"
#import "LKMeTableViewCell.h"
#import "LKMeHeaderView.h"
#import "LKMineModel.h"

static NSString * const mineCellID = @"HotLiveCell";

@interface LKMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LKMeViewController

#pragma mark - LazyLoad

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSArray array];
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
        [_tableView registerNib:[UINib nibWithNibName:@"LKMeTableViewCell" bundle:nil] forCellReuseIdentifier:mineCellID];
    }
    return _tableView;
}

#pragma mark - Events

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUptable];
    [self setRefresh];
}


- (void)setUptable {
    
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    LKMeHeaderView *headerView = [LKMeHeaderView loadNibHeader];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:self.tableView];
}

- (void)setRefresh {

    NSArray *datas = @[@[@{@"title":@"映客贡献榜"},
                         @{@"title":@"收益",@"detail":@"0映票"},
                         @{@"title":@"账户",@"detail":@"0钻石"}],
                       @[@{@"title":@"等级",@"detail":@"3级"},
                         @{@"title":@"实名认证",@"detail":@"0映票"}],
                       @[@{@"title":@"设置"}]];
    
    self.dataSource = [LKMineModel mj_objectArrayWithKeyValuesArray:datas];
    
    [self.tableView reloadData];
}


#pragma mark - data && delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *datas = self.dataSource[section];
    
    return datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellID];
    cell.accessoryType = YES;
    
    if (self.dataSource.count > indexPath.section) {
        
        NSArray *data = self.dataSource[indexPath.section];
        
        if (data.count > indexPath.row) {
            
            cell.model = self.dataSource[indexPath.section][indexPath.row];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.0;
    }else {
        
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            LKSettingViewController *setting = [[LKSettingViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
        }
    }
}

@end
