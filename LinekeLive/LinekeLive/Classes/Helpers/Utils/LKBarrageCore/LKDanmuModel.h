//
//  LKDanmuModel.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDanmuModelProtocol.h"

@interface LKDanmuModel : NSObject<LKDanmuModelProtocol>

/** 弹幕的开始时间 */
@property (nonatomic, assign) NSTimeInterval beginTime;

/** 弹幕的存活时间 */
@property (nonatomic, assign) NSTimeInterval liveTime;

@property (nonatomic, copy) NSString *content;

@end
