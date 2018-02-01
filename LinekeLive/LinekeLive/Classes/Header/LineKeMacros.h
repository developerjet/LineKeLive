//
//  LineKeMacros.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/22.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#ifndef LineKeMacros_h
#define LineKeMacros_h

#import <YYKit.h>
#import "UIColor+Extension.h"
#import <MJExtension/MJExtension.h>
#import "UIImageView+SDWebImage.h"
#import "LKRefreshGifHeader.h"
#import "LKLiveHandler.h"
#import "LKCacheHelper.h"
#import "XDProgressHUD.h"
#import "LKEnumHeader.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "APIConfig.h"
#import <Masonry.h>

/// COLOR
#define COLORHEX(hex)         [UIColor colorWithHexString:hex]
#define COLOR(r, g, b, a)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1.0]

#define kAppDelegate        ((AppDelegate *)([UIApplication sharedApplication].delegate))
#define kCurrentKeyWindow   [UIApplication sharedApplication].keyWindow

/// WeakSelf
#define WeakSelf    __weak typeof(self) weakSelf = self

/// VIEW_SCREEN
#define SCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define SCREEN_WIDTH     SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT    SCREEN_BOUNDS.size.height

#define SCREEN_NAV       64
#define SCREEN_TABBAR    49

/// IMAGE
#define IMG(x)       [UIImage imageNamed:x]
#define IMGURL(url)  [NSURL URLWithString:url]

/// UD
#define UD      [NSUserDefaults standardUserDefaults]

/** 屏幕适配 */
#define iPhone6P (SCREEN_HEIGHT == 736)
#define iPhone6  (SCREEN_HEIGHT == 667)
#define iPhone5  (SCREEN_HEIGHT == 568)
#define iPhone4  (SCREEN_HEIGHT == 480)

/** 版本号 */
#define kVersionNum  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/** 通知相关 */
#define kFollowKey  @"NotificationNameFollowAnchor"

/** 本地存储 */
#define UD  [NSUserDefaults standardUserDefaults]

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif /* LineKeMacros_h */
