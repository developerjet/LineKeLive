//
//  LKCacheData.m
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKCacheData.h"

@implementation LKCacheData

+ (LKCacheData *)createDataWithDate:(NSDate *)date Count:(NSInteger)count GiftName:(NSString *)giftName {
    
    LKCacheData *data = [LKCacheData new];
    data.date = date;
    data.count = count;
    data.giftName = giftName;
    data.oldCount = 0;
    
    return data;
}

@end
