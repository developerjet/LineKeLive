//
//  LKNavigationBar.m
//  LinekeLive
//
//  Created by Original_TJ on 2018/2/22.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKNavigationBar.h"

@implementation LKNavigationBar


#pragma mark -
#pragma mark - <layoutSubviews>
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    for (UIView *view in self.subviews) {
        if (systemVersion >= 11.0) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                NSLog(@"_UIBarBackground");
                CGRect frame = view.frame;
                frame.size.height = 64;
                if (kDevice_Is_iPhoneX) {
                    frame.origin.y = 24;
                }
                view.frame = frame;
                NSLog(@"修改后的Frame: %@",NSStringFromCGRect(view.frame));
            }
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                NSLog(@"_UINavigationBarContentView");
                CGRect frame = view.frame;
                frame.origin.y = 20;
                if (kDevice_Is_iPhoneX) {
                    frame.origin.y = 44;
                }
                view.frame = frame;
            }
        }
    }
}




@end
