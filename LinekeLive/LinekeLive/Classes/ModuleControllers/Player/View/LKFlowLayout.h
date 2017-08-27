//
//  LKFlowLayout.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKFlowLayout : UICollectionViewFlowLayout

/**
 多少列
 */
@property (nonatomic, assign) NSInteger cols;


/**
 多少行
 */
@property (nonatomic, assign) NSInteger rows;

@end
