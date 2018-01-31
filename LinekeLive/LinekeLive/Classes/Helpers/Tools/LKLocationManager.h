//
//  LKLocationManager.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationFinishedBlock)(NSString *lat, NSString *lon);

@interface LKLocationManager : NSObject

+ (instancetype)sharedManager;

/**
 获取当前经纬度
 */
- (void)achieveLocation:(LocationFinishedBlock)locationBlock;


/**
 获取经度
 */
@property (nonatomic, copy) NSString *latitude;


/**
 获取纬度
 */
@property (nonatomic, copy) NSString *longitude;


/** 
 获取当前定位城市 
 */
@property (nonatomic, copy) NSString *city;

@end
