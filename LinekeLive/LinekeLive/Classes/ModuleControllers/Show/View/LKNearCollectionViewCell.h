//
//  LKNearCollectionViewCell.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLiveModel.h"

@interface LKNearCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) LKLiveModel *model;

- (void)showAnimate;

@end
