//
//  XDProgressHUD.h
//  OnlyBrother_ Seller
//
//  Created by codeTan on 16/10/23.
//  Copyright © 2016年 谭捷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDProgressHUD : NSObject

+ (void)showHUDWithText:(NSString *)text hideDelay:(NSTimeInterval)delay;

+ (void)showHUDWithLongText:(NSString *)text hideDelay:(NSTimeInterval)delay;

+ (void)showHUDWithIndeterminate:(NSString *)text;

+ (void)showHUDWithIndeterminateAndText:(NSString *)text hideDelay:(NSTimeInterval)delay;

/** 展示自定义GIF动画 */
+ (void)showGIFWithtext:(NSString *)text;

/** 隐藏HUD */
+ (void)hideHUD;

@end
