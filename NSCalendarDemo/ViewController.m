//
//  ViewController.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "YQCalendarView.h"
#import "YQEventModel.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()<UITableViewDataSource, YQCalendarViewDelegate>
@property (nonatomic, weak) IBOutlet YQCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) YQEventModel *selectModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArr = [NSMutableArray array];
    
    NSArray *arr = @[
                     @{@"date":[NSDate date],
                       @"eventTitle":@"买火车票",
                       @"eventDescription":@"元旦回家的火车票",
                       @"eventType":@(ItemViewEventsTypeImportent)
                       },
                     @{@"date":[NSDate dateWithTimeIntervalSinceNow:4*24*3600],
                       @"eventTitle":@"上传 gitHub",
                       @"eventDescription":@" 将写好的 demo 上传到 github",
                       @"eventType":@(ItemViewEventsTypeEmergency)
                       },
                     @{@"date":[NSDate dateWithTimeIntervalSinceNow:14*24*3600],
                       @"eventTitle":@"吃饭",
                       @"eventDescription":@"约一个朋友出来吃饭",
                       @"eventType":@(ItemViewEventsTypeImportent)
                       },
                     @{@"date":[NSDate dateWithTimeIntervalSinceNow:24*24*3600],
                       @"eventTitle":@"看电影",
                       @"eventDescription":@"今天晚上7点上映的盗墓笔记",
                       @"eventType":@(ItemViewEventsTypeNormal)
                       },
                     @{@"date":[NSDate dateWithTimeIntervalSinceNow:28*24*3600],
                       @"eventTitle":@"跑步",
                       @"eventDescription":@"今天下午三点参加上海马拉松比赛",
                       @"eventType":@(ItemViewEventsTypeNormal)
                       },
                     ];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSDictionary *dict = (NSDictionary *)obj;
        YQEventModel *model = [YQEventModel new];
        model = [model initWithDict:dict];
        [self.dataArr addObject:model];
        
    }];
    
    [_calendarView setEventsArray:self.dataArr];
    
    _calendarView.delegate = self;
}


- (IBAction)lastMonth:(UIBarButtonItem *)sender {
    [_calendarView lastMonth];
    [_calendarView setEventsArray:self.dataArr];
}

- (IBAction)nextMonth:(UIBarButtonItem *)sender {
     [_calendarView nextMonth];
    [_calendarView setEventsArray:self.dataArr];
}

- (void)calendarView:(YQCalendarView *)calendarView didSelectItemAtDate:(NSDate *)date {
    
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        YQEventModel *eventModel = obj;
        
        if ([eventModel.date isEqualToDate:date]) {
            
            self.selectModel = eventModel;
            
            *stop = YES;
            
        }else{
            self.selectModel = nil;
        }
        
    }];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.selectModel?1:0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    
    if (!cell) {

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identify"];
    }
    
    
    cell.textLabel.text = self.selectModel.eventTitle;
    cell.detailTextLabel.text = self.selectModel.eventDescription;
    
    return cell;
}


@end
