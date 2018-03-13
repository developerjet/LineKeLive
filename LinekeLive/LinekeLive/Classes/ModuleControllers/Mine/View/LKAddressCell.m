//
//  LKAddressCell.m
//  LinekeLive
//
//  Created by Original_TJ on 2018/2/27.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKAddressCell.h"

@implementation LKAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAddressMode:(NSDictionary *)addressMode {
    
    _addressMode = addressMode;
    
    self.nameLabel.text = addressMode[@"name"];
    self.phoneLabel.text = addressMode[@"phone"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
