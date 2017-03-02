//
//  CQPageControl.h
//  TestNavi
//
//  Created by 韦存情 on 2017/3/1.
//  Copyright © 2017年 aideer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQPageControlDelegate;
@interface CQPageControl : UIControl

/** CQPageControlDelegate */
@property (nonatomic, weak) id<CQPageControlDelegate> delegate;

/** page指示器的个数,默认0 */
@property (nonatomic, assign) NSInteger numberOfPages;

/** 当前选中的page,默认0 */
@property (nonatomic, assign) NSInteger currentPage;

/** 只有一张图时是否隐藏pagecontrol,默认YES */
@property (nonatomic, assign) BOOL hidePageControlForSinglePage;

/** pageControl分页指示器的size,默认{7,7} */
@property (nonatomic, assign) CGSize pageIndicatorSize;

/** pageControl当前分页指示器颜色 */
@property (nonatomic, strong) UIColor *currentPageIndicatorColor;

/** pageControl分页指示器颜色 */
@property (nonatomic, strong) UIColor *pageIndicatorColor;

/** pageControl当前分页指示器图片,设置后currentPageIndicatorColor失效 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/** pageControl分页指示器图片,设置后pageIndicatorColor失效 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;


@end

@protocol CQPageControlDelegate <NSObject>

@optional

- (void)pageControl:(CQPageControl *)pageControl didSelectIndex:(NSInteger)index;

@end
