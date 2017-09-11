//
//  LKNearViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKNearViewController.h"
#import "LKNearCollectionViewCell.h"
#import "LKPlayerViewController.h"
#import "LKLiveHandler.h"
#import "LKLiveModel.h"
#import <MJRefresh.h>

#define kMargin  5
#define kItemWidth  100
#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)
//#define collectionWid   (SCREEN_WIDTH-(cols+1)*margin)/cols

static NSString * const Identifier = @"NearLiveCell";

@interface LKNearViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LKNearViewController

#pragma mark - lazy

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kMargin;
        layout.minimumInteritemSpacing = kMargin;
        layout.sectionInset = UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
        
        CGRect fm = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:fm collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"LKNearCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:Identifier];
    }
    return _collectionView;
}

#pragma mark - load

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorBackGroundWhiteColor];

    [self setUpListOrReload];
}

- (void)setUpListOrReload {
    
    __weak typeof(self) weasSelf = self;
    self.collectionView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        
        [weasSelf reloadNear];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    //添加长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longGesture];
    _longGesture = longGesture;
    
    [self.view addSubview:self.collectionView];
}

- (void)startShake:(UICollectionViewCell *)cell {
    
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animation];
    
    anima.keyPath = @"transform.rotation";
    anima.duration = 0.25;
    anima.repeatCount = MAXFLOAT; //无限抖动
    anima.values = @[@(ANGLE_TO_RADIAN(-5)),@(ANGLE_TO_RADIAN(5)),@(ANGLE_TO_RADIAN(-5))];
    anima.fillMode = kCAFillModeForwards; //动画填充方式
    
    //给正在移动的cell添加抖动
    [cell.layer addAnimation:anima forKey:@"shake"];
}

- (void)endShake:(UICollectionViewCell *)cell {
    
    [cell.layer removeAnimationForKey:@"shake"];
}

- (void)longPress:(UILongPressGestureRecognizer *)longGesture {
    
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
            LKNearCollectionViewCell *cell = (LKNearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [self startShake:cell];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];

            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - net

- (void)reloadNear {

    [XDProgressHUD showHUDWithIndeterminate:@"正在加载..."];
    
    [LKLiveHandler executeGetNearLiveTaskWithSuccess:^(id obj) {
        [self endRefrshing];
        [XDProgressHUD hideHUD];
        
        if (obj) {
            [self.dataSource addObjectsFromArray:obj];
            [self.collectionView reloadData];
        }
        
    } failed:^(id obj) {
        
        [self endRefrshing];
        [XDProgressHUD hideHUD];
        
        [XDProgressHUD showHUDWithText:@"请求失败" hideDelay:1.0];
    }];
}

- (void)endRefrshing {
    
    if ([self.collectionView.mj_header isRefreshing]) {
        
        [self.collectionView.mj_header endRefreshing];
    }
    else if ([self.collectionView.mj_footer isRefreshing]) {
        
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - data && delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKNearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    if (self.dataSource.count > indexPath.row) {
        
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat outInset = self.view.width - 2 * kMargin;
    NSInteger count = outInset / kItemWidth;
    NSInteger extraTotal = (NSInteger)(outInset - kMargin * (count - 1 ));
    
    CGFloat itemWH;
    
    if (extraTotal < count * kItemWidth) {
        
        itemWH = extraTotal / count;
        
    } else {
        
        CGFloat extraWidth = extraTotal % kItemWidth;
        itemWH = kItemWidth + extraWidth / count;
    }
    
    return CGSizeMake(itemWH, itemWH + 30);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKNearCollectionViewCell *cells = (LKNearCollectionViewCell *)cell;
    
    [cells showAnimate]; //动画展示
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *selectIndex = [collectionView indexPathForItemAtPoint:[_longGesture locationInView:collectionView]];
    
    LKNearCollectionViewCell *cell = (LKNearCollectionViewCell *)[collectionView cellForItemAtIndexPath:selectIndex];
    
    if (self.dataSource.count > indexPath.row) {
        
        LKLiveModel *model = self.dataSource[indexPath.row];
        [self endShake:cell];
        [self playIsMd:model];
    }
}


/**
 设置cell可以移动
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}


/**
 iOS9.0后提供的api

 @param collectionView 当前cell
 @param sourceIndexPath 需要移动的cell位置
 @param destinationIndexPath 移动到目标位置
 */
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longGesture locationInView:self.collectionView]];
    // 找到当前的cell
    LKNearCollectionViewCell *cell = (LKNearCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
    [self endShake:cell]; //停止抖动
    
    //取出源item数据
    LKLiveModel *model = [self.dataSource objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [self.dataSource removeObject:model];
    //将数据插入到资源数组中的目标位置上
    [self.dataSource insertObject:model atIndex:destinationIndexPath.item];
}

#pragma mark - player

- (void)playIsMd:(LKLiveModel *)model {
    if (!model) return;
    
    LKPlayerViewController *player = [[LKPlayerViewController alloc] init];
    player.model = model;
    [self.navigationController pushViewController:player animated:YES];
}

@end
