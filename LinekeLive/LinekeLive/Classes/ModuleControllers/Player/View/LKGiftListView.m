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

#define kMargin  10
#define kMaxCols 4
#define kItemWidth   (SCREEN_WIDTH-(kMaxCols+1)*kMargin) / kMaxCols
#define kItemHeight  80

static NSInteger kRowCount    = 2;
static NSInteger kColumnCount = 4;
static NSString *kCellIdentifier = @"CellFromIdentifier";

@interface LKGiftListFlowLayout : UICollectionViewFlowLayout

@end

@implementation LKGiftListFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *att in attributes) {
        CGSize size = att.size;
        NSInteger page = att.indexPath.section;
        CGFloat x = (att.indexPath.row % kColumnCount) * size.width + page * self.collectionView.frame.size.width;
        CGFloat y = ((att.indexPath.row / kColumnCount) % kRowCount) * size.height;
        CGRect frame = att.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        att.frame = frame;
    }
    return attributes;
}

@end

@interface LKGiftListView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *show_BGView; //背景视图
@property (nonatomic, strong) UIView *show_GFView; //礼物展示区域
@property (nonatomic, strong) UIButton         *startButton;
@property (nonatomic, strong) UIPageControl    *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *resultItems;
@property (nonatomic, strong) NSArray          *objectKeys;

@end

@implementation LKGiftListView

#pragma mark -
#pragma mark - Lazy
- (NSArray *)objectKeys {
    
    if (!_objectKeys) {
        _objectKeys = @[@"type1", @"type2", @"type4", @"type5", @"type6", @"type49"];
    }
    return _objectKeys;
}

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
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = kMargin;
        layout.minimumInteritemSpacing = kMargin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kShowListHeight) collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"LKGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    }
    return _collectionView;
}

#pragma mark - Life Cycle
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
    NSMutableArray *temp = [NSMutableArray new];
    
    [LKLiveHandler executeGetGiftTaskWithSuccess:^(id obj) {
        if (![obj isKindOfClass:[NSDictionary class]]) return;
        
        if ([obj[@"status"] integerValue] == 200) {
            [self endProgress];
            NSDictionary *object = obj[@"message"];
            for (NSString *type in self.objectKeys)
            {
                [temp addObjectsFromArray:[LKGiftModel mj_objectArrayWithKeyValuesArray:object[type][@"list"]]];
            }
            // 拆分数组
            [self.resultItems addObjectsFromArray:[self splitArray:temp withSubSize:8]];
            if (self.resultItems.count) {
                [self.resultItems removeObjectAtIndex:self.resultItems.count-1];
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

#pragma mark - <UICollectionViewData && Delegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.resultItems.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.resultItems[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if ([self.resultItems[indexPath.section] count] > indexPath.row) {
        cell.model = self.resultItems[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf;
    if ([self.resultItems[indexPath.section] count] > indexPath.row) {
        LKGiftModel *model = self.resultItems[indexPath.section][indexPath.row];
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
    return CGSizeMake(kItemWidth, kItemHeight);
}

// 该方法是设置一个section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin);
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

#pragma mark - 拆分数组
/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}



@end
