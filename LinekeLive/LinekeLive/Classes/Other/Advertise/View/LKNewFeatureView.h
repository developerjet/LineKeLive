//
//  LKAdvertiseView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKNewFeatureView : UIView

/**
 自定义广告页展示(单张&多张广告页)

 @param urlStringGroups 图片数组
 @param isCache 是否开启缓存
 @return 广告页
 */
- (instancetype)initWithConfigUrlStringGroups:(NSArray *)urlStringGroups
                                      isCache:(BOOL)isCache;

/** 阅读完成时回调 */
@property (nonatomic, copy) void(^readFinishedBlock)();

- (void)show;
- (void)dismiss;

@end
