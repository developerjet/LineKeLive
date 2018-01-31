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
#import "LKMainSegmentView.h"


@interface LKMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) LKMainSegmentView *topView;
@property (nonatomic, strong) NSArray *titleNames;

@end

@implementation LKMainViewController

#pragma mark - LazyLoad

- (UIScrollView *)contentScrollView {
    
    if (!_contentScrollView) {
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _contentScrollView = [[UIScrollView alloc] initWithFrame:frame];
        //设置ScrollView的contentSize
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES; //设置分页
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.titleNames.count, 0);
        //_contentScrollView.contentOffset = CGPointMake(self.contentScrollView.frame.size.width, 0);
    }
    return _contentScrollView;
}

- (NSArray *)titleNames {
    
    if (!_titleNames) {
        
        _titleNames = @[@"关注", @"热门", @"附近"];
    }
    return _titleNames;
}

- (LKMainSegmentView *)topView {
    
    if (!_topView) {
        
        _topView = [[LKMainSegmentView alloc] initWithFrame:CGRectMake(0, 0, 200, 50) titleNames:self.titleNames];
        WeakSelf;
        _topView.topBlock = ^(NSInteger index) {
            CGPoint point = CGPointMake(index*self.contentScrollView.width, weakSelf.contentScrollView.contentOffset.y);
            [weakSelf.contentScrollView setContentOffset:point animated:YES];
        };
    }
    return _topView;
}

#pragma mark - EventMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    
    self.view.backgroundColor = [UIColor colorBackGroundWhiteColor];
    
    [self setupNav];
    
    //视图容器
    [self.view addSubview:self.contentScrollView];
    [self setupChildControllers];
}


- (void)setupNav {
    
    self.navigationItem.titleView  = self.topView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"global_search"]
                                             style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"title_button_more"]
                                            style:UIBarButtonItemStyleDone target:nil action:nil];
}

//添加子控制器
- (void)setupChildControllers {
    
    NSArray *vcNames = @[@"LKFocuseViewController",
                         @"LKHotViewController",
                         @"LKNearViewController"];
    
    for (NSInteger idx = 0; idx < vcNames.count; idx++) {
        UIViewController *vc = [[NSClassFromString(vcNames[idx]) alloc] init];
        vc.title = self.titleNames[idx];
        //当执行这段代码addChildViewController，不会执行该vc的viewDidLoad
        [self addChildViewController:vc];
    }
    
    //设置ScrollView的contentSize
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES; //设置分页
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * vcNames.count, 0);
    self.contentScrollView.contentOffset = CGPointMake(self.contentScrollView.frame.size.width, 0);
    
    //进入主控制器加载第第二个页面
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}


#pragma mark - UIScrollViewDelegate

//动画结束调用代理
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = SCREEN_WIDTH; //scrollView.frame.size.width;
    CGFloat height = SCREEN_HEIGHT;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //获取索引值
    NSInteger index = offsetX / width;
    
    //索引值联动TopView
    [self.topView scrolling:index];
    
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
