
//
//  LKLiveHandler.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBaseHandler.h"

@interface LKLiveHandler : LKBaseHandler


/**
 获取热门直播信息
 */
+ (void)executeGetHotLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed;

/**
 获取附近的人直播信息
 */
+ (void)executeGetNearLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed;

/**
 获取搜索界面主播信息
 */
+ (void)executeGetSearchListTaskWithSuccess:(successBlock)success failed:(failedBlock)failed;

/**
 获取礼物的数据
 */
+ (void)executeGetGiftTaskWithSuccess:(successBlock)success failed:(failedBlock)failed;

/**
 获取广告页
 */
+ (void)executeGetAdvertTaskWithSuccess:(successBlock)success failed:(failedBlock)failed;


@end
