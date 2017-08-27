//
//  LKMainTopView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/24.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMainTopView.h"

@interface LKMainTopView()
@property (nonatomic, strong) UIView *lineView; //线条指示器
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation LKMainTopView

#pragma mark - lazyLoad

- (NSMutableArray *)buttons {
    
    if (!_buttons) {
    
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titleNemas {
    
    if (self = [super initWithFrame:frame]) {
        
        CGFloat btnW = self.width / titleNemas.count;
        CGFloat btnH = self.height;
        
        for (NSInteger idx=0 ; idx<titleNemas.count; idx++) {
            NSString *vcName = titleNemas[idx];
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            [titleBtn setTitle:vcName forState:UIControlStateNormal];
            [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            titleBtn.tag = idx; //tag值绑定
            titleBtn.frame = CGRectMake(btnW*idx, 0, btnW, btnH);
            [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn]; //添加按钮
            [self.buttons addObject:titleBtn];
            
            if (idx == 1) {
                CGFloat h = 2; //线条的高度
                CGFloat y = 40; //self.height - 10;
                
                [titleBtn.titleLabel sizeToFit];
    
                self.lineView = [[UIView alloc] init];
                self.lineView.backgroundColor = [UIColor whiteColor];
                
                self.lineView.top = y;
                self.lineView.height = h;
                self.lineView.width = titleBtn.titleLabel.width;
                self.lineView.centerX = titleBtn.centerX;
                [self addSubview:self.lineView];
            }
        }
    }
    
    return self;
}


#pragma mark - 

//滑动控制器时调用title自动滚动
- (void)scrolling:(NSInteger)index {
    
    UIButton *button = self.buttons[index]; //拿到按钮
    
    [self animateStart:button];
}

- (void)titleClick:(UIButton *)button {
    
    if (self.topBlock) {
        
        self.topBlock(button.tag);
    }
    
    [self scrolling:button.tag];
}


- (void)animateStart:(UIButton *)button {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.lineView.centerX = button.centerX;
    }];
}


@end
