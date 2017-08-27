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
@property (nonatomic, strong) UIImageView *tabBgView; //tabBar背景图片
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIButton *cameraButton;


@end

@implementation LKBasicTabBar

#pragma mark - LazyLoad

- (UIButton *)cameraButton {
    
    if (_cameraButton == nil) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.tag = LKItemTypeLaunch;
    }
    return _cameraButton;
}

- (UIImageView *)tabBgView {
    
    if (_tabBgView == nil) {
        _tabBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"global_tab_bg"]];
    }
    
    return _tabBgView;
}

- (NSArray *)dataSource {
    
    if (_dataSource == nil) {
        _dataSource = @[@"tab_live", @"tab_me"];
    }
    return _dataSource;
}

#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.tabBgView];
        
        for (NSInteger idx=0; idx<self.dataSource.count; idx++) {
    
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


/**
 按钮布局
 */
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


#pragma mark - DidSelectItem

- (void)itemClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemIndex:)]) {
        
        [self.delegate tabBar:self didSelectItemIndex:button.tag];
    }
    
    //!self.block?:self.block(self, button.tag);
    
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
    
    [self animateStart:button];
}


/**
 添加动画
 */
- (void)animateStart:(UIButton *)button {
    
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
