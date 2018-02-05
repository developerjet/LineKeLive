//
//  LKLiveChatViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLiveRoomViewController.h"
#import "LKAnimationManager.h"
#import "LKShareActivityView.h"
#import "LKLiveSessionView.h"
#import "LKUserListView.h"
#import "LKGiftListView.h"
#import "LKDanmuModel.h"
#import "LKGiftModel.h"
#import "LKDanmuView.h"
#import "LKGiftData.h"

@interface LKLiveRoomViewController ()<UITextViewDelegate, LKGiftListViewDelegate, LKDanmuViewProtocol>
@property (weak, nonatomic) IBOutlet UIView      *menuView;
@property (weak, nonatomic) IBOutlet UILabel     *countLable;
@property (weak, nonatomic) IBOutlet UIButton    *ticketView;
@property (weak, nonatomic) IBOutlet UIButton    *followView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic, weak)   LKDanmuView *danmuView;
@property (nonatomic, strong) LKGiftListView *giftListView;
@property (nonatomic, strong) UIView *showView; //礼物展示区域
@property (nonatomic, strong) LKGiftData *data;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *keyBoardView;
@property (nonatomic, strong) UITextView *inputTextView; //聊天输入框
@property (nonatomic, strong) LKUserListView *userListView;
@property (nonatomic, strong) LKLiveSessionView *sessionView;
@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, assign) CGFloat originalY;

@end

@implementation LKLiveRoomViewController

#pragma mark - lazy

- (LKGiftData *)data {
    
    if (!_data) {
        _data = [[LKGiftData alloc] init];
    }
    return _data;
}

#pragma mark - viewLoad

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubviews];
    [self initKeyboardNote];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initSession];
}

- (void)initKeyboardNote {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)isFollow {
    
    return [[LKCacheHelper shared] getAncherIsFollow:self.model];
}

- (void)initSession {
    
    LKLiveSessionView *sessionView = [[LKLiveSessionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-210, SCREEN_WIDTH, 160)];
    [self.view addSubview:sessionView];
    [self.view bringSubviewToFront:sessionView];
    _originalY = sessionView.center.y;
    _sessionView = sessionView;
    
    __weak typeof(self) weakSelf = self;
    sessionView.isDraggBlock = ^{
        [weakSelf.view endEditing:YES];
    };
}

- (void)configSubviews {
    
    self.view.backgroundColor = [UIColor clearColor];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.menuView.layer.cornerRadius = self.menuView.layer.frame.size.height * 0.5;
    self.menuView.layer.masksToBounds = YES;
    
    self.ticketView.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.iconView.layer.cornerRadius  = self.iconView.layer.height * 0.5;
    self.iconView.layer.masksToBounds = YES;

    self.followView.layer.cornerRadius  = self.followView.layer.height * 0.5;
    self.followView.layer.masksToBounds = YES;
    
    if ([self isFollow]) {
        self.followView.selected = YES;
        [self.followView setTitle:@"已关注" forState:UIControlStateNormal];
    }else {
        self.followView.selected = NO;
        [self.followView setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        _timer = timer;
        [self.ticketView setTitle:[NSString stringWithFormat:@"映票 %d", arc4random_uniform(10000)] forState:UIControlStateNormal]; //随机显示映票数
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } repeats:YES];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-140)/2, SCREEN_WIDTH, 140)];
    self.showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.showView];
    
    /// 弹幕
    LKDanmuView *danmuView = [[LKDanmuView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 150)];
    danmuView.delegate = self;
    self.danmuView = danmuView;
    [self.view addSubview:danmuView];
    
    // 用户列表
    CGFloat userX = CGRectGetMaxX(self.menuView.frame) + 10;
    CGFloat userW = SCREEN_WIDTH - userX - 60;
    _userListView = [[LKUserListView alloc] initWithFrame:CGRectMake(userX, 30, userW, 40)];
    [self.view addSubview:_userListView];
    
    /// 会话输入
    [self createKeyBoard];
}

- (void)createKeyBoard {
    
    //自定义聊天输入框
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    _keyBoardView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.view addSubview:_keyBoardView];
    [self.view bringSubviewToFront:_keyBoardView];
    
    CGFloat padding = 10;
    
    CGFloat btnW = 70;
    CGFloat btnX = SCREEN_WIDTH - (btnW + padding);
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = [UIColor colorNavThemeColor];
    sendButton.frame = CGRectMake(btnX, padding, btnW, 30);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sendButton.userInteractionEnabled = YES;
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    [sendButton addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [_keyBoardView addSubview:sendButton];
    
    CGFloat boxW = 30;
    CGFloat boxX = SCREEN_WIDTH - (btnW + padding) - (boxW + padding);
    UIButton *boxInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [boxInButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    boxInButton.frame = CGRectMake(boxX, padding, boxW, boxW);
    [_keyBoardView addSubview:boxInButton];
    
    CGFloat textW = SCREEN_WIDTH - (btnW + padding) - (boxW + padding) - 2*padding;
    UITextView *inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding, textW, 30)];
    inputTextView.delegate = self;
    inputTextView.layer.cornerRadius = 3;
    inputTextView.layer.borderWidth = 0.8;
    inputTextView.returnKeyType = UIReturnKeySend;
    inputTextView.layer.borderColor = COLORHEX(@"e8e8e8").CGColor;
    [_keyBoardView addSubview:inputTextView];
    _inputTextView = inputTextView;
}

- (void)keyboardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:[curve integerValue]]; //设置动画曲线，控制动画速度
        _keyBoardView.center = CGPointMake(_keyBoardView.center.x, keyBoardEndY-_keyBoardView.bounds.size.height/2.0);
        _sessionView.center = CGPointMake(_sessionView.center.x, keyBoardEndY-_keyBoardView.frame.size.height- _sessionView.bounds.size.height/2.0);
        [UIView commitAnimations];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    CGFloat keyBoardEndH = value.CGRectValue.size.height;
    NSNumber *duration = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:[curve integerValue]];
        _keyBoardView.center = CGPointMake(_keyBoardView.center.x, keyBoardEndY - (_keyBoardView.bounds.size.height - keyBoardEndH)/2);
        _sessionView.center = CGPointMake(_sessionView.center.x, _originalY);
        [UIView commitAnimations];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    self.inputTextView.text = @"";
}

#pragma mark - LKDanmuViewProtocol
- (UIView *)danmuViewWithModel:(LKDanmuModel *)model {
    
    UILabel *label = [UILabel new];
    label.text = model.content;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRandom];
    [label sizeToFit];
    
    return label;
}

- (NSTimeInterval)currentTime {
    
    static double time;
    time += 0.1;
    return time;
}

#pragma mark - Setter
- (void)setModel:(LKLiveModel *)model {
    
    _model = model;
    
    [self.iconView downloadImage:model.creator.portrait placeholder:@"default_room"];
    self.countLable.text = [NSString stringWithFormat:@"%ld人", (long)model.onlineUsers];
}

#pragma mark - Room Actions
- (IBAction)roomEvents:(UIButton *)btn {
    LKPlayerEventStatus status = btn.tag;
    
    switch (status) {
        case LKPlayerEventStatus_Session:
            [self.inputTextView becomeFirstResponder]; //弹出会话输入框
            break;
        case LKPlayerEventStatus_GiveGift:
            [self showGiftBox];
            break;
        case LKPlayerEventStatus_Activity:
            [self showActivity];
            break;
        case LKPlayerEventStatus_Message:
            break;
        default:
            break;
    }
}

- (void)showGiftBox {
    
    LKGiftListView *ListBox = [[LKGiftListView alloc] init];
    ListBox.delegate = self;
    [ListBox show];
}

- (void)showActivity {
    
    NSArray *activitys = @[@"shareView_qq", @"shareView_wx", @"shareView_friend", @"shareView_msg", @"shareView_copylink"];
    LKShareActivityView *activity = [[LKShareActivityView alloc] initWithConfigActivitys:activitys];
    [activity show];
}

- (IBAction)followClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        self.model.follow = YES;
        [[LKCacheHelper shared] followAnchor:self.model];
        [self.followView setTitle:@"已关注" forState:UIControlStateNormal];
        [XDProgressHUD showHUDWithText:@"已关注主播" hideDelay:1.0];
    }else {
        self.model.follow = NO;
        [[LKCacheHelper shared] unFollowAnchor:self.model];
        [self.followView setTitle:@"关注" forState:UIControlStateNormal];
        [XDProgressHUD showHUDWithText:@"取消关注" hideDelay:1.0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFollowKey object:nil];
}

- (void)sendClick {
    
    LKDanmuModel *dmModel = [LKDanmuModel new];
    dmModel.beginTime = 2;
    dmModel.liveTime = 5;
    dmModel.content = self.inputTextView.text;
    [self.danmuView.models addObject:dmModel];
    
    LKSessionModel *session = [LKSessionModel new];
    session.level = 9;
    session.name = @"王思聪";
    session.talk = self.inputTextView.text;
    self.sessionView.session = session;
    
    //清除之前的会话
    self.inputTextView.text = @"";
}

#pragma mark - LKGiftListViewDelegate
- (void)startAnimaView:(LKGiftListView *)giftView DidSelectItem:(LKGiftModel *)model {
    
    self.data.giftIcon = model.img2;
    self.data.giftName = model.subject; //礼物名称
    self.data.senderName  = [NSString stringWithFormat:@"用户%d", arc4random()%2]; //模拟两个用户在送礼物
    self.data.deveiceType = [NSString stringWithFormat:@"%d", arc4random()%2+1]; //模拟用户设备
    
    LKAnimationManager *manager = [LKAnimationManager manager];
    manager.parentView = self.showView;
    [manager animWithData:self.data finishedBlock:^(BOOL result) {
        LKLog(@"complete...");
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self sendClick];
        [self.inputTextView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - remove
- (void)dealloc {
    
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//移除timer
- (void)removeTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
