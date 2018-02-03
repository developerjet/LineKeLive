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
#import "LKFlowLayout.h"
#import "LKGiftModel.h"

#define margin  10
static NSString *const GitfIdentifier = @"GiftCell";
static CGFloat contentHeight = 220.f;

static int const cols = 4;
#define itemW   (SCREEN_WIDTH-(cols+1)*margin)/cols
#define itemH   81

@interface LKGiftListView()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *show_BGView; //背景视图
@property (nonatomic, strong) UIView *show_GFView; //礼物展示区域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl; /** >索引< **/
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation LKGiftListView

#pragma mark - Lazy
- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        CGRect fm = CGRectMake(0, contentHeight-20, SCREEN_WIDTH, 20);
        _pageControl = [[UIPageControl alloc] initWithFrame:fm];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return _pageControl;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        //流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = margin/2;
        layout.minimumInteritemSpacing = margin/2;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.show_GFView.bounds collectionViewLayout:layout];
        _collectionView.bounces  = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"LKGiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:GitfIdentifier];
    }
    return _collectionView;
}

#pragma mark - initialize
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
    
    self.show_GFView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0)];
    self.show_GFView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.show_GFView];
    
    [self.show_GFView addSubview:self.collectionView];
    
    [self.show_GFView addSubview:self.pageControl];
    
    [self addGiftList];
}

#pragma mark - animate
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.show_GFView.frame = CGRectMake(0, SCREEN_HEIGHT-contentHeight, SCREEN_WIDTH, contentHeight);
        self.collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.show_GFView.frame.size.height-20);
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

#pragma mark - net
- (void)addGiftList {
    
    [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    [LKLiveHandler executeGetGiftTaskWithSuccess:^(id obj) {
        if (![obj isKindOfClass:[NSDictionary class]]) return;
        
        if ([obj[@"status"] integerValue] == 200) {
            [self endProgress];
            
            NSDictionary *dictionaryMs = obj[@"message"];
            self.dataSource = @[[LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type1"][@"list"]],
                                [LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type2"][@"list"]],
                                [LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type4"][@"list"]],
                                [LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type5"][@"list"]],
                                [LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type6"][@"list"]],
                                [LKGiftModel mj_objectArrayWithKeyValuesArray:dictionaryMs[@"type49"][@"list"]]];
        
            
            self.pageControl.numberOfPages = [self.dataSource count];
            
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

#pragma mark - delegate && data

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataSource.count;
}

//每组返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LKGiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GitfIdentifier forIndexPath:indexPath];
    if ([self.dataSource[indexPath.section] count] > indexPath.row) {
        cell.model = self.dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataSource[indexPath.section] count] > indexPath.row) {
        LKGiftModel *model = self.dataSource[indexPath.section][indexPath.row];
        [self sendGiftIsMd:model];
    }
}

- (void)sendGiftIsMd:(LKGiftModel *)model {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendGiftListViewDelegate:DidSelectItem:)]) {
        
        [self.delegate sendGiftListViewDelegate:self DidSelectItem:model];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(itemW, itemH);
}

// 该方法是设置一个section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // 注意，这里默认会在top有+64的边距，因为状态栏+导航栏是64.
    // 因为我们常常把[[UIScreen mainScreen] bounds]作为CollectionView的区域，所以苹果API就默认给了+64的EdgeInsets，这里其实是一个坑，一定要注意。
    // 这里我暂时不用这个边距，所以top减去64
    // 所以这是就要考虑你是把Collection从屏幕左上角(0,0)开始放还是(0,64)开始放。
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width   = SCREEN_WIDTH;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //获取索引值
    NSInteger index = offsetX / width;
    
    if (offsetX <= 0) {
        self.pageControl.currentPage = 1;
    }
    
    //切换索引
    self.pageControl.currentPage = index;
    //NSLog(@"offsetX：%f", offsetX);
}

@end
