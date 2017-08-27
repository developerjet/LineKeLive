//
//  LKMeHeaderView.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/28.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMeHeaderView.h"

static NSString * iconURL = @"http://p3.music.126.net/cm1Zl1iA4FWPOeFciGJhxQ==/7834020348056256.jpg";

@interface LKMeHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation LKMeHeaderView

+ (instancetype)loadNibCell {
    
    NSBundle *_currentBundle = [NSBundle mainBundle];
    LKMeHeaderView *meHeaderV = [[_currentBundle loadNibNamed:@"LKMeHeaderView" owner:nil options:nil] firstObject];
    
    return meHeaderV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUpUI];
}

- (void)setUpUI {

    self.iconView.layer.cornerRadius = self.iconView.layer.frame.size.height*0.5;
    self.iconView.layer.masksToBounds = YES;
    [self.iconView downloadImage:iconURL placeholder:@"icon"];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
}

@end
