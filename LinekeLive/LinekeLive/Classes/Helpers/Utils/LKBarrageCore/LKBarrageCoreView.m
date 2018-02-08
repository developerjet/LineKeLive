//
//  LKDanmuView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/11.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBarrageCoreView.h"
#import "CALayer+Aimate.h"

#define kClockSec 0.1
#define kDandaoCount 5

@interface LKBarrageCoreView()
{
    BOOL _isPause;
}

@property (nonatomic, weak) NSTimer *clock;

@property (nonatomic, strong) NSMutableArray *laneWaitTimes;
@property (nonatomic, strong) NSMutableArray *laneLeftTimes;

@property (nonatomic, strong) NSMutableArray *danmuViews;

@end

@implementation LKBarrageCoreView

#pragma mark - lazy
- (NSMutableArray *)danmuViews {
    
    if (!_danmuViews) {
        _danmuViews = [NSMutableArray array];
    }
    return _danmuViews;
}

- (NSMutableArray *)laneWaitTimes {
    
    if (!_laneWaitTimes) {
        _laneWaitTimes = [NSMutableArray array];
        for (int i = 0; i < kDandaoCount; i++) {
            _laneWaitTimes[i] = @0.0;
        }
    }
    return _laneWaitTimes;
}

- (NSMutableArray *)laneLeftTimes {
    
    if (!_laneLeftTimes) {
        _laneLeftTimes = [NSMutableArray array];
        for (int i = 0; i < kDandaoCount; i++) {
            _laneLeftTimes[i] = @0.0;
        }
    }
    return _laneLeftTimes;
}

- (NSMutableArray *)models {
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSTimer *)clock {
    
    if (!_clock) {
        NSTimer *clock = [NSTimer timerWithTimeInterval:kClockSec target:self selector:@selector(checkAndBiu) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:clock forMode:NSRunLoopCommonModes];
        _clock = clock;
    }
    return _clock;
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)click:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:tap.view];
    for (UIView *danmuView in self.danmuViews) {
        CGRect frame = danmuView.layer.presentationLayer.frame;
        BOOL isContain = CGRectContainsPoint(frame, point);
        if (isContain) {
        
            if (self.delegate && [self.delegate respondsToSelector:@selector(danmuViewDidClick:at:)]) {
                
                [self.delegate danmuViewDidClick:danmuView at:point];
            }
            
            break;
        }
    }
    
    UIView *tapView = self.danmuViews.firstObject;
    LKLog(@"%@", NSStringFromCGRect(tapView.layer.presentationLayer.frame));
}


#pragma mark - 接口
- (void)pause {
    _isPause = YES;
    
    [[self.danmuViews valueForKey:@"layer"] makeObjectsPerformSelector:@selector(pauseAimate)];
    [self removeTimer];
}

- (void)resume {
    _isPause = NO;
    
    [[self.danmuViews valueForKey:@"layer"] makeObjectsPerformSelector:@selector(resumeAimate)];
    [self clock];
}


/**
 移除定时器
 */
- (void)removeTimer {

    [self.clock invalidate];
    self.clock = nil;
}

#pragma mark - 私有方法
- (void)checkAndBiu {
    
    if (_isPause) {
        return;
    }
    
    for (int i = 0; i < kDandaoCount; i++) {
        double waitValue = [self.laneWaitTimes[i] doubleValue] - kClockSec;
        if (waitValue <= 0.0) {
            waitValue = 0.0;
        }
        self.laneWaitTimes[i] = @(waitValue);
        

        double leftValue = [self.laneLeftTimes[i] doubleValue] - kClockSec;
        if (leftValue <= 0.0) {
            leftValue = 0.0;
        }
        self.laneLeftTimes[i] = @(leftValue);
    }
    
    
    //ModelProtocol
    [self.models sortUsingComparator:^NSComparisonResult(id<LKBarrageModelProtocol>  _Nonnull obj1, id<LKBarrageModelProtocol>  _Nonnull obj2) {
        
        if (obj1.beginTime < obj2.beginTime) {
            return NSOrderedAscending;
        }
        
        return NSOrderedDescending;
    }];
    
    // 检测模型数组里面所有的模型，是否可以发射，如果可以，直接发射
    NSMutableArray *deleteModels = [NSMutableArray array];
    for (id<LKBarrageModelProtocol> model in self.models) {
        
        // 1.检测开始时间是否有到达
        NSTimeInterval beginTime = model.beginTime;
        NSTimeInterval currentTime = self.delegate.currentTime;
        
        
        // 2.当开始时间大于当前时间
        if (beginTime > currentTime) {
            break;
        }
        
        // 3.发送时间已经到了
        // 检查碰撞
        BOOL result = [self checkBoomAndBiuWith:model];
        if (result) {
            [deleteModels addObject:model];
        }
    }
    
    [self.models removeObjectsInArray:deleteModels];
}

- (BOOL)checkBoomAndBiuWith:(id<LKBarrageModelProtocol>)model {
    
    CGFloat danDaoH = self.frame.size.height / kDandaoCount;
    
    // 遍历所有的弹道，在每个弹道里面，进行检测
    for (int i = 0; i < kDandaoCount; i++) {
        
        // 1.获取该弹道的绝对等待时间
        NSTimeInterval waitTime = [self.laneWaitTimes[i] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        
        // 2.绝对等待时间没有，可以发射，如果发射了，可能存在和前一个弹幕产生碰撞
        UIView *danmuView = [self.delegate danmuViewWithModel:model];
        
        NSTimeInterval leftTime = [self.laneLeftTimes[i] doubleValue];
        double speed = (danmuView.frame.size.width + self.frame.size.width) / model.liveTime;
        double distance = leftTime + speed;
        if (distance > self.frame.size.width) {
            continue;
        }
        
        
        [self.danmuViews addObject:danmuView];
        
        // 重置数据
        self.laneWaitTimes[i] = @(danmuView.frame.size.width / speed);
        self.laneLeftTimes[i] = @(model.liveTime);
        
        // 3.弹幕确定可以发射
        // 3.1先把弹幕视图，加到弹幕背景里面
        CGRect frame = danmuView.frame;
        frame.origin = CGPointMake(self.frame.size.width, danDaoH * i);
        danmuView.frame = frame;
        [self addSubview:danmuView];
        
        // UIViewAnimationOptionCurveLinear：匀速
        [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            CGRect frame = danmuView.frame;
            frame.origin.x = -danmuView.frame.size.width;
            danmuView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [danmuView removeFromSuperview];
            [self.danmuViews removeObject:danmuView];
        }];
        
        return YES;
    }
    
    //如果没有碰撞，还要发生弹幕视图
    return NO;
}


#pragma mark - 声明周期方法
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self clock];
    self.layer.masksToBounds = YES;
}

- (void)dealloc {
    
    [self removeTimer];
}

@end
