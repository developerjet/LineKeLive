//
//  LKAdvertiseView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKAdvertiseView.h"
#import <SDWebImageManager.h>
#import "LKLiveHandler.h"
#import "LKAdvertModel.h"
#import "LKCacheHelper.h"

static NSInteger showtime = 3.0;

@interface LKAdvertiseView()
@property (weak, nonatomic) IBOutlet UIImageView *advImageView;
@property (weak, nonatomic) IBOutlet UIButton *timerView;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation LKAdvertiseView

#pragma mark - load

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
    self.timerView.alpha = 0.7;
    self.timerView.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.timerView.titleLabel.font = [UIFont systemFontOfSize:10];
    self.timerView.layer.cornerRadius = 3.0;
    self.timerView.layer.masksToBounds = YES;
    [self.timerView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self downAdv];
    [self showAdv];
    [self startTimer];
}

+ (instancetype)loadAdvertiseView {
    
    NSBundle *_currentBoundle = [NSBundle mainBundle];
    LKAdvertiseView *advView = [[_currentBoundle loadNibNamed:@"LKAdvertiseView" owner:nil options:nil] firstObject];
    
    return advView;
}


#pragma mark - net

//展示广告
- (void)showAdv {
    
    NSString *filePath = [LKCacheHelper getAdvertise];

    UIImage *lastCacheImage = [[SDWebImageManager sharedManager].imageCache imageFromCacheForKey:filePath];
    
    if (lastCacheImage) {
        
        self.advImageView.image = lastCacheImage;
        
    }else {
        
        self.hidden = YES;
    }
}

//下载广告
- (void)downAdv {

    [LKLiveHandler executeGetAdvertTaskWithSuccess:^(id obj) {
        if (obj) {
            LKAdvertModel *adv = obj;
            NSURL *imageURL = [NSURL URLWithString:adv.image];
            
            //SDWebImageAvoidAutoSetImage下载完不给图片赋值
            [[SDWebImageManager sharedManager] loadImageWithURL:imageURL
                                                        options:SDWebImageAvoidAutoSetImage
                                                       progress:nil
                                                      completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                          
                                                          [LKCacheHelper setAdvertiseWithURL:adv.image];
                                                      }];
        }
        
    } failed:^(id obj) {
        
        LKLog(@"obj：%@", obj);
    }];
    
}

#pragma mark - timer

- (void)startTimer {
    
    __block NSUInteger timerOut = showtime + 1;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timerOut <= 0) {
            dispatch_source_cancel(_timer); //倒计时结束，关闭
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismiss];
            });
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.timerView setTitle:[NSString stringWithFormat:@"%zds跳过",timerOut] forState:UIControlStateNormal];
            });
            timerOut--;
        }
    });
    
    dispatch_resume(timer);
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.advImageView.alpha = 0.f;
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.advImageView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
