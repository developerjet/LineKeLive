//
//  LKGiftModel.h
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKGiftData : NSObject

/**
 设备类型(1.手机 2.电脑)
 */
@property (nonatomic, copy) NSString *deveiceType;

/**
 发送者名称
 */
@property (nonatomic, copy) NSString *senderName;


/**
 礼物名称
 */
@property (nonatomic, copy) NSString *giftName;


/**
 发送者头像
 */
@property (nonatomic, copy) NSString *giftIcon;


@end
