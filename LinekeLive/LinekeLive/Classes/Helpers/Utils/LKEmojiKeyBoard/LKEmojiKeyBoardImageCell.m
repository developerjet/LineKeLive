//
//  LKEmojiKeyBoardImageCell.m
//  LinekeLive
//
//  Created by CoderTan on 2018/2/7.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "LKEmojiKeyBoardImageCell.h"

@implementation LKEmojiKeyBoardImageCell{
    
    UIButton *_emojiButton;
}

#pragma mark - <initWithFrame>
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emojiButton.userInteractionEnabled = NO; //避免冲突
        [_emojiButton setImage:[self setImage:@"aio_face_delete"] forState:UIControlStateNormal];
        [_emojiButton setImage:[self setImage:@"aio_face_delete_pressed"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_emojiButton];
    }
    return self;
}

- (UIImage *)setImage:(NSString *)imageName {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x", imageName] ofType:@"png"];
    return [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark - <layoutSubviews>
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _emojiButton.frame = self.bounds;
}

@end
