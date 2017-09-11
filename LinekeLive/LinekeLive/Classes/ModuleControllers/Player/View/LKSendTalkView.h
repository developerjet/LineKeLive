//
//  LKSendTaskView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/17.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTalkModel.h"

@interface LKSendTalkView : UIView

@property (nonatomic, strong) LKTalkModel *talkModel;


/**
 是否拖拽了列表
 */
@property (nonatomic, copy) void(^isDraggBlock)();

@end
