//
//  CUAdvertisingView.m
//  DigitalPrint
//
//  Created by Apple on 2016/11/17.
//  Copyright © 2016年 cucsi. All rights reserved.
//

#import "CUAdvertisingView.h"

@implementation CUImageBean

@end



@interface CUAdvertisingView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *centerImageView;
@property (nonatomic, weak) UIImageView *rightImageView;

@property (nonatomic, weak) UIButton *centerButton;
@property (nonatomic, weak) UIPageControl *advertisingPage;

//@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) BOOL isJump;

@end

@implementation CUAdvertisingView

+ (id)adsViewWithFrame:(CGRect)frame
{
    return [self adsViewWithFrame:frame delegate:nil];
}

+ (id)adsViewWithFrame:(CGRect)frame delegate:(id<CUAdvertisingViewDelegate>)delegate
{
    return [[self alloc] initWithFrame:frame delegate:delegate];
}

- (void)jumpToBeforePage
{
    if (self.imageURLArray.count <= 1)
    {
        return;
    }
    if (!_isJump)
    {
        _isJump = YES;
        [self stopTimer];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)jumpToNextPage
{
    if (self.imageURLArray.count <= 1)
    {
        return;
    }
    if (!_isJump)
    {
        _isJump = YES;
        [self stopTimer];
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    }
    
}

- (id)initWithFrame:(CGRect)frame delegate:(id<CUAdvertisingViewDelegate>)delegate
{
    self.delegate = delegate;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.placeholderImage = DEF_BANNER_IMAGE;
        [self freshScrollView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self freshScrollView];
}

- (void)freshScrollView
{
    // 创建 scrollview
    if (!_scrollView)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        // 设置 scrollview 属性
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        
        _scrollView = scrollView;
    }
    
//    self.showPage = 0;
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, 0);
    _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
    if (self.imageURLArray.count <= 1)
    {
        _scrollView.scrollEnabled = NO;
    }
    
    // 创建左中右视图
    if (!_leftImageView)
    {
        UIImageView *leftImageView = [[UIImageView alloc] init];
        [_scrollView addSubview:leftImageView];
        leftImageView.clipsToBounds = YES;
        if (_imageViewContentMode)
        {
            leftImageView.contentMode = _imageViewContentMode;
        }
        
        _leftImageView = leftImageView;
        
    }
    _leftImageView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    if (!_centerImageView)
    {
        UIImageView *centerImageView = [[UIImageView alloc] init];
        [_scrollView addSubview:centerImageView];
        centerImageView.clipsToBounds = YES;
        if (_imageViewContentMode)
        {
            centerImageView.contentMode = _imageViewContentMode;
        }
        
        _centerImageView = centerImageView;
        
    }
    _centerImageView.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    if (!_rightImageView)
    {
        UIImageView *rightImageView = [[UIImageView alloc] init];
        [_scrollView addSubview:rightImageView];
        rightImageView.clipsToBounds = YES;
        if (_imageViewContentMode)
        {
            rightImageView.contentMode = _imageViewContentMode;
        }
        
        _rightImageView = rightImageView;
        
    }
    _rightImageView.frame = CGRectMake(_scrollView.frame.size.width * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    // 创建中间点击按钮
    if (!_centerButton)
    {
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        centerButton.backgroundColor = [UIColor clearColor];
        [centerButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:centerButton];
        
        _centerButton = centerButton;
    }
    _centerButton.frame = CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    // 创建页面指示器
    if (!_advertisingPage)
    {
        UIPageControl *advertisingPage = [[UIPageControl alloc] init];
        advertisingPage.hidden = _hidePageControl;
        advertisingPage.userInteractionEnabled = NO;
        [self addSubview:advertisingPage];
        
        _advertisingPage = advertisingPage;
    }
    _advertisingPage.frame = CGRectMake(0, _scrollView.frame.size.height - 20 , _scrollView.frame.size.width, 20);
    
}

/**
 按钮点击事件

 @param sender 点击按钮
 */
- (void)click:(id)sender
{
    if (self.imageURLArray.count <= 0)
    {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(cu_advertisingViewClickForPage:)])
    {
        [_delegate cu_advertisingViewClickForPage:self.showPage];
    }
}

/**
 设置轮播图片

 @param imageURLArray 轮播图片数组
 */
- (void)setImageURLArray:(NSArray<CUImageBean *> *)imageURLArray
{
    [self setImageURLArray:imageURLArray withFirstShow:0];
}

- (void)setImageURLArray:(NSArray<CUImageBean *> *)imageURLArray withFirstShow:(NSUInteger)showPage
{
    _imageURLArray = imageURLArray;
    _scrollView.scrollEnabled = (imageURLArray.count > 1);
    self.hidePageControl = (imageURLArray.count < 2);
    _advertisingPage.numberOfPages = imageURLArray.count;
    
    if (!imageURLArray || imageURLArray.count == 0)
    {
        self.showPage = 0;
    }
    else if (imageURLArray.count <= showPage)
    {
        self.showPage = imageURLArray.count - 1;
    }
    else
    {
        self.showPage = showPage;
    }
    
    [self loadImage];
    [self startTimer];
}


/**
 设置轮播间隔时间,正数正向播放,负数反向播放,0停止播放

 @param time 间隔时间
 */
- (void)setTime:(NSInteger)time
{
    _time = time;
    
    [self startTimer];
}

/**
 设置显示页码，与页面控制器同步

 @param showPage 显示页码
 */
- (void)setShowPage:(NSUInteger)showPage
{
    if (showPage != _showPage)
    {
        _showPage = showPage;
        _advertisingPage.currentPage = showPage;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(cu_changeShowPage:)])
    {
        [_delegate cu_changeShowPage:showPage];
    }
}

/**
 设置页面指示器是否隐藏

 @param hidePageControl 是否隐藏
 */
- (void)setHidePageControl:(BOOL)hidePageControl
{
    _hidePageControl = hidePageControl;
    if (_advertisingPage)
    {
        _advertisingPage.hidden = _hidePageControl;
    }
}

/**
 设置图片显示方式

 @param imageViewContentMode 显示方式
 */
- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode
{
    _imageViewContentMode = imageViewContentMode;
    if (_centerImageView)
    {
        _centerImageView.contentMode = _imageViewContentMode;
    }
    if (_leftImageView)
    {
        _leftImageView.contentMode = _imageViewContentMode;
    }
    if (_rightImageView)
    {
        _rightImageView.contentMode = _imageViewContentMode;
    }
}

/**
 创建 Timer
 */
- (void)startTimer
{
    if (_imageURLArray.count <= 1)
    {
        return;
    }
    [self stopTimer];
    if (_time != 0)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(_time > 0 ? _time:-_time) target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        _timer = timer;
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

/**
 自动轮播
 */
- (void)autoScroll
{
    __weak typeof(self) weakSelf = self;
    if (_time > 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(weakSelf.frame.size.width * 2, 0);
        } completion:^(BOOL finished) {
            [weakSelf loadImage];
            weakSelf.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }];
//        [_scrollView setContentOffset:CGPointMake(_weakSelf.frame.size.width * 2, 0) animated:YES];
    }
    else if (_time < 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf loadImage];
            weakSelf.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        }];
//        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

/**
 停止计时器
 */
- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
}

/**
 触发页面时,停止自动轮播
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

/**
 停止触发页面,自动轮播开始
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

/**
 滑动切换视图
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImage];
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

/**
 滚动动画结束
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_isJump)
    {
        _isJump = NO;
        [self startTimer];
    }
    [self loadImage];
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

/**
 加载图片
 */
- (void)loadImage
{
    [self changeShowPage];
    
    if (_imageURLArray.count > 0)
    {
        CUImageBean *centerImage = _imageURLArray[_showPage];
        CUImageBean *leftImage = _imageURLArray[[self leftShowPage]];
        CUImageBean *rightImage = _imageURLArray[[self rightShowPage]];
        
        if (centerImage.image)
        {
            _centerImageView.image = centerImage.image;
        }
        else
        {
            [_centerImageView sd_setImageWithURL:centerImage.url placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image)
                {
                    centerImage.image = image;
                }
            }];
        }
        
        if (leftImage.image)
        {
            _leftImageView.image = leftImage.image;
        }
        else
        {
            [_leftImageView sd_setImageWithURL:leftImage.url placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image)
                {
                    leftImage.image = image;
                }
            }];
        }
        
        if (rightImage.image)
        {
            _rightImageView.image = rightImage.image;
        }
        else
        {
            [_rightImageView sd_setImageWithURL:rightImage.url placeholderImage:self.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image)
                {
                    rightImage.image = image;
                }
            }];
        }
        
    }
    else
    {
        _centerImageView.image = self.placeholderImage;
        _leftImageView.image = self.placeholderImage;
        _rightImageView.image = self.placeholderImage;
    }
}

/**
 计算当前显示页数
 */
- (void)changeShowPage
{
    if (_imageURLArray.count > 1)
    {
        if (_showPage >= _imageURLArray.count)
        {
            self.showPage = _imageURLArray.count - 1;
        }
        
        CGPoint offset = _scrollView.contentOffset;
        if (offset.x > self.frame.size.width * 1.5)
        {
            self.showPage = [self rightShowPage];
        }
        else if (offset.x == 0)
        {
            self.showPage = [self leftShowPage];
        }
    }
    else
    {
        self.showPage = 0;
    }
}

/**
 获取当前显示页左边的页码
 @returns 显示页左边的页码
 */
- (NSInteger)leftShowPage
{
    if (self.imageURLArray.count > 0)
    {
        return (_showPage + _imageURLArray.count - 1) % _imageURLArray.count;
    }
    else
    {
        return 0;
    }
}

/**
 获取当前显示页右边的页码
 @returns 显示页右边的页码
 */
- (NSInteger)rightShowPage
{
    if (self.imageURLArray.count > 0)
    {
        return (_showPage + 1) % _imageURLArray.count;
    }
    else
    {
        return 0;
    }
}

@end
