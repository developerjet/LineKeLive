//
//  LKMeTableViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMeTableViewCell.h"

@interface LKMeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation LKMeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorBackGroundWhiteColor];
}


- (void)setModel:(LKMineModel *)model {
    
    _model = model;
    
    _leftLabel.text = model.title;
    _rightLabel.text = model.detail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
