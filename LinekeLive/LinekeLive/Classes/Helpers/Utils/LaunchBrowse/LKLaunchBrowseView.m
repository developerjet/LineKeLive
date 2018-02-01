//
//  LKAdvertiseView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLaunchBrowseView.h"
#import "LKLaunchBrowseCell.h"

static NSInteger showtime = 3.0;
static NSString  *const kCacheImagesKey  = @"kCacheImagesKey";
static NSString  *const kReuseIdentifier = @"kCellReuseIdentifier";

@interface LKLaunchBrowseView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSArray           *imageGroups; // 设置加载广告图片数组
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UIButton          *timerButton;
@property (nonatomic, strong) UIButton          *jumpButton;

@end

@implementation LKLaunchBrowseView

#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - init Configs
- (instancetype)initWithConfigImageGroups:(NSArray *)imageGroups isCache:(BOOL)isCache {
    
    if (self = [super init]) {
        self.alpha = 0.0; //默认不显示
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
        if (isCache) {
            if ([self isExited]) { //如果已缓存(直接从缓存取)
                self.imageGroups = [self showImages];
            }else {
                self.imageGroups = imageGroups;
                [self cacheImages];
            }
        }else {
            self.imageGroups = imageGroups;
        }
        
        [self configSubviews];
    }
    return self;
}

- (void)configSubviews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO; //关闭弹簧效果
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[LKLaunchBrowseCell class] forCellWithReuseIdentifier:kReuseIdentifier];
    [self addSubview:_collectionView];
    
    self.timerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.timerButton.layer.cornerRadius = 3.0;
    self.timerButton.layer.masksToBounds = YES;
    self.timerButton.hidden = self.imageGroups.count == 1 ? NO : YES;
    self.timerButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.timerButton setTitle:[NSString stringWithFormat:@"%zds跳过",showtime] forState:UIControlStateNormal];
    [self.timerButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.timerButton];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.hidden = self.imageGroups.count > 1 ? NO : YES;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.numberOfPages = self.imageGroups.count;
    [self addSubview:self.pageControl];
    
    self.jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.jumpButton setTitle:@"开启APP" forState:UIControlStateNormal];
    [self.jumpButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.jumpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.jumpButton.layer.borderColor = [UIColor redColor].CGColor;
    self.jumpButton.layer.cornerRadius = 20;
    self.jumpButton.hidden = YES;
    self.jumpButton.layer.borderWidth = 1.5;
    self.jumpButton.layer.masksToBounds = YES;
    [self.jumpButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.jumpButton];
    
    if (self.imageGroups.count == 1) { //如果是单张图片
        [self startTimer]; // 开启倒计时
    }
}

#pragma mark - filed image
//展示广告
- (NSArray *)showImages {
    
    return [NSArray arrayWithContentsOfFile:[self filePath]];
}

//下载缓存
- (void)cacheImages {
    
    [self.imageGroups writeToFile:[self filePath] atomically:YES];
}

- (NSString *)filePath {
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [cachePaths lastObject];
    NSString *imagesPath = [document stringByAppendingPathComponent:@"images.plist"];
    return imagesPath;
}

//判断图片是否存在
- (BOOL)isExited {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
}

#pragma mark - timer
- (void)startTimer {
    
    __block NSUInteger timerOut = showtime + 1;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timerOut <= 0) {
            dispatch_source_cancel(_timer); //倒计时结束，关闭
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismiss];
            });
            
        }else {
            // 主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.timerButton setTitle:[NSString stringWithFormat:@"%zds跳过",timerOut] forState:UIControlStateNormal];
            });
            timerOut--;
        }
    });
    
    dispatch_resume(timer);
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.timerButton.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (self.readFinishedBlock) {
        self.readFinishedBlock();
    }
}

#pragma mark -
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnH = 32;
    CGFloat btnW = 68;
    CGFloat btnX = self.frame.size.width - btnW - 20;
    CGFloat btnY = 30;
    
    self.collectionView.frame = self.frame;
    self.timerButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 20);
    self.jumpButton.frame = CGRectMake((self.frame.size.width-140)/2, self.frame.size.height - 120, 140, 40);
}

#pragma mark - UICollection data && delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LKLaunchBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.imagePath = self.imageGroups[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

#pragma mark - ScrollViewViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / [UIScreen mainScreen].bounds.size.width;
    _jumpButton.hidden = index == self.imageGroups.count-1 ? NO : YES;
    
    if (offsetX <= 0) {
        [self.pageControl setCurrentPage:0];
    }
    [self.pageControl setCurrentPage:index];
}

@end

