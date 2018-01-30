//
//  LKShareView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/19.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKShareView.h"

#define bottom_height   160
#define views_bgColor   [UIColor colorWithHexString:@"FFFFFF"]

@interface LKShareView()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIView  *overalView;
@property (nonatomic, strong) UIView  *bottomView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LKShareView

#pragma mark -
#pragma mark - initial
- (instancetype)init {
    if (self = [super init]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIApplication sharedApplication].keyWindow.frame;
    
    CGFloat padding = 10;
    // configura gestureRecognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    
    // configura subviews
    _overalView = [[UIView alloc] initWithFrame:self.frame];
    _overalView.backgroundColor = [UIColor clearColor];
    [self addSubview:_overalView];
    [_overalView addGestureRecognizer:tap];

    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, bottom_height)];
    _bottomView.backgroundColor = views_bgColor;
    [self addSubview:_bottomView];
    
    CGFloat titleW = 60;
    CGFloat titleX = (SCREEN_WIDTH - titleW) * 0.5;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, padding, titleW, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"分享至";
    [_bottomView addSubview:titleLabel];
    
    CGFloat lineW = (SCREEN_WIDTH - padding * 4 - titleW) * 0.5;
    CGFloat lineY = titleLabel.centerY;
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(padding, lineY, lineW, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [_bottomView addSubview:lineView1];
    
    CGFloat lineX = CGRectGetMaxX(titleLabel.frame) + padding;
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [_bottomView addSubview:lineView2];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (_bottomView.frame.size.height-60)/2, SCREEN_WIDTH, 60)];
    [_bottomView addSubview:_scrollView];
    
    CGFloat btnW = 60;
    CGFloat btnH = 40;
    CGFloat btnX = 30;
    // configura share item's
    for (int i = 0; i < self.items.count; i++)
    {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(btnX + (i * btnW), 10, btnW, btnH);
        [item setImage:[UIImage imageNamed:self.items[i]] forState:UIControlStateNormal];
        // 将所有按钮都移至底部
        item.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
        item.tag = i + 1000;
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:item];
    }
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat height = _bottomView.frame.size.height - CGRectGetMaxY(_scrollView.frame);
    closeBtn.frame = CGRectMake(0, CGRectGetMaxY(_scrollView.frame), SCREEN_WIDTH, height);
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:closeBtn];
}


#pragma mark -
#pragma mark - animate click
- (void)animShow {
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *view = self.scrollView.subviews[i];
        
        if ([view isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.25 delay: i * 0.05 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                //清空形变.
                view.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    }
}

- (void)animClose:(UIButton *)btn {
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIView *view = self.scrollView.subviews[i];
        
        if ([btn isKindOfClass:[UIButton class]]) {
            // 判断如果是当前点击的按钮，让按钮放大
            if (btn == view) {
                [UIView animateWithDuration:0.25 animations:^{
                    // 放大当前按钮
                    btn.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
                    // 放大同时alpha置为0
                    btn.alpha = 0;
                } completion:^(BOOL finished) { // 完成时隐藏移除
                    [UIView animateWithDuration:0.25 animations:^{
                        _bottomView.alpha = 0.0;
                        [self removeFromSuperview];
                    }];
                }];
            }else {
                // 如果不是当前按钮
                [UIView animateWithDuration:0.25 animations:^{
                    view.transform = CGAffineTransformMakeScale(0.001, 0.001);
                    view.alpha = 0;
                }];
            }
        }
    }
}

- (void)dismiss {
    
    NSArray *subViews = self.scrollView.subviews;
    // 反转数组
    NSArray *array = [[subViews reverseObjectEnumerator] allObjects];
    
    for (int i = 0; i < array.count; i++) {
        UIView *view = array[i];
        // 所有按钮都下移
        if ([view isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.5 delay: i * 0.05 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                //将所有按钮都依次移至底部
                view.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT);
            } completion:nil];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _bottomView.frame = CGRectMake(_bottomView.origin.x, SCREEN_HEIGHT, SCREEN_WIDTH, bottom_height);
        _overalView.alpha = 0.0;
        [self removeFromSuperview];
    });
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _bottomView.frame = CGRectMake(_bottomView.origin.x, SCREEN_HEIGHT-bottom_height, SCREEN_WIDTH, bottom_height);
    } completion:^(BOOL finished) {
        
        [self animShow];
    }];
}

- (void)itemClick:(UIButton *)button {
    LKSharedState state = button.tag;
    
    switch (state) {
        case LKSharedStateQQ:
            LKLog(@"分享到QQ");
            break;
        case LKSharedStateWeiChat:
            LKLog(@"分享到微信");
            break;
        case LKSharedStateTimeLine:
            LKLog(@"分享到朋友圈");
            break;
        case LKSharedStateShortMsg:
            LKLog(@"分享到短息");
            break;
        case LKSharedStateLink:
            LKLog(@"复制链接");
            break;
        default:
            break;
    }
    
    [self animClose:button];
}

#pragma mark -
#pragma mark - Lazy
- (NSArray *)items {
    
    if (!_items) {
        _items = @[@"shareView_qq",
                   @"shareView_wx",
                   @"shareView_friend",
                   @"shareView_msg",
                   @"shareView_copylink"];
    }
    return _items;
}


@end
