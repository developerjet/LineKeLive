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
    CGFloat length = [UIScreen mainScreen].bounds.size.width / kEmojiColumnCount;
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
    
    if (!_emojiAssets) {
        NSArray *emojis = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"]];
        _emojiAssets = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < emojis.count; i++) {
            [_emojiAssets addObjectsFromArray:emojis[i]];
        }
    }
    return _emojiAssets;
}

@end
