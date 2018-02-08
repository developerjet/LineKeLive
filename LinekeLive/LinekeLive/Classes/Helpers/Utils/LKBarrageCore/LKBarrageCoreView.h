//
//  LKDanmuView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBarrageModelProtocol.h"

@protocol LKDanmuViewProtocol <NSObject>

@property (nonatomic, readonly) NSTimeInterval currentTime;

@optional
- (UIView *)danmuViewWithModel:(id<LKBarrageModelProtocol>)model;

- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;

@end


@interface LKBarrageCoreView : UIView


@property (nonatomic, weak) id<LKDanmuViewProtocol> delegate;

@property (nonatomic, strong) NSMutableArray <id <LKBarrageModelProtocol>>*models;

- (void)pause;
- (void)resume;

@end
