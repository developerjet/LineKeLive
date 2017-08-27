//
//  LKGiftAnimation.m
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKAnimation.h"

@interface LKAnimation()

@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);
@property (nonatomic, getter = isExecuting) BOOL executing;

@end

@implementation LKAnimation

@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithUserID:(NSString *)userID Count:(NSInteger)count OldCount:(NSInteger)oldCount InView:(UIView *)inView Data:(LKGiftData *)data finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock {
    LKAnimation *obj = [[LKAnimation alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        obj.giftView = [LKGiftSendView createInView:inView Count:count OldCount:oldCount Identifier:userID];
        [obj.giftView setData:data];
        obj.parentView = inView;
    });
    obj.data = data;
    obj.finishedBlock = finishedBlock;
    return obj;
}

- (void)start {
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    _giftView.data = _data;
    @weakify(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        _giftView.originFrame = _giftView.frame;
        [weak_self.parentView addSubview:_giftView];
        
        [self.giftView animateWithCompleteBlock:^(BOOL finished, NSInteger finishCount) {
            weak_self.finished = finished;
            weak_self.finishedBlock(finished,finishCount);
        } Index:[self.giftView.identifier intValue]];
    });
}

#pragma mark -  手动触发 KVO
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

@end
