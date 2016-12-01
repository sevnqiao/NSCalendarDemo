//
//  YQCalendarItemView.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "YQCalendarItemView.h"
#import "NSDate+YQCalendar.h"
#import "YQEventModel.h"

@interface YQCalendarItemView()
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, assign) ItemViewSelectStyle selectStyle;

@property (nonatomic, strong) CALayer  *eventLayer;
@property (nonatomic, assign) ItemViewEventsType eventType;
@end


@implementation YQCalendarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initTitleLabelWithFrame:CGRectMake(frame.size.width/8, frame.size.width/8, frame.size.width*3/4, frame.size.width*3/4)];
        [self initEventLayerWithFrame:CGRectMake(frame.size.width/6, frame.size.height - 3, frame.size.width*2/3, 3)];
        [self initGestureRecognizer];
    }
    return self;
}

- (void)initTitleLabelWithFrame:(CGRect)frame {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = frame;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.layer.cornerRadius = self.titleLabel.frame.size.width / 2.0;
    self.titleLabel.layer.masksToBounds = YES;
    [self addSubview:self.titleLabel];
}

- (void)initEventLayerWithFrame:(CGRect)frame {
    
    self.eventLayer = [CALayer layer];
    self.eventLayer.frame = frame;
    [self.layer addSublayer:self.eventLayer];
    
}

- (void)initGestureRecognizer{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self addGestureRecognizer:tap];
    
}

- (void)clickAction:(UIButton *)sender {

    if (self.calendarModel.day == [NSDate currentDay] && self.calendarModel.month == [NSDate currentMonth]) {
        
        self.calendarModel.itemStyle = ItemViewSelectStyleSpcial;
        
    }else{
        
        self.calendarModel.itemStyle = ItemViewSelectStyleNormal;
    }
    
    [self setCalendarModel:_calendarModel];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCalendarItemView:)]) {
        [self.delegate didSelectCalendarItemView:self];
    }
}


- (void)setCalendarModel:(YQCalendarModel *)calendarModel {
    
    _calendarModel = calendarModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)calendarModel.day];
    if (calendarModel) {
        self.selectStyle = calendarModel.itemStyle;
    }else{
        self.selectStyle = ItemViewSelectStyleNone;
    }
    
    if (calendarModel.eventModel) {
        self.eventType = calendarModel.eventModel.eventType;
    }else{
        self.eventType = ItemViewEventsTypeNone;
    }
    
    [self setNeedsDisplay];
    
}

- (void)setSelectStyle:(ItemViewSelectStyle)selectStyle {

    switch (selectStyle) {
        case ItemViewSelectStyleNone:
        {
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
            break;
        case ItemViewSelectStyleWeekendOrOtherMonth:
        {
            self.titleLabel.textColor = [UIColor grayColor];
            self.titleLabel.backgroundColor = [UIColor clearColor];
        }
            break;
        case ItemViewSelectStyleNormal:
        {
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor grayColor];
        }
            break;
        case ItemViewSelectStyleSpcial:
        {
            self.titleLabel.textColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = [UIColor redColor];
        }
            break;
    }
    
    [self setNeedsDisplay];
}

- (void)setEventType:(ItemViewEventsType)eventType {
    
    switch (eventType) {
        case ItemViewEventsTypeNone:
        {
            self.eventLayer.backgroundColor = [UIColor clearColor].CGColor;
        }
            break;
        case ItemViewEventsTypeNormal:
        {
            self.eventLayer.backgroundColor = [UIColor greenColor].CGColor;
        }
            break;
        case ItemViewEventsTypeImportent:
        {
            self.eventLayer.backgroundColor = [UIColor orangeColor].CGColor;
        }
            break;
        case ItemViewEventsTypeEmergency:
        {
            self.eventLayer.backgroundColor = [UIColor redColor].CGColor;
        }
            break;
    }
    [self setNeedsDisplay];
}


@end
