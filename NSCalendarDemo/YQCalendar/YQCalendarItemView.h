//
//  YQCalendarItemView.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/28.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQCalendarModel.h"

@class YQCalendarItemView;

@protocol YQCalendarItemViewDelegate <NSObject>
@optional

- (void)didSelectCalendarItemView:(YQCalendarItemView *)calendarItemView;

@end


@interface YQCalendarItemView : UIView

@property (nonatomic, strong) YQCalendarModel *calendarModel;
@property (nonatomic, assign) id<YQCalendarItemViewDelegate> delegate;

@end
