//
//  LandscapeViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/9.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LandscapeViewController_iphone.h"

#define TimeIntervalHeight 44
#define TimeIntervalLabelWidth 31
#define DataHeaderHeight 32
#define DataRowPerHeight 22
#define leftTableViewWidth 100
#define RightTableViewRowWidth 80
#define ItemIntervalHeight 2

@interface LandscapeViewController_iphone ()
{
    NSDictionary *dict_data;
}

@end

@implementation LandscapeViewController_iphone
@synthesize dict_shifts;
@synthesize dict_filter;


-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr_timeInterval = [NSArray arrayWithObjects:@"1am",@"2am",@"3am",@"4am",@"5am",@"6am",@"7am",@"8am",@"9am",@"10am",@"11am",@"12am",@"1pm",@"2pm",@"3pm",@"4pm",@"5pm",@"6pm",@"7pm",@"8pm",@"9pm",@"10pm",@"11pm",@"12pm", nil];

    
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"1"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"2"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"4"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"5"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"7"])
    {
        dict_data = [DatabaseManager shiftSortedByLocationUuid:dict_shifts];
    }
    
    UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(0, TimeIntervalHeight, leftTableViewWidth, 1)];
    line0.backgroundColor = SetColor(235, 235, 235, 1.0);
    [self.view addSubview:line0];
    
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TimeIntervalHeight+1, leftTableViewWidth, ScreenWidth - TimeIntervalHeight-1)];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTableView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(leftTableViewWidth, 0, 1, ScreenWidth)];
    line1.backgroundColor = SetColor(235, 235, 235, 1.0);
    [self.view addSubview:line1];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(leftTableViewWidth+1 , 0 ,ScreenHeight-leftTableViewWidth-1,ScreenWidth-TimeIntervalHeight - 1);
    _scrollView.contentSize = CGSizeMake(leftTableViewWidth+1+23*RightTableViewRowWidth, ScreenWidth-TimeIntervalHeight - 1);
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

    _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _leftTableView.frame.origin.y, _scrollView.contentSize.width, _leftTableView.frame.size.height)];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_rightTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"1"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"2"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"4"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"5"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"7"])
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
        if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"1"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"2"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"4"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"5"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"7"])
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
    
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"1"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"2"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"4"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"5"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"7"])
    {
        NSMutableArray *arr = [dict_data objectForKey:[[dict_data allKeys] objectAtIndex:section]];
        NSMutableDictionary *dict = [DatabaseManager shiftSortedByEmployeeUuid:arr];
        return [dict allKeys].count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"1"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"2"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"4"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"5"] || [[dict_filter objectForKey:@"filter"] isEqualToString:@"7"])
    {
        NSMutableArray *arr = [dict_data objectForKey:[[dict_data allKeys] objectAtIndex:indexPath.section]];
        NSMutableDictionary *dict = [DatabaseManager shiftSortedByEmployeeUuid:arr];
        NSMutableArray *arr2 = [dict objectForKey:[[dict allKeys] objectAtIndex:indexPath.row]];
        return DataRowPerHeight * arr2.count + ItemIntervalHeight * (arr2.count - 1) + DataRowPerHeight;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *arr = [dict_data objectForKey:[[dict_data allKeys] objectAtIndex:indexPath.section]];
    NSMutableDictionary *dict = [DatabaseManager shiftSortedByEmployeeUuid:arr];
    NSString *employeeuuid = [[dict allKeys] objectAtIndex:indexPath.row];
    NSMutableArray *arr_data = [dict objectForKey:employeeuuid];
    float rowHeight = DataRowPerHeight * arr_data.count + 2 * (arr_data.count - 1) + DataRowPerHeight;
    
    if (tableView == self.leftTableView) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        Employees *employee = [DatabaseManager getEmployeeByUuid:employeeuuid];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = employee.fullName;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, rowHeight-1, leftTableViewWidth, 1)];
        line.backgroundColor = SetColor(243, 243, 243, 1.0);
        [cell.contentView addSubview:line];
 
        return cell;
        
    }
    
    else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
        }
        
        for (int i = 1; i < 23; i++) {
            UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(i*80, 0, 1, DataRowPerHeight * (arr_data.count + 1))];
            line2.backgroundColor = SetColor(245, 245, 245, 1.0);
            [cell.contentView addSubview:line2];
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, rowHeight-1, _rightTableView.frame.size.width, 1)];
        line.backgroundColor = SetColor(243, 243, 243, 1.0);
        [cell.contentView addSubview:line];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor grayColor];
        
        arr_data = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:arr_data]];
        
        int i = 0;
        for (Shifts *shift in arr_data) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift.string_time]];
            NSString *time1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
            NSString *time2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
            float interval1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1];
            float interval2 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2];
            float lable_x = interval1 * RightTableViewRowWidth;
            float label_w =  (interval2-interval1) * RightTableViewRowWidth;
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(lable_x, DataRowPerHeight/2+i*DataRowPerHeight+i * ItemIntervalHeight, label_w, DataRowPerHeight)];
            lab.layer.masksToBounds = YES;
            lab.layer.cornerRadius = DataRowPerHeight/2;
            if (label_w == RightTableViewRowWidth/4) {
                lab.frame = CGRectMake(lable_x, DataRowPerHeight/2+i*DataRowPerHeight+i * ItemIntervalHeight,20,20);
                lab.layer.cornerRadius = 10;
            }
            if (shift.positionUuid != nil) {
                Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                lab.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
            }
            else
            {
                lab.backgroundColor = SetColor(156, 168, 160, 1.0);
            }
            [cell.contentView addSubview:lab];
            
            UILabel *lab_position = [[UILabel alloc] initWithFrame:CGRectMake(0, lab.frame.origin.y, lable_x-10, lab.frame.size.height)];
            lab_position.textAlignment = NSTextAlignmentRight;
            lab_position.font = [UIFont boldSystemFontOfSize:15.0];
            if (shift.positionUuid != nil) {
                Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                lab_position.text = position.name;
                lab_position.textColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
            }
            else
            {
                lab_position.text = @"Unassigned";
                lab_position.textColor = SetColor(156, 168, 160, 1.0);
            }
            [cell.contentView addSubview:lab_position];
            
            i++;
        }
        return cell;
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.leftTableView.contentOffset = scrollView.contentOffset;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     self.leftTableView.contentOffset = scrollView.contentOffset;
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
