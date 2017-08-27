//
//  LKDanmuModelProtocol.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LKDanmuModelProtocol;

@protocol LKDanmuModelProtocol <NSObject>

@required
/** 弹幕的开始时间 */
@property (nonatomic, readonly) NSTimeInterval beginTime;

/** 弹幕的存活时间 */
@property (nonatomic, readonly) NSTimeInterval liveTime;


@end
