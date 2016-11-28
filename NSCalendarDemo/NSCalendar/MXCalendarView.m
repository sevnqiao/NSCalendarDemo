//
//  MXCalendarView.m
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/15.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import "MXCalendarView.h"
#import "UIColor+Additions.h"
#import "NSDate+Additions.h"
#import "MXTools.h"
static const NSUInteger kDateNumber = 42;
@implementation MXEventTags

@end

@implementation MXCalendarTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(@"#428ced");
        CGFloat originX = 15;
        CGFloat originY = 10;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, 30, 20)];
        imageView.image = [UIImage imageNamed:@"calendar_red"];
        imageView.contentMode = UIViewContentModeCenter;
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(originX+100, originY, 30, 20)];
        imageView1.image = [UIImage imageNamed:@"calendar_yellow"];
        imageView1.contentMode = UIViewContentModeCenter;
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(originX+200, originY, 30, 20)];
        imageView2.image = [UIImage imageNamed:@"calendar_green"];
        imageView2.contentMode = UIViewContentModeCenter;
        UILabel *label = [MXTools creatLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), originY, 70, 20) font:[UIFont systemFontOfSize:13] textColor:COLOR_ALPHA(@"#133563", 0.7) textAlignment:NSTextAlignmentLeft];
        UILabel *label1 = [MXTools creatLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame), originY, 70, 20) font:[UIFont systemFontOfSize:13] textColor:COLOR_ALPHA(@"#133563", 0.7) textAlignment:NSTextAlignmentLeft];
        UILabel *label2 = [MXTools creatLabelWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame), originY, 70, 20) font:[UIFont systemFontOfSize:13] textColor:COLOR_ALPHA(@"#133563", 0.7) textAlignment:NSTextAlignmentLeft];
        label.text = @"待办事项";
        label1.text  = @"经济日历";
        label2.text = @"业务节点";
        
        
        [self addSubview:imageView];
        [self addSubview:imageView1];
        [self addSubview:imageView2];
        [self addSubview:label];
        [self addSubview:label1];
        [self addSubview:label2];
        
        originY = 40;
        CGFloat width = (CGRectGetWidth(self.frame)-30)/7;
        
        NSArray *tempArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i = 0; i<7; i++) {
            UILabel *label = [MXTools creatLabelWithFrame:CGRectMake(originX + width*i, originY, width, 20) font:[UIFont systemFontOfSize:13] textColor:COLOR_ALPHA(@"#16305c", 0.6) textAlignment:NSTextAlignmentCenter];
            label.text = tempArray[i];
            [self addSubview:label];
        }

    }
    return self;
}

@end
@interface MXCalendarView ()<MXDateColumnViewDelegate>
@property(nonatomic,strong)NSMutableArray *dateViewArray;
@property(nonatomic,assign)NSUInteger currentSelectIndex;
@end
@implementation MXCalendarView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateViewArray = [NSMutableArray arrayWithCapacity:kDateNumber];
        CGFloat width = (CGRectGetWidth(self.frame)-30)/7;
        CGFloat height = width>31?31+15:width+15;
        CGFloat left = width>31?(width-31)/2:0;
        CGFloat originY = 0;
        CGFloat originX = 15;
        
        for (int i = 0; i<kDateNumber; i++) {
            MXDateColumnView *dateView = [[MXDateColumnView alloc]initWithFrame:CGRectMake(originX + width*(i%7), originY+(i/7)*height, width, height)];
            dateView.edgeInsets = UIEdgeInsetsMake(2, left, 6, left);
            dateView.delegate = self;
            [self addSubview:dateView];
            [self.dateViewArray addObject:dateView];
        }
        
        //调整高度
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, originY+height*6);
       
        
    }
    return self;
}
-(void)setAllEventTags:(NSMutableArray *)marray;
{
#warning 优化
    @autoreleasepool {
        for (int i =0; i<self.dateViewArray.count; i++) {
            [((MXDateColumnView *)self.dateViewArray[i]) setColumnType:MXDateColumnViewTypeNone];
        }
        for (MXEventTags *tag in marray) {
            for (int i =0; i<self.dateViewArray.count; i++) {
                NSDate *date = ((MXDateColumnView *)self.dateViewArray[i]).date;
                if ([tag.dateString isEqualToString:[date convertToStringWithFormat:@"yyyyMMdd"]]) {
                    [((MXDateColumnView *)self.dateViewArray[i]) setColumnType:tag.types];
                    
                }
            }
        }
    }
    
}
-(void)setCalendarViewWithDate:(NSDate *)date
{
    /*
    //提取date所在月份的第一天的日期
    NSInteger year = [date getYearOfTheDate];
    NSInteger month = [date getMonthOfTheDate];
    //NSInteger day = [date getDayOfTheDate];
    NSDate *firstDate = [NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)year,(long)month,(long)1]];
    NSDate *previous = [firstDate getPreviousDate];
    //获取星期
    NSInteger weakDay = [firstDate getWeekdayOfTheDate];
    NSInteger numOfDays = [firstDate getNumberOfDaysOneMonth];
    NSInteger previousMonthDays = [previous getNumberOfDaysOneMonth];
    //设置日期
    for (int i=0; i<self.dateViewArray.count; i++) {
        
        //上一个月
        if (i < weakDay-1) {
            ((MXDateColumnView *)self.dateViewArray[i]).day = previousMonthDays - (weakDay - i) +1;
            ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleDark;
        }
        //当月
        else if (i >= weakDay-1 && i < weakDay+numOfDays-1) {
            ((MXDateColumnView *)self.dateViewArray[i]).day = i - (weakDay -1) + 1;
            if (i%7 == 0 || i%7 == 6) {
                ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleGray;
            }else
            {
               ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleWhite;
            }
        }else//下一个月
        {
            ((MXDateColumnView *)self.dateViewArray[i]).day = i - (weakDay+numOfDays-1) +1;
            ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleDark;
        }
        
    }
     */
   
    //更改为 直接设置 日期  便于后期回调
    NSInteger year = [date getYearOfTheDate];
    NSInteger month = [date getMonthOfTheDate];
    //NSInteger day = [date getDayOfTheDate];
    NSDate *firstDate = [NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-01",(long)year,(long)month]];
    NSDate *previous = [firstDate getPreviousDate];
    NSInteger previousYear = [previous getYearOfTheDate];
    NSInteger previousMonth = [previous getMonthOfTheDate];
    //获取星期
    NSInteger weakDay = [firstDate getWeekdayOfTheDate];
    NSInteger numOfDays = [firstDate getNumberOfDaysOneMonth];
    NSInteger previousMonthDays = [previous getNumberOfDaysOneMonth];
    
    NSDate *nextDate = [[NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)year,(long)month,(long)numOfDays]] getNextDate];
    NSInteger nextYear = [nextDate getYearOfTheDate];
    NSInteger nextMonth = [nextDate getMonthOfTheDate];
    for (int i=0; i<self.dateViewArray.count; i++) {
        
        //上一个月
        if (i <= weakDay-2) {
            NSDate *date = [NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)previousYear,(long)previousMonth,(long)(previousMonthDays - (weakDay - i) +2)]];
            ((MXDateColumnView *)self.dateViewArray[i]).date = date;
            ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleDark;
        }
        //当月
        else if (i > weakDay-2 && i <= weakDay+numOfDays-2) {
            NSDate *date = [NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)year,(long)month,(long)(i - (weakDay -2) )]];
            ((MXDateColumnView *)self.dateViewArray[i]).date = date;
            if (i%7 == 0 || i%7 == 6) {
                ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleGray;
            }else
            {
                ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleWhite;
            }
        }else//下一个月
        {
            NSDate *date = [NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)nextYear,(long)nextMonth,(long)(i - (weakDay+numOfDays-2))]];
            ((MXDateColumnView *)self.dateViewArray[i]).date = date;
            ((MXDateColumnView *)self.dateViewArray[i]).colorStyle  = MXDateColumnViewColorStyleDark;
        }
        
    }
    //设置默认选择日期
    if (year == [[NSDate localeDate]getYearOfTheDate] && month == [[NSDate localeDate]getMonthOfTheDate]) {
        [self setSelectedDate:[NSDate localeDate] ];
    }else
    {
        [self setSelectedDate:[NSDate dateFormString:[NSString stringWithFormat:@"%04ld-%02ld-01",year,month]]];
    }

}
-(NSDate *)startDate
{
    return ((MXDateColumnView*)self.dateViewArray[0]).date;
}
-(NSDate *)endDate
{
    return ((MXDateColumnView*)self.dateViewArray[41]).date;
}
-(void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    NSString *str= [selectedDate convertToStringWithFormat:@"yyyy-MM-dd"];
    @autoreleasepool {
        for (int i =0; i<self.dateViewArray.count; i++) {
            NSDate *date = ((MXDateColumnView *)self.dateViewArray[i]).date;
            if ([str isEqualToString:[date convertToStringWithFormat:@"yyyy-MM-dd"]]) {
                ((MXDateColumnView *)self.dateViewArray[self.currentSelectIndex]).selected = NO;
                [((MXDateColumnView *)self.dateViewArray[i]) setSelected:YES];
                self.currentSelectIndex = i;
                return;
            }
        }
    }
}
#pragma mark - MXDateColumnViewDelegate
-(void)didSelectedDateColumnView:(MXDateColumnView *)dateColumnView
{
    _selectedDate = dateColumnView.date;
    //重置以前的dateColumnView的选中状态
    ((MXDateColumnView *)self.dateViewArray[self.currentSelectIndex]).selected = NO;
    //保存当前选中引索
    self.currentSelectIndex = [self.dateViewArray indexOfObject:dateColumnView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarView:didSelectedDate:)]) {
        [self.delegate calendarView:self didSelectedDate:_selectedDate];
    }
    
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path, NULL, 0, rect.size.height);

    [self drawLinearGradient:context path:path startColor:COLOR(@"#428ced").CGColor endColor:COLOR(@"347ad7").CGColor];
    CGPathRelease(path);
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
