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
typedef NS_ENUM(NSUInteger, LKPlayRoomTaskType) {
    LKPlayRoomTaskSendChat = 1000,
    LKPlayRoomTaskMessage,
    LKPlayRoomTaskSendGift,
    LKPlayRoomTaskOpenShare,
};

@class LKLiveRoomViewController;

@protocol LKLiveRoomViewControllerDelegate <NSObject>

- (void)roomViewControllerDelegate:(LKLiveRoomViewController *)controller didSelectItemType:(LKPlayRoomTaskType)itemType;

@end

@interface LKLiveRoomViewController : LKHasNavViewController

@property (nonatomic, weak) id <LKLiveRoomViewControllerDelegate> delegate;

@property (nonatomic, strong) LKLiveModel *model;

@end
