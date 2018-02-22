//
//  LKMainTopView.m
//  LinekeLive
//
//  Created by CODER_TJ on 2017/6/24.
//  Copyright © 2017年 CODER_TJ. All rights reserved.
//

#import "LKSegmentItemBar.h"

@interface LKSegmentItemBar()
@property (nonatomic, strong) UIView *indicatorView; //线条指示器
@property (nonatomic, strong) NSMutableArray *itemGroups;

@end

@implementation LKSegmentItemBar

#pragma mark - Lazy
- (NSMutableArray *)itemGroups {
    
    if (!_itemGroups) {
        _itemGroups = [NSMutableArray array];
    }
    return _itemGroups;
}


#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame segmentItems:(NSArray *)items {
    
    if (self = [super initWithFrame:frame]) {
        CGFloat btnH = self.height;
        CGFloat btnW = self.width / items.count;
        
        for (NSInteger idx = 0; idx < items.count; idx++)
        {
            UIButton *titleItem = [UIButton buttonWithType:UIButtonTypeCustom];
            titleItem.titleLabel.textAlignment = NSTextAlignmentCenter;
            titleItem.titleLabel.font = [UIFont systemFontOfSize:18];
            [titleItem setTitle:items[idx] forState:UIControlStateNormal];
            [titleItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            titleItem.tag = idx; //tag值绑定
            titleItem.frame = CGRectMake(btnW*idx, 0, btnW, btnH);
            [titleItem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleItem]; //添加按钮
            [self.itemGroups addObject:titleItem];
            
            if (idx == 1) {
                CGFloat h = 2; //线条的高度
                CGFloat y = 40; //self.height - 10;
                [titleItem.titleLabel sizeToFit];
    
                self.indicatorView = [[UIView alloc] init];
                self.indicatorView.backgroundColor = [UIColor whiteColor];
                
                self.indicatorView.top     = y;
                self.indicatorView.height  = h;
                self.indicatorView.width   = titleItem.titleLabel.width;
                self.indicatorView.centerX = titleItem.centerX;
                [self addSubview:self.indicatorView];
            }
        }
    }
    
    return self;
}

#pragma mark - Setter
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    self.indicatorView.backgroundColor = tintColor;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitleColor:tintColor forState:UIControlStateNormal];
        }
    }
}

#pragma mark -
#pragma mark - Cycle Actions
//滑动控制器时调用title自动滚动
- (void)scrolling:(NSInteger)index
{
    UIButton *button = self.itemGroups[index]; //拿到按钮
    [self scrollEnd:button];
}

- (void)itemClick:(UIButton *)button
{
    if (self.didFinishedBlock){
        self.didFinishedBlock(button.tag);
    }
    
    [self scrolling:button.tag];
}

- (void)scrollEnd:(UIButton *)button {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.centerX = button.centerX;
    }];
}


@end
