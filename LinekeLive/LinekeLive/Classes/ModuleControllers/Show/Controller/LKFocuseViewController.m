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

static NSString *const kFocuseIdentifier = @"kFocuseIdentifier";

@interface LKFocuseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *playerList;

@end

@implementation LKFocuseViewController

#pragma mark - Lazy
- (NSMutableArray *)playerList {

    if (!_playerList) {
        _playerList = [NSMutableArray array];
    }
    return _playerList;
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
        [_tableView registerNib:[UINib nibWithNibName:@"LKHotLiveTableViewCell" bundle:nil] forCellReuseIdentifier:kFocuseIdentifier];
    }
    return _tableView;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorBackGroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteRefresh) name:kFollowKey
                                               object:nil];
    
    [self initTableView];
}

- (void)initTableView {
    
    [self.playerList addObject:[self initialLive]];
    [self.playerList addObjectsFromArray:[LKCacheHelper shared].allAnchorMs];
    
    [self.view addSubview:self.tableView];
}

- (LKLiveModel *)initialLive {
    
    LKLiveModel *live = [[LKLiveModel alloc] init];
    live.city = @"深圳市";
    live.onlineUsers = 2366;
    live.streamAddr = kLiveRtmp;
    
    LKCreatorModel *creator = [[LKCreatorModel alloc] init];
    live.creator  = creator;
    creator.nick  = @"CoderTan";
    creator.birth = @"1993-11-17";
    creator.portrait = @"http://p3.music.126.net/cm1Zl1iA4FWPOeFciGJhxQ==/7834020348056256.jpg";
    
    return live;
}

- (void)noteRefresh {
    if (self.playerList.count) {
        [self.playerList removeAllObjects];
    }
    
    [self.playerList addObject:[self initialLive]];
    [self.playerList addObjectsFromArray:[LKCacheHelper shared].allAnchorMs];
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.playerList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKHotLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFocuseIdentifier];
    cell.backgroundColor = [UIColor colorBackGroundWhiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.playerList.count > indexPath.row) {
        cell.model = self.playerList[indexPath.row];
    }
    return cell;
}

#pragma mark - <UITableViewDataDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.playerList.count > indexPath.row) {
        LKLiveModel *live = self.playerList[indexPath.row]; //获取直播的源
        [self playLive:live];
    }
}

- (void)playLive:(LKLiveModel *)live {
    if (!live) return;
    
    LKPlayerViewController *player = [[LKPlayerViewController alloc] init];
    player.model = live;
    player.streamAddr = live.streamAddr;
    [self.navigationController pushViewController:player animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0 + SCREEN_WIDTH;
}

@end
