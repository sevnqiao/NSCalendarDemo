//
//  ViewController.m
//  NSCalendarDemo
//
//  Created by xiong on 16/11/25.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "ViewController.h"
#import "YQCalendarView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, weak) IBOutlet YQCalendarView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (IBAction)lastMonth:(UIBarButtonItem *)sender {
    [_calendarView lastMonth];
}

- (IBAction)nextMonth:(UIBarButtonItem *)sender {
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
