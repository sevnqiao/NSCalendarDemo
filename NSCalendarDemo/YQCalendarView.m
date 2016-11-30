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
    
    YQCalendarItemView *_lastSelectItemView;
}

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) NSMutableArray *itemModelArray;

@end


@implementation YQCalendarView

- (NSMutableArray *)itemViewArray {
    if (!_itemViewArray) {
        _itemViewArray = [NSMutableArray array];
    }
    return _itemViewArray;
}

- (NSMutableArray *)itemModelArray {
    if (!_itemModelArray) {
        _itemModelArray = [NSMutableArray array];
    }
    return _itemModelArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    @autoreleasepool {
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
}

- (void)initDaysTitleLabel {
    @autoreleasepool {
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
            
            [self.itemViewArray addObject:itemView];
        }
    }
}

- (void)getDayTitleArrWithMonth:(NSInteger)month year:(NSInteger)year {
    
    [self.itemModelArray removeAllObjects];

    // 1. 获取当前显示视图中上个月需要显示的部分
    NSMutableArray *lastMonthDayTitleArray = [NSMutableArray array];
    [lastMonthDayTitleArray addObjectsFromArray:[NSDate getLastMonthDaysTitleWithCurrentMonth:month currentYear:year]];
    [_itemModelArray addObjectsFromArray:lastMonthDayTitleArray];
    
    // 2. 获取当前显示视图中本月需要显示的部分
    NSMutableArray *currentMonthDayTitleArray = [NSMutableArray array];
    [currentMonthDayTitleArray addObjectsFromArray:[NSDate getCurrentMonthDaysTitleWithMonth:month year:year]];
    [_itemModelArray addObjectsFromArray:currentMonthDayTitleArray];
    
    // 3. 获取当前显示视图中下个月需要显示的部分
    NSMutableArray *nextMonthDayTitleArray = [NSMutableArray array];
    [nextMonthDayTitleArray addObjectsFromArray:[NSDate getNextMonthDaysTitleWithCurrentMonth:month currentYear:year]];
    [_itemModelArray addObjectsFromArray:nextMonthDayTitleArray];
    
    lastMonthNum = lastMonthDayTitleArray.count;
    currentMonthNum = currentMonthDayTitleArray.count;
    nextMonthNum = nextMonthDayTitleArray.count;
    
    // 4. 整体的 frame 适应下高度
    CGRect rect = self.frame;
    rect.size.height = kItem_Width * (lastMonthNum + currentMonthNum + nextMonthNum <= 35 ? 6 : 7);
    self.frame = rect;
    
    // 5. 显示的 item 的属性的控制
    [self reloadItemViews];
}

- (void)reloadItemViews{
    
    @autoreleasepool {
        for (int i = 0; i< kItemTotleNum; i++) {
            
            YQCalendarItemView *itemView = _itemViewArray[i];
            
            if (i < _itemModelArray.count) {
                YQCalendarModel *itemModel = _itemModelArray[i];
                itemView.calendarModel = itemModel;
            }
        }
    }
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
- (void)didSelectCalendarItemView:(YQCalendarItemView *)calendarItemView {

    if (_lastSelectItemView == calendarItemView) {
        return;
    }
    
    if (_lastSelectItemView) {
        
        YQCalendarModel *itemModel = _lastSelectItemView.calendarModel;
        
        NSInteger weekDay = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] component:NSWeekdayCalendarUnit fromDate:itemModel.date];
        
        if (itemModel.day == [NSDate currentDay] && itemModel.month == [NSDate currentMonth]) {
            
            itemModel.itemStyle = ItemViewSelectStyleSpcial;
            
        }else if (weekDay == 1 || weekDay == 7 || itemModel.month != [NSDate currentMonth]) {
            
            itemModel.itemStyle = ItemViewSelectStyleWeekendOrOtherMonth;
            
        }else {
            
            itemModel.itemStyle = ItemViewSelectStyleNone;
        }
        
        [_lastSelectItemView setCalendarModel:itemModel];
    }
    
    _lastSelectItemView = calendarItemView;
}

@end
