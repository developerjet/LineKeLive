//
//  LKFocuseViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKFocuseViewController.h"
#import "LKHotLiveTableViewCell.h"
#import "LKPlayerViewController.h"

static NSString * const Identifier = @"FocuseCell";

@interface LKFocuseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LKFocuseViewController

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
        [_tableView registerNib:[UINib nibWithNibName:@"LKHotLiveTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
    }
    return _tableView;
}

#pragma mark - viewLaod

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    [self.view addSubview:self.tableView];
    
    [self reloadAllDatas];
}

- (void)reloadAllDatas {
    
    LKLiveModel *live = [[LKLiveModel alloc] init];
    live.city = @"深圳市";
    live.onlineUsers = 2366;
    live.streamAddr = kLiveRtmp;
    
    LKCreatorModel *creator = [[LKCreatorModel alloc] init];
    live.creator = creator;
    creator.nick = @"CoderTan";
    creator.birth = @"1993-11-17";
    creator.portrait = @"http://p3.music.126.net/cm1Zl1iA4FWPOeFciGJhxQ==/7834020348056256.jpg";
    
    [self.dataSource addObject:live];
    [self.dataSource addObjectsFromArray:[LKCacheHelper shared].allAnchorMs];
    
    [self.tableView  reloadData];
}


#pragma mark - data && delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKHotLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
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
        //获取直播的源
        LKLiveModel *model = self.dataSource[indexPath.row];
        [self playerThisModel:model];
    }
}

- (void)playerThisModel:(LKLiveModel *)model {
    if (!model) return;
    
    LKPlayerViewController *player = [[LKPlayerViewController alloc] init];
    player.model = model;
    [self.navigationController pushViewController:player animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0 + SCREEN_WIDTH;
}


@end
