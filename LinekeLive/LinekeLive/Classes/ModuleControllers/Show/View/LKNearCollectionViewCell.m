//
//  LKNearCollectionViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/27.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKNearCollectionViewCell.h"

@interface LKNearCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *levelView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation LKNearCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configUI];
}

- (void)configUI {
    
    self.iconView.userInteractionEnabled = NO;
    self.levelView.layer.cornerRadius = 3.0;
    self.levelView.layer.masksToBounds = YES;
    self.levelView.backgroundColor = [UIColor colorWithRandom];//随机色
    self.backgroundColor = [UIColor colorBackGroundWhiteColor];
    self.distanceLabel.textColor = [UIColor colorDarkTextColor];
    [self.levelView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)showAnimate {
    
    if (self.model.isShow) {
        return;
    }
    
    self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
    
    [UIView animateWithDuration:1 animations:^{
        
        self.layer.transform = CATransform3DMakeScale(1, 1, 1); //恢复原始大小
        
        self.model.show = YES;
    }];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
}

- (void)setModel:(LKLiveModel *)model {
    
    _model = model;
    
    self.distanceLabel.text = model.distance;
    [self.iconView downloadImage:model.creator.portrait placeholder:@"default_room"];
    [self.levelView setTitle:[NSString stringWithFormat:@"%ld", model.creator.level] forState:UIControlStateNormal];
}

@end
