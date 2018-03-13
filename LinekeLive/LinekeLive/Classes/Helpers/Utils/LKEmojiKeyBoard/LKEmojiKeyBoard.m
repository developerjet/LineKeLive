//
//  EmojiManagerView.m
//  LinekeLive
//
//  Created by CoderTan on 2018/2/6.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKEmojiKeyBoard.h"
#import "LKEmojiKeyBoardFlowLayout.h"
#import "LKEmojiKeyBoardLabelCell.h"
#import "LKEmojiKeyBoardImageCell.h"

static  NSString *kEmojiLabelCellIdentifier = @"LKEmojiKeyBoardLabelCell";
static  NSString *kEmojiImageCellIdentifier = @"LKEmojiKeyBoardImageCell";

@interface LKEmojiKeyBoard()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray   *emojiAssets;
@property (nonatomic, strong) UICollectionView *emojiCollectionView;

@end

@implementation LKEmojiKeyBoard

#pragma mark - Life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
        [self adjustLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LKEmojiKeyBoardDelegate>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        [self initSubviews];
        [self adjustLayout];
    }
    return self;
}

- (void)initSubviews {
    
    LKEmojiKeyBoardFlowLayout *emojiLayout = [[LKEmojiKeyBoardFlowLayout alloc] init];
    emojiLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    emojiLayout.sectionInset = UIEdgeInsetsZero;
    
    _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:emojiLayout];
    _emojiCollectionView.delegate = self;
    _emojiCollectionView.dataSource = self;
    _emojiCollectionView.pagingEnabled = YES;
    _emojiCollectionView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
    [_emojiCollectionView registerClass:[LKEmojiKeyBoardLabelCell class]
             forCellWithReuseIdentifier:kEmojiLabelCellIdentifier];
    [_emojiCollectionView registerClass:[LKEmojiKeyBoardImageCell class]
             forCellWithReuseIdentifier:kEmojiImageCellIdentifier];
    _emojiCollectionView.showsVerticalScrollIndicator = NO;
    _emojiCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_emojiCollectionView];
}

- (void)adjustLayout {
    
    //CGFloat length = [UIScreen mainScreen].bounds.size.width / kEmojiColumnCount;
    CGRect emojiFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height);
    _emojiCollectionView.frame = emojiFrame;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.emojiAssets.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.emojiAssets[section] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == kEmojiRowCount * kEmojiColumnCount - 1) { //删除按钮
        LKEmojiKeyBoardImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEmojiImageCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    LKEmojiKeyBoardLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEmojiLabelCellIdentifier forIndexPath:indexPath];
    if (self.emojiAssets.count > indexPath.row) {
        NSArray *values = self.emojiAssets[indexPath.section];
        if (values.count > indexPath.row) {
            NSString *emoji = self.emojiAssets[indexPath.section][indexPath.row];
            cell.emoji = emoji;
        }
    }
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat length = ([UIScreen mainScreen].bounds.size.width / kEmojiColumnCount) - 0.05;
    return CGSizeMake(length, length);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kEmojiRowCount * kEmojiColumnCount - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyBoardEventDeleteValue)]) {
            [self.delegate emojiKeyBoardEventDeleteValue];
        }
    }

    NSArray *emojiArr = self.emojiAssets[indexPath.section];
    if (indexPath.row < [emojiArr count]) {
        NSString *emoji = emojiArr[indexPath.row];
        if (emoji.length) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyBoard:didSendEmoji:)]) {
                [self.delegate emojiKeyBoard:self didSendEmoji:emoji];
            }
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark -
#pragma mark - Lazy
- (NSMutableArray *)emojiAssets {
    int maxSize = 20;
    if (!_emojiAssets) {
        NSArray *emojis = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"]] firstObject];
        _emojiAssets = [[NSMutableArray alloc] init];
        if (emojis.count > maxSize) {
            [_emojiAssets addObjectsFromArray:[self splitArray:emojis withSubSize:maxSize]];
        }
    }
    return _emojiAssets;
}

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
