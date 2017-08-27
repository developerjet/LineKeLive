//
//  MJExtensionConfig.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "LKCreatorModel.h"
#import "LKLiveModel.h"

@implementation MJExtensionConfig

+ (void)load {
    
    //将属性名换为其他key去字典中取值
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"ID": @"id"};
    }];
    
    [LKLiveModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        
        return @{@"descriptionField": @"description"};
    }];
    
    
    //驼峰转下划线
    [LKCreatorModel mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
       
        return [propertyName mj_underlineFromCamel];
    }];
    
    
    [LKLiveModel mj_setupReplacedKeyFromPropertyName121:^id(NSString *propertyName) {
        
        return [propertyName mj_underlineFromCamel];
    }];
}


@end
