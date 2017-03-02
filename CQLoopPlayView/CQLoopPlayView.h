//
//  CQLoopPlayView.h
//  LoopPlaybackDemo
//
//  Created by 韦存情 on 16/6/13.
//  Copyright © 2016年 韦存情. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger,CQLoopPlayViewPageControlAlignment){
    CQLoopPlayViewPageControlAlignmentCenter,
    CQLoopPlayViewPageControlAlignmentRight
};

@class CQLoopPlayView;
@protocol CQLoopPlayViewDelegate <NSObject>

@optional

- (void)loopPlayView:(CQLoopPlayView *)loopPlayView didSelectImageAtIndex:(NSInteger)index;
- (void)loopPlayView:(CQLoopPlayView *)loopPlayView didScrollToIndex:(NSInteger)index;

@end

@interface CQLoopPlayView : UIView

/**
 *  封装collectionView实现轮播图
 *
 *   frame              轮播图的frame
 *   placeholderImage   占位图
 */
- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage;

/**
 *  封装collectionView实现轮播图
 *
 *   frame              轮播图的frame
 *   placeholderImage   占位图
 */
+ (instancetype)loopPlayViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage;

/*************  数据源  ****************/

/** URL字符串数组 */
@property (nonatomic, copy) NSArray<NSString *> *URLStringArray;

/** 本地图片名数组 */
@property (nonatomic, copy) NSArray<NSString *> *localImageNameArray;

/** 图片左下方说明文字数组 */
@property (nonatomic, copy) NSArray<NSString *> *textArray;

/** 图片右下方说明文字数组(右下方文字label宽度比左下方label短) */
@property (nonatomic, copy) NSArray<NSString *> *detailTextArray;

/*************   图片轮播   ****************/

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** 是否自动轮播,默认YES */
@property (nonatomic, assign) BOOL autoPlay;

/** 计时器时间间隔,默认5.0 */
@property (nonatomic, assign) CGFloat timeInterval;

/*************  回调  ****************/

@property (nonatomic, weak) id<CQLoopPlayViewDelegate> delegate;

@property (nonatomic, copy) void(^selectImageBlock)(NSInteger index);
@property (nonatomic, copy) void(^scrollEndBlock)(NSInteger index);

/*************   PageControl  ****************/

/** pageControl位置,默认CQLoopPlayViewPageControlAlignmentCenter */
@property (nonatomic, assign) CQLoopPlayViewPageControlAlignment pageControlAlignment;

/** 是否显示pageControl,默认YES */
@property (nonatomic, assign) BOOL showPageControl;

/** 只有一张图时是否隐藏pagecontrol,默认YES */
@property (nonatomic, assign) BOOL hidePageControlForSinglePage;

/** pageControl的size,默认{80,15} */
@property (nonatomic, assign) CGSize pageControlSize;

/** pageControl分页指示器的size,默认{7,7} */
@property (nonatomic, assign) CGSize pageIndicatorSize;

/** pageControl背景颜色 */
@property (nonatomic, strong) UIColor *pageControlBackgroundColor;

/** pageControl当前分页指示器颜色 */
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;

/** pageControl分页指示器颜色 */
@property (nonatomic, strong) UIColor *pageIndicatorColor;

/** pageControl当前分页指示器图片,设置后currentPageIndicatorColor失效 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/** pageControl分页指示器图片,设置后pageIndicatorColor失效 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;

/** 当显示文字或详细文字时pagecontrol是否自动向上偏移,默认YES */
@property (nonatomic, assign) BOOL automaticallyAdjustsTextInsets;

/** pagecontrol距离轮播图底部的偏移量,默认2.0 
 *  当automaticallyAdjustsTextInsets属性为YES时,pageControlBottomInset默认为距离底部文字的偏移量
 */
@property (nonatomic, assign) CGFloat pageControlBottomInset;

/** pagecontrol距离轮播图右侧的偏移量,默认0.0 */
@property (nonatomic, assign) CGFloat pageControlRightInset;




@end

