//
//  LKRefreshGifHeader.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/30.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKRefreshGifHeader.h"
#import "UIImage+Additions.h"

@implementation LKRefreshGifHeader

#pragma mark - 重写父类方法
#pragma mark - 基本设置
- (void)prepare
{
    [super prepare];
    
    // 隐藏设置
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.automaticallyChangeAlpha = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSInteger i = 1; i <= 29; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%ld", i]];
        UIImage *newImage = [image imageFixImageViewSize:CGSizeMake(40, 40)];
        [idleImages addObject:newImage];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置正在刷新的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSInteger i = 9; i <= 21; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_fly_%ld", i]];
        UIImage *newImage = [image imageFixImageViewSize:CGSizeMake(40, 40)];
        [refreshingImages addObject:newImage];
    }
    
    // 设置进行刷新的状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
}

@end
