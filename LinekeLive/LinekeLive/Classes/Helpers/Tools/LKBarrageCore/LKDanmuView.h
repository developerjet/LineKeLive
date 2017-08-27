//
//  LKDanmuView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LKDanmuModelProtocol.h"

@protocol LKDanmuViewProtocol <NSObject>

@property (nonatomic, readonly) NSTimeInterval currentTime;

- (UIView *)danmuViewWithModel:(id<LKDanmuModelProtocol>)model;


- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;

@end


@interface LKDanmuView : UIView


@property (nonatomic, weak) id<LKDanmuViewProtocol> delegate;

@property (nonatomic, strong) NSMutableArray <id <LKDanmuModelProtocol>>*models;

- (void)pause;
- (void)resume;

@end
