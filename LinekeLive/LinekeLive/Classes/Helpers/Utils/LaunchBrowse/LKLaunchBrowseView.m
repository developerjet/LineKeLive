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

@interface LKLaunchBrowseView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSArray           *imageGroups; // 设置加载广告图片数组
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UIButton          *timerButton; //可自定义样式
@property (nonatomic, strong) UIButton          *jumpButton;
@property (nonatomic, strong) UIImage           *savedImage;
@property (nonatomic, strong) UIImageView       *currentImageView;
@property (nonatomic, assign) BOOL              isCancel;

@end

@implementation LKLaunchBrowseView

#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - Life Cycle
- (instancetype)initWithConfigImageGroups:(NSArray *)imageGroups isCache:(BOOL)isCache {
    
    if (self = [super init]) {
        self.alpha = 0.0; //默认不显示
        self.backgroundColor = [UIColor blackColor];
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
        if (isCache) {
            if ([self isExited]) { //如果已缓存(直接从缓存取)
                self.imageGroups = [self filedImages];
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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
    self.timerButton.layer.cornerRadius = 12.0;
    self.timerButton.layer.masksToBounds = YES;
    self.timerButton.hidden = self.imageGroups.count == 1 ? NO : YES;
    self.timerButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.65];
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
    //[self addSubview:self.jumpButton];
    
    // 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    // 长按手势
    UILongPressGestureRecognizer *longGtr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    longGtr.minimumPressDuration = 1.f;
    [self.collectionView addGestureRecognizer:longGtr];
    
    _currentImageView = [[UIImageView alloc] initWithFrame:self.collectionView.bounds];
    _currentImageView.hidden = YES;
    [self addSubview:_currentImageView];
    
    if (self.imageGroups.count == 1) { //如果是单张图片
        [self startTimer]; // 开启倒计时
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    
    if (self.isCancel) {
        [self dismiss];
    }
}

- (void)longAction:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
        NSString *imagePath = [NSString stringWithFormat:@"%@", self.imageGroups[[indexPath item]]];
        if ([imagePath containsString:@"http"] || [imagePath containsString:@"https"]) {
            [_currentImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            _savedImage = _currentImageView.image;
        }else {
            _savedImage = [UIImage imageNamed:imagePath];
        }
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil, nil];
        [sheet showInView:self];
    }
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [self  performSelector:@selector(beginSave) withObject:nil afterDelay:0.25];
    }
}

- (void)beginSave {
    
    [self saveBrowIsImage:_savedImage];
}

- (void)saveBrowIsImage:(UIImage *)image {
    
    if (image) {
        NSLog(@"saveImage");
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil;
    if(error != NULL) {
        msg = @"保存图片失败";
    }else {
        msg = @"图片保存成功";
    }
    [XDProgressHUD showHUDWithText:msg hideDelay:1.0];
}

#pragma mark - <Setters && Getters>
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    [self.jumpButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - filed images
//展示广告
- (NSArray *)filedImages {
    
    return [NSArray arrayWithContentsOfFile:[self filePath]];
}

//下载缓存
- (void)cacheImages {
    
    [self.imageGroups writeToFile:[self filePath] atomically:YES];
}

- (NSString *)filePath {
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [cachePaths lastObject];
    NSString *imagesPath = [document stringByAppendingPathComponent:@"browse.plist"];
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
    if (self.browseFinishedBlock) {
        self.browseFinishedBlock();
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.timerButton.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnH = 24;
    CGFloat btnW = 56;
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
    self.isCancel = index == self.imageGroups.count-1 ? YES : NO; //浏览到最后一张点击事件生效
    
    if (offsetX <= 0) {
        [self.pageControl setCurrentPage:0];
    }
    [self.pageControl setCurrentPage:index];
}

@end

