//
//  LKHotLiveTableViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/25.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKHotLiveTableViewCell.h"

@interface LKHotLiveTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *watchLable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;

@end

@implementation LKHotLiveTableViewCell

- (void)setFrame:(CGRect)frame {

    frame.size.height -= 10;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setCellUI];
}


- (void)setCellUI {
    
    self.backgroundColor = [UIColor clearColor];
    self.watchLable.textColor = [UIColor orangeColor];
    self.headView.layer.cornerRadius = self.headView.layer.frame.size.height*0.5;
    self.headView.layer.masksToBounds = YES;
}

- (void)setModel:(LKLiveModel *)model {
    
    _model = model;
    
    self.locationLabel.text = model.city;
    self.nameLabel.text = model.creator.nick ? model.creator.nick : model.nick;
    self.categoriesLabel.text = model.creator.birth ? model.creator.birth : model.level;
    self.watchLable.text = [NSString stringWithFormat:@"%ld 在看", model.onlineUsers];
    [self.headView downloadImage:model.creator.portrait ? model.creator.portrait : model.image2 placeholder:@"default_room"];
    [self.bigImageView downloadImage:model.creator.portrait ? model.creator.portrait : model.image2 placeholder:@"default_room"];
}

@end
