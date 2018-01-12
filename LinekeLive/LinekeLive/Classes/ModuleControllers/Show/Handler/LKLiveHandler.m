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

static NSString * kParams = @"imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1";

@implementation LKLiveHandler

+ (void)executeGetHotLiveTaskWithSuccess:(successBlock)success failed:(failedBlock)failed {

    // NSString *kHotAPI = [NSString stringWithFormat:@"%@?%@", API_HotLive, kParams];
    NSString *url = @"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_11.000000&count=5&multiaddr=1";
    
    [HttpTool getWithPath:url params:nil success:^(id json) {
        
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
        
        failed(error);
    }];
}


@end
