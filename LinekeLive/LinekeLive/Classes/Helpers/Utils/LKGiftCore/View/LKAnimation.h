//
//  LKGiftAnimation.h
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKGiftSendView.h"
#import "LKGiftData.h"
#import "LKGiftCore.h"

@interface LKAnimation : NSOperation

@property (nonatomic, strong) LKGiftSendView *giftView;
@property (nonatomic, strong) LKGiftData *data;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, copy) NSString *userID; //新增用户


/**
 回调参数增加了结束时礼物累计数
 */
+ (instancetype)animOperationWithUserID:(NSString *)userID
                                  Count:(NSInteger)count
                               OldCount:(NSInteger)oldCount
                                 InView:(UIView *)inView
                                   Data:(LKGiftData *)data
                          finishedBlock:(void(^)(BOOL result, NSInteger finishedCount))finishedBlock;

@end
