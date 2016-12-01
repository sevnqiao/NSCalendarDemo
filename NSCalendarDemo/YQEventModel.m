//
//  YQEventModel.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "YQEventModel.h"

@implementation YQEventModel

- (void)setDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    _date =  [calendar dateWithEra:1 year:components.year month:components.month day:components.day hour:0 minute:0 second:0 nanosecond:0];
    
}

- (YQEventModel *)initWithDict:(NSDictionary *)dict {
    
    self.date = [dict valueForKey:@"date"];
    self.eventTitle = [dict valueForKey:@"eventTitle"];
    self.eventDescription = [dict valueForKey:@"eventDescription"];
    self.eventType = [[dict valueForKey:@"eventType"] integerValue];
    
    
    return self;
}

@end
