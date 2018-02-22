//
//  LKEmojiKeyBoardCell.m
//  LinekeLive
//
//  Created by CoderTan on 2018/2/7.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKEmojiKeyBoardLabelCell.h"

@implementation LKEmojiKeyBoardLabelCell{
    UILabel *_emojiLabel;
}

#pragma mark - <initWithFrame>
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_emojiLabel];
    }
    return self;
}

#pragma mark - <Setters>
- (void)setEmoji:(NSString *)emoji {
    _emoji = emoji;
    
    _emojiLabel.text = emoji;
}

#pragma mark - <layoutSubviews>
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _emojiLabel.frame = self.bounds;
}

@end
