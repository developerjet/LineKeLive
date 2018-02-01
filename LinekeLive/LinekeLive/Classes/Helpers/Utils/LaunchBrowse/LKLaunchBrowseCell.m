//
//  LKAdvertImageCell.m
//  LinekeLive
//
//  Created by CoderTan on 2018/1/31.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKLaunchBrowseCell.h"

@implementation LKLaunchBrowseCell

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.featureView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.featureView];
    }
    return self;
}

- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    
    if ([imagePath containsString:@"http"] || [imagePath containsString:@"https"]) {
        [self.featureView downloadImage:imagePath placeholder:@"follow_bg"];
    }else {
        self.featureView.image = [UIImage imageNamed:imagePath];
    }
}

#pragma mark -
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.featureView.frame = self.bounds;
}

@end
