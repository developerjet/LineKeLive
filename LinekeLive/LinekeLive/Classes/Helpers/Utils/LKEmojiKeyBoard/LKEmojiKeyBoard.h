//
//  EmojiManagerView.h
//  LinekeLive
//
//  Created by CoderTan on 2018/2/6.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKEmojiKeyBoard;
@protocol LKEmojiKeyBoardDelegate <NSObject>
@optional

- (void)emojiKeyBoard:(LKEmojiKeyBoard *)keyBoard didSendEmoji:(NSString *)emoji;
- (void)emojiKeyBoardEventDeleteValue;
@end

@interface LKEmojiKeyBoard : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LKEmojiKeyBoardDelegate>)delegate;

@property (nonatomic, weak) id<LKEmojiKeyBoardDelegate> delegate;

@end
