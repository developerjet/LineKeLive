//
//  LKShareView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/19.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kActivityStatus) {
    kActivityStatus_QQ = 1000,
    kActivityStatus_WeiChat ,
    kActivityStatus_TimeLine,
    kActivityStatus_SMS,
    kActivityStatus_CopyLink,
};

@interface LKShareActivityView : UIView

///---------------------
/// @name show && dismiss
///---------------------
- (void)show;
- (void)dismiss;

/** 设置分享控件 */
- (instancetype)initWithConfigActivitys:(NSArray *)activitys;

/** 自定义分享样式数组 */
@property (nonatomic, strong) NSArray *activitys;

@end
