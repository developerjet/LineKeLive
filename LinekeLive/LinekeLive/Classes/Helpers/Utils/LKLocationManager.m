//
//  LKLocationManager.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LKLocationManager()<CLLocationManagerDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) LocationFinishedBlock locationBlock;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LKLocationManager

#pragma mark - lazyLoad

- (CLGeocoder *)geocoder {
    
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

#pragma mark - initialize
+ (instancetype)sharedManager {
    
    static LKLocationManager * _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[LKLocationManager alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 100; //定位附近距离
        _locationManager.delegate = self;
        //[_locationManager startUpdatingLocation];
        
        if (![CLLocationManager locationServicesEnabled]) {
            
            [self showAlert]; //开启定位
            
        }else {
            CLAuthorizationStatus state = [CLLocationManager authorizationStatus]; //获取当前的定位状态
            
            if (state == kCLAuthorizationStatusNotDetermined) {
                [_locationManager requestWhenInUseAuthorization];
            }
        }
    }
    
    return self;
}

- (void)showAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前定位未开启" message:@"请在设置界面打开定位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


//开启定位
- (void)startLocation {

    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingHeading];
    
    //获取最新定位
    CLLocation *currentLocation = [locations firstObject];
    
    //打印当前的经度与纬度
    //NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    NSString *lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    
    [LKLocationManager sharedManager].latitude = lat;
    [LKLocationManager sharedManager].longitude = lon;
    
    // 传递经纬度
    self.locationBlock(lat, lon);
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    
    //反地理编码(经纬度 -> 地址)
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error == nil) {
            CLPlacemark *placemark = [placemarks firstObject];
            [LKLocationManager sharedManager].city = placemark.locality;
            NSLog(@"当前城市：%@", placemark.locality);
        }
    }];
}


//定位失败
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
    [self showAlert];
}

- (void)achieveLocation:(LocationFinishedBlock)locationBlock {
    
    self.locationBlock = locationBlock;
    [self startLocation];
}

- (void)openService {
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self openService];
    }
}

@end
