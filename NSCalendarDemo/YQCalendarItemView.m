//
//  YQCalendarItemView.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "YQCalendarItemView.h"


@interface YQCalendarItemView()
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIColor  *titleColor;
@property (nonatomic, strong) UIColor  *selectColor;

@end


@implementation YQCalendarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initTitleLabelWithFrame:self.bounds];
        [self initGestureRecognizer];
    }
    return self;
}

- (void)initTitleLabelWithFrame:(CGRect)frame {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = frame;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.cornerRadius = self.frame.size.width / 2.0;
    self.titleLabel.layer.masksToBounds = YES;
    [self addSubview:self.titleLabel];
    
}

- (void)initGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self addGestureRecognizer:tap];
}

- (void)clickAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectCalendarItemView:)]) {
        [self.delegate didSelectCalendarItemView:self];
    }
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
    [self setNeedsDisplay];
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    self.titleLabel.backgroundColor = selectColor;
    [self setNeedsDisplay];
}


- (void)setSelectStyle:(ItemViewSelectStyle)selectStyle {

    switch (selectStyle) {
        case ItemViewSelectStyleNone:
        {
            self.titleColor = [UIColor blackColor];
            self.selectColor = [UIColor clearColor];
        }
            break;
        case ItemViewSelectStyleNormal:
        {
            self.titleColor = [UIColor whiteColor];
            self.selectColor = [UIColor grayColor];
        }
            break;
        case ItemViewSelectStyleSpcial:
        {
            self.titleColor = [UIColor whiteColor];
            self.selectColor = [UIColor redColor];
        }
            break;
        case ItemViewSelectStyleWeekendOrOtherMonth:
        {
            self.titleColor = [UIColor grayColor];
            self.selectColor = [UIColor clearColor];
        }
            break;
    }
}

@end
