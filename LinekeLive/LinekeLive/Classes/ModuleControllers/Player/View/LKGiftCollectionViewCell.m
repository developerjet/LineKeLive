//
//  LKGiftCollectionViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/7.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKGiftCollectionViewCell.h"

@interface LKGiftCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *giftPrice;

@end

@implementation LKGiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configUI];
}


- (void)configUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.layer.cornerRadius = 5;
    selectView.layer.masksToBounds = YES;
    selectView.layer.borderWidth = 1;
    selectView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    selectView.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundView = selectView;
}


- (void)setModel:(LKGiftModel *)model {
    
    _model = model;
    
    [self.giftImage downloadImage:model.img2 placeholder:@"default_room"];
    self.giftName.text = model.subject;
    self.giftPrice.text = [NSString stringWithFormat:@"￥%.2ld", model.coin];
}

@end
