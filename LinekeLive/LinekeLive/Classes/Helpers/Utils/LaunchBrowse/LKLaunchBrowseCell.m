//
//  LKAdvertImageCell.m
//  LinekeLive
//
//  Created by CODER_TJ on 2018/1/31.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKLaunchBrowseCell.h"
#import <UIImageView+WebCache.h>

@implementation LKLaunchBrowseCell

#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.browseView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.browseView];
    }
    return self;
}

- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;
    
    if ([imagePath containsString:@"http"] || [imagePath containsString:@"https"]) {
        [self.browseView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"follow_bg"]];
    }else {
        self.browseView.image = [UIImage imageNamed:imagePath];
    }
}

#pragma mark -
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.browseView.frame = self.bounds;
}

@end
