//
//  LKFlowLayout.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKFlowLayout.h"

static CGFloat margin = 10;
static CGFloat maxW = 0;

@interface LKFlowLayout()

@property (nonatomic, strong) NSMutableArray *attributeMs;



@end

@implementation LKFlowLayout

#pragma mark - lazy

- (NSMutableArray *)attributeMs {
    
    if (!_attributeMs) {
        _attributeMs = [[NSMutableArray alloc] init];
    }
    return _attributeMs;
}

#pragma mark - initialize

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal; //设置横向滚动
        self.minimumLineSpacing = margin/2;
        self.minimumInteritemSpacing = margin/2;
        self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        self.cols = 2;
        self.rows = 1;
    }
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self setItemSize:self.cols withRows:self.rows];
}

- (void)setItemSize:(NSInteger)cols withRows:(NSInteger)rows {
    
    CGFloat itemW = self.collectionView.bounds.size.width -
                    self.sectionInset.left -
                    self.sectionInset.right -
                    ((((CGFloat)cols - 1) * self.minimumInteritemSpacing) / (CGFloat)cols);
    
    CGFloat itemH = self.collectionView.bounds.size.height -
                    self.sectionInset.top -
                    self.sectionInset.bottom -
                    ((((CGFloat)rows - 1) * self.minimumLineSpacing) / (CGFloat)rows);
    
    // 1.获取数据的多少组
    NSInteger sectionCount = self.collectionView.numberOfSections;
    
    // 2.给每组数组布局
    NSInteger pageNum = 0;
    
    for (NSInteger section=0; section<sectionCount; section++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item=0; item<itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attrMs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            NSInteger page = item / (cols * rows);
            NSInteger index = item % (cols * rows);
            
            CGFloat cellX = self.sectionInset.left + ((CGFloat)(index % rows) * (itemW + self.minimumInteritemSpacing)) + self.collectionView.bounds.size.width * (CGFloat)(page + pageNum);
            CGFloat cellY = self.sectionInset.top + (CGFloat)(index * cols) * (itemH + self.minimumLineSpacing);
            
            attrMs.frame = CGRectMake(cellX, cellY, itemW, itemH);
            
            [self.attributeMs addObject:attrMs];
            
            NSInteger sectionNum = (itemCount - 1) / (cols * rows) + 1;
            
            pageNum += sectionNum;
        }
    }
    
    // 3.计算最大width
    maxW = (pageNum) * self.collectionView.bounds.size.width;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.attributeMs[indexPath.item];
}

- (CGSize)collectionViewContentSize {
    [super collectionViewContentSize];
    
    return CGSizeMake(maxW, 0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return NO;
}

@end
