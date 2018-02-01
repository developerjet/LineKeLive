//
//  LKCacheData.h
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKCacheData : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger oldCount; //记录上次动画结束时礼物总数
@property (nonatomic, strong) NSString *giftName;

+ (LKCacheData *)createDataWithDate:(NSDate *)date Count:(NSInteger)count GiftName:(NSString *)giftName;

@end
