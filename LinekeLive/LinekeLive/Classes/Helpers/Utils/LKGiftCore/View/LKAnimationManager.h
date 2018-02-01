//
//  LKAnimationManager.h
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKAnimation.h"
#import "LKGiftCore.h"
#import "LKCacheData.h"

@interface LKAnimationManager : NSObject

@property (nonatomic, strong) UIView *parentView;

//单利
+ (instancetype)manager;


/**
 取消所有队列操作
 */
- (void)cancelAllOperations;


/**
 动画操作：需要userID和回调
 */
- (void)animWithData:(LKGiftData *)data finishedBlock:(void(^)(BOOL result))finishedBlock;


@end
