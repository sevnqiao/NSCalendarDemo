//
//  MXCalendarMainViewController.m
//  ListedCompany
//
//  Created by IOS_HMX on 15/7/10.
//  Copyright (c) 2015年 Mitake Inc. All rights reserved.
//

#import "MXCalendarMainViewController.h"
#import "MXCalendarView.h"
#import "MXMonthSelectView.h"
#import "UIColor+Additions.h"
#import "UIView+CustomBorder.h"
#import "MXCalendarCellOne.h"
#import "MXCalendarCellTwo.h"
#import "MXViewEventViewController.h"
#import "MXAddEventViewController.h"
#import "MXNewsViewController.h"
#import "NSDate+Additions.h"
#import "CycleScrollView.h"

#define kAllEventTitle @[@{@"title":@"待办事项",@"image":@"calendar_sign_red",@"cell":@"MXCalendarCellOne"},@{@"title":@"经济日历",@"image":@"calendar_sign_yellow",@"cell":@"MXCalendarCellTwo"},@{@"title":@"业务节点",@"image":@"calendar_sign_green",@"cell":@"MXCalendarCellFive"}]

@interface MXCalendarMainViewController ()<MXMonthSelectViewDelegate,MXCalendarViewDelegate,CycleScrollViewDelegate>


@property(nonatomic,strong)NSMutableArray *viewsArray;
@property(nonatomic,strong)MXCalendarView *currentCalendarView;
@property (nonatomic ,strong)CycleScrollView *mainScorllView;
@property(nonatomic,strong)UIView *tableHeaderView;

@property(nonatomic,strong)MXMonthSelectView *monthSelectView;
@property(nonatomic,strong)UIView *tabelFooterView;
@property(nonatomic,strong)NSDate *currentDate;///当前选中的日期

#pragma 数据源
@property(nonatomic,copy)NSMutableArray *schedulesArray;
@property(nonatomic,strong)NSMutableArray *commissionArray;//代办
@property(nonatomic,strong)NSMutableArray *economicArray;//经济
@property(nonatomic,strong)NSMutableArray *businessArray;//业务
@property(nonatomic,strong)NSMutableArray *allEventsTag;
@property(nonatomic,strong)NSMutableDictionary *cacheData;

@property(nonatomic,strong)NSMutableArray *currentEventTitle;
@property(nonatomic,strong)NSMutableArray *currentEventArray;

@end

@implementation MXCalendarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.monthSelectView;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak MXCalendarMainViewController *weakSelf = self;
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 3;
    };
//    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
//        NSLog(@"点击了第%d个",pageIndex);
//    };
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHUDMessage:nil lockScreen:NO];
    [self getData];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cancelAllOperation];
    [self hideHUD];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.currentEventArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray *)self.currentEventArray[section]).count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 29)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 15, 29)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:self.currentEventTitle[section][@"image"]];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 29)];
    label.text = self.currentEventTitle[section][@"title"];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = COLOR_ALPHA(@"#000000", 0.7);
    [view addSubview:label];
    [view setBorderWidth:1 withColor:[UIColor lineColor] direction:UIViewCustomBorderDirectionBottom|UIViewCustomBorderDirectionTop];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.currentEventArray[indexPath.section] count]-1 == indexPath.row) {
        return [self cellHeightWithClassName:self.currentEventTitle[indexPath.section][@"cell"] contentString:self.currentEventArray[indexPath.section][indexPath.row][@"title"]]+MXCellLayerHeight;
    }
    return [self cellHeightWithClassName:self.currentEventTitle[indexPath.section][@"cell"] contentString:self.currentEventArray[indexPath.section][indexPath.row][@"title"]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *classString = self.currentEventTitle[indexPath.section][@"cell"];
    Class class = NSClassFromString(classString);
    NSString *ID = [NSString stringWithFormat:@"cell%@",classString];
    MXCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell  = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //如果是最后一行 加 分割线
    if ([self.currentEventArray[indexPath.section] count]-1 == indexPath.row) {
        [cell addLineLayer];
    }else
    {
        [cell removeLineLayer];
    }
    [cell setCellData:self.currentEventArray[indexPath.section][indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.currentEventTitle[indexPath.section][@"title"] isEqualToString:@"待办事项"])
    {
        [self performSegueWithIdentifier:@"ViewEvent" sender:self.currentEventArray[indexPath.section][indexPath.row]];
    }else
    {
        [self performSegueWithIdentifier:@"ViewCalendarNews" sender:self.currentEventArray[indexPath.section][indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteEventAtIndexPath:indexPath];
    }
}
#pragma mark - get and set
-(CycleScrollView *)mainScorllView
{
    if (!_mainScorllView) {
        _mainScorllView =  [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 276)];
        _mainScorllView.delegate = self;
    }
    return _mainScorllView;
}
-(NSMutableArray *)viewsArray
{
    if (!_viewsArray) {
        _viewsArray = [[NSMutableArray alloc]initWithCapacity:3];
        for (int i=0; i<3; i++) {
            MXCalendarView *view = [[MXCalendarView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 276)];
            view.delegate = self;
            view.tag = i;
            [_viewsArray addObject:view];
        }
        //初始值
        self.currentCalendarView = _viewsArray[0];
        [self.currentCalendarView setCalendarViewWithDate:[NSDate localeDate]];
        [self resetDateFromIndex:0];
    }
    return _viewsArray;
}

-(MXMonthSelectView *)monthSelectView
{
    if (!_monthSelectView) {
        _monthSelectView = [[MXMonthSelectView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
        _monthSelectView.delegate = self;
    }
    return _monthSelectView;
}
-(NSMutableArray *)businessArray
{
    if (!_businessArray) {
        _businessArray = [[NSMutableArray alloc]init];
    }
    return _businessArray;
}
-(NSMutableArray *)economicArray
{
    if (!_economicArray) {
        _economicArray = [[NSMutableArray alloc]init];
    }
    return _economicArray;
}
-(NSMutableArray *)commissionArray
{
    if (!_commissionArray) {
        _commissionArray = [[NSMutableArray alloc]init];
    }
    return _commissionArray;
}
-(NSMutableDictionary *)cacheData
{
    if (!_cacheData) {
        _cacheData = [[NSMutableDictionary alloc]init];
    }
    return _cacheData;
}
-(NSMutableArray *)currentEventTitle
{
    if (!_currentEventTitle) {
        _currentEventTitle = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _currentEventTitle;
}
-(NSMutableArray *)allEventsTag
{
    if (!_allEventsTag) {
        _allEventsTag = [[NSMutableArray alloc]init];
    }
    return _allEventsTag;
}
-(NSMutableArray *)currentEventArray
{
    if (!_currentEventArray) {
        _currentEventArray = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return _currentEventArray;
}
-(NSDate *)currentDate
{
    return self.currentCalendarView.selectedDate;
}
-(UIView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 336)];
        MXCalendarTitleView *view = [[MXCalendarTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
        [_tableHeaderView addSubview:view];
        [_tableHeaderView addSubview:self.mainScorllView];
    }
    return _tableHeaderView;
}
-(UIView *)tabelFooterView
{
    if (!_tabelFooterView) {
        _tabelFooterView  =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
        _tabelFooterView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [MXTools creatLabelWithFrame:CGRectMake(15, 0, 14*8, 50)
                                                 font:[UIFont systemFontOfSize:14]
                                            textColor:COLOR_ALPHA(@"#333333", 0.9)
                                        textAlignment:NSTextAlignmentLeft];
        label.text = @"当天没有任何事项";
        label.adjustsFontSizeToFitWidth = YES;
        [_tabelFooterView addSubview:label];
        UILabel *label1 = [MXTools creatLabelWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 0, 150, 50)
                                                 font:[UIFont systemFontOfSize:12]
                                            textColor:COLOR_ALPHA(@"#333333", 0.5)
                                        textAlignment:NSTextAlignmentLeft];
        label1.text = @"(可点击右上角＋添加)";
        [_tabelFooterView addSubview:label1];
    }
    return _tabelFooterView;
}
#pragma mark - private
-(void)getData
{
    
    AFHTTPRequestOperation *op = [MXApi scheduleListQueryStartDate:[self.currentCalendarView.startDate convertToStringWithFormat:@"yyyyMMdd"]
                                                           endDate:[self.currentCalendarView.endDate convertToStringWithFormat:@"yyyyMMdd"]
                                                        completion:^(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMessage) {
                                                            if (responseObject) {
                                                                self.schedulesArray = responseObject[@"schedules"];
                                                                //缓存数据
//                                                                [self.cacheData setObject:self.schedulesArray forKey:self.monthSelectView.date];
                                                                //解析数据
                                                                [self parseData:nil];
                                                                //刷新日历的事项标记
                                                                [self.currentCalendarView setAllEventTags:self.allEventsTag];
                                                                [self.tableView reloadData];
                                                            }else
                                                            {
                                                                [MXTools toastWithContent:errorMessage showInView:self.view];
                                                            }
                                                            [self removeOperation:operation];
                                                            [self hideHUD];
                                                        }];
    
    [self addOperation:op];
}
-(void)parseData:(id)data
{
    
    [self.currentEventArray removeAllObjects];
    [self.currentEventTitle removeAllObjects];
    [self.businessArray removeAllObjects];
    [self.economicArray removeAllObjects];
    [self.commissionArray removeAllObjects];
    [self.allEventsTag removeAllObjects];
    //如果为nil
    if (self.schedulesArray==nil||self.schedulesArray.count == 0) {
        self.tableView.tableFooterView = self.tabelFooterView;
        return;
    }
    //解析数据 获取当前日期里的事项
    __block NSMutableArray *currentDataArray = [NSMutableArray array];
    [self.schedulesArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"show_date"]isEqualToString:[self.currentDate convertToStringWithFormat:@"yyyyMMdd"]]) {
            currentDataArray = [obj[@"source_types"] mutableCopy];
            *stop = YES;
        }
    }];
    __block MXCalendarMainViewController *weakSelf = self;
    [currentDataArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"source_type"] integerValue]==1) {
            weakSelf.businessArray = [obj[@"details"] mutableCopy];
        }else if  ([obj[@"source_type"] integerValue]==2) {
            weakSelf.economicArray = [obj[@"details"] mutableCopy];
        }else if ([obj[@"source_type"] integerValue]==3)
        {
            weakSelf.commissionArray = [obj[@"details"] mutableCopy];
        }
    }];
    
    //确定section
    
    if(self.commissionArray.count>0)
    {
        [self.currentEventTitle addObject:kAllEventTitle[0]];
        [self.currentEventArray addObject:self.commissionArray];
    }
    if (self.economicArray.count>0) {
        [self.currentEventTitle addObject:kAllEventTitle[1]];
        [self.currentEventArray addObject:self.economicArray];
    }
    if (self.businessArray.count>0) {
        [self.currentEventTitle addObject:kAllEventTitle[2]];
        [self.currentEventArray addObject:self.businessArray];
    }

    if (self.currentEventTitle.count==0) {
        self.tableView.tableFooterView = self.tabelFooterView;
    }else
    {
        self.tableView.tableFooterView = [[UILabel alloc]init];
    }
    
    //获取当月的所有日期的事项 用于标记
    
    [self.schedulesArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        NSString *dateString = obj[@"show_date"];
        MXDateColumnViewType type = MXDateColumnViewTypeNone;
        for (NSDictionary *dic in obj[@"source_types"]) {
            if ([dic[@"source_type"]integerValue]==1 ) {
                type = type|MXDateColumnViewTypeBusiness;
            }
            if ([dic[@"source_type"]integerValue]==2) {
                type = type|MXDateColumnViewTypeEconomic;
            }
            if ([dic[@"source_type"]integerValue]==3) {
                type = type|MXDateColumnViewTypeCommission;
            }
        }
        MXEventTags *tags= [[MXEventTags alloc]init];
        tags.dateString = dateString;
        tags.types = type;
        [weakSelf.allEventsTag addObject:tags];
    }];
   
    
}
-(void)deleteEventAtIndexPath:(NSIndexPath *)indexPath
{

    AFHTTPRequestOperation *op = [MXApi deleteScheduleBusSign:@"PS"
                                                   scheduleId:[self.currentEventArray[indexPath.section][indexPath.row][@"id"] integerValue]
                                                   completion:^(AFHTTPRequestOperation *operation, id responseObject, NSString *errorMessage) {
                                                       if (responseObject) {
                                                           [self getData];
                                                       }else
                                                       {
                                                           [MXTools toastWithContent:errorMessage showInView:self.view];
                                                       }
                                                       [self removeOperation:operation];
                                                   }];
    [self addOperation:op];
    
    
    
}
#pragma mark - MXCalendarViewDelegate
-(void)calendarView:(MXCalendarView *)calendarView didSelectedDate:(NSDate *)date
{
    self.currentDate = date;
    [self parseData:nil];
    [self.tableView reloadData];
}
#pragma mark - MXMonthSelectViewDelegate
-(void)monthSelectView:(MXMonthSelectView *)monthSelectView selectDate:(NSDate *)date
{
    //刷新当前CalendarView的日期
    [self.currentCalendarView setCalendarViewWithDate:date];
    //刷新上一月 和下一月的 日期
    [self resetDateFromIndex:[self.viewsArray indexOfObject:self.currentCalendarView]];
    [self refreshDateEvents];
    
}
-(void)didScrolledAtIndex:(NSInteger)index
{
    //得到当前的CalendarView
    self.currentCalendarView = [self.viewsArray objectAtIndex:index];
    //刷新标题的月份
    self.monthSelectView.date = self.currentCalendarView.selectedDate;
    //刷新上一月 和下一月的 日期
    [self resetDateFromIndex:index];
    //刷新日历事项数据
    [self refreshDateEvents];  
}
-(void)refreshDateEvents
{
//    if(self.cacheData[self.monthSelectView.date])
//    {
//        //如果有缓存数据
//        self.schedulesArray = self.cacheData[self.monthSelectView.date];
//        [self parseData:nil];
//        [self.currentCalendarView setAllEventTags:self.allEventsTag];
//        [self.tableView reloadData];
//        
//    }else
//    {
        [self getData];
//    }
}
-(void)resetDateFromIndex:(NSInteger)index
{
    MXCalendarView *view = [self.viewsArray objectAtIndex:index];
    //当前月份的的上一个月的第一天
    NSDate *previousDate = [view.startDate getPreviousDate];
    NSDate *nextDate = [view.endDate getNextDate];
    if (index == 0) {
        //前一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:2]) setCalendarViewWithDate:previousDate];
        //后一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:1]) setCalendarViewWithDate:nextDate];
    }
    if (index == 1) {
        //前一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:0]) setCalendarViewWithDate:previousDate];
        //后一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:2]) setCalendarViewWithDate:nextDate];
    }
    if (index == 2) {
        //前一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:1]) setCalendarViewWithDate:previousDate];
        //后一个月
        [( (MXCalendarView *)[self.viewsArray objectAtIndex:0]) setCalendarViewWithDate:nextDate];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if([vc isKindOfClass:[MXViewEventViewController class]])
    {
        [vc setValue:sender forKey:@"dicData"];
        
    }else if ([vc isKindOfClass:[MXNewsViewController class]])
    {
        NSDictionary *dic = (NSDictionary *)sender;
        if ([dic[@"source_type"]integerValue]==2) {
            vc.title=@"经济日历";
            [vc setValue:@0 forKey:@"newsType"];
        }else
        {
            vc.title=@"业务节点";
            [vc setValue:@1 forKey:@"newsType"];
        }
        [vc setValue:@0 forKey:@"newsType"];
        [vc setValue:sender forKey:@"dicData"];
        
    }else if ([vc isKindOfClass: [MXAddEventViewController class]])
    {
        [vc setValue:@0 forKey:@"type"];
    }
    
}

@end
