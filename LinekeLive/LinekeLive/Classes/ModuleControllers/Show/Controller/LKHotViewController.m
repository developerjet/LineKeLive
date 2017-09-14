//
//  LKHotViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHotViewController.h"
#import "LKHotLiveTableViewCell.h"
#import "LKPlayerViewController.h"
#import <MJRefresh.h>

static NSString * const LiveCellID = @"HotLiveCell";

@interface LKHotViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LKHotViewController

#pragma mark - LazyLoad

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorBackGroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除系统线条
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"LKHotLiveTableViewCell" bundle:nil] forCellReuseIdentifier:LiveCellID];
    }
    return _tableView;
}

#pragma mark - Events

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    
    [self setUptableOrReload];
}


- (void)setUptableOrReload {
    
    __weak typeof(self) weasSelf = self;
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weasSelf.dataSource removeAllObjects];
        
        [weasSelf reloadHot];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.tableView];
}

#pragma mark - net

- (void)reloadHot {

    [XDProgressHUD showHUDWithIndeterminate:@"正在加载热门..."];
    
    [LKLiveHandler executeGetHotLiveTaskWithSuccess:^(id obj) {
        [self endRefrshing];
        [XDProgressHUD hideHUD];
        
        [self.dataSource addObjectsFromArray:obj];
        [self.tableView  reloadData];
        
    } failed:^(id obj) {
        
        [self endRefrshing];
        [XDProgressHUD hideHUD];
        [XDProgressHUD showHUDWithText:@"请求失败" hideDelay:1.0];
    }];
}

- (void)endRefrshing {
    
    if ([self.tableView.mj_header isRefreshing]) {
        
        [self.tableView.mj_header endRefreshing];
    }
    else if ([self.tableView.mj_footer isRefreshing]) {
        
        [self.tableView.mj_footer endRefreshing];
    }
}


#pragma mark - UITableViewDataSource Or UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKHotLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LiveCellID];
    cell.backgroundColor = [UIColor colorBackGroundWhiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSource.count > indexPath.row) {
        
        cell.model = self.dataSource[indexPath.row];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource.count > indexPath.row) {
        LKLiveModel *model = self.dataSource[indexPath.row];
        [self playThisModel:model];
    }
}

- (void)playThisModel:(LKLiveModel *)model {
    if (!model) return;
    
    LKPlayerViewController *playerVC = [[LKPlayerViewController alloc] init];
    playerVC.model = model;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0 + SCREEN_WIDTH;
}

/*
 注意：系统自带的播放器实现不了直播视频播放
- (void)systemPlayWithURL:(NSString *)url {
    if (!url || url.length<=0) return;
    
    MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self presentViewController:movieVC animated:YES completion:NULL];
}
 */



@end
