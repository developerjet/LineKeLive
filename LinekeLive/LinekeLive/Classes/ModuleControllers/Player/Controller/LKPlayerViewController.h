//
//  LKPlayerViewController.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHasNavViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LKLiveModel.h"

@class IJKMediaControl;
@interface LKPlayerViewController : LKHasNavViewController

@property(atomic, retain) id<IJKMediaPlayback> player;

@property(nonatomic, strong) LKLiveModel *model;

@end
