//
//  LKMainTopView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidFinishedBlock)(NSInteger index);

@interface LKItemSegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame segmentItems:(NSArray *)items;

- (void)scrolling:(NSInteger)index;

/** 点击菜单标题的回调 */
@property (nonatomic, copy) DidFinishedBlock didFinishedBlock;
/** 菜单栏主题颜色设置(默认白色) */
@property (nonatomic, strong) UIColor *subviewColor;

@end
