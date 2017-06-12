//
//  LandscapeDayViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/2.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LandscapeDayViewController_iphone.h"

#define TimeIntervalHeight 44
#define TimeIntervalLabelWidth 31
#define DataHeaderHeight 32
#define DataRowPerHeight 22
#define leftTableViewWidth 100
#define RightTableViewRowWidth 80
#define ItemIntervalHeight 2

@interface LandscapeDayViewController_iphone ()
{
    NSDictionary *dict_data;
    UILabel *dateLabel;
    NSNumber *dateNumner;
}
@end

@implementation LandscapeDayViewController_iphone
@synthesize dict_filter;
@synthesize dict_shifts;

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateNumner = [NSNumber numberWithInt:0];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, ScreenHeight, 45)];
    titleView.layer.borderWidth = 1.0;
    titleView.layer.borderColor = [SetColor(243, 243, 243, 1.0) CGColor];
    [self.view addSubview:titleView];
    
    float wid = titleView.frame.size.width;
    float hei = titleView.frame.size.height;
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(wid/2-50, -1, 100, hei)];
    dateLabel.font = [UIFont boldSystemFontOfSize:17.0];
    dateLabel.alpha = 0.87;
    dateLabel.text = @"Jun 18 2016";
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:dateLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(wid/2-100, -1, hei, hei);
    [leftBtn setImage:[UIImage imageNamed:@"landscape_<"] forState:UIControlStateNormal];
    leftBtn.tag = 0;
    [titleView addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(getDayShiftsDay:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(wid/2+55, -1, hei, hei);
    rightBtn.tag = 1;
    [rightBtn setImage:[UIImage imageNamed:@"landscape_>"] forState:UIControlStateNormal];
    [titleView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(getDayShiftsDay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *arr_timeInterval = [NSArray arrayWithObjects:@"1am",@"2am",@"3am",@"4am",@"5am",@"6am",@"7am",@"8am",@"9am",@"10am",@"11am",@"12am",@"1pm",@"2pm",@"3pm",@"4pm",@"5pm",@"6pm",@"7pm",@"8pm",@"9pm",@"10pm",@"11pm",@"12pm", nil];
    
    
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
    {
        dict_data = [DatabaseManager shiftSortedByLocationUuid:dict_shifts];
    }
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TimeIntervalHeight+1+hei, leftTableViewWidth, ScreenWidth - TimeIntervalHeight-1-hei)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTableView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(leftTableViewWidth, hei, 1, ScreenWidth)];
    line1.backgroundColor = SetColor(235, 235, 235, 1.0);
    [self.view addSubview:line1];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(leftTableViewWidth+1 , hei ,ScreenHeight-leftTableViewWidth-1,ScreenWidth-TimeIntervalHeight - 1 - hei);
    _scrollView.contentSize = CGSizeMake(leftTableViewWidth+1+23*RightTableViewRowWidth, ScreenWidth-TimeIntervalHeight - 1 - hei);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, TimeIntervalHeight, _scrollView.contentSize.width, 1)];
    line2.backgroundColor = SetColor(235, 235, 235, 1.0);
    [_scrollView addSubview:line2];
    
    
    for (int i = 0; i < arr_timeInterval.count; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i * RightTableViewRowWidth - TimeIntervalLabelWidth/2, 0, TimeIntervalLabelWidth, TimeIntervalHeight)];
        if (i == 0) {
            lab.frame = CGRectMake(0, 0, TimeIntervalLabelWidth, TimeIntervalHeight);
        }
        lab.text = [arr_timeInterval objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:12.0];
        [_scrollView addSubview:lab];
    }
    
    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TimeIntervalHeight, _scrollView.contentSize.width, _leftTableView.frame.size.height)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_rightTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
    {
        return [dict_data allKeys].count;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DataHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftTableViewWidth, DataHeaderHeight)];
    headerView.backgroundColor = SetColor(243, 243, 243, 1.0);
    
    if ([tableView isEqual:_leftTableView]) {
        if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
        {
            NSString *locationuuid = [[dict_data allKeys] objectAtIndex:section];
            Locations *location = [DatabaseManager getLocationByUuid:locationuuid];
            
            UILabel * headerLabel = [[UILabel alloc] initWithFrame:headerView.frame];
            headerLabel.textColor = [UIColor grayColor];
            headerLabel.highlightedTextColor = [UIColor whiteColor];
            headerLabel.font = [UIFont boldSystemFontOfSize:12];
            headerLabel.text = location.name;
            headerLabel.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:headerLabel];
        }
    }
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
    {
        NSMutableArray *arr = [dict_data objectForKey:[[dict_data allKeys] objectAtIndex:section]];
        NSMutableDictionary *dict = [DatabaseManager shiftSortedByPositionUuid:arr];
        return [dict allKeys].count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
    {
        return DataRowPerHeight * 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([dict_data allKeys].count > 0) {
        NSMutableArray *arr = [dict_data objectForKey:[[dict_data allKeys] objectAtIndex:indexPath.section]];
        NSMutableDictionary *dict = [DatabaseManager shiftSortedByPositionUuid:arr];
        NSString *positionuuid = [[dict allKeys] objectAtIndex:indexPath.row];
        NSMutableArray *arr_data = [dict objectForKey:positionuuid];
        
        if (tableView == self.leftTableView) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
            }
            
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
            if ([positionuuid isEqualToString:UnassignedPositionUuid]) {
                cell.textLabel.text = @"Unassigned";
            }
            else
            {
                Positions *position = [DatabaseManager getPositionByUuid:positionuuid];
                cell.textLabel.text = position.name;
            }
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, DataRowPerHeight*2-1, leftTableViewWidth, 1)];
            line.backgroundColor = SetColor(243, 243, 243, 1.0);
            [cell.contentView addSubview:line];
            
            return cell;
            
        }
        
        else{
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
            }
            
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            for (int i = 0; i < 22; i++) {
                UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(i*RightTableViewRowWidth+(RightTableViewRowWidth-1), 0, 1, DataRowPerHeight * 2)];
                line2.backgroundColor = SetColor(245, 245, 245, 1.0);
                [cell.contentView addSubview:line2];
            }
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, DataRowPerHeight*2-1, _rightTableView.frame.size.width, 1)];
            line.backgroundColor = SetColor(243, 243, 243, 1.0);
            [cell.contentView addSubview:line];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            cell.textLabel.textColor = [UIColor grayColor];
            NSMutableArray *arr_sorted = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:arr_data]];
            //arr_data = [DatabaseManager sortedShiftArrayByTime:arr_data];
            NSMutableArray *arr_temp = [DatabaseManager shiftSortedBySameStartTimeStamp:arr_sorted];
            for (NSDictionary *dict_temp in arr_temp) {
                
                NSDictionary *dict = [StringManager interceptionTime:[dict_temp objectForKey:@"time"]];
                NSString *time1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
                NSString *time2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
                float interval1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1];
                float interval2 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2];
                float lable_x = interval1 * RightTableViewRowWidth;
                float label_w =  (interval2-interval1) * RightTableViewRowWidth;
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(lable_x, DataRowPerHeight/2, label_w, DataRowPerHeight)];
                lab.layer.masksToBounds = YES;
                lab.layer.cornerRadius = DataRowPerHeight/2;
                if (label_w == RightTableViewRowWidth/4) {
                    lab.frame = CGRectMake(lable_x, DataRowPerHeight/2+1,20,20);
                    lab.layer.cornerRadius = 10;
                }
                
                if (![positionuuid isEqualToString:UnassignedPositionUuid]) {
                    Positions *position = [DatabaseManager getPositionByUuid:positionuuid];
                    lab.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                }
                else
                {
                    lab.backgroundColor = SetColor(156, 168, 160, 1.0);
                }
                [cell.contentView addSubview:lab];
                
                UILabel *lab_count = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 20, 20)];
                if (label_w == RightTableViewRowWidth/4) {
                    lab_count.frame = CGRectMake(0, 0, 20, 20);
                }
                lab_count.textColor = [UIColor whiteColor];
                lab_count.font = [UIFont systemFontOfSize:12.0];
                lab_count.textAlignment = NSTextAlignmentCenter;
                lab_count.text = [NSString stringWithFormat:@"%@",[dict_temp objectForKey:@"count"]];
                [lab addSubview:lab_count];
            }
            return cell;
        }
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.leftTableView.contentOffset = scrollView.contentOffset;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.leftTableView.contentOffset = scrollView.contentOffset;
}

-(void) getDayShiftsDay:(UIButton *) sender
{
    NSDictionary *dict = [UserEntity getCalendarDate];
    if ([[dict objectForKey:@"state"] isEqualToString:@"1"]) {
        
        NSDate *date1 = nil;
        NSDate *date2 = nil;
        if ([dateNumner intValue] == 0) {
            NSNumber *number = [dict objectForKey:@"number1"];
            date1 = [StringManager timeStampTransferDate:number];
        }
        else
        {
            date1 = [StringManager timeStampTransferDate:dateNumner];
        }
        if (sender.tag == 0) {
            date2 = [date1 dateByAddingTimeInterval:-1 * 24 * 60 * 60];
        }
        else if (sender.tag == 1)
        {
            date2 = [date1 dateByAddingTimeInterval:1 * 24 * 60 * 60];
        }
        NSNumber *numner2 = [StringManager getDayDateStamp:date2];
        dateNumner = numner2;
        if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"]) {
            dict_shifts = [DatabaseManager getShiftsByPositionUuid:[dict_filter objectForKey:@"positionUuid"] andDayStamp:numner2];
        }
        else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"6"])
        {
            dict_shifts = [DatabaseManager getShiftsByPositionsAndDayStamp:numner2];
        }
        dict_data = [DatabaseManager shiftSortedByLocationUuid:dict_shifts];
        [_leftTableView reloadData];
        [_rightTableView reloadData];
    }
}


-(void)deviceOrientChange:(NSNotification *)noti
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            break;
            
        default:
            
            break;
            
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
