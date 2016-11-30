//
//  YQCalendarModel.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemViewSelectStyle) {
    ItemViewSelectStyleNone = 1,  // 未选中,
    ItemViewSelectStyleNormal,    // 普通日期选中
    ItemViewSelectStyleSpcial,    // 当前日期选中
    ItemViewSelectStyleWeekendOrOtherMonth,   // 周末或其它月份未选中
};

@interface YQCalendarModel : NSObject
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic ) NSDate *date;
@property (nonatomic, assign) ItemViewSelectStyle itemStyle;
@end
