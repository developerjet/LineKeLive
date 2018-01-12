//
//  LKShareView.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/19.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LKSharedState) {
    LKSharedStateQQ = 1000,
    LKSharedStateWeiChat ,
    LKSharedStateTimeLine,
    LKSharedStateShortMsg,
    LKSharedStateLink
};

@interface LKShareView : UIView

///---------------------
/// @name show && dismiss
///---------------------
- (void)show;
- (void)dismiss;

@end
