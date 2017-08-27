//
//  LKShareView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/19.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LKSharedCoreType) {
    LKSharedCoreTencentQQ = 899,
    LKSharedCoreWeiChat ,
    LKSharedCoreTimeLine,
    LKSharedCoreShortMsg,
    LKSharedCoreCopyLine
};

@interface LKShareView : UIView

+ (instancetype)loadShareCore;


- (void)show;

- (void)dismiss;

@end
