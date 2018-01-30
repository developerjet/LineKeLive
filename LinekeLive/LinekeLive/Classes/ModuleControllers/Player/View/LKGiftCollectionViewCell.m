//
//  LKGiftCollectionViewCell.m
//  LinekeLive
//
//  Created by CoderTan on 2017/8/7.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKGiftCollectionViewCell.h"

@interface LKGiftCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *giftPrice;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;

@end

@implementation LKGiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureas];
}

- (void)configureas {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *selectView = [[UIView alloc] init];
    selectView.layer.cornerRadius = 5;
    selectView.layer.borderWidth = 1.5;
    selectView.layer.borderColor = [UIColor orangeColor].CGColor;
    selectView.layer.masksToBounds = YES;
    
    selectView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectView;
}


- (void)setModel:(LKGiftModel *)model {
    _model = model;
    
    self.giftName.text = model.subject;
    [self.giftImage downloadImage:model.img2 placeholder:@"default_room"];
    self.giftPrice.text = [NSString stringWithFormat:@"￥%.2ld", model.coin];
}

@end
