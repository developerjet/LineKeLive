//
//  LKLoginViewController.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/22.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LKLoginStyle) {
    WeiBoLogin = 1, //微博登录
    MoBileLogin,
    WeChatLogin,
    QQLogin,
};

@interface LKLoginViewController : UIViewController

@end
