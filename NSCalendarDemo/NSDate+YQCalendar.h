//
//  NSDate+YQCalendar.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YQCalendar)

#pragma mark + NSCalendar 获取相关时间方法

#pragma mark - NSCalendar 获取当前年月日
+ (NSInteger)currentYear;

+ (NSInteger)currentMonth;

+ (NSInteger)currentDay;


# pragma mark - 获取上个月或下个月对应的年月
+ (NSInteger)getLastMonthWithMonth:(NSInteger)month;

+ (NSInteger)getYearOfLastMonthWithMonth:(NSInteger)month year:(NSInteger)year;

+ (NSInteger)getNextMonthWithMonth:(NSInteger)month;

+ (NSInteger)getYearOfNextMonthWithMonth:(NSInteger)month year:(NSInteger)year;

#pragma mark - 获取当前月份的相关天数
// 一个月有多少天
+ (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;

// 一个月有几周
+ (NSInteger)numberOfWeekInMonth:(NSInteger)month year:(NSInteger)year;

// 这个月份的第一周有几天
+ (NSInteger)numberOfDaysAtFirstWeekInMonth:(NSInteger)month year:(NSInteger)year;

// 这个月份的最后一周有几天
+ (NSInteger)numberOfDaysAtLastWeekInMonth:(NSInteger)month year:(NSInteger)year;

// 获取当前日历视图上需要显示的当前月的日期的数组
+ (NSMutableArray *)getCurrentMonthDaysTitleWithMonth:(NSInteger)month year:(NSInteger)year;

// 获取当前日历视图上需要显示的下个月的日期的数组
+ (NSMutableArray *)getNextMonthDaysTitleWithCurrentMonth:(NSInteger)month currentYear:(NSInteger)year;

// 获取当前日历视图上需要显示的上个月的日期的数组
+ (NSMutableArray *)getLastMonthDaysTitleWithCurrentMonth:(NSInteger)month currentYear:(NSInteger)year;

@end
