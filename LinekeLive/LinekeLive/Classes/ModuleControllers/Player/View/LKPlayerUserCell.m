//
//  LKPlayerUserCell.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/25.
//  Copyright © 2018年 CoderTan. All rights reserved.
//

#import "LKPlayerUserCell.h"

@implementation LKPlayerUserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.image = [UIImage imageNamed:@"icon"];
        _userImageView.layer.cornerRadius  = frame.size.height * 0.5;
        _userImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_userImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userImageView.frame = self.bounds;
}

@end
