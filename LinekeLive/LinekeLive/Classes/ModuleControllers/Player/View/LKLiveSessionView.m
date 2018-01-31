//
//  LKSendTaskView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/17.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLiveSessionView.h"
#import "LKTalkTableViewCell.h"

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";
@interface LKLiveSessionView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LKLiveSessionView

#pragma mark - lazyLoad

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator   = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除系统线条
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"LKTalkTableViewCell" bundle:nil] forCellReuseIdentifier:kCellReuseIdentifier];
    }
    return _tableView;
}

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        [self configureData];
    }
    return self;
}

- (void)configureData {
    
    NSArray *datas = @[@{@"level": @2, @"name": @"冷少", @"talk": @"主播真美啊~😆"},
                      @{@"level": @4, @"name": @"瞄神", @"talk": @"主播做什么工作的啊~😆"},
                      @{@"level": @2, @"name": @"CoderTan", @"talk": @"主播有男朋友没啊~😆"},
                      @{@"level": @5, @"name": @"冷少", @"talk": @"主播是照骗啊啊~😑"},
                      @{@"level": @2, @"name": @"峰少", @"talk": @"主播真没啊~😆"},
                      @{@"level": @2, @"name": @"李易峰", @"talk": @"主播约吗，给你刷红包啊~😆"},
                      @{@"level": @2, @"name": @"隔壁老王啊", @"talk": @"今晚3点见哟"},
                      @{@"level": @2, @"name": @"猪宝宝", @"talk": @"主播什么罩杯啊😝"},
                      @{@"level": @2, @"name": @"薛之谦", @"talk": @"来听听我的新专辑，全部免费。"},
                      @{@"level": @5, @"name": @"李荣浩", @"talk": @"村里有个菇凉叫小芳啊~"},
                      @{@"level": @9, @"name": @"网易云音乐", @"talk": @"网易云音乐遇见大好心情"},
                      @{@"level": @10, @"name": @"张栋梁", @"talk": @"当你孤单你会想起谁？"},
                      @{@"level": @5, @"name": @"相见恨晚2017", @"talk": @"主播你好~😆"},
                      @{@"level": @3, @"name": @"演员", @"talk": @"该配合你演出的我视而不见~😆"}];
    
    [self.dataSource addObjectsFromArray:[LKTalkModel mj_objectArrayWithKeyValuesArray:datas]];
    [self.tableView reloadData];
}

- (void)setTalkModel:(LKTalkModel *)talkModel {
    _talkModel = talkModel;
 
    // 插入到最后索引
    [self.dataSource insertObject:talkModel atIndex:self.dataSource.count];
    [self.tableView reloadData];
    
    // 滚动到指定位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _tableView.transform = CGAffineTransformMakeScale(1, -1);
        
    } completion:^(BOOL finished) {

        _tableView.transform = CGAffineTransformIdentity; // 恢复动画
    }];
}

#pragma mark - delegate && data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LKTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 26.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.isDraggBlock) {
        self.isDraggBlock();
    }
}

@end
