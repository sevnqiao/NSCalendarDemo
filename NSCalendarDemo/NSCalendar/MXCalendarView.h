//
//  MXCalendarView.h
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/15.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXDateColumnView.h"
@class MXCalendarView;
/**
 *  日历里 所包含的日历事件类
 */
@interface MXEventTags : NSObject
/**
 *  日历类型
 */
@property(nonatomic,assign)MXDateColumnViewType types;
/**
 *  日历的时间
 */
@property(nonatomic,copy)NSString *dateString;
@end
/**
 *  日历中不可滑动的部分 （星期 及 经济日历）
 */
@interface MXCalendarTitleView : UIView

@end
/**
 *  日历view 代理
 */
@protocol MXCalendarViewDelegate<NSObject>
@optional
/**
 *  日历view 点击事件选择日期
 *
 *  @param calendarView 当前calendarView
 *  @param date         选中的日期
 */
-(void)calendarView:(MXCalendarView *)calendarView didSelectedDate:(NSDate*)date;
@end

/**
 *  日历view
 */
@interface MXCalendarView : UIView
/**
 *  选中的日期
 */
@property(nonatomic,strong,setter = setSelectedDate:)NSDate *selectedDate;
/**
 *  当前日历view的 第一天的日期（不是当月的第一天的日期）
 */
@property(nonatomic,strong,readonly)NSDate* startDate;
/**
 *  当前日历view的 最后一天的日期（不是当月的最后一天的日期）
 */
@property(nonatomic,strong,readonly)NSDate* endDate;
/**
 *  代理
 */
@property(nonatomic,assign)id<MXCalendarViewDelegate>delegate;
/**
 *  根据传的日期绘制当月的日历
 *
 *  @param date 任意日期
 */
-(void)setCalendarViewWithDate:(NSDate *)date;
/**
 *  设置日历里的事件表示
 *
 *  @param array 日历组合
 */
-(void)setAllEventTags:(NSMutableArray *)array;
@end
