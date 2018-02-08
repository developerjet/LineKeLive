//
//  LKMeHeaderView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKMeHeaderView : UIView

/** 顶部点击回调 */
@property (nonatomic, weak) void(^DidFinishedBlock)(NSInteger index);

@end
