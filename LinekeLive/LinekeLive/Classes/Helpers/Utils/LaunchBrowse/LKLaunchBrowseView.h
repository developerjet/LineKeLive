//
//  LKAdvertiseView.h
//  LinekeLive
//
//  Created by CODER_TJ on 2017/6/27.
//  Copyright © 2017年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKLaunchBrowseView : UIView

/**
 自定义启动(广告)页展示(单张&多张广告页)

 @param imageGroups 本地&网络图片数组
 @param isCache 是否开启缓存
 @return 广告页
 */
- (instancetype)initWithConfigImageGroups:(NSArray *)imageGroups
                                      isCache:(BOOL)isCache;
/** 阅读完成时回调 */
@property (nonatomic, copy) void(^browseFinishedBlock)();
/** 跳转按钮图片设置 */
@property (nonatomic, copy) NSString *imageName;
/** 指定滚动的图片位置 */
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)show;
- (void)dismiss;

@end
