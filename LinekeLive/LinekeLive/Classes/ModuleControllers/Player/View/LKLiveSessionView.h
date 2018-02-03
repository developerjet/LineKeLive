//
//  LKSendTaskView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/17.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKSessionModel.h"

@interface LKLiveSessionView : UIView
@property (nonatomic, strong) LKSessionModel *session;
@property (nonatomic, copy) void(^isDraggBlock)();

@end
