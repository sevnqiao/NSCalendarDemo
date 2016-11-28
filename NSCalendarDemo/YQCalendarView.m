//
//  YQCalendarView.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "YQCalendarView.h"
#import "YQCalendarItemView.h"
#import "NSDate+YQCalendar.h"

#define kScreen_width [UIScreen mainScreen].bounds.size.width
#define kScreen_height [UIScreen mainScreen].bounds.size.height
#define kItem_Width   30
#define kItemTotleNum 42
#define kCalendarView_Width  self.frame.size.width
#define kCalendarView_Height self.frame.size.height

@interface YQCalendarView() <YQCalendarItemViewDelegate>
{
    NSInteger lastMonthNum;
    NSInteger currentMonthNum;
    NSInteger nextMonthNum;
    
    NSInteger selectYear;
    NSInteger selectMonth;
    NSInteger selectDay;
}

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSMutableArray *calendarTitleLabelArray;

@end


@implementation YQCalendarView

- (NSMutableArray *)calendarTitleLabelArray {
    if (!_calendarTitleLabelArray) {
        _calendarTitleLabelArray = [NSMutableArray array];
    }
    return _calendarTitleLabelArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;

        self.year = [NSDate currentYear];
        self.month = [NSDate currentMonth];
        selectDay = [NSDate currentDay];
        selectMonth = [NSDate currentMonth];
        selectYear = [NSDate currentYear];
        
        [self initWeekTitleLabel];
        [self initDaysTitleLabel];
        
        [self getDayTitleArrWithMonth:self.month year:self.year];
    }
    return self;
}

- (void)initWeekTitleLabel {
    
    NSArray *weekArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    
    for (int i = 0; i < 7; i++) {
        UILabel *weekTitleLabel = [[UILabel alloc]init];
        weekTitleLabel.frame = CGRectMake(kCalendarView_Width/7 * i, 0, kCalendarView_Width/7, kItem_Width);
        weekTitleLabel.textAlignment = NSTextAlignmentCenter;
        weekTitleLabel.font = [UIFont systemFontOfSize:14];
        if (i == 0 || i == 6) {
            weekTitleLabel.textColor = [UIColor grayColor];
        }else {
            weekTitleLabel.textColor = [UIColor blackColor];
        }
        weekTitleLabel.text = weekArr[i];
        [self addSubview:weekTitleLabel];
    }
}

- (void)initDaysTitleLabel {
    
    for (int i = 0; i< kItemTotleNum; i++) {
        
        NSInteger lat = i / 7;
        NSInteger lng = i % 7;
        
        YQCalendarItemView *itemView = [[YQCalendarItemView alloc]initWithFrame:CGRectMake(kCalendarView_Width/7 * lng + (kCalendarView_Width/7 - kItem_Width)/2,
                                                                                           kItem_Width + kItem_Width * lat,
                                                                                           kItem_Width,
                                                                                           kItem_Width)];
        itemView.tag = i;
        itemView.delegate = self;
        [self addSubview:itemView];
        
        [self.calendarTitleLabelArray addObject:itemView];
    }
}

- (void)getDayTitleArrWithMonth:(NSInteger)month year:(NSInteger)year {
    
    NSInteger lastYear = [NSDate getYearOfLastMonthWithMonth:month year:year];
    NSInteger lastMonth = [NSDate getLastMonthWithMonth:month];
    
    NSInteger nextYear = [NSDate getYearOfNextMonthWithMonth:month year:year];
    NSInteger nextMonth = [NSDate getNextMonthWithMonth:month];
    

    // 1. 获取当前显示视图中上个月需要显示的部分
    NSMutableArray *lastMonthDayTitleArray = [NSMutableArray array];
    [lastMonthDayTitleArray addObjectsFromArray:[NSDate getLastMonthDaysTitleWithMonth:lastMonth year:lastYear]];
    
    // 2. 获取当前显示视图中本月需要显示的部分
    NSMutableArray *currentMonthDayTitleArray = [NSMutableArray array];
    [currentMonthDayTitleArray addObjectsFromArray:[NSDate getCurrentMonthDaysTitleWithMonth:month year:year]];

    // 3. 获取当前显示视图中下个月需要显示的部分
    NSMutableArray *nextMonthDayTitleArray = [NSMutableArray array];
    [nextMonthDayTitleArray addObjectsFromArray:[NSDate getNextMonthDaysTitleWithMonth:nextMonth year:nextYear]];
    
    lastMonthNum = lastMonthDayTitleArray.count;
    currentMonthNum = currentMonthDayTitleArray.count;
    nextMonthNum = nextMonthDayTitleArray.count;
    
    // 4. 显示的 item 的属性的控制
    for (int i = 0; i< kItemTotleNum; i++) {
        
        YQCalendarItemView *itemView = _calendarTitleLabelArray[i];
        
        if (i < lastMonthNum) {
            // 上个月需要显示的部分
            itemView.title = lastMonthDayTitleArray[i];
            itemView.selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            
            if (itemView.title.floatValue == selectDay && [NSDate getLastMonthWithMonth:self.month] == selectMonth && [NSDate getYearOfLastMonthWithMonth:self.month year:self.year] == selectYear) {
                itemView.selectStyle = ItemViewSelectStyleNormal;
                
            }else {
                itemView.selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            }
            
            if (itemView.title.floatValue == [NSDate currentDay] && self.year == [NSDate currentYear] && self.month == [NSDate currentMonth]) {
                itemView.selectStyle = ItemViewSelectStyleSpcial;
            }
            
        }else if (i < lastMonthNum + currentMonthNum) {
            // 当前月
            itemView.title = currentMonthDayTitleArray[i - lastMonthNum];

            if (itemView.title.floatValue == selectDay && self.month == selectMonth && self.year == selectYear) {
                itemView.selectStyle = ItemViewSelectStyleNormal;
                
            }else {
                itemView.selectStyle = ItemViewSelectStyleNone;
            }
            
            if (itemView.title.floatValue == [NSDate currentDay] && self.year == [NSDate currentYear] && self.month == [NSDate currentMonth]) {
                itemView.selectStyle = ItemViewSelectStyleSpcial;
            }
            
        }else if (i < lastMonthNum + currentMonthNum + nextMonthNum) {
            // 下个月需要显示的部分
            itemView.title = nextMonthDayTitleArray[i - lastMonthNum - currentMonthNum];
            itemView.selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            
            if (itemView.title.floatValue == selectDay && [NSDate getNextMonthWithMonth:self.month] == selectMonth && [NSDate getYearOfNextMonthWithMonth:self.month year:self.year] == selectYear) {
                itemView.selectStyle = ItemViewSelectStyleNormal;
                
            }else {
                itemView.selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            }
            
            if (itemView.title.floatValue == [NSDate currentDay] && self.year == [NSDate currentYear] && self.month == [NSDate currentMonth]) {
                itemView.selectStyle = ItemViewSelectStyleSpcial;
            }
        }
        // 周末颜色改为灰色
        NSInteger lng = i % 7;
        if ((lng == 0 || lng == 6) && itemView.selectStyle != ItemViewSelectStyleSpcial && itemView.selectStyle != ItemViewSelectStyleNormal) {
            itemView.selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
        }
    }
    
    // 5. 整体的 frame 适应下高度
    CGRect rect = self.frame;
    rect.size.height = kItem_Width * (lastMonthNum + currentMonthNum + nextMonthNum <= 35 ? 6 : 7);
    self.frame = rect;
}

- (void)lastMonth {
    
    // 获取上个月对应的年月
    self.year = [NSDate getYearOfLastMonthWithMonth:self.month year:self.year];
    self.month = [NSDate getLastMonthWithMonth:self.month];
    
    [self getDayTitleArrWithMonth:self.month year:self.year];
 
}

- (void)nextMonth {

    // 获取下个月对应的年月
    self.year = [NSDate getYearOfNextMonthWithMonth:self.month year:self.year];
    self.month = [NSDate getNextMonthWithMonth:self.month];
    
    [self getDayTitleArrWithMonth:self.month year:self.year];
    
}

#pragma mark - YQCalendarItemViewDelegate
- (void)didSelectCalendarItemView:(YQCalendarItemView *)calendarItemView1 {
    
    selectDay = calendarItemView1.title.integerValue;
    
    
    for (int i = 0; i < _calendarTitleLabelArray.count; i++) {
        
        YQCalendarItemView *calendarItemView = _calendarTitleLabelArray[i];
        
        if (calendarItemView == calendarItemView1) {
            
            if (i < lastMonthNum) {
                selectYear = [NSDate getYearOfLastMonthWithMonth:self.month year:self.year];
                selectMonth = [NSDate getLastMonthWithMonth:self.month];
                
                [self lastMonth];
                return ;
                
            }else if (i < lastMonthNum + currentMonthNum) {
                selectYear = self.year;
                selectMonth = self.month;
            }else{
                selectYear = [NSDate getYearOfNextMonthWithMonth:self.month year:self.year];
                selectMonth = [NSDate getNextMonthWithMonth:self.month];
                
                [self nextMonth];
                return;
            }
            
            if (self.year == [NSDate currentYear] && self.month == [NSDate currentMonth] && selectDay == [NSDate currentDay]) {
                // 如果是当前时间
                (calendarItemView).selectStyle = ItemViewSelectStyleSpcial;
            }else {
                (calendarItemView).selectStyle = ItemViewSelectStyleNormal;
            }
        }
        else if (i % 7 != 0 && i % 7 != 6 && i >= lastMonthNum && i < lastMonthNum + currentMonthNum) {
            // 当前月份
            if (self.year == [NSDate currentYear] && self.month == [NSDate currentMonth] && i-lastMonthNum+1 == [NSDate currentDay]) {
                // 如果是当前时间
                (calendarItemView).selectStyle = ItemViewSelectStyleSpcial;
            }else {
                (calendarItemView).selectStyle = ItemViewSelectStyleNone;
            }
        }
        else{
            // 其它月份或是周末
            (calendarItemView).selectStyle = ItemViewSelectStyleWeekendOrOtherMonth;
        }
        
    }
    
    
    
}

@end
