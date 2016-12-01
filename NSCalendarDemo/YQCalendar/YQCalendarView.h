//
//  YQCalendarView.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQCalendarView;

@protocol YQCalendarViewDelegate <NSObject>
@optional

- (void)calendarView:(YQCalendarView *)calendarView didSelectItemAtDate:(NSDate *)date;

@end

@interface YQCalendarView : UIView

@property (nonatomic, assign) id<YQCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *eventsArray;

- (void)lastMonth ;
- (void)nextMonth ;
    

@end
