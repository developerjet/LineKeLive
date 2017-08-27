//
//  LKLiveChatViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKLiveRoomViewController.h"
#import "LKAnimationManager.h"
#import "LKGiftListView.h"
#import "LKSendTalkView.h"
#import "LKDanmuView.h"
#import "LKDanmuModel.h"
#import "LKGiftModel.h"
#import "LKShareView.h"
#import "LKGiftData.h"

@interface LKLiveRoomViewController ()<UITextViewDelegate, LKGiftListViewDelegate, LKDanmuViewProtocol>
@property (weak, nonatomic) IBOutlet UILabel     *countLable;
@property (weak, nonatomic) IBOutlet UIButton    *ticketView;
@property (weak, nonatomic) IBOutlet UIButton    *followView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView      *menuView;

@property (nonatomic, weak) LKDanmuView *danmuView;
@property (nonatomic, strong) LKGiftListView *giftListView;
@property (nonatomic, strong) UIView *animView; //礼物展示区域
@property (nonatomic, strong) LKGiftData *data;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *keyBoardView;
@property (nonatomic, strong) UITextView *taskTextView; //聊天输入框
@property (nonatomic, strong) LKSendTalkView *talkView;

@property (nonatomic, assign) CGFloat centerOriginY;

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
    
    [self configureUI];
    [self initNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configBringUI];
}

- (void)initNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)isAnchorFollow {
    
    return [[LKCacheHelper shared] getAncherIsFollow:self.model];
}

- (void)configBringUI {
    
    LKSendTalkView *talkView = [[LKSendTalkView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-210, SCREEN_WIDTH, 160)];
    [self.view addSubview:talkView];
    [self.view bringSubviewToFront:talkView];
    _centerOriginY = talkView.center.y;
    _talkView = talkView;
}

- (void)configureUI {
    
    self.view.backgroundColor = [UIColor clearColor];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.menuView.layer.cornerRadius = self.menuView.layer.frame.size.height * 0.5;
    self.menuView.layer.masksToBounds = YES;
    
    self.iconView.layer.cornerRadius = self.iconView.layer.height * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.ticketView.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.followView.layer.cornerRadius = self.followView.layer.height * 0.5;
    self.followView.layer.masksToBounds = YES;
    
    if ([self isAnchorFollow]) {
        [self.followView setTitle:@"已关注" forState:UIControlStateNormal];
    }else {
        [self.followView setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
        _timer = timer;
        [self.ticketView setTitle:[NSString stringWithFormat:@"映票 %d", arc4random_uniform(10000)] forState:UIControlStateNormal]; //随机显示映票数
        
    } repeats:YES];
    
    self.animView = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT-140)/2, SCREEN_WIDTH, 140)];
    self.animView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.animView];
    
    /// 弹幕
    LKDanmuView *danmuView = [[LKDanmuView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 150)];
    danmuView.delegate = self;
    self.danmuView = danmuView;
    [self.view addSubview:danmuView];
    
    /// 会话输入
    [self createKeyBoard];
}

- (void)createKeyBoard {
    
    //自定义聊天输入框
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    _keyBoardView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    [self.view addSubview:_keyBoardView];
    [self.view bringSubviewToFront:_keyBoardView];
    
    CGFloat padding = 15, margin = 10;
    UITextView *taskTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, margin, (SCREEN_WIDTH-30)-70, 30)];
    taskTextView.delegate = self;
    taskTextView.layer.borderWidth = 1.0;
    taskTextView.layer.borderColor = [UIColor colorWithHexString:@"989898"].CGColor;
    taskTextView.text = @"请输入你的想法...";
    [_keyBoardView addSubview:taskTextView];
    _taskTextView = taskTextView;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = [UIColor orangeColor];
    CGFloat btnX = CGRectGetMaxX(taskTextView.frame)+margin;
    CGFloat btnW = SCREEN_WIDTH - btnX - padding;
    sendButton.frame = CGRectMake(btnX, margin, btnW, 30);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    sendButton.userInteractionEnabled = YES;
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    [sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [_keyBoardView addSubview:sendButton];
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
        _talkView.center = CGPointMake(_talkView.center.x, keyBoardEndY-_keyBoardView.frame.size.height- _talkView.bounds.size.height/2.0);
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
        _talkView.center = CGPointMake(_talkView.center.x, _centerOriginY);
        [UIView commitAnimations];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    self.taskTextView.text = @"";
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

#pragma mark - setter

- (void)setModel:(LKLiveModel *)model {
    
    _model = model;
    
    [self.iconView downloadImage:model.creator.portrait placeholder:@"default_room"];
    self.countLable.text = [NSString stringWithFormat:@"%ld人", (long)model.onlineUsers];
}

#pragma mark - click

- (IBAction)openTools:(UIButton *)btn {
    LKPlayRoomTaskType taskType = btn.tag;
    
    switch (taskType) {
        case LKPlayRoomTaskSendChat:
            [_taskTextView becomeFirstResponder];
            break;
        case LKPlayRoomTaskSendGift:
            self.giftListView = [[LKGiftListView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.giftListView.delegate = self;
            [self.giftListView show];
            break;
         case LKPlayRoomTaskOpenShare:
            [self openShare];
            break;
        default:
            break;
    }
}

- (void)openShare {
    
    LKShareView *view = [LKShareView loadShareCore];
    [view show];
}

- (IBAction)followClick:(UIButton *)button {
    button.selected = !button.selected;
    
    if (button.selected) {
        self.model.follow = YES;
        [[LKCacheHelper shared] followAnchor:self.model];
        [XDProgressHUD showHUDWithText:@"已关注主播" hideDelay:1.0];
        [_followView setTitle:@"已关注" forState:UIControlStateNormal];
    }else {
        self.model.follow = NO;
        [[LKCacheHelper shared] unFollowAnchor:self.model];
        [XDProgressHUD showHUDWithText:@"取消主播" hideDelay:1.0];
        [_followView setTitle:@"关注" forState:UIControlStateNormal];
    }
}


- (void)sendClick:(UIButton *)btn {
    [self.view endEditing:YES];
    
    LKDanmuModel *dmModel = [LKDanmuModel new];
    dmModel.beginTime = 2;
    dmModel.liveTime = 5;
    dmModel.content = self.taskTextView.text;
    [self.danmuView.models addObject:dmModel];
    
    LKTalkModel *talkModel = [LKTalkModel new];
    talkModel.name = @"王思聪";
    talkModel.talk = self.taskTextView.text;
    talkModel.level = 9;
    self.talkView.talkModel = talkModel;

    //清除之前的会话
    self.taskTextView.text = @"";
}

#pragma mark - LKGiftListViewDelegate

- (void)sendGiftListViewDelegate:(LKGiftListView *)giftView DidSelectItem:(LKGiftModel *)model {
    
    self.data.senderName = [NSString stringWithFormat:@"用户%d", arc4random()%2]; //模拟两个用户在送礼物
    self.data.deveiceType = [NSString stringWithFormat:@"%d", arc4random()%2+1]; //模拟用户设备
    
    self.data.giftName = model.subject; //礼物名称
    self.data.giftIcon = model.img2;
    
    LKAnimationManager *manager = [LKAnimationManager manager];
    manager.parentView = self.animView;
    [manager animWithData:self.data finishedBlock:^(BOOL result) {
        LKLog(@"complete...");
    }];
}

#pragma mark - remove

- (void)dealloc {
    
    [self removeTimer];
}

//移除timer
- (void)removeTimer {
    
    [_timer invalidate];
    _timer = nil;
}

@end
