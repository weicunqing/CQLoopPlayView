//
//  CQLoopPlayCell.m
//  LoopPlaybackDemo
//
//  Created by 韦存情 on 16/6/14.
//  Copyright © 2016年 韦存情. All rights reserved.
//

#import "CQLoopPlayCell.h"

#define TEXT_FONT [UIFont systemFontOfSize:14.0]
#define TEXT_COLOR [UIColor whiteColor]
#define TEXT_BACKGROUND_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]

// textLabel和detailTextLabel的高
#define LABEL_HEIGHT 30.0
// textLabel宽度占contentView的宽度的比。
#define LABEL_WIDTH_RATIO 0.75

@interface CQLoopPlayCell()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;

@end
@implementation CQLoopPlayCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
    }
    return self;
}

#pragma mark -- properties

- (void)setText:(NSString *)text {
    _text = text;
    
    self.textLabel.text = [NSString stringWithFormat:@"  %@",_text];
    if (self.textLabel.isHidden) {
        self.textLabel.hidden = NO;
    }
    if (self.detailTextLabel.isHidden) {
        self.detailTextLabel.hidden = NO;
    }
}
- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",_detailText];
    if (self.textLabel.isHidden) {
        self.textLabel.hidden = NO;
    }
    if (self.detailTextLabel.isHidden) {
        self.detailTextLabel.hidden = NO;
    }
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    }
    return _imageView;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = TEXT_COLOR;
        _textLabel.font = TEXT_FONT;
        _textLabel.backgroundColor = TEXT_BACKGROUND_COLOR;
        _textLabel.hidden = YES;
    }
    return _textLabel;
}
- (UILabel *)detailTextLabel {
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc]init];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.textColor = TEXT_COLOR;
        _detailTextLabel.font = TEXT_FONT;
        _detailTextLabel.backgroundColor = TEXT_BACKGROUND_COLOR;
        _detailTextLabel.hidden = YES;
    }
    return _detailTextLabel;
}
#pragma mark -- override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
    
    CGFloat titleLabelW = self.contentView.frame.size.width * LABEL_WIDTH_RATIO;
    CGFloat titleLabelH = LABEL_HEIGHT;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.contentView.frame.size.height - titleLabelH;
    self.textLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    CGFloat detailLabelW = self.contentView.frame.size.width - titleLabelW;
    CGFloat detailLabelH = titleLabelH;
    CGFloat detailLabelX = titleLabelW;
    CGFloat detailLabelY = titleLabelY;
    self.detailTextLabel.frame = CGRectMake(detailLabelX, detailLabelY, detailLabelW, detailLabelH);
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
}

@end
