//
//  LKLiveHandler.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLiveHandler.h"
#import "LKLocationManager.h"
#import "LKCreatorModel.h"
#import "LKLiveModel.h"
#import "HttpTool.h"

@implementation LKLiveHandler

+ (void)executeGetHotLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {
    
    [HttpTool getWithPath:API_HotLive params:nil success:^(id json) {
        NSInteger errorCode = [json[@"dm_error"] integerValue];

        if (errorCode == 0) { //请求成功
            NSArray *lives = [LKLiveModel mj_objectArrayWithKeyValuesArray:json[@"lives"]];
            success(lives);
        }else {
            failed(json);
        }
        
    } failure:^(NSError *error) {
        
        failed(error);
    }];

}


+ (void)executeGetNearLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {
    
    NSString *url = API_NearLive;
    NSDictionary *params = @{@"uid": @"85149891",
                             @"latitude": @"22.570442",
                             @"longitude": @"113.852035"}; //深圳地区
    
    [HttpTool getWithPath:url params:params success:^(id json) {
        
        NSInteger errorCode = [json[@"dm_error"] integerValue];
        
        if (errorCode == 0) { //请求成功
            
            NSArray *liveModels = [LKLiveModel mj_objectArrayWithKeyValuesArray:json[@"lives"]];
            success(liveModels);
            
        }else {
            
            failed(json);
        }
        
    } failure:^(NSError *error) {
        
        failed(error);
    }];
}

+ (void)executeGetGiftTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {
    
    NSDictionary *params = @{@"type": @"0",
                             @"page": @"1",
                             @"rows": @"150"};
    
    NSString *tsakURL = @"http://qf.56.com/pay/v4/giftList.ios";
    
    [HttpTool getWithPath:tsakURL params:params success:^(id json) {
        
        success(json);
        
    } failure:^(NSError *error) {
        
        failed(error);
    }];
}


+ (void)executeGetAdvertTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {
    
    [HttpTool getWithPath:API_Advertise params:nil success:^(id json) {
        
        NSInteger errorCode = [json[@"dm_error"] integerValue];
        
        if (errorCode == 0) { //请求成功
            
        }else {
            
            failed(json);
        }
        
    } failure:^(NSError *error) {
        
    }];
}


@end
