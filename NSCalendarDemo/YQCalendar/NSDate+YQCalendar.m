//
//  NSDate+YQCalendar.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "NSDate+YQCalendar.h"
#import "YQCalendarModel.h"
#import "YQEventModel.h"

@implementation NSDate (YQCalendar)

#pragma mark - NSCalendar 获取当前年月日
+ (NSInteger)currentYear {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return components.year;
    
}

+ (NSInteger)currentMonth {
    
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return components.month;
    
}

+ (NSInteger)currentDay {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    return components.day;
    
}


# pragma mark - 获取上个月或下个月对应的年月
+ (NSInteger)getLastMonthWithMonth:(NSInteger)month {
    
    if (month == 1) {
        return 12;
    }
    return month - 1;
}

+ (NSInteger)getYearOfLastMonthWithMonth:(NSInteger)month year:(NSInteger)year{
    
    if (month == 1) {
        return year - 1;
    }
    return year;
}

+ (NSInteger)getNextMonthWithMonth:(NSInteger)month {
    
    if (month == 12) {
        return 1;
    }
    return month + 1;
}

+ (NSInteger)getYearOfNextMonthWithMonth:(NSInteger)month year:(NSInteger)year{
    
    if (month == 12) {
        return year + 1;
    }
    return year;
}


#pragma mark - 获取当前月份的相关天数
// 一个月有多少天
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year{
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateWithEra:1 year:year month:month day:15 hour:0 minute:0 second:0 nanosecond:0];
    NSRange monthRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return monthRange.length;
    
}

// 一个月有几周
+ (NSInteger)numberOfWeekInMonth:(NSInteger)month year:(NSInteger)year{
    
    NSUInteger weeks = 0;
    NSUInteger weekday = [self numberOfDaysAtFirstWeekInMonth:month year:year];
    if (weekday > 0) {
        weeks += 1;
    }
    NSUInteger monthDays = [self numberOfDaysInMonth:month year:year];
    weeks = weeks + (monthDays - weekday) / 7;
    if ((monthDays - weekday) % 7 > 0) {
        weeks += 1;
    }
    return weeks;
    
}

// 这个月份的第一周有几天
+ (NSInteger)numberOfDaysAtFirstWeekInMonth:(NSInteger)month year:(NSInteger)year{
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setValue:month forComponent:NSCalendarUnitMonth];
    [components setValue:year forComponent:NSCalendarUnitYear];
    [components setDay:1];
    
    NSDate *date = [calendar dateFromComponents:components];
    components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return 8 - components.weekday;
}

// 这个月份的最后一周有几天
+ (NSInteger)numberOfDaysAtLastWeekInMonth:(NSInteger)month year:(NSInteger)year{
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [NSDateComponents new];
    [components setValue:month forComponent:NSCalendarUnitMonth];
    [components setValue:year forComponent:NSCalendarUnitYear];
    [components setDay:[self numberOfDaysInMonth:month year:year]];
    
    NSDate *date = [calendar dateFromComponents:components];
    components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return components.weekday;
}


// 获取当前日历视图上需要显示的当前月的日期的数组
+ (NSMutableArray *)getCurrentMonthDaysTitleWithMonth:(NSInteger)month year:(NSInteger)year {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < [self numberOfDaysInMonth:month year:year]; i++) {
        @autoreleasepool {
            YQCalendarModel *model = [YQCalendarModel new];
            model.year = year;
            model.month = month;
            model.day = i+1;
            
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            model.date = [calendar dateWithEra:1 year:model.year month:model.month day:model.day hour:0 minute:0 second:0 nanosecond:0];
            
            NSInteger weekDay = [calendar component:NSWeekdayCalendarUnit fromDate:model.date];
            
            if (i+1 == [self currentDay] && month == [self currentMonth]) {
                
                model.itemStyle = ItemViewSelectStyleSpcial;
                
            }else if (weekDay == 1 || weekDay == 7) {
                
                model.itemStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            }else {
                model.itemStyle = ItemViewSelectStyleNone;
            }
            
            [arr addObject:model];
        }
    }
    
    return arr;
}

// 获取当前日历视图上需要显示的下个月的日期的数组
+ (NSMutableArray *)getNextMonthDaysTitleWithCurrentMonth:(NSInteger)month currentYear:(NSInteger)year {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger nextMonth = [NSDate getNextMonthWithMonth:month];
    NSInteger nextYear = [NSDate getYearOfNextMonthWithMonth:month year:year];
    
    // 当前月最后一周有多少天
    NSInteger lastWeekDaysNum = [NSDate numberOfDaysAtLastWeekInMonth:month year:year];
    if (lastWeekDaysNum == 7) {
        lastWeekDaysNum = 0;
    }
    
    for (int i = 0; i < 7 - lastWeekDaysNum; i++) {
        @autoreleasepool {
            YQCalendarModel *model = [YQCalendarModel new];
            model.year = nextYear;
            model.month = nextMonth;
            model.day = i+1;
            
            if (i+1 == [self currentDay] && model.month == [self currentMonth]) {
                
                model.itemStyle = ItemViewSelectStyleSpcial;
                
            }else{
                
                model.itemStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            }
            
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            model.date = [calendar dateWithEra:1 year:model.year month:model.month day:model.day hour:0 minute:0 second:0 nanosecond:0];
            
            [arr addObject:model];
        }
    }
    return arr;
    
}

// 获取当前日历视图上需要显示的上个月的日期的数组
+ (NSMutableArray *)getLastMonthDaysTitleWithCurrentMonth:(NSInteger)month currentYear:(NSInteger)year {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger lastMonth = [NSDate getLastMonthWithMonth:month];
    NSInteger lastYear = [NSDate getYearOfLastMonthWithMonth:month year:year];
    
    // 当前月第一周有几天
    NSInteger firstWeekDayNum = [NSDate numberOfDaysAtFirstWeekInMonth:month year:year];
    
    if (firstWeekDayNum == 7) {
        firstWeekDayNum = 0;
    }
    // 1.上个月的几天
    
    for (int i = 0; i < 7 - firstWeekDayNum; i++) {
        @autoreleasepool {
            NSInteger lastMonthDaysNum = [NSDate numberOfDaysInMonth:lastMonth year:lastYear];
            
            YQCalendarModel *model = [YQCalendarModel new];
            model.year = lastYear;
            model.month = lastMonth;
            model.day = lastMonthDaysNum - (7 - firstWeekDayNum - i) + 1;
            
            if (model.day == [self currentDay] && model.month == [self currentMonth]) {
                
                model.itemStyle = ItemViewSelectStyleSpcial;
                
            }else{
                
                model.itemStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            }
            
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            model.date = [calendar dateWithEra:1 year:model.year month:model.month day:model.day hour:0 minute:0 second:0 nanosecond:0];
            
            [arr addObject:model];
        }
    }
    return arr;
    
}


@end
