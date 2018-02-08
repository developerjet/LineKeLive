//
//  LKEmojiKeyBoardFlowLayout.m
//  LinekeLive
//
//  Created by CoderTan on 2018/2/7.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKEmojiKeyBoardFlowLayout.h"

@implementation LKEmojiKeyBoardFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *att in attributes) {
        CGSize size = att.size;
        NSInteger page = att.indexPath.section;
        CGFloat x = (att.indexPath.row % kEmojiColumnCount) * size.width + page * self.collectionView.frame.size.width;
        CGFloat y = ((att.indexPath.row / kEmojiColumnCount) % kEmojiRowCount) * size.height;
        CGRect frame = att.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        att.frame = frame;
    }
    return attributes;
}

@end
