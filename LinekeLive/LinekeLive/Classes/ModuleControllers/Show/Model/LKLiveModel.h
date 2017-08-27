//
//  LKLiveModel.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKCreatorModel.h"
#import "LKExtra.h"

@interface LKLiveModel : NSObject

@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) LKCreatorModel * creator;
@property (nonatomic, strong) LKExtra * extra;
@property (nonatomic, assign) NSInteger group;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) NSInteger landscape;
@property (nonatomic, strong) NSArray * like;
@property (nonatomic, assign) NSInteger link;
@property (nonatomic, strong) NSString * liveType;
@property (nonatomic, assign) NSInteger multi;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger onlineUsers;
@property (nonatomic, assign) NSInteger optimal;
@property (nonatomic, assign) NSInteger pubStat;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger rotate;
@property (nonatomic, strong) NSString * shareAddr;
@property (nonatomic, assign) NSInteger slot;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * streamAddr;
@property (nonatomic, strong) NSString * tagId;
@property (nonatomic, strong) NSString * token;
@property (nonatomic, assign) NSInteger version;

@property (nonatomic, copy) NSString *distance;

/** 是否已经关注 */
@property (nonatomic, assign) BOOL follow;

/** 区分动画展 */
@property (nonatomic, getter=isShow) BOOL show;

@end
