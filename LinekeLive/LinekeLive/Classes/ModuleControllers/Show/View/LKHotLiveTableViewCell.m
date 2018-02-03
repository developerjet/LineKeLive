//
//  LKHotLiveTableViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHotLiveTableViewCell.h"

@interface LKHotLiveTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *usersLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *backBgView;

@end

@implementation LKHotLiveTableViewCell

- (void)setFrame:(CGRect)frame {

    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configSubviews];
}

- (void)configSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    self.usersLabel.textColor = [UIColor orangeColor];
    self.headerView.layer.cornerRadius  = self.headerView.layer.frame.size.height*0.5;
    self.headerView.layer.masksToBounds = YES;
}

- (void)setModel:(LKLiveModel *)model {
    
    _model = model;
    
    self.cityLabel.text = model.city;
    self.nameLabel.text = model.creator.nick ? model.creator.nick : model.nick;
    self.detailLabel.text = model.creator.birth ? model.creator.birth : model.level;
    self.usersLabel.text = [NSString stringWithFormat:@"%ld 在看", model.onlineUsers];
    [self.headerView downloadImage:model.creator.portrait ? model.creator.portrait : model.image2 placeholder:@"default_room"];
    [self.backBgView downloadImage:model.creator.portrait ? model.creator.portrait : model.image2 placeholder:@"default_room"];
}

@end
