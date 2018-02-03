//
//  LKLiveChatViewController.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHasNavViewController.h"
#import "LKLiveModel.h"

/**
 底部点击类型
 */
typedef NS_ENUM(NSUInteger, LKPlayerEventStatus) {
    LKPlayerEventStatus_Session = 1000, //聊天
    LKPlayerEventStatus_Message, //私聊
    LKPlayerEventStatus_GiveGift, //送礼物
    LKPlayerEventStatus_Activity //分享
};

@class LKLiveRoomViewController;

@protocol LKLiveRoomControllerDelegate <NSObject>
@optional
- (void)livePlayerRoomCtrl:(LKLiveRoomViewController *)roomCtrl didSelectStatus:(LKPlayerEventStatus)status;

@end

@interface LKLiveRoomViewController : LKHasNavViewController
@property (nonatomic, weak) id <LKLiveRoomControllerDelegate> delegate;
@property (nonatomic, strong) LKLiveModel *model;

@end
