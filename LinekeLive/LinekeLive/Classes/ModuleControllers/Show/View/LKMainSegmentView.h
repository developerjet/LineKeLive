//
//  LKMainTopView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MainTopBlock)(NSInteger index);

@interface LKMainSegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titleNemas;

- (void)scrolling:(NSInteger)index;

@property (nonatomic, copy) MainTopBlock topBlock;

@end
