//
//  CUAdvertisingView.h
//  DigitalPrint
//
//  Created by Apple on 2016/11/17.
//  Copyright © 2016年 cucsi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 轮播图片的数据模型
 */
@interface CUImageBean : NSObject

/**
 图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 图片名称
 */
@property (nonatomic, copy) NSString *name;

/**
 图片路径（当image有值时无效）
 */
@property (nonatomic, strong) NSURL *url;

@end

/**
 轮播控件的代理方法
 */
@protocol CUAdvertisingViewDelegate <NSObject>

@optional

/**
 点击图片的页码

 @param showPage 页码
 */
- (void)cu_advertisingViewClickForPage:(NSInteger)showPage;

/**
 页码变更回调

 @param showPage 页码
 */
- (void)cu_changeShowPage:(NSUInteger)showPage;

@end


/**
 轮播图控件视图
 */
@interface CUAdvertisingView : UIView


/**
 轮播图片的数据
 */
@property (nonatomic, copy) NSArray<CUImageBean *> *imageURLArray;

/**
 占位图
 */
@property (nonatomic, strong) UIImage *placeholderImage;

/**
 设置轮播间隔时间（=0: 不轮播; >0: 正向轮播; <0: 反向轮播）
 */
@property (nonatomic, assign) NSInteger time;

/**
 设置是否隐藏页面指示器
 */
@property (nonatomic, assign) BOOL hidePageControl;

/**
 设置图片视图的显示方式
 */
@property (nonatomic) UIViewContentMode imageViewContentMode;

/**
 显示页数
 */
@property (nonatomic, assign) NSUInteger showPage;

/**
 代理对象
 */
@property (nonatomic, weak) id<CUAdvertisingViewDelegate> delegate;


// 构造方法
+ (id)adsViewWithFrame:(CGRect)frame;
+ (id)adsViewWithFrame:(CGRect)frame delegate:(id<CUAdvertisingViewDelegate>)delegate;


/**
 设置轮播图片数据数据

 @param imageURLArray 轮播图片数据
 @param showPage 第一个显示的页码
 */
- (void)setImageURLArray:(NSArray<CUImageBean *> *)imageURLArray withFirstShow:(NSUInteger)showPage;

// 手动调用滑动
- (void)jumpToBeforePage;
- (void)jumpToNextPage;

// 自动轮播控制
- (void)startTimer;
- (void)stopTimer;

@end
