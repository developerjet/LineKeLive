//
//  LKPlayerUserInfoView.h
//  LinekeLive
//
//  Created by CoderTan on 2018/1/25.
//  Copyright © 2018年 CoderTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKUserListView : UIView
@property (nonatomic, strong) NSString *userUrl;
@property (nonatomic, copy) void(^DidUserRowBlock)(NSInteger row);

@end
