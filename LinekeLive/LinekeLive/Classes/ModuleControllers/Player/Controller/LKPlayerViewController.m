//
//  LKPlayerViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/26.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKPlayerViewController.h"
#import "LKLiveRoomViewController.h"
#import <UIView+MJExtension.h>

@interface LKPlayerViewController ()<IJKMediaPlayback, LKLiveRoomViewControllerDelegate>
@property (nonatomic, strong) LKLiveRoomViewController *roomVC;
///毛玻璃效果
@property (nonatomic, strong) UIVisualEffectView *effectView;
///粒子动画
@property (nonatomic, weak) CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) CGPoint starPoint;
@property (nonatomic, assign) CGPoint prePoint;

@end

@implementation LKPlayerViewController

#pragma mark - LazyLoad

- (CAEmitterLayer *)emitterLayer {
    
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.player.view.frame.size.width-30,self.player.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //[stepCell setName:[NSString stringWithFormat:@"step%d", i]];
            
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        [self.player.view.layer insertSublayer:emitterLayer below:nil];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

- (LKLiveRoomViewController *)roomVC {
    
    if (!_roomVC) {
        _roomVC = [[LKLiveRoomViewController alloc] init];
    }
    return _roomVC;
}

- (UIButton *)closeBtn {
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"mg_room_btn_guan_h"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closePlayer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIImageView *)blurImageView {
    
    if (!_blurImageView) {
        CGRect frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _blurImageView = [[UIImageView alloc] initWithFrame:frame];
        [_blurImageView downloadImage:self.model.creator.portrait placeholder:@"default_room"];
    }
    return _blurImageView;
}

#pragma mark - view Loads

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO]; //隐藏导航栏
    
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}


- (void)initSubviews {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initPlayView];
    [self initRoomView];
    [self beginEmitter];
}

- (void)beginEmitter {
    
    [self emitterLayer];
    
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}

- (void)endEmitter {
    
    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
}

//创建主播放控制器视图
- (void)initPlayView {
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.streamAddr withOptions:options];
    self.player = player;
    self.player.view.frame = self.view.bounds;
    self.player.shouldAutoplay = YES; //设置自动播放
    [self.view addSubview:self.player.view];
    
    // 创建毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 创建毛玻璃视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.blurImageView.bounds;
    [self.blurImageView addSubview:effectView];
    [self.view addSubview:self.blurImageView];
    self.effectView = effectView;
}

- (void)initRoomView {
    
    self.roomVC.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:self.roomVC];
    [self.view addSubview:self.roomVC.view];
    self.roomVC.model = self.model;
    
    self.closeBtn.frame = CGRectMake(SCREEN_WIDTH-50, 30, 40, 40);
    [self.view addSubview:self.closeBtn];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - Handle player action
- (void)panEvent:(UIPanGestureRecognizer *)pan {
    
    if (_panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _prePoint  = [pan locationInView:self.view];
        _starPoint = _roomVC.view.frame.origin;
    }
    if (_panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point =  [pan locationInView:self.view];
        CGFloat x = _roomVC.view.frame.origin.x;
        x += point.x - _prePoint.x;
        x = x > 0 ? 0 : x;
        x = x < -_roomVC.view.frame.size.width ? -_roomVC.view.frame.size.width:x;
        _roomVC.view.mj_x = x;
        _prePoint = point;
    }
    if (_panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        CGFloat x = _starPoint.x - _roomVC.view.frame.origin.x;
        if (x < - _roomVC.view.frame.size.width/3) {
            x = 0;
        }else if(x > _roomVC.view.frame.size.width/3){
            x = - _roomVC.view.frame.size.width;
        }else{
            x = _starPoint.x;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            
            _roomVC.view.mj_x = x;
        }];
    }
}

- (void)closePlayer {
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
    self.player = nil;
    [self endEmitter];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 隐藏毛玻璃
 */
- (void)dismiss {
    
    // UIViewAnimationOptionCurveLinear:时间曲线函数(匀速)
    WeakSelf;
    [UIView animateWithDuration:0.35 delay:0.35 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.effectView.alpha = 0;
        weakSelf.blurImageView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        weakSelf.effectView.hidden = YES;
        weakSelf.blurImageView.hidden = YES;
        [weakSelf.effectView removeFromSuperview];
        [weakSelf.blurImageView removeFromSuperview];
    }];
}
#pragma mark - notificationBack

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0, 未知
    //    MPMovieLoadStatePlayable       = 1 << 0, 缓冲结束可以播放
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES 缓冲结束自动播放
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started 暂停播放
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        //缓冲完成开始播放(隐藏毛玻璃)
        [self dismiss];
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded, 直播结束
    //    MPMovieFinishReasonPlaybackError, 直播错误
    //    MPMovieFinishReasonUserExited 用户退出
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped, //暂停
    //    MPMoviePlaybackStatePlaying, //播放
    //    MPMoviePlaybackStatePaused, //重置
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    //监听网络环境，监听缓冲
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    //监听直播完成回调
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    //监听直播是否准备好
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    //监听用户的主动操作
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}


@end
