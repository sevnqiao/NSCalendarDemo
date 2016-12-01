//
//  YQEventModel.h
//  NSCalendarDemo
//
//  Created by xiong on 16/11/30.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQCalendarModel.h"

@interface YQEventModel : NSObject

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) NSString *eventTitle;

@property (nonatomic, copy) NSString *eventDescription;

@property (nonatomic, assign) ItemViewEventsType eventType;


- (YQEventModel *)initWithDict:(NSDictionary *)dict; 

@end
