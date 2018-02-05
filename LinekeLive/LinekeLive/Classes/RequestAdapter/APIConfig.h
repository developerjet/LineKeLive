//
//  APIConfig.h
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIConfig : NSObject

/***************************************** Service *****************************************/

/**
 信息类服务器地址 映客所有接口
 */
#define SERVER_ALL_API   @"http://serviceinfo.inke.com/serviceinfo/info?uid=139587564"


/**
 信息类服务器地址
 */
#define SERVER_HOST @"http://service.ingkee.com/"

/**
 图片类服务器地址
 */
#define IMAGE_HOST @"http://img.meelive.cn"


/***************************************** API *****************************************/

/**
 首页热门数据
 */
#define API_HotLive @"api/live/simpleall?uid=85149891"


/**
 附近的人
 */
#define API_NearLive @"api/live/near_recommend" //?uid=85149891&latitude=40.090562&longitude=116.413353

/**
 搜索页面
 */
#define API_SearchList @"http://service.inke.com/api/recommend/aggregate?&uid=139587564"


/**
 广告地址
 */
#define API_Advertise @"advertise/get"


/**
 本地推流直播地址
 */
#define kLiveRtmp   @"rtmp://192.168.1.166:1935/rtmplive/room"

@end
