//
//  InputBoxBar.m
//  LinekeLive
//
//  Created by CODER_TJ on 2018/2/6.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import "InputBoxBar.h"

#define kSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

static CGFloat kBoxBar_Height = 60;
static CGFloat kEmojis_Height = 180;

@interface InputBoxBar()<UITextViewDelegate, LKEmojiKeyBoardDelegate>
@property (nonatomic, strong) UIView     *topLine;
@property (nonatomic, strong) UIView     *botLine;

@property (nonatomic, strong) UIButton   *voicesButton; // 声音
@property (nonatomic, strong) UIButton   *senderButton; // 发送
@property (nonatomic, strong) UIButton   *switchButton; // 用于切换文字&表情键盘

@property (nonatomic, strong) UIView     *configedgView; //边框
@property (nonatomic, strong) UITextView *configTextView;
/// 系统键盘的高度
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat emojiHeight; //表情键盘高度
/// 自定义表情键盘
@property (nonatomic, strong) LKEmojiKeyBoard *keyBoardView;

@property (nonatomic, assign) double     originDuration;
@property (nonatomic, assign) NSInteger  animationCurve;
@property (nonatomic, assign) BOOL       keyboardIsVisible;
@property (nonatomic, assign) kInputBarDidStatus keyBoardStatus;

@end

@implementation InputBoxBar

#pragma mark - initial
- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        self.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kBoxBar_Height);
        
        [self initSubview];
        [self initKeyBoardNote];
    }
    return self;
}

- (void)initSubview {
    _maxLine  = 3;
    _fontSize = 16;
    _keyboardIsVisible = YES;
    _keyBoardStatus = kInputBarDidStatus_Emoji; //默认系统键盘
    
    CGFloat padding = 10;
    CGFloat lineHeight = 1;
    
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, lineHeight)];
    _topLine.backgroundColor = [self utilColor];
    [self addSubview:_topLine];
    
    _botLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-lineHeight, kSCREEN_WIDTH, lineHeight)];
    _botLine.backgroundColor = [self utilColor];
    [self addSubview:_botLine];
    
    CGFloat voiceW = 30;
    CGFloat originY = (self.height - voiceW) * 0.5;
    self.voicesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voicesButton.frame = CGRectMake(padding, originY, voiceW, voiceW);
    [self.voicesButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    [self.voicesButton setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
    [self addSubview:self.voicesButton];
    
    
    CGFloat btnW = 60;
    CGFloat btnX = SCREEN_WIDTH - (btnW + padding);
    self.senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.senderButton.frame = CGRectMake(btnX, padding, btnW, 28);
    self.senderButton.backgroundColor = [UIColor colorNavThemeColor];
    [self.senderButton setTitle:@"发送" forState:UIControlStateNormal];
    self.senderButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.senderButton.userInteractionEnabled = YES;
    self.senderButton.layer.cornerRadius = 5;
    self.senderButton.layer.masksToBounds = YES;
    [self.senderButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.senderButton];
    
    CGFloat boxX = SCREEN_WIDTH - (btnW + padding) - (voiceW + padding);
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(boxX, originY, voiceW, voiceW);
    [self.switchButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
    [self.switchButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateSelected];
    [self.switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.switchButton.selected = YES;
    [self addSubview:self.switchButton];
    
    // 边框
    CGFloat width = SCREEN_WIDTH - (btnW + padding) - 2*(voiceW + padding) - 2*padding;
    self.configedgView = [[UIView alloc] init];
    self.configedgView.width = width;
    self.configTextView.height = [self defaultTxHeight]+10;
    self.configedgView.left = CGRectGetMaxX(self.voicesButton.frame) + padding;
    self.configedgView.layer.borderWidth = 1;
    self.configedgView.layer.cornerRadius = 3;
    self.configedgView.layer.borderColor = [self utilColor].CGColor;
    self.configedgView.layer.masksToBounds = YES;
    [self addSubview:self.configedgView];
    
    self.configTextView = [[UITextView alloc] init];
    self.configTextView.left = CGRectGetMaxX(self.voicesButton.frame) + padding + 5;
    self.configTextView.width = self.configedgView.width - 10;
    self.configTextView.height = [self defaultTxHeight];
    self.configTextView.delegate = self;
    self.configTextView.scrollsToTop = NO;
    self.configTextView.returnKeyType = UIReturnKeySend;
    self.configTextView.font = [UIFont systemFontOfSize:_fontSize];
    self.configTextView.backgroundColor = [UIColor clearColor];
    self.configTextView.textContainerInset = UIEdgeInsetsZero;
    self.configTextView.textContainer.lineFragmentPadding = 0;
    self.configTextView.enablesReturnKeyAutomatically = YES;
    self.configTextView.layoutManager.allowsNonContiguousLayout = NO;
    [self addSubview:self.configTextView];
    
    self.keyBoardView = [[LKEmojiKeyBoard alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kEmojis_Height, SCREEN_WIDTH, kEmojis_Height) delegate:self];
    self.keyBoardView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.keyBoardView];
}

- (UIColor *)utilColor {
    
    return [UIColor colorWithHexString:@"e8e8e8"];
}

// 默认输入框高度
- (CGFloat)defaultTxHeight {
    
    if (!_fontSize || _fontSize < 20) {
        _fontSize = 16;
    }
    self.configTextView.font = [UIFont systemFontOfSize:_fontSize];
    CGFloat lineHeight = self.configTextView.font.lineHeight;
    self.height = ceil(lineHeight) + 10 + 10;
    return lineHeight;
}

- (void)initKeyBoardNote
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
     _keyboardIsVisible    = YES;
    _keyBoardView.hidden   = YES;
    _switchButton.selected = YES;
    
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    _originDuration = duration.doubleValue;
    _animationCurve = [curve integerValue];
    _keyboardHeight = value.CGRectValue.size.height;
    [UIView animateWithDuration:_originDuration animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve]; //设置动画曲线，控制动画速度
        self.center = CGPointMake(self.center.x, keyBoardEndY-self.bounds.size.height/2.0);
        [UIView commitAnimations];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    _keyboardIsVisible = NO;
    if (!_keyboardIsVisible) return;
    
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    CGFloat keyBoardEndH = value.CGRectValue.size.height;
    NSNumber *duration = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    _originDuration = duration.doubleValue;
    _animationCurve = [curve integerValue];
    [UIView animateWithDuration:_originDuration animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve];
        self.center = CGPointMake(self.center.x, keyBoardEndY - (self.bounds.size.height - keyBoardEndH)/2);
        [UIView commitAnimations];
    }];
}

#pragma mark -
#pragma mark - Setters - Getters
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    
    if (!fontSize || _fontSize < 20) {
        _fontSize = 20;
    }
    self.configTextView.font = [UIFont systemFontOfSize:_fontSize];
    CGFloat lineH = self.configTextView.font.lineHeight;
    self.height = ceil(lineH) + 10 + 10;
    self.configTextView.height = lineH;
}

- (void)setMaxLine:(NSInteger)maxLine {
    _maxLine = maxLine;
    
    if (!_maxLine || _maxLine <= 0) {
        _maxLine = 3;
    }
}

- (NSString *)content {
    
    if (self.configTextView.text.length) {
        return self.configTextView.text;
    }
    return nil;
}

#pragma mark - <LKEmojiKeyBoardDelegate>
- (void)emojiKeyBoard:(LKEmojiKeyBoard *)keyBoard didSendEmoji:(NSString *)emoji {
    
    [self.configTextView insertText:emoji];
}

- (void)emojiKeyBoardEventDeleteValue {
    
    if (self.configTextView.text.length) {
        [self.configTextView deleteBackward];
    }
}

#pragma mark - Actions for Handel
- (void)switchAction:(UIButton *)button {
    button.selected = !button.selected;
    
    if (!button.selected) { //弹出表情键盘
        _keyBoardStatus = kInputBarDidStatus_Emoji;
        [self endEditing:YES]; //系统键盘退出
        [UIView animateWithDuration:_originDuration+0.35 animations:^{
            [UIView setAnimationsEnabled:YES];
            [UIView setAnimationCurve:_animationCurve];
            self.center = CGPointMake(self.center.x, self.keyBoardView.top - (self.height/2));
            self.keyBoardView.hidden = NO;
            [UIView commitAnimations];
        }];
        
    }else {
        _keyBoardStatus = kInputBarDidStatus_keyboard;
        [self become];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxBar:DidKeyBoardStatus:)]) {
        
        [self.delegate inputBoxBar:self DidKeyBoardStatus:_keyBoardStatus];
    }
}

- (void)become {
    
    [self.configTextView becomeFirstResponder];
}

- (void)recovery {
    self.switchButton.selected = YES;
    
    [self endEditing:YES]; //系统键盘退出
    [UIView animateWithDuration:_originDuration animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve];
        self.center = CGPointMake(self.center.x, kSCREEN_HEIGHT + self.height);
        self.keyBoardView.hidden = YES;
        [UIView commitAnimations];
    }];
}

// 清空输入信息
- (void)reset {
    if (self.configTextView.text.length > 0) {
        if (self.editFinishedBlock) {
            self.editFinishedBlock(self.configTextView.text);
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxBar:DidEndEditingAtText:)]) {
            
            [self.delegate inputBoxBar:self DidEndEditingAtText:self.configTextView.text];
        }
    }
    
    self.configTextView.text = nil;
    [self.configTextView.delegate textViewDidChange:self.configTextView];
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length <= 0) {
        self.senderButton.enabled = NO;
    }else {
        self.senderButton.enabled = YES;
    }
    
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.maxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.height = contentSizeH;
    }else{
        textView.height = maxTextViewHeight;
    }
    self.height = ceil(textView.height) + 10 + 10;
    self.bottom = self.keyboardIsVisible == YES ? kSCREEN_HEIGHT - _keyboardHeight : kSCREEN_HEIGHT - kEmojis_Height;
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputBoxBar:DidEditingAtText:)]) {
        
        [self.delegate inputBoxBar:self DidEditingAtText:textView.text];
    }
}

#pragma mark -
#pragma mark - <layoutSubviews>
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.switchButton.centerY = self.height * 0.5;
    self.senderButton.centerY = self.height * 0.5;
    self.voicesButton.centerY = self.height * 0.5;
    
    self.configedgView.height   = self.configTextView.height + 10;
    self.configedgView.centerY  = self.height * 0.5;
    self.configTextView.centerY = self.height * 0.5;
    self.botLine.bottom = self.height - 1;
}

#pragma mark - dealloc
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
