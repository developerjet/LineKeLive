//
//  LKGiftSendView.m
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKGiftSendView.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

#pragma mark - 送礼物累计数字 抖动显示

@implementation LKGiftViewShakeLabel

- (void)startAnimWithDuration:(NSTimeInterval)duration CompleteBlock:(ShakeLabelCompleteBlock)complete {
    
    [UIView animateKeyframesWithDuration:duration-0.2 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            
            self.transform = CGAffineTransformMakeScale(4, 4);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
            if (complete) {
                complete();
            }
            
        }];
    }];
}


#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _borderColor;
    [super drawRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawRect:rect];
    
    self.shadowOffset = shadowOffset;
}


@end


#pragma mark - playCustomGiftAnim 送礼物动画
@interface LKGiftSendView()

@property (nonatomic, strong) UIImageView *bgImageView;
//记录动画结束时累加数量，在将来的3s内，能继续叠加
@property (nonatomic, copy) void(^completeBlock)(BOOL finished, NSInteger finishCount);

/** 区分在哪个队列(动画位置不同) */
@property (nonatomic, assign) NSInteger queueIndex;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval hideDuration;

@end

@implementation LKGiftSendView

+ (LKGiftSendView *)createInView:(UIView *)inView Count:(NSInteger)count OldCount:(NSInteger)oldCount Identifier:(NSString *)identifier {
    
    LKGiftSendView *customView = [LKGiftSendView new];
    customView.oldAnimCount = oldCount;
    customView.identifier = identifier;
    customView.animCount = count;
    customView.alpha = 0;
    customView.duration = 0.5;
    customView.hideDuration = 1.0;
    customView.frame = CGRectMake(0, inView.height, inView.width*0.5, inView.height*0.3);

    [customView setGiftUI];
    
    return customView;
}


/******************************* 初始化UI *******************************/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _headImageView.layer.cornerRadius = _headImageView.layer.frame.size.height/2;
    _headImageView.layer.masksToBounds = YES;
}

- (void)setGiftUI {
    
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"giftBg"]];
    _deviceImageView = [[UIImageView alloc] init];
    
    _headImageView = [[UIImageView alloc] init];
    _giftImageView = [[UIImageView alloc] init];
    _senderNameLabel = [[UILabel alloc] init];
    _senderNameLabel.textColor = [UIColor redColor];
    _senderNameLabel.font = [UIFont boldSystemFontOfSize:12];
    
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = [UIColor whiteColor];
    _giftNameLabel.font = [UIFont boldSystemFontOfSize:12];
    
    
    //初始化动画label
    _shakeLabel = [[LKGiftViewShakeLabel alloc] init];
    _shakeLabel.font = [UIFont boldSystemFontOfSize:20];
    _shakeLabel.borderColor = [UIColor blackColor];
    _shakeLabel.textColor = [UIColor purpleColor];
    _shakeLabel.textAlignment = NSTextAlignmentCenter;
    _shakeLabel.number = 0;
    
    [self addSubview:_bgImageView];
    [self addSubview:_deviceImageView];
    [self addSubview:_headImageView];
    [self addSubview:_giftImageView];
    [self addSubview:_senderNameLabel];
    [self addSubview:_giftNameLabel];
    [self addSubview:_shakeLabel];
    
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
    
    CGFloat margin = 2;
    
    [_deviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 5;
        make.centerY.equalTo(self);
    }];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.mas_height).multipliedBy(0.8);
        make.centerY.equalTo(self);
        make.left.equalTo(_deviceImageView.mas_right).offset = margin;
    }];
    [_senderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset = margin;
        make.centerY.equalTo(self);
    }];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_senderNameLabel.mas_right).offset = margin;
        make.centerY.equalTo(self);
    }];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_giftNameLabel.mas_right).offset = margin;
        make.centerY.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(1.3);
        make.width.equalTo(_giftImageView.mas_height);
    }];
    [_shakeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_giftImageView.mas_right).offset = margin;
        make.centerY.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.8);
        make.width.equalTo(_shakeLabel.mas_height).multipliedBy(3);
    }];
}


/******************************* 刷新礼物数据 *******************************/

- (void)setData:(LKGiftData *)data {
    _data = data;
    
    //设备图标
    if ([data.deveiceType integerValue] == 1) { //手机
        _deviceImageView.image = [UIImage imageNamed:@"phone"];
    }else { //电脑
        _deviceImageView.image = [UIImage imageNamed:@"computer"];
    }
    
    _headImageView.image = [UIImage imageNamed:@"icon.png"];
    _senderNameLabel.text = data.senderName;
    _giftNameLabel.text = [NSString stringWithFormat:@"送出%@", data.giftName];
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:data.giftIcon] placeholderImage:[UIImage imageNamed:@"good9_30x30.png"]];
}

/******************************* 动画模块 *******************************/
- (void)animateWithCompleteBlock:(CompleteBlock)complete Index:(NSInteger)index {
    self.queueIndex = index;
    CGFloat yPosition = 0;
    
    if (index == 1) {
        yPosition = self.frame.size.height+5;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            self.frame = CGRectMake(0, yPosition, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self callBacksShake];
        }];
    });
    
    self.completeBlock = complete;
}

//使用回调实现不断抖动
- (void)callBacksShake {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideGiftView) object:nil];
    
    if (_oldAnimCount < _animCount) {
        _oldAnimCount++;
        self.shakeLabel.number = _oldAnimCount;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            weak_self.shakeLabel.text = [NSString stringWithFormat:@"X %ld", (long)_oldAnimCount];
            [weak_self.shakeLabel startAnimWithDuration:weak_self.duration CompleteBlock:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self callBacksShake];
                });
            }];
        });
    }else {
        
        [self performSelector:@selector(hideGiftView) withObject:nil afterDelay:self.hideDuration];
    }
}

//隐藏view，iOS2.0后销毁该方法
- (void)hideGiftView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y-20, self.frame.size.width, self.frame.size.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            NSInteger tempCount = 0; //该变量的作用(避免在隐藏期间，_animCount增加但还没抖动)
            if (_oldAnimCount > 0) {
                tempCount = _oldAnimCount;
            }else {
                tempCount = _animCount;
            }
            
            if (self.completeBlock) {
                self.completeBlock(YES, tempCount);
            }
            
            [self destoryed];
        }];
    });
}


/**
 销毁该view，并重置所有状态
 */
- (void)destoryed {
    [self reset];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
}

//重置
- (void)reset {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.frame = _originFrame;
        self.shakeLabel.text = @"";
    });
    
    self.animCount = 1;
    self.completeBlock = nil;
}

@end
