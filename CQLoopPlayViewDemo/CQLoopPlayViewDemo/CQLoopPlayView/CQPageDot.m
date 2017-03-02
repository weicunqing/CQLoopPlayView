//
//  CQPageDot.m
//  TestNavi
//
//  Created by 韦存情 on 2017/3/1.
//  Copyright © 2017年 aideer. All rights reserved.
//

#import "CQPageDot.h"

@implementation CQPageDot

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _normalColor = [UIColor lightGrayColor];
        _selectColor = [UIColor whiteColor];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = self.normalColor;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
    }
    return self;
}

#pragma mark -- properties
- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    
    if (!self.isSelected) {
        self.backgroundColor = _normalColor;
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    
    if (self.isSelected) {
        self.backgroundColor = _selectColor;
    }
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    
    if (!self.isSelected) {
        self.image = _normalImage;
    }
}

- (void)setSelectImage:(UIImage *)selectImage {
    _selectImage = selectImage;
    
    if (self.isSelected) {
        self.image = _selectImage;
    }
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    self.backgroundColor = _selected ? self.selectColor : self.normalColor;
    self.image = _selected ? self.selectImage : self.normalImage;
}


#pragma mark -- override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetWidth(self.frame) * 0.5;
}

@end
