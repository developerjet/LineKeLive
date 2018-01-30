//
//  LKLoginViewController.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/22.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kLoginStatus) {
    kLoginStatus_WeiBo   = 1, //微博登录
    kLoginStatus_MoBile,
    kLoginStatus_WeChat,
    kLoginStatus_TXQQ
};

@interface LKLoginViewController : UIViewController

@end
