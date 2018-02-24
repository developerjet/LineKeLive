//
//  LKMeHeaderView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kMeHeaderDidStatus) {
    kMeHeaderDidStatus_Left = 1000,
    kMeHeaderDidStatus_Right
};

@interface LKMeHeaderView : UIView

/** 顶部点击回调 */
@property (nonatomic, copy) void(^DidFinishedBlock)(kMeHeaderDidStatus status);

@end
