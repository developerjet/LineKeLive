//
//  LKCacheHelper.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKCacheHelper.h"

static NSString * const kAdvertKey = @"advertise_Key";

#define LKFiledCache [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LKCaches.plist"]

@interface LKCacheHelper()
{
    NSMutableArray *_allAnchorMs;
}
@end

@implementation LKCacheHelper

#pragma mark - manager

+ (instancetype)shared {
    
    static LKCacheHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance  = [[LKCacheHelper alloc] init];
    });
    return _sharedInstance;
}


- (NSMutableArray *)allAnchorMs {
    
    if (_allAnchorMs == nil) {
        
        _allAnchorMs = [NSKeyedUnarchiver unarchiveObjectWithFile:LKFiledCache];
        
        if (_allAnchorMs == nil) {
            
            _allAnchorMs = [NSMutableArray array];
        }
    }
    
    return _allAnchorMs;
}

#pragma mark - setter && getter
- (void)followAnchor:(LKLiveModel *)ancher {
    
    [self.allAnchorMs removeObject:ancher];
    [self.allAnchorMs insertObject:ancher atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:self.allAnchorMs toFile:LKFiledCache];
}

- (void)unFollowAnchor:(LKLiveModel *)ancher {

    [[LKCacheHelper shared].allAnchorMs enumerateObjectsUsingBlock:^(LKLiveModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([ancher.streamAddr isEqualToString:obj.streamAddr]) {
            
            [self.allAnchorMs removeObject:obj];
        }
    }];
    
    [NSKeyedArchiver archiveRootObject:self.allAnchorMs toFile:LKFiledCache];
}

- (BOOL)getAncherIsFollow:(LKLiveModel *)ancher {
    
    __block BOOL follow = NO;
    [[LKCacheHelper shared].allAnchorMs enumerateObjectsUsingBlock:^(LKLiveModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([ancher.streamAddr isEqualToString:obj.streamAddr]) {

            follow = obj.follow;
        }
    }];
    
    return follow;
}


+ (void)setAdvertiseWithURL:(NSString *)url {
    if (!url || url.length<=0) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:kAdvertKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAdvertise {

   return [[NSUserDefaults standardUserDefaults] valueForKey:kAdvertKey];
}


@end
