//
//  LKGiftListView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKGiftListView.h"
#import "LKGiftCollectionViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "LineKeMacros.h"
#import "LKGiftModel.h"

#define kShowViewHeight  230
#define kShowListHeight  200

static int const maxCols = 4;
static NSString *kCellIdentifier = @"CellFromIdentifier";

#define itemH   80
#define margin  10
#define itemW   (SCREEN_WIDTH-(maxCols+1)*margin)/maxCols

@interface LKGiftListView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *show_BGView; //背景视图
@property (nonatomic, strong) UIView *show_GFView; //礼物展示区域
@property (nonatomic, strong) UIButton         *startButton;
@property (nonatomic, strong) UIPageControl    *pageControl; /** >索引< **/
@property (nonatomic, strong) NSMutableArray   *resultItems;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LKGiftListView

#pragma mark - Lazy
- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        CGRect frame = CGRectMake(0, kShowViewHeight-30, SCREEN_WIDTH, 30);
        _pageControl = [[UIPageControl alloc] initWithFrame:frame];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

- (UIButton *)startButton {
    
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(SCREEN_WIDTH-60, kShowViewHeight-32, 50, 24);
        [_startButton setTitle:@"赠送" forState:UIControlStateNormal];
        _startButton.layer.cornerRadius = 12.0;
        _startButton.layer.masksToBounds = YES;
        _startButton.backgroundColor = [UIColor colorNavThemeColor];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_startButton addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (NSMutableArray *)resultItems {
    
    if (!_resultItems) {
        _resultItems = [[NSMutableArray alloc] init];
    }
    return _resultItems;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        //流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = margin/2;
        layout.minimumInteritemSpacing = margin/2;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kShowListHeight) collectionViewLayout:layout];
        _collectionView.bounces  = NO;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"LKGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}

#pragma mark - inital
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.show_BGView = [[UIView alloc] initWithFrame:self.frame];
    [self addSubview:self.show_BGView];
    
    //添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.show_BGView addGestureRecognizer:tap];
    
    self.show_GFView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kShowViewHeight)];
    self.show_GFView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    [self addSubview:self.show_GFView];
    
    [self.show_GFView addSubview:self.collectionView];
    //添加索引
    [self.show_GFView addSubview:self.pageControl];
    [self.show_GFView addSubview:self.startButton];
    
    [self requestList];
}

#pragma mark - Cycle Actions
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.show_GFView.frame = CGRectMake(0, SCREEN_HEIGHT-kShowViewHeight, SCREEN_WIDTH, kShowViewHeight);
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.show_GFView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        self.show_GFView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)startClick:(UIButton *)sender {
    
    if (self.startBlock) {
        self.startBlock();
    }
}

#pragma mark - CyCle left
- (void)requestList {
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    [LKLiveHandler executeGetGiftTaskWithSuccess:^(id obj) {
        if (![obj isKindOfClass:[NSDictionary class]]) return;
        
        if ([obj[@"status"] integerValue] == 200) {
            [self endProgress];
            NSDictionary *object = obj[@"message"];
            NSArray *keys = @[@"type1", @"type2", @"type4", @"type5", @"type6", @"type49"];
            
            for (NSString *type in keys)
            {
                [self.resultItems addObjectsFromArray:[LKGiftModel mj_objectArrayWithKeyValuesArray:object[type][@"list"]]];
            }
            self.pageControl.numberOfPages = self.resultItems.count;
            [self.collectionView reloadData];
            
        }else {
            
            [self endProgress];
        }
        
    } failed:^(id obj) {
        
        [self endProgress];
    }];
}

- (void)endProgress {
    
    [MBProgressHUD hideHUDForView:self.collectionView animated:YES];
}

#pragma mark - UICollectionView Delegate && data
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.resultItems.count;
}

//每组返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.resultItems[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([self.resultItems[indexPath.section] count] > indexPath.row)
    {
        cell.model = self.resultItems[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.resultItems[indexPath.section] count] > indexPath.row)
    {
        LKGiftModel *model = self.resultItems[indexPath.section][indexPath.row];
        __weak typeof(self) weakSelf = self;
        self.startBlock = ^{
            [weakSelf showAnima:model];
        };
    }
}

- (void)showAnima:(LKGiftModel *)model {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(startAnimaView:DidSelectItem:)]) {
        
        [self.delegate startAnimaView:self DidSelectItem:model];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(itemW, itemH);
}

// 该方法是设置一个section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width   = SCREEN_WIDTH;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / width; //获取索引值
    if (offsetX <= 0) {
        self.pageControl.currentPage = 1;
    }
    
    //切换索引
    self.pageControl.currentPage = index;
}

@end
