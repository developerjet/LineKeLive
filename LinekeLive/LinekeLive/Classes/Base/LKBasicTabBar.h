//
//  LKBasicTabBar.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LKTabBarItemType) {
    LKItemTypeLaunch = 10,  //启动直播
    LKItemTypeLive   = 100, //展示直播
    LKItemTypeMine,         //我的
};

@class LKBasicTabBar;
typedef void(^TabBarBlock)(LKBasicTabBar *tabBar, LKTabBarItemType itemIndex);

@protocol LKBasicTabBarDelegate <NSObject>
@required
- (void)tabBar:(LKBasicTabBar *)tabBar didSelectItemIndex:(LKTabBarItemType)index;

@end

@interface LKBasicTabBar : UIView

@property (nonatomic, weak) id<LKBasicTabBarDelegate> delegate;

@property (nonatomic, copy) TabBarBlock block;

@end
