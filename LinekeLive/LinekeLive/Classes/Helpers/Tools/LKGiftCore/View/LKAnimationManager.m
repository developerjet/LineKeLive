//
//  LKAnimationManager.m
//  LinekeLive
//
//  Created by brother on 2017/8/8.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKAnimationManager.h"

#define Height_GiftView self.parentView.frame.size.height * 0.35
#define Width_GiftView self.parentView.frame.size.width * 0.5

@interface LKAnimationManager()

@property (nonatomic, assign) NSInteger count;

/// 队列1
@property (nonatomic, strong) NSOperationQueue *queue1;
/// 队列2
@property (nonatomic, strong) NSOperationQueue *queue2;
/// 操作缓存池
@property (nonatomic, strong) NSCache *operationCache;
/// 维护用户礼物信息
@property (nonatomic, strong) NSCache *userGiftInfos;

@property (nonatomic, assign) int isInQueue1;

@end

@implementation LKAnimationManager

#pragma mark - manager
+ (instancetype)manager {
    static LKAnimationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LKAnimationManager alloc] init];
        //sharedInstance.
    });
    return sharedInstance;
}

- (void)animWithData:(LKGiftData *)data finishedBlock:(void (^)(BOOL))finishedBlock {
    @weakify(self);
    NSString *queueID = [NSString stringWithFormat:@"%d", _isInQueue1];
    //拼接key存入NSCache
    NSString *key = [NSString stringWithFormat:@"%@,%@", data.senderName, data.giftName];
    //在有用户礼物信息时
    if ([self.userGiftInfos objectForKey:key]) {
        LKCacheData *cacheGiftData = [self.userGiftInfos objectForKey:key];
        double timeInterval = [[NSDate date] timeIntervalSinceDate:cacheGiftData.date];
        //超过15s，连击失效
        if (timeInterval > 15) {
            cacheGiftData.count = 1;
            cacheGiftData.oldCount = 0;
            [self.operationCache removeObjectForKey:key];
        }else {
            cacheGiftData.count += 1;
        }
        cacheGiftData.date = [NSDate date];
        [self.userGiftInfos setObject:cacheGiftData forKey:key];
        
        //如果有操作缓存，则直接累加，不需要重建Operation
        if ([self.operationCache objectForKey:key] != nil) {
            LKAnimation *animObj = [self.operationCache objectForKey:key];
            animObj.giftView.animCount = cacheGiftData.count;
            return;
        }
        
        //没有操作，创建Operation
        LKAnimation *animObj = [LKAnimation animOperationWithUserID:queueID Count:cacheGiftData.count OldCount:cacheGiftData.oldCount InView:self.parentView Data:data finishedBlock:^(BOOL result, NSInteger finishedCount) {
           
            [weak_self.operationCache removeObjectForKey:key];
            //回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            //存储结束时的count
            LKCacheData *cacheGiftData = [weak_self.userGiftInfos objectForKey:key];
            cacheGiftData.oldCount = finishedCount;
            if (cacheGiftData != nil) {
                [weak_self.userGiftInfos setObject:cacheGiftData forKey:key];
            }
        }];
        
        //将操作添加到缓存池
        [self.operationCache setObject:animObj forKey:key];
        
        if (_isInQueue1 == 1) {
            _isInQueue1 = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                animObj.giftView.frame = CGRectMake(0, self.parentView.frame.size.height*0.5, Width_GiftView, Height_GiftView);
                animObj.giftView.originFrame = animObj.giftView.frame;
            });
            
            [self.queue1 addOperation:animObj];
        }else {
            _isInQueue1 = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                animObj.giftView.frame = CGRectMake(0, self.parentView.frame.size.height*0.2, Width_GiftView, Height_GiftView);
                animObj.giftView.originFrame = animObj.giftView.frame;
            });
            [self.queue2 addOperation:animObj];
        }
        
    }else { //在没有用户礼物信息时
        //不存在该操作，直接创建
        LKAnimation *animObj = [LKAnimation animOperationWithUserID:queueID Count:1 OldCount:0 InView:self.parentView Data:data finishedBlock:^(BOOL result, NSInteger finishedCount) {
            [weak_self.operationCache removeObjectForKey:key];
            // 回调
            if (finishedBlock) {
                finishedBlock(result);
            }
            LKCacheData *cacheGiftData = [weak_self.userGiftInfos objectForKey:key];
            cacheGiftData.oldCount = finishedCount;
            if (cacheGiftData != nil) {
                [weak_self.userGiftInfos setObject:cacheGiftData forKey:key];
            }
        }];
        
        //将礼物信息数量存起来
        LKCacheData *cacheData = [LKCacheData createDataWithDate:[NSDate date] Count:1 GiftName:data.giftName];
        [self.userGiftInfos setObject:cacheData forKey:key];
        
        //将操作添加到缓存池
        [self.operationCache setObject:animObj forKey:key];
        
        if (_isInQueue1 == 1) {
            _isInQueue1 = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                animObj.giftView.frame = CGRectMake(0, self.parentView.frame.size.height*0.5, Width_GiftView, Height_GiftView);
                animObj.giftView.originFrame = animObj.giftView.frame;
            });
            
            [self.queue1 addOperation:animObj];
        }else {
            _isInQueue1 = 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                animObj.giftView.frame = CGRectMake(0, self.parentView.frame.size.height*0.2, Width_GiftView, Height_GiftView);
                animObj.giftView.originFrame = animObj.giftView.frame;
            });
            [self.queue2 addOperation:animObj];
        }
    }
}


#pragma mark - lazy
- (NSOperationQueue *)queue1 {
    
    if (!_queue1) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
    }
    return _queue1;
}

- (NSOperationQueue *)queue2 {
    
    if (!_queue2) {
        _queue2 = [[NSOperationQueue alloc] init];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}

- (NSCache *)operationCache {
    
    if (!_operationCache) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

- (NSCache *)userGiftInfos {
    
    if (!_userGiftInfos) {
        _userGiftInfos = [[NSCache alloc] init];
    }
    return _userGiftInfos;
}


#pragma mark - remove
- (void)cancelAllOperations {
    
    [self.queue1 cancelAllOperations];
    self.queue1 = nil;
    
    [self.queue2 cancelAllOperations];
    self.queue2 = nil;
    
    [self.userGiftInfos removeAllObjects];
    self.userGiftInfos = nil;
    
    [self.operationCache removeAllObjects];
    self.operationCache = nil;
}

@end
