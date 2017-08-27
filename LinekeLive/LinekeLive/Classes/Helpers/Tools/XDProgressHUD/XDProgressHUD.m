//
//  XDProgressHUD.m
//  OnlyBrother_ Seller
//
//  Created by codeTan on 16/10/23.
//  Copyright © 2016年 谭捷. All rights reserved.
//

#import "XDProgressHUD.h"
#import "MBProgressHUD.h"
#define kCurrentKeyWindow  [UIApplication sharedApplication].keyWindow
#define HUD_TAG  101010

@implementation XDProgressHUD

+ (void)showHUDWithText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.tag = HUD_TAG;
    hud.mode = MBProgressHUDModeText;
    hud.label.text =  text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithIndeterminateAndText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:kCurrentKeyWindow animated:YES];
    hud.tag = HUD_TAG;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithLongText:(NSString *)text hideDelay:(NSTimeInterval)delay
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.tag = HUD_TAG;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (void)showHUDWithIndeterminate:(NSString *)text
{
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
    hud = [MBProgressHUD showHUDAddedTo:window animated:NO];
    hud.tag = HUD_TAG;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
}


+ (void)hideHUD {
    
    UIView *window = kCurrentKeyWindow;
    MBProgressHUD *hud = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
    if (hud.superview&&[hud isKindOfClass:MBProgressHUD.class]) {
        [hud removeFromSuperview];
        hud = nil;
    }
}

@end
