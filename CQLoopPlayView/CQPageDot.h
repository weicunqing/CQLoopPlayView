//
//  CQPageDot.h
//  TestNavi
//
//  Created by 韦存情 on 2017/3/1.
//  Copyright © 2017年 aideer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQPageDot : UIImageView


/** 是否选中状态 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/** 普通状态下颜色 */
@property (nonatomic, strong) UIColor *normalColor;

/** 选中状态下颜色 */
@property (nonatomic, strong) UIColor *selectColor;

/** 普通状态下图片 */
@property (nonatomic, strong) UIImage *normalImage;

/** 选中状态下图片 */
@property (nonatomic, strong) UIImage *selectImage;

@end
