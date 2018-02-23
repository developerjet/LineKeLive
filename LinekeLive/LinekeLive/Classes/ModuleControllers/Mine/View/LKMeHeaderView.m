//
//  LKMeHeaderView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMeHeaderView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import <Masonry.h>

@interface LKMeHeaderView()
@property (nonatomic, strong) UIView   *spaceView;
@property (nonatomic, strong) UIView   *bottomView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *topLeftBtn;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UIImageView *backGroundView;
@property (nonatomic, strong) NSArray *items; // 底部标题

@end

@implementation LKMeHeaderView

#pragma mark - Lazy
- (NSArray *)items {
    
    if (!_items) {
        _items = @[@"关注1", @"直播1", @"粉丝99"];
    }
    return _items;
}

#pragma mark - Life Cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubview];
        [self initConstraint];
    }
    return self;
}

- (void)initSubview {
    
    _spaceView = [[UIView alloc] init];
    _spaceView.backgroundColor = [UIColor grayColor];
    [self addSubview:_spaceView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    _backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_tableheader_image"]];
    [self addSubview:_backGroundView];
    
    _topLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topLeftBtn setImage:[UIImage imageNamed:@"me_global_search"] forState:UIControlStateNormal];
    [self addSubview:_topLeftBtn];
    
    _topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_topRightBtn setImage:[UIImage imageNamed:@"me_title_more"] forState:UIControlStateNormal];
    [self addSubview:_topRightBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"送出99";
    [self addSubview:_titleLabel];
    
    _topLeftBtn.tag  = 10000;
    _topRightBtn.tag = 10001;
    [_topLeftBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topRightBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstraint {

    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_spaceView.mas_top);
        make.left.right.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(_bottomView.mas_top).offset(0);
    }];
    
    [_topLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
        make.width.height.equalTo(@30);
    }];
    
    [_topRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-14);
        make.top.equalTo(self).offset(30);
        make.width.height.equalTo(@30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.centerX.equalTo(self);
        make.top.equalTo(_topLeftBtn);
    }];
    
    CGFloat w = SCREEN_WIDTH / self.items.count;
    for (int i = 0; i < self.items.count; i++)
    {
        UIButton *item = [[UIButton alloc] init];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        [item setTitle:self.items[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_bottomView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomView).offset(w * i);
            make.top.equalTo(_bottomView);
            make.bottom.equalTo(_bottomView);
            make.width.equalTo(@(w));
        }];
    }
}

#pragma mark - actions
- (void)onClick:(UIButton *)button {
    
    if (self.DidFinishedBlock) {
        self.DidFinishedBlock(button.tag);
    }
}


@end
