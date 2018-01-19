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
#import "LKAdvertModel.h"
#import "LKLiveModel.h"
#import "HttpTool.h"

/*
 http://116.211.167.106/api/live/users?lc=0000000000000043&cc=TG0001&cv=IK3.8.10_Iphone&proto=7&idfa=2D707AF8-980F-415C-B443-6FED3E9BBE97&idfv=76F26589-EA5D-4D0A-BC1C-A4B6010FFA37&devi=135ede19e251cd6512eb6ad4f418fbbde03c9266&osversion=ios_10.100000&ua=iPhone5_2&imei=&imsi=&uid=310474203&sid=209pU5OK49fA6uhxX3taEXIWAm5lENuCrr6xKL48pqAQ0Y0FqL&conn=wifi&mtid=87edd7144bd658132ae544d7c9a0eba8&mtxid=acbc329027f3&logid=110,30,5&start=0&count=20&id=
 */

static NSString * user_hot_Url = @"http://116.211.167.106/api/live/users?lc=0000000000000043&cc=TG0001&cv=IK3.8.10_Iphone&proto=7&idfa=2D707AF8-980F-415C-B443-6FED3E9BBE97&idfv=76F26589-EA5D-4D0A-BC1C-A4B6010FFA37&devi=135ede19e251cd6512eb6ad4f418fbbde03c9266&osversion=ios_10.100000&ua=iPhone5_2&imei=&imsi=&uid=310474203&sid=209pU5OK49fA6uhxX3taEXIWAm5lENuCrr6xKL48pqAQ0Y0FqL&conn=wifi&mtid=87edd7144bd658132ae544d7c9a0eba8&mtxid=acbc329027f3&logid=110,30,5&start=0&count=20&id=";

@implementation LKLiveHandler

+ (void)executeGetHotLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {
    //NSString *kHotAPI = [NSString stringWithFormat:@"%@?%@", API_HotLive, kParams];
    
    [HttpTool getWithPath:user_hot_Url params:nil success:^(id json) {
        
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
    
    //LKLocationManager * manager = [LKLocationManager sharedManager];
    
    NSDictionary *params = @{@"uid": @"85149891",
                             @"latitude": @"22.570442",
                             @"longitude": @"113.852035"}; //深圳地区
    
    [HttpTool getWithPath:API_NearLive params:params success:^(id json) {
        
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
            
            LKAdvertModel *advertModels = [LKAdvertModel mj_objectWithKeyValues:[json[@"resources"] firstObject]];
            success(advertModels);
            
        }else {
            
            failed(json);
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}


@end
