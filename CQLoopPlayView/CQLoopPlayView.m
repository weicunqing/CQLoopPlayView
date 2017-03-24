//
//  CQLoopPlayView.m
//  LoopPlaybackDemo
//
//  Created by 韦存情 on 16/6/13.
//  Copyright © 2016年 韦存情. All rights reserved.
//

#import "CQLoopPlayView.h"
#import "CQLoopPlayCell.h"
#import "CQPageControl.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif


static NSString *const cellIdentifier = @"CQLoopPlayCell";
static NSInteger const sectionCount = 3;

@interface CQLoopPlayView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;//轮播图
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIImage *placeholderImage;//占位图
@property (nonatomic, strong) NSArray* imageArray;//图片数组
@property (nonatomic, strong) CQPageControl* pageCtrl;//

@property (nonatomic, strong) NSTimer* timer;//计时器
@property (nonatomic, assign ,readonly) UICollectionViewScrollPosition scrollPosition;

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@end

@implementation CQLoopPlayView

#pragma mark initialize Method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        [self initialize];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initialize];
}
- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage {
    
    if (self = [super initWithFrame:frame]) {
        self.placeholderImage = placeholderImage;
        [self initialize];
    }
    return self;
}
+ (instancetype)loopPlayViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage {
    return [[self alloc]initWithFrame:frame placeholderImage:placeholderImage];
}
- (void)initialize {
    
    // pageControl
    _pageControlBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    _pageControlAlignment = CQLoopPlayViewPageControlAlignmentCenter;
    _showPageControl = YES;
    _hidePageControlForSinglePage = YES;
    
    _pageControlSize = CGSizeMake(80, 15);
    _pageIndicatorSize = CGSizeMake(7, 7);
    
    _automaticallyAdjustsTextInsets = YES;
    _pageControlBottomInset = 2.0;
    _pageControlRightInset = 0.0;
    
    // timer
    _autoPlay = YES;
    _timeInterval = 2.0;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // subview
    [self addSubview:self.collectionView];
    [self addSubview:self.pageCtrl];
    
}

#pragma mark -- actions
- (void)reloadData {
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:1] atScrollPosition:self.scrollPosition animated:NO];
    
    [self updatePageControl];
}
- (void)updatePageControl {
    
    if (self.imageArray.count == 0) return;
    if (self.imageArray.count == 1 && self.hidePageControlForSinglePage) {
        self.pageCtrl.hidden = YES;
        return;
    };
    
    self.pageCtrl.hidden = !self.showPageControl;
    
    self.pageCtrl.numberOfPages = self.imageArray.count;
    self.pageCtrl.currentPage = self.currentIndex;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark collectionView DelegateAndDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sectionCount;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count?self.imageArray.count:1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CQLoopPlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *indexImage = self.imageArray[indexPath.item];
    if (indexImage == nil) {
        cell.imageView.image = self.placeholderImage;
    }
    
    if ([indexImage isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)indexImage;
    }else if ([indexImage isKindOfClass:[NSString class]]) {
        if ([indexImage hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:indexImage] placeholderImage:self.placeholderImage];
        }else {
            UIImage *image = [UIImage imageNamed:indexImage];
            if (image) {
                cell.imageView.image = image;
            }else {
                cell.imageView.image = self.placeholderImage;
            }
        }
    }else if(indexImage != nil) {
        
        NSLog(@"CQLoopPlayView  图片数组的格式不正确,请确认数组成员是字符串或者图片");
    }
    
    if (self.textArray.count > indexPath.item) {
        cell.text = self.textArray[indexPath.item];
    }
    if (self.detailTextArray.count > indexPath.item) {
        cell.detailText = self.detailTextArray[indexPath.item];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectImageBlock) {
    
        self.selectImageBlock(indexPath.item);
    }
    if([self.delegate respondsToSelector:@selector(loopPlayView:didSelectImageAtIndex:)]){
    
        [self.delegate loopPlayView:self didSelectImageAtIndex:indexPath.item];
    }
}

#pragma mark scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imageArray.count == 0) return;
    
    self.pageCtrl.currentPage = self.currentIndex;
   
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoPlay) {
        [self removeTimer];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoPlay) {
        [self startTimer];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (self.imageArray.count == 0) return;
    
    if ([self.delegate respondsToSelector:@selector(loopPlayView:didScrollToIndex:)]) {
        
        [self.delegate loopPlayView:self didScrollToIndex:self.currentIndex];
    } else if (self.scrollEndBlock) {
        
        self.scrollEndBlock(self.currentIndex);
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:1] atScrollPosition:self.scrollPosition animated:NO];
    
}

#pragma mark NSTimer Method
- (void)timerAction
{
    if (self.imageArray.count == 0) {
        return;
    }
    
    NSIndexPath *nextIndexPath;
    if (self.currentIndex == self.imageArray.count-1) {
        nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    }else {
        nextIndexPath = [NSIndexPath indexPathForItem:self.currentIndex+1 inSection:1];
    }
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:self.scrollPosition animated:YES];

    
}
- (void)startTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark lazy Load
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = self.frame.size;
        layout.scrollDirection = self.scrollDirection;
        self.flowLayout = layout;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[CQLoopPlayCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _collectionView;
}
-(CQPageControl *)pageCtrl
{
    if (!_pageCtrl) {
        _pageCtrl = [[CQPageControl alloc]init];
        _pageCtrl.hidden = !self.showPageControl;
        _pageCtrl.backgroundColor = _pageControlBackgroundColor;
        _pageCtrl.frame = CGRectMake(CGRectGetMidX(self.frame)-self.pageControlSize.width*0.5, CGRectGetHeight(self.frame)-self.pageControlSize.height-self.pageControlBottomInset, self.pageControlSize.width, self.pageControlSize.height);
        _pageCtrl.pageIndicatorSize = self.pageIndicatorSize;
    }
    return _pageCtrl;
}

#pragma mark -- setter getter
// data source
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    
    if (_imageArray.count == 1) {
        self.collectionView.scrollEnabled = NO;
    }else {
        self.collectionView.scrollEnabled = YES;
        [self setAutoPlay:self.autoPlay];
    }
    
    [self reloadData];
}
- (void)setURLStringArray:(NSArray<NSString *> *)URLStringArray {
    _URLStringArray = URLStringArray;
    
    self.imageArray = _URLStringArray.copy;
}
- (void)setLocalImageNameArray:(NSArray<NSString *> *)localImageNameArray {
    _localImageNameArray = localImageNameArray;
    
    self.imageArray = _localImageNameArray;
}
- (void)setTextArray:(NSArray<NSString *> *)textArray {
    _textArray = textArray;
    
    [self reloadData];
}
- (void)setDetailTextArray:(NSArray<NSString *> *)detailTextArray {
    _detailTextArray = detailTextArray;
    
    [self reloadData];
}

// auto play
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = _scrollDirection;
}
- (void)setAutoPlay:(BOOL)autoPlay {
    _autoPlay = autoPlay;
    
    if (self.timer) {
        [self removeTimer];
    }
    
    if (_autoPlay) {
        [self startTimer];
    }
}
- (void)setTimeInterval:(CGFloat)timeInterval {
    _timeInterval = timeInterval;
    
    if (self.timer) {
        [self removeTimer];
    }
    
    if (self.autoPlay) {
        [self startTimer];
    }
}

// page control
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    
    self.pageCtrl.hidden = !_showPageControl;
}
- (void)setHidePageControlForSinglePage:(BOOL)hidePageControlForSinglePage {
    _hidePageControlForSinglePage = hidePageControlForSinglePage;
    
    self.pageCtrl.hidePageControlForSinglePage = _hidePageControlForSinglePage;
}
- (void)setPageControlAlignment:(CQLoopPlayViewPageControlAlignment)pageControlAlignment {
    _pageControlAlignment = pageControlAlignment;
    
    [self updatePageControl];
}
- (void)setPageControlSize:(CGSize)pageControlSize {
    _pageControlSize = pageControlSize;
    
    CGRect frame = self.pageCtrl.frame;
    frame.size.width = _pageControlSize.width;
    frame.size.height = _pageControlSize.height;
    self.pageCtrl.frame = frame;
    
}
- (void)setPageIndicatorSize:(CGSize)pageIndicatorSize {
    _pageIndicatorSize = pageIndicatorSize;
    
    self.pageCtrl.pageIndicatorSize = _pageIndicatorSize;
}
- (void)setPageControlBackgroundColor:(UIColor *)pageControlBackgroundColor {
    _pageControlBackgroundColor = pageControlBackgroundColor;
    
    self.pageCtrl.backgroundColor = _pageControlBackgroundColor;
}
- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor {
    _pageIndicatorColor = pageIndicatorColor;
    
    self.pageCtrl.pageIndicatorColor = _pageIndicatorColor;
}
- (void)setCurrentPageIndicatorColor:(UIColor *)currentPageIndicatorColor {
    _currentPageIndicatorColor = currentPageIndicatorColor;
    
    self.pageCtrl.currentPageIndicatorColor = _currentPageIndicatorColor;
}
- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    _pageIndicatorImage = pageIndicatorImage;
    
    self.pageCtrl.pageIndicatorImage = _pageIndicatorImage;
}
- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    _currentPageIndicatorImage = currentPageIndicatorImage;
    
    self.pageCtrl.currentPageIndicatorImage = _currentPageIndicatorImage;
}
- (void)setAutomaticallyAdjustsTextInsets:(BOOL)automaticallyAdjustsTextInsets {
    _automaticallyAdjustsTextInsets = automaticallyAdjustsTextInsets;
    
    [self updatePageControl];
}
- (void)setPageControlBottomInset:(CGFloat)pageControlBottomInset {
    _pageControlBottomInset = pageControlBottomInset;
    
    [self updatePageControl];
}
- (void)setPageControlRightInset:(CGFloat)pageControlRightInset {
    _pageControlRightInset = pageControlRightInset;
    
    [self updatePageControl];
}

- (NSInteger)currentIndex {
   
    if (self.imageArray.count <= 0) {
        return 0;
    }
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }
    NSInteger index;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        index = MAX(0, (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width);
    }else {
        index = MAX(0, (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height);
    }
    
    return index % self.imageArray.count;
}

- (UICollectionViewScrollPosition)scrollPosition {
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return UICollectionViewScrollPositionLeft;
    }else {
        return UICollectionViewScrollPositionTop;
    }
}

#pragma mark -- override
- (void)dealloc {

    if (self.timer) {
        [self removeTimer];
    }
    
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    self.flowLayout.itemSize = self.frame.size;
    self.collectionView.frame = self.bounds;
    
    CGSize pageCtrlSize = self.pageCtrl.bounds.size;

    CGFloat x = (self.frame.size.width - pageCtrlSize.width) * 0.5;
    if (self.pageControlAlignment == CQLoopPlayViewPageControlAlignmentRight) {
        x = self.collectionView.frame.size.width - pageCtrlSize.width ;
    }
    CGFloat y = self.collectionView.frame.size.height - pageCtrlSize.height;
    if (self.automaticallyAdjustsTextInsets && (self.textArray.count > 0 || self.detailTextArray.count > 0)) {
        y -= 30.0;
    }
    CGRect pageCtrlFrame = CGRectMake(x, y, pageCtrlSize.width, pageCtrlSize.height);
    pageCtrlFrame.origin.y -= self.pageControlBottomInset;
    pageCtrlFrame.origin.x -= self.pageControlRightInset;
    self.pageCtrl.frame = pageCtrlFrame;
    self.pageCtrl.hidden = !_showPageControl;

}
@end

