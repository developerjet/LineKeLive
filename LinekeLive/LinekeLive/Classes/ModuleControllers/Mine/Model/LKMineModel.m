//
//  LKMineModel.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMineModel.h"

@implementation LKMineModel

+ (instancetype)initClassWithTitle:(NSString *)title detail:(NSString *)detail {
    
    LKMineModel *meModel = [[LKMineModel alloc] init];
    meModel.title  = title;
    meModel.detail = detail;
    return meModel;
}

@end
