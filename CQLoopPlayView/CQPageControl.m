//
//  CQPageControl.m
//  TestNavi
//
//  Created by 韦存情 on 2017/3/1.
//  Copyright © 2017年 aideer. All rights reserved.
//

#import "CQPageControl.h"
#import "CQPageDot.h"

@interface CQPageControl ()

@property (nonatomic, strong) NSMutableArray<CQPageDot *> *dotArray;
@end
@implementation CQPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      
      [self initSettings];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initSettings];
}

- (void)initSettings {
    
    _numberOfPages = 0;
    _currentPage = 0;
    _hidePageControlForSinglePage = YES;
    
    _pageIndicatorSize = CGSizeMake(7, 7);
    
    self.dotArray = [NSMutableArray array];
    
}

#pragma mark -- actions
- (void)updateUI {
    
    if (self.numberOfPages == 0) {
        self.hidden = YES;
        return;
    }else if (self.hidePageControlForSinglePage && self.numberOfPages == 1) {
        self.hidden = YES;
        return;
    }
    
    for (CQPageDot *dot in self.dotArray) {
        [dot removeFromSuperview];
    }
    [self.dotArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        CQPageDot *dot = [[CQPageDot alloc]init];
        [self addSubview:dot];
        [self.dotArray addObject:dot];
        
        if (self.pageIndicatorColor) {
            dot.normalColor = self.pageIndicatorColor;
        }
        if (self.currentPageIndicatorColor) {
            dot.selectColor = self.currentPageIndicatorColor;
        }
        if (self.pageIndicatorImage) {
            dot.normalImage = self.pageIndicatorImage;
        }
        if (self.currentPageIndicatorImage) {
            dot.selectImage = self.currentPageIndicatorImage;
        }
        
        dot.selected = (i == self.currentPage);
        
        CGFloat space = CGRectGetWidth(self.frame)/(self.numberOfPages+1.0);
        CGFloat w = self.pageIndicatorSize.width;
        CGFloat h = self.pageIndicatorSize.height;
        CGFloat x = space * (i+1) + w * i;
        CGFloat y = (CGRectGetHeight(self.frame)-h) * 0.5;
        dot.frame = CGRectMake(x, y, w, h);
        
        UITapGestureRecognizer *tapDot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageDotDidSelected:)];
        [dot addGestureRecognizer:tapDot];
    }
    
}

- (void)pageDotDidSelected:(UITapGestureRecognizer *)tap {
    
    CQPageDot *dot = (CQPageDot *)[tap view];
    NSInteger index = [self.dotArray indexOfObject:dot];
    
    if ([self.delegate respondsToSelector:@selector(pageControl:didSelectIndex:)]) {
        [self.delegate pageControl:self didSelectIndex:index];
    }
}
#pragma mark -- properties
- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    
    [self updateUI];
}
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    for (CQPageDot *dot in self.dotArray) {
        
        if ([self.dotArray indexOfObject:dot] == _currentPage) {
            [dot setSelected:YES];
        }else {
            [dot setSelected:NO];
        }
    }
}
- (void)setHidePageControlForSinglePage:(BOOL)hidePageControlForSinglePage {
    _hidePageControlForSinglePage = hidePageControlForSinglePage;
    
    [self updateUI];
}

- (void)setPageIndicatorSize:(CGSize)pageIndicatorSize {
    _pageIndicatorSize = pageIndicatorSize;
    
    [self updateUI];
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    _pageIndicatorColor = pageIndicatorColor;
    
    for (CQPageDot *dot in self.dotArray) {
        dot.normalColor = _pageIndicatorColor;
    }
}
- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    _currentPageIndicatorColor = currentPageIndicatorColor;
    
    for (CQPageDot *dot in self.dotArray) {
        dot.selectColor = _currentPageIndicatorColor;
    }
}
- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    _pageIndicatorImage = pageIndicatorImage;
    
    for (CQPageDot *dot in self.dotArray) {
        dot.normalImage = _pageIndicatorImage;
    }
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    _currentPageIndicatorImage = currentPageIndicatorImage;
    
    for (CQPageDot *dot in self.dotArray) {
        dot.selectImage = _currentPageIndicatorImage;
    }
}
#pragma mark -- override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.08;
    
    if (self.dotArray.count == 0) {
        return;
    }
    for (NSInteger i = 0; i < self.numberOfPages; i++) {
        
        CQPageDot *dot = self.dotArray[i];
        CGFloat w = self.pageIndicatorSize.width;
        CGFloat h = self.pageIndicatorSize.height;
        CGFloat space = (CGRectGetWidth(self.frame)-w*self.numberOfPages)/(self.numberOfPages+1.0);
        CGFloat x = space * (i+1) + w * i;
        CGFloat y = (CGRectGetHeight(self.frame)-h) * 0.5;
        dot.frame = CGRectMake(x, y, w, h);
        
    }
}

@end
