//
//  LKGiftSendView.h
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKGiftData.h"
#import "LKGiftCore.h"

/******************************* LKGiftViewShakeLabel *******************************/

typedef void(^ShakeLabelCompleteBlock)(void);

@interface LKGiftViewShakeLabel : UILabel

/**
 动画时间
 */
@property (nonatomic, assign) NSTimeInterval duration;


/**
 描边颜色
 */
@property (nonatomic, strong) UIColor *borderColor;


/**
 礼物数字显示
 */
@property (nonatomic, assign) NSInteger number;

- (void)startAnimWithDuration:(NSTimeInterval)duration CompleteBlock:(ShakeLabelCompleteBlock)complete;

@end


/******************************* LKGiftSendView *******************************/

typedef void(^CompleteBlock)(BOOL finished, NSInteger finishCount);

@interface LKGiftSendView : UIView

@property (nonatomic, strong) UIImageView *deviceImageView; //终端设备图标
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *giftImageView; //礼物图标

@property (nonatomic, strong) UILabel *senderNameLabel; //送礼物者
@property (nonatomic, strong) UILabel *giftNameLabel; //送礼物者


@property (nonatomic, strong) LKGiftViewShakeLabel *shakeLabel;
@property (nonatomic, assign) NSInteger animCount; //动画执行到了第几次
@property (nonatomic, assign) NSInteger oldAnimCount; //上次动画执行到了第几次
@property (nonatomic, assign) CGRect originFrame; //记录原始坐标
@property (nonatomic, strong) NSString *identifier; //缓存池标识

@property (nonatomic, strong) LKGiftData *data;


+ (LKGiftSendView *)createInView:(UIView *)inView Count:(NSInteger)count OldCount:(NSInteger)oldCount Identifier:(NSString *)identifier;


/**
 视图切换

 index=1：第一视图
 index=2：第二视图，动画位置不变
 */
- (void)animateWithCompleteBlock:(CompleteBlock)complete Index:(NSInteger)index;

@end
