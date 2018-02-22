//
//  LKBasicTabBar.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKBasicTabBar.h"

@interface LKBasicTabBar()
@property (nonatomic, strong) UIButton *lastItem;
@property (nonatomic, strong) NSArray  *dataSource;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImageView *tabBgView; //tabBar背景图片

@end

@implementation LKBasicTabBar

#pragma mark - Lazy
- (UIImageView *)tabBgView {
    
    if (!_tabBgView) {
        _tabBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    return _tabBgView;
}

- (UIButton *)cameraButton {
    
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.tag = LKItemTypeLaunch;
    }
    return _cameraButton;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[@"tab_live", @"tab_me"];
    }
    return _dataSource;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tabBgView];
        
        for (NSInteger idx=0; idx<self.dataSource.count; idx++)
        {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.adjustsImageWhenHighlighted = NO; //不让图片在高亮下改变
            [item setImage:[UIImage imageNamed:self.dataSource[idx]] forState:UIControlStateNormal];
            [item setImage:[UIImage imageNamed:[self.dataSource[idx] stringByAppendingString:@"_p"]] forState:UIControlStateSelected];
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = LKItemTypeLive + idx; //区分点击事件
            _cameraButton.tag = LKItemTypeLaunch + idx;
            
            if (idx == 0) {
                item.selected = YES;
                self.lastItem = item;
            }
            [self addSubview:item];
        }
        
        //添加启动直播按钮
        [self addSubview:self.cameraButton];
    }
    return self;
}

#pragma mark - Override Methods
- (void)setFrame:(CGRect)frame
{
    if (self.superview &&CGRectGetMaxY(self.superview.bounds) !=CGRectGetMaxY(frame)) {
        frame.origin.y =CGRectGetHeight(self.superview.bounds) -CGRectGetHeight(frame);
    }
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (NSInteger idx=0; idx<[self subviews].count; idx++) {
        UIView *btn = [self subviews][idx];
        CGFloat width = self.bounds.size.width / self.dataSource.count;
        
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.frame = CGRectMake((btn.tag - LKItemTypeLive) * width, 0, width, self.frame.size.height);
        }
    }
    
    self.tabBgView.frame = self.bounds;
    [self.cameraButton sizeToFit];
    self.cameraButton.center = CGPointMake(self.frame.size.width * 0.5, self.bounds.size.height - 50);
}


#pragma mark - <Actions For Handle>
- (void)itemClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemIndex:)]) {
        
        [self.delegate tabBar:self didSelectItemIndex:button.tag];
    }
    
    if (self.block) {
        self.block(self, button.tag);
    }
    
    //如果点击的是启动直播
    if (button.tag == LKItemTypeLaunch) {
        return;
    };
    
    //将上一个按钮的选中状态职位NO
    self.lastItem.selected = NO;
    
    //将正在点击的按钮状态置为YES
    button.selected = YES;
    
    //将当前按钮设置为上一个按钮
    self.lastItem = button;
    
    [self animaShow:button];
}

- (void)animaShow:(UIButton *)button {
    
    [UIView animateWithDuration:0.2 animations:^{
        button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            //动画恢复
            button.transform = CGAffineTransformIdentity;
        }];
    }];
}
@end
