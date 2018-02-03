//
//  LKMainViewController.m
//  LinekeLive
//
//  Created by CoderTan on 2017/6/23.
//  Copyright © 2017年 CoderTan. All rights reserved.
//

#import "LKMainViewController.h"
#import "LKFocuseViewController.h"
#import "LKHotViewController.h"
#import "LKNearViewController.h"
#import "LKItemSegmentView.h"

@interface LKMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray           *itemTitles;
@property (nonatomic, strong) LKItemSegmentView *itemSegment;
@property (nonatomic, strong) UIScrollView      *conentScrollView;

@end

@implementation LKMainViewController

#pragma mark - LazyLoad
- (UIScrollView *)conentScrollView {
    
    if (!_conentScrollView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _conentScrollView = [[UIScrollView alloc] initWithFrame:frame];
        //设置ScrollView的contentSize
        _conentScrollView.delegate = self;
        _conentScrollView.pagingEnabled = YES; //设置分页
        _conentScrollView.showsVerticalScrollIndicator = NO;
        _conentScrollView.showsHorizontalScrollIndicator = NO;
        _conentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.itemTitles.count, 0);
    }
    return _conentScrollView;
}

- (NSArray *)itemTitles {
    
    if (!_itemTitles) {
        _itemTitles = @[@"关注", @"热门", @"附近"];
    }
    return _itemTitles;
}

- (LKItemSegmentView *)itemSegment {
    
    if (!_itemSegment) {
        _itemSegment = [[LKItemSegmentView alloc] initWithFrame:CGRectMake(0, 0, 200, 50) segmentItems:self.itemTitles];
        WeakSelf;
        _itemSegment.didFinishedBlock = ^(NSInteger index) {
            CGPoint point = CGPointMake(index * self.conentScrollView.width, weakSelf.conentScrollView.contentOffset.y);
            [weakSelf.conentScrollView setContentOffset:point animated:YES];
        };
    }
    return _itemSegment;
}

#pragma mark - DidLoads
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}

- (void)initSubviews {
    
    self.view.backgroundColor = [UIColor colorBackGroundWhiteColor];
    [self initNavigation];
    
    [self.view addSubview:self.conentScrollView];
    [self initChildCtrl];
}

- (void)initNavigation {
    
    self.navigationItem.titleView  = self.itemSegment;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"global_search"]
                                             style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"title_button_more"]
                                            style:UIBarButtonItemStyleDone target:nil action:nil];
}

//添加子控制器
- (void)initChildCtrl {
    
    NSArray *vcNames = @[@"LKFocuseViewController",
                         @"LKHotViewController",
                         @"LKNearViewController"];
    
    for (NSInteger idx = 0; idx < vcNames.count; idx++) {
        UIViewController *vc = [[NSClassFromString(vcNames[idx]) alloc] init];
        vc.title = self.itemTitles[idx];
        //当执行这段代码addChildViewController，不会执行该vc的viewDidLoad
        [self addChildViewController:vc];
    }
    
    //设置ScrollView的contentSize
    self.conentScrollView.delegate = self;
    self.conentScrollView.pagingEnabled = YES; //设置分页
    self.conentScrollView.showsVerticalScrollIndicator = NO;
    self.conentScrollView.showsHorizontalScrollIndicator = NO;
    self.conentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * vcNames.count, 0);
    self.conentScrollView.contentOffset = CGPointMake(self.conentScrollView.frame.size.width, 0);
    
    //进入主控制器加载第第二个页面
    [self scrollViewDidEndScrollingAnimation:self.conentScrollView];
}


#pragma mark - UIScrollViewDelegate
//动画结束调用代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width  = SCREEN_WIDTH; //scrollView.frame.size.width;
    CGFloat height = SCREEN_HEIGHT;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //获取索引值
    NSInteger index = offsetX / width;
    
    //索引值联动SegmentView
    [self.itemSegment scrolling:index];
    
    //根据索引值返回vc的引用
    UIViewController *childVC = self.childViewControllers[index];
    
    //判断当前vc是否执行过viewDidLoad
    if ([childVC isViewLoaded]) return;
    
    //设置子控制器view大小
    childVC.view.frame = CGRectMake(offsetX, 0, scrollView.frame.size.width, height);
    
    //将子控制器的view加到ScrollView
    [scrollView addSubview:childVC.view];
}

//减速结束时调用加载子控制器view的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


@end
