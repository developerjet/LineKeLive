//
//  LKBaseHandler.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 处理完成事件
 */
typedef void(^completeBlock)();



/**
 处理时间成功

 @param obj 返回成功数据
 */
typedef void(^successBlock)(id obj);



/**
 处理事件失败

 @param obj 错误数据
 */
typedef void(^failedBlock)(id obj);

@interface LKBaseHandler : NSObject

@end
