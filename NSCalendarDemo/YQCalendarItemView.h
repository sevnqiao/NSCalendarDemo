//
//  YQCalendarItemView.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ItemViewSelectStyle) {
    ItemViewSelectStyleNone = 1,  // 未选中,
    ItemViewSelectStyleNormal,    // 普通日期选中
    ItemViewSelectStyleSpcial,    // 当前日期选中
    ItemViewSelectStyleWeekendOrOtherMonth,   // 周末或其它月份未选中
};

@class YQCalendarItemView;

@protocol YQCalendarItemViewDelegate <NSObject>
@optional

- (void)didSelectCalendarItemView:(YQCalendarItemView *)calendarItemView;

@end


@interface YQCalendarItemView : UIView

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) ItemViewSelectStyle selectStyle;
@property (nonatomic, assign) id<YQCalendarItemViewDelegate> delegate;

@end
