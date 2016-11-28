//
//  ViewController.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "YQCalendarView.h"


@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, strong) YQCalendarView *calendarView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _calendarView = [[YQCalendarView alloc]initWithFrame:CGRectMake(0, 64, 375, 210)];
    [self.view addSubview:_calendarView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 20, 70, 44)];
    [btn setTitle:@"last" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 20, 70, 44)];
    [btn2 setTitle:@"next" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 274, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 274) style:UITableViewStylePlain];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}


- (void)last{
    
    [_calendarView lastMonth];
}
- (void)next{
    [_calendarView nextMonth];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    
    if (!cell) {

        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identify"];
    }
    // cell data
    // .....
    
    cell.textLabel.text = [NSString stringWithFormat:@"今天 %ld 点干什么", (long)indexPath.row];
    
    return cell;
}


@end
