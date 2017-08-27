//
//  CALayer+Aimate.h
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Aimate)

///暂停动画
- (void)pauseAimate;

/// 恢复动画
- (void)resumeAimate;

@end
