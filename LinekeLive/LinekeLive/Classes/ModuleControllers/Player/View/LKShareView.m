//
//  LKShareView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/19.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKShareView.h"

#define kCustomHeight   160

@implementation LKShareView

+ (instancetype)loadShareCore {
    
    NSBundle *_bundle = [NSBundle mainBundle];
    LKShareView *view = [[_bundle loadNibNamed:@"LKShareView" owner:nil options:nil] firstObject];
    
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kCustomHeight);
}


- (void)show {
    
    CGRect fm = self.frame;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [UIView animateWithDuration:0.15 animations:^{
    
            self.frame = CGRectMake(fm.origin.x, SCREEN_HEIGHT-kCustomHeight, fm.size.width, kCustomHeight);
        }];

    } completion:^(BOOL finished) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

- (void)dismiss {
    
    CGRect fm = self.frame;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.frame = CGRectMake(fm.origin.x, fm.origin.y + kCustomHeight, fm.size.width, kCustomHeight);
        
    } completion:^(BOOL finished) {
        
        self.alpha = 0;
        [self removeFromSuperview];
    }];
}

- (IBAction)coreClick:(UIButton *)button {
    LKSharedCoreType type = button.tag;
    
    switch (type) {
        case LKSharedCoreTencentQQ:
            LKLog(@"分享到QQ");
            break;
        case LKSharedCoreWeiChat:
            LKLog(@"分享到微信");
            break;
        case LKSharedCoreTimeLine:
            LKLog(@"分享到朋友圈");
            break;
        case LKSharedCoreShortMsg:
            LKLog(@"分享到短息");
            break;
        case LKSharedCoreCopyLine:
            LKLog(@"赋值链接");
            break;
            
        default:
            break;
    }
}

- (IBAction)clean:(id)sender {
    
    [self dismiss];
}


@end
