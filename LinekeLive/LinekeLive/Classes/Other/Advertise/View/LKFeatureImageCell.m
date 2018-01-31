//
//  LKAdvertImageCell.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/31.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKFeatureImageCell.h"

@implementation LKFeatureImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.showImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.showImgView];
    }
    return self;
}

- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    
    if ([imagePath containsString:@"http"] || [imagePath containsString:@"https"]) {
        [self.showImgView downloadImage:imagePath placeholder:@"follow_bg"];
    }else {
        self.showImgView.image = [UIImage imageNamed:imagePath];
    }
}

#pragma mark -
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.showImgView.frame = self.bounds;
}

@end
