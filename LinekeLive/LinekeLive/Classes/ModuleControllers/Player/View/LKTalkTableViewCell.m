//
//  LKTalkTableViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/17.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKTalkTableViewCell.h"

@interface LKTalkTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *levelView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *talkLabel;

@end

@implementation LKTalkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configUI];
}

- (void)configUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.levelView.layer.cornerRadius = 3.0;
    self.levelView.layer.masksToBounds = YES;
    self.levelView.backgroundColor = [UIColor colorWithRandom];
    [self.levelView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.talkLabel.textColor = [UIColor whiteColor];   
}

- (void)setModel:(LKSessionModel *)model {
    _model = model;
    
    NSString *level = [NSString stringWithFormat:@"%ld", model.level];
    [self.levelView setTitle:level forState:UIControlStateNormal];
    self.nameLabel.text = [NSString stringWithFormat:@"%@:", model.name];
    self.talkLabel.text = model.talk;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
