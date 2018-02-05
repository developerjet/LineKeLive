//
//  LKGiftListView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/6.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKGiftModel, LKGiftListView;

typedef void(^StartFinishedBlock)(void);

@protocol LKGiftListViewDelegate <NSObject>
@optional
- (void)startAnimaView:(LKGiftListView *)view DidSelectItem:(LKGiftModel *)model;

@end

@interface LKGiftListView : UIView

/** 展示礼物列表 */
- (void)show;
/** 关闭礼物列表 */
- (void)dismiss;

/** delegate */
@property (nonatomic, weak) id<LKGiftListViewDelegate> delegate;

@property (nonatomic, copy) StartFinishedBlock  startBlock;

@end
