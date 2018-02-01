//
//  CALayer+Aimate.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "CALayer+Aimate.h"

@implementation CALayer (Aimate)

- (void)pauseAimate {
    
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pauseTime;
}

- (void)resumeAimate {
    
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() toLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}


@end
