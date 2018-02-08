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
#import "LKBarrageModel.h"
#import "LKGiftModel.h"
#import "LKBarrageCoreView.h"
#import "InputBoxBar.h"
#import "LKGiftData.h"

@interface LKLiveRoomViewController ()<UITextViewDelegate, LKGiftListViewDelegate, LKDanmuViewProtocol, InputBoxBarDelegate>
@property (weak, nonatomic) IBOutlet UIView      *connectView;
@property (weak, nonatomic) IBOutlet UIButton    *timerButton;
@property (weak, nonatomic) IBOutlet UILabel     *onUsersLabel;
@property (weak, nonatomic) IBOutlet UIButton    *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *showView; //礼物展示区域
@property (nonatomic, strong) LKGiftData *data;
@property (nonatomic,   weak) LKBarrageCoreView *danmuView;
@property (nonatomic, strong) LKGiftListView *giftListView;

@property (nonatomic, strong) InputBoxBar       *keyBoardBar;;
@property (nonatomic, strong) LKUserListView    *userListView;
@property (nonatomic, strong) LKLiveSessionView *sessionView;
@property (nonatomic, assign) kInputBarDidStatus status;

@property (nonatomic, assign) CGFloat    sessionOriginY;
@property (nonatomic, assign) double     originDuration;
@property (nonatomic, assign) NSInteger  animationCurve;
@property (nonatomic, assign) BOOL       keyboardIsVisible;
@end

@implementation LKLiveRoomViewController

#pragma mark - Lazy
- (LKGiftData *)data {
    
    if (!_data) {
        _data = [[LKGiftData alloc] init];
    }
    return _data;
}

#pragma mark - DidLoads
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSubviews];
    [self initKeyboardNote];
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
    _sessionOriginY = sessionView.center.y;
    _sessionView = sessionView;
}

- (void)configSubviews {
    
    self.view.backgroundColor = [UIColor clearColor];
    self.connectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.connectView.layer.cornerRadius = self.connectView.layer.frame.size.height * 0.5;
    self.connectView.layer.masksToBounds = YES;
    
    self.timerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.headerImgView.layer.cornerRadius  = self.headerImgView.layer.height * 0.5;
    self.headerImgView.layer.masksToBounds = YES;

    self.followButton.layer.cornerRadius  = self.followButton.layer.height * 0.5;
    self.followButton.layer.masksToBounds = YES;
    
    if ([self isFollow]) {
        self.followButton.selected = YES;
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else {
        self.followButton.selected = NO;
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        _timer = timer;
        [self.timerButton setTitle:[NSString stringWithFormat:@"映票 %d", arc4random_uniform(10000)] forState:UIControlStateNormal]; //随机显示映票数
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    } repeats:YES];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-140)/2, SCREEN_WIDTH, 140)];
    self.showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.showView];
    
    /// 弹幕
    LKBarrageCoreView *danmuView = [[LKBarrageCoreView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 150)];
    danmuView.delegate = self;
    self.danmuView = danmuView;
    [self.view addSubview:danmuView];
    
    [self initSession];
    
    // 用户列表
    CGFloat userX = CGRectGetMaxX(self.connectView.frame) + 10;
    CGFloat userW = SCREEN_WIDTH - userX - 60;
    _userListView = [[LKUserListView alloc] initWithFrame:CGRectMake(userX, 30, userW, 40)];
    [self.view addSubview:_userListView];
    
    self.keyBoardBar = [[InputBoxBar alloc] init];
    self.keyBoardBar.delegate = self;
    [self.view addSubview:self.keyBoardBar];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    _keyboardIsVisible = YES;
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    _originDuration = duration.doubleValue;
    _animationCurve = [curve integerValue];
    
    [UIView animateWithDuration:_originDuration animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve]; //设置动画曲线，控制动画速度
        _sessionView.center = CGPointMake(_sessionView.center.x, keyBoardEndY-_keyBoardBar.frame.size.height- _sessionView.bounds.size.height/2.0);
        [UIView commitAnimations];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    _keyboardIsVisible = NO;
    NSDictionary *userInfo = [noti userInfo];
    NSNumber *duration = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    _originDuration = duration.doubleValue;
    _animationCurve = [curve integerValue];
    
    [UIView animateWithDuration:_originDuration animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve];
        _sessionView.center = CGPointMake(_sessionView.center.x, _sessionOriginY);
        [UIView commitAnimations];
    }];
}

#pragma mark - <InputBoxBarDelegate>
- (void)inputBoxBar:(InputBoxBar *)boxBar DidKeyBoardStatus:(kInputBarDidStatus)status {
    
    self.status = status;
    if (self.status == kInputBarDidStatus_Emoji) {
        if (!_keyboardIsVisible) { //系统键盘已经回收
            CGFloat layoutY = CGRectGetMidY(boxBar.frame) - (boxBar.height + 70);
            [UIView animateWithDuration:_originDuration+0.35 animations:^{
                [UIView setAnimationsEnabled:YES];
                [UIView setAnimationCurve:_animationCurve];
                _sessionView.center = CGPointMake(_sessionView.center.x, layoutY);
                [UIView commitAnimations];
            }];
        }
    }
}

- (void)inputBoxBar:(InputBoxBar *)boxBar DidEditingAtText:(NSString *)text {
    
    CGFloat layoutY = CGRectGetMidY(boxBar.frame) - (_sessionView.bounds.size.height - 40);
    self.sessionView.center = CGPointMake(_sessionView.center.x, layoutY);
}

- (void)inputBoxBar:(InputBoxBar *)boxBar DidEndEditingAtText:(NSString *)text {
    
    LKBarrageModel *dmModel = [LKBarrageModel new];
    dmModel.beginTime = 2;
    dmModel.liveTime = 5;
    dmModel.content = text;
    [self.danmuView.models addObject:dmModel];
    
    LKSessionModel *session = [LKSessionModel new];
    session.level = 9;
    session.name = @"王思聪";
    session.talk = text;
    self.sessionView.session = session;
}

#pragma mark - <LKDanmuViewProtocol>
- (UIView *)danmuViewWithModel:(LKBarrageModel *)model {
    
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
    
    [self.headerImgView downloadImage:model.creator.portrait placeholder:@"default_room"];
    self.onUsersLabel.text = [NSString stringWithFormat:@"%ld人", (long)model.onlineUsers];
}

#pragma mark - Room Actions
- (IBAction)roomEvents:(UIButton *)btn {
    LKPlayerEventStatus status = btn.tag;
    
    switch (status) {
        case LKPlayerEventStatus_Session:
            [self.keyBoardBar become]; //弹出会话输入框
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
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [XDProgressHUD showHUDWithText:@"已关注主播" hideDelay:1.0];
    }else {
        self.model.follow = NO;
        [[LKCacheHelper shared] unFollowAnchor:self.model];
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        [XDProgressHUD showHUDWithText:@"取消关注" hideDelay:1.0];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFollowKey object:nil];
}

#pragma mark - <LKGiftListViewDelegate>
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self recoveryKeyBoard];
}

- (void)recoveryKeyBoard {
    [self.view endEditing:YES]; //系统键盘退出
    
    [UIView animateWithDuration:_originDuration+0.35 animations:^{
        [UIView setAnimationsEnabled:YES];
        [UIView setAnimationCurve:_animationCurve];
        [self.keyBoardBar recovery];
        _sessionView.center = CGPointMake(_sessionView.center.x, _sessionOriginY);
        [UIView commitAnimations];
    }];
}

#pragma mark - remove
- (void)dealloc {
    
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//移除timer
- (void)removeTimer {
    [self.keyBoardBar recovery];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
