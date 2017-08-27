//
//  LKCacheHelper.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLiveModel.h"

@interface LKCacheHelper : NSObject

+ (instancetype)shared;

@property (nonatomic, strong, readonly) NSMutableArray *allAnchorMs;

/**
 获取广告链接地址
 */
+ (NSString *)getAdvertise;


/**
 存储广告链接地址
 */
+ (void)setAdvertiseWithURL:(NSString *)url;


/**
 取消关注主播

 @param ancher 主播信息
 */
- (void)unFollowAnchor:(LKLiveModel *)ancher;

/**
 关注主播

 @param ancher 主播信息
 */
- (void)followAnchor:(LKLiveModel *)ancher;

/**
 是否已关注
 */
- (BOOL)getAncherIsFollow:(LKLiveModel *)ancher;

@end
