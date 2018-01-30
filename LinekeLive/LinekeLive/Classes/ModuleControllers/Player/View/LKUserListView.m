//
//  LKPlayerUserInfoView.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/25.
//  Copyright © 2018年 CoderTan. All rights reserved.
//

#import "LKUserListView.h"
#import "LKPlayerUserCell.h"

static NSString *kCellReuseIdentifier = @"kCellReuseIdentifier";

@interface LKUserListView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray *userList;
@end

@implementation LKUserListView

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collection.delegate   = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor clearColor];
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.showsVerticalScrollIndicator = NO;
        [_collection registerClass:[LKPlayerUserCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
        [self addSubview:_collection];
    }
    return self;
}

#pragma mark - UICollection data && delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LKPlayerUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.DidUserRowBlock) {
        self.DidUserRowBlock(indexPath.row);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

@end
