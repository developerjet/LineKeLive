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
        [self addAnimWithImageView:_userImageView];
        [self.contentView addSubview:_userImageView];
    }
    return self;
}

- (void)addAnimation {
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue   = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 3;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)addAnimWithImageView:(UIImageView *)imageView {
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue   = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 3;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [imageView.layer addAnimation:animation forKey:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userImageView.frame = self.bounds;
}

@end
