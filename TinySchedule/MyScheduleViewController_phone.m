//
//  MyScheduleViewController_phone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "MyScheduleViewController_phone.h"

#define CalendarMiniViewHeight  60
#define CalendarExpandViewHeight1 280
#define CalendarExpandViewHeight2 320
#define CalendarExpandViewHeight3 360
#define TableViewHeaderViewHieght 30
#define TableViewCellHieght 60
#define TableViewTagStartValue 100

@interface MyScheduleViewController_phone ()
{
    NSMutableDictionary *dict_shifts;
    NSArray *arr_shiftHeader;
    CalendarMiniView *calendarMiniView;
    GFCalendarView *calendarExpandView;
    
    Shifts *takeShift;

    NSTimer *myTimer;
    
    BOOL isInitShiftData;
    
    NSString *selectUuid;
    
    float _oldY;
}
@end

@implementation MyScheduleViewController_phone


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
        dict_shifts = [NSMutableDictionary dictionary];
        arr_shiftHeader = [NSArray array];
        isInitShiftData = YES;
        selectUuid = nil;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (isInitShiftData == YES) {
        
        [self initShiftsData];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    isInitShiftData = YES;
    selectUuid = nil;
    [self settableFrame:0];
    
    [self setCalendarMiniView];
    calendarExpandView.frame = CGRectMake(10, -calendarExpandView.frame.size.height, ScreenWidth-20, calendarExpandView.frame.size.height);
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 0) {
        _filterBtn.frame = CGRectMake(self.view.frame.size.width-44, _filterBtn.frame.origin.y, _filterBtn.frame.size.width, _filterBtn.frame.size.height);
        _addBtn.hidden = YES;
    }

    [StringManager setCalendarWeekDictionary:[NSDate date]];
    //设置默认的选项 -- week 在创建min calendar viewshi 赋值
    [self initView];
    
    [self initShiftsData];
    
    [self setbeginRefreshing];

//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] && [appdelegate.currentEmployee.isManager intValue] == 1)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:InternationalL(@"warmPrompt") message:InternationalL(@"landscapepPrompt") delegate:nil cancelButtonTitle:InternationalL(@"ok") otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
}
/*
 //0-week:startDay_Stamp endDay_Stamp  1-day day_stamp

//0-all schedules  1-my schedules  2-employee  3-position  4-location  5-all employees  6-alllpositions  7-all locations  8-open shift available
 
 
 landViewController:

 */

-(void)initShiftsData
{
    NSString *name = @"";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.currentEmployee.isManager == 1) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[UserEntity getFilter]];
        if (dict.count == 0) {
            dict_shifts = [DatabaseManager managerGetAllShifts];
            name = @"All Schedules";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"0"])
        {
            dict_shifts = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager managerGetAllShifts]];
            name = @"All Schedules";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"1"])
        {
            dict_shifts = [DatabaseManager getAllMyShifts];
            name = @"My Schedules";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"2"])
        {
            dict_shifts = [DatabaseManager getShiftsByEmployeeUuid:[dict objectForKey:@"employeeUuid"]];
            if ([[dict objectForKey:@"employeeUuid"] isEqualToString:OpenShiftEmployeeUuid]) {
                name = @"Open Shift";
            }
            else
            {
                Employees *employee = [DatabaseManager getEmployeeByUuid:[dict objectForKey:@"employeeUuid"]];
                name = employee.fullName;
            }
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"3"])
        {
            dict_shifts = [DatabaseManager getShiftsByPositionUuid:[dict objectForKey:@"positionUuid"]];
            Positions *position = [DatabaseManager getPositionByUuid:[dict objectForKey:@"positionUuid"]];
            name = position.name;
            if (position == nil) {
                name = @"Unassigned";
            }
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"4"])
        {
            dict_shifts = [DatabaseManager getShiftsByLocationUuid:[dict objectForKey:@"locationUuid"]];
            Locations *location = [DatabaseManager getLocationByUuid:[dict objectForKey:@"locationUuid"]];
            name = location.name;
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"5"])
        {
            dict_shifts = [DatabaseManager getShiftsByEmployeess];
            name = @"All Employees";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"6"])
        {
            dict_shifts = [DatabaseManager getShiftsByPositions];
            name = @"All Positions";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"7"])
        {
            dict_shifts = [DatabaseManager getShiftsByLocations];
            name = @"All Locations";
        }
    }
    else
    {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[UserEntity getFilter]];
        if ([[dict objectForKey:@"filter"] isEqualToString:@"1"] || [dict allKeys].count == 0)
        {
            dict_shifts = [DatabaseManager getAllMyShifts];
            name = @"My Schedules";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"8"])
        {             //employee的full schedule
            dict_shifts = [DatabaseManager getFullShiftsByEmployeeLocations];
            name = @"Full Schedules";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"9"])
        {
            //employee的open shift
            dict_shifts = [DatabaseManager getEmployeeNeedActionOpenShift_dict];
            name = @"Open Shifts";
        }
        else if ([[dict objectForKey:@"filter"] isEqualToString:@"10"])
        {
            //employee的open shift
            dict_shifts = [DatabaseManager getShiftsByEmployeePositions];
            name = @"Position";
        }
        else
        {
            name = @"My Schedules";
        }
    }
    
    _titlelabel.text = name;
    
    arr_shiftHeader = nil;
    arr_shiftHeader = [NSArray arrayWithArray:[dict_shifts allKeys]];
    if (arr_shiftHeader.count != 0) {
        arr_shiftHeader = [DatabaseManager sortedShiftByStartDate:[NSMutableArray arrayWithArray:[dict_shifts allKeys]]];
    }

    if (arr_shiftHeader.count == 0) {
        [_tableView reloadData];
        _bgImageView.hidden = NO;
    }
    else
    {
        _bgImageView.hidden = YES;
        
        [_tableView reloadData];

    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toFilterController:(UIButton *)sender {
    FilterViewController_iphone *filter = [FilterViewController_iphone new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:filter];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)addShift:(UIButton *)sender {
    CreateScheduleViewController_iphone *schedule = [CreateScheduleViewController_iphone new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:schedule];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)initView
{
    
    if (calendarMiniView == nil) {
        [self setCalendarMiniView];
    }
    
    CGPoint origin = CGPointMake(10, 64.0);
    calendarExpandView = [[GFCalendarView alloc] initWithFrameOrigin:origin width:ScreenWidth-20];
    calendarExpandView.frame = CGRectMake(10, -calendarExpandView.frame.size.height, ScreenWidth-20, calendarExpandView.frame.size.height);
    // 点击某一天的回调
    calendarExpandView.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        [self setCalendarMiniView];
        isInitShiftData = NO;
        dict_shifts = nil;
        dict_shifts = [DatabaseManager getShiftsByCalendarAndFilter];
        arr_shiftHeader = nil;
        arr_shiftHeader = [NSMutableArray arrayWithArray:[dict_shifts allKeys]];
        if (arr_shiftHeader.count != 0) {
            arr_shiftHeader = [DatabaseManager sortedShiftByStartDate:[NSMutableArray arrayWithArray:[dict_shifts allKeys]]];
        }
        calendarExpandView.frame = CGRectMake(10, -calendarExpandView.frame.size.height, ScreenWidth-20, calendarExpandView.frame.size.height);
        
        [UIView animateWithDuration:AnimatedDuration animations:^{
            if (arr_shiftHeader.count == 0) {
                _bgImageView.hidden = NO;
            }
            else
            {
                _bgImageView.hidden = YES;
            }
            [self settableFrame:0];
        } completion:^(BOOL finished){
            
        }];
    };
    
    [self.view addSubview:calendarExpandView];
    
    if (_bgImageView == nil) {
        if (ScreenWidth > 400) {
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , ScreenHeight)];
            _bgImageView.image = [UIImage imageNamed:@"noShift_7p"];
        }
        else if (ScreenWidth == 375)
        {
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , _tableView.frame.size.height)];
            _bgImageView.image = [UIImage imageNamed:@"noShift_6"];
        }
        else
        {
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , _tableView.frame.size.height)];
            _bgImageView.image = [UIImage imageNamed:@"noShift_5"];
        }
        _bgImageView.userInteractionEnabled = YES;
        [_tableView addSubview:_bgImageView];
    }
}
-(void) settableFrame:(int) show
{
    if (show == 0) {
        _tableView.frame = CGRectMake(0, CalendarMiniViewHeight+NavibarHeight, ScreenWidth, _tableView.frame.size.height);
    }
    else
    {
        if (ScreenWidth == 320) {
            _tableView.frame = CGRectMake(0, CalendarExpandViewHeight1+NavibarHeight, ScreenWidth, _tableView.frame.size.height);
        }
        else if (ScreenWidth == 375)
        {
            _tableView.frame = CGRectMake(0, CalendarExpandViewHeight2+NavibarHeight, ScreenWidth, _tableView.frame.size.height);
        }
        else
        {
            _tableView.frame = CGRectMake(0, CalendarExpandViewHeight3+NavibarHeight, ScreenWidth, _tableView.frame.size.height);
        }
    }
    [_tableView reloadData];
}

-(void) setCalendarMiniView
{
    //更新 calendar menu
    for (UIView *view in calendarMiniView.subviews) {
        [view removeFromSuperview];
    }
    [calendarMiniView removeFromSuperview];
    calendarMiniView = nil;
    calendarMiniView.hidden = NO;
    calendarMiniView = [[CalendarMiniView alloc]initWithFrame:CGRectMake(0, NavibarHeight, ScreenWidth, CalendarMiniViewHeight)];
    calendarMiniView.delegate = self;
    [self.view addSubview:calendarMiniView];
}

-(void)touchView
{
    [UIView animateWithDuration:0 animations:^{
        
        calendarMiniView.hidden = YES;
        calendarExpandView.frame = CGRectMake(10, NavibarHeight, ScreenWidth-20, calendarExpandView.frame.size.height);
        [self settableFrame:1];
    } completion:^(BOOL finished){
        _bgImageView.hidden = YES;
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr_shiftHeader.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arr_shiftHeader.count > section) {
        NSString *key = [arr_shiftHeader objectAtIndex:section];
        NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[dict_shifts objectForKey:key]]];
        return arr_temp.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TableViewHeaderViewHieght;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewCellHieght;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == arr_shiftHeader.count-1) {
        return TableViewHeaderViewHieght;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TableViewHeaderViewHieght)];
    headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    if (section < arr_shiftHeader.count) {
        
        NSString *key = [arr_shiftHeader objectAtIndex:section];
        UILabel *label_title = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 150, TableViewHeaderViewHieght)];
        label_title.font = [UIFont boldSystemFontOfSize:12.0];
        label_title.text = [NSString stringWithFormat:@"%@",key];
        label_title.alpha = 0.3;
        [headerView addSubview:label_title];
        
        NSMutableArray *arr2 = [dict_shifts objectForKey:key];
        float totalHours = 0.0;
        for (Shifts *shift in arr2) {
            totalHours += [shift.totalHours floatValue];
        }
        
        UILabel *lab_hours = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 116, 0, 100, TableViewHeaderViewHieght)];
        NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2fh",totalHours]];
        lab_hours.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
        lab_hours.alpha = 0.3;
        lab_hours.textAlignment = NSTextAlignmentRight;
        lab_hours.font = [UIFont systemFontOfSize:12.0];
        [headerView addSubview:lab_hours];
    }

    return headerView;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == arr_shiftHeader.count-1) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TableViewHeaderViewHieght)];
        
        NSString *str_totalhours = @"Total: ";
        float hour = 0.0;
        for (NSString *key in arr_shiftHeader) {
            NSMutableArray *arr2 = [dict_shifts objectForKey:key];
            for (Shifts *shift in arr2) {
                hour += [shift.totalHours floatValue];
            }
        }
        NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2fh",hour]];
        str_totalhours = [NSString stringWithFormat:@"%@%@ %@",str_totalhours,[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
        UILabel *lab_total = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-120/2, 0, 120, 30)];
        [lab_total setAttributedText:SetAttributeText(str_totalhours, SetColor(0, 0, 0, 0.2), RegularFontName, 12.0)];
         lab_total.textAlignment = NSTextAlignmentCenter;
         lab_total.font = [UIFont systemFontOfSize:12.0];
         [footerView addSubview:lab_total];
         
         float lineWid = (ScreenWidth-32-120)/2.0;
         
         UILabel *line1 = [[UILabel alloc] initWithFrame: CGRectMake(16, 15, lineWid, 0.3)];
         line1.backgroundColor = SetColor(216, 216, 210, 1.0);
         [footerView addSubview:line1];
         
         UILabel *line2 = [[UILabel alloc] initWithFrame: CGRectMake(lab_total.frame.origin.x+lab_total.frame.size.width, 15, lineWid, 0.3)];
         line2.backgroundColor = SetColor(216, 216, 210, 1.0);
         [footerView addSubview:line2];
        
        return footerView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"scheduleCell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.imageView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSLog(@"%lu",(long)indexPath.section);
    if (indexPath.section < arr_shiftHeader.count) {
        NSString *key = [arr_shiftHeader objectAtIndex:indexPath.section];
        NSMutableArray *arr_2 = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[dict_shifts objectForKey:key]]];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, TableViewCellHieght/2-28/2, 28, 28)];
        [cell.contentView addSubview:imageview];
        
        if (arr_2.count >  indexPath.row) {
            Shifts *shift = [arr_2 objectAtIndex:indexPath.row];
            /****************************处理图标状态***************************************/
            //explore
            NSNumber *nowStamp = [StringManager dateTransferTimeStamp:[NSDate date]];
            if ([nowStamp longLongValue] >= [shift.endTime longLongValue]) {
                imageview.image = [UIImage imageNamed:@"circle_gary"];
            }
            else
            {
                //save
                if (shift.takeState == 0) {
                    
                    imageview.image = [UIImage imageNamed:@"circle_red_1"];
                }
                //save & publish
                else if (shift.takeState == 1)
                {
                    //open shift
                    if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                        
                        //unfinished
                        if (shift.needEmployeesNumber - shift.haveTakedEmployeesNumber > 0) {
                            
                            imageview.image = [UIImage imageNamed:@"circle_green"];
                            
                            UILabel *lab_num = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
                            lab_num.textAlignment = NSTextAlignmentCenter;
                            lab_num.text = [NSString stringWithFormat:@"%d",shift.needEmployeesNumber - shift.haveTakedEmployeesNumber];
                            lab_num.textColor = AppMainColor;
                            lab_num.font = [UIFont boldSystemFontOfSize:13.0];
                            [imageview addSubview:lab_num];
                        }
                        //finished
                        else
                        {
                            imageview.image = [UIImage imageNamed:@"circle_green_done"];
                        }
                    }
                    //employee
                    else
                    {
                        
                        if (shift.isTake == 1) {
                            imageview.image = [UIImage imageNamed:@"circle_green_done"];
                        }
                        else
                        {
                            imageview.image = [UIImage imageNamed:@"circle_green"];
                        }
                    }
                }
            }
            
            /**************************** textLabel ***************************************/
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 200, 20)];
            lable.textColor = SetColor(3, 3, 3, 1.0);
            lable.text = [NSString stringWithFormat:@"%@",shift.string_time];
            [cell.contentView addSubview:lable];
            Drop *drop = [DatabaseManager getPendingDropByShiftUuid:shift.uuid];
            Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:shift.uuid];
            if (drop != nil || swap != nil) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(220+10, 5, 30, 30);
                [btn setImage:[UIImage imageNamed:@"s_alerm"] forState:UIControlStateNormal];
                [cell.contentView addSubview:btn];
            }
            /**************************** detailTextLabel ***************************************/
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 34, ScreenWidth-64, 16)];
            detailLabel.textColor = SetColor(0, 0, 0, 0.3);
            detailLabel.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:detailLabel];
            Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
            if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                detailLabel.text = [NSString stringWithFormat:@"Open Shift at %@",location.name];
            }
            else
            {
                Employees *e = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
                detailLabel.text = [NSString stringWithFormat:@"%@ at %@",e.fullName,location.name];
                if(e == nil)
                {
                    detailLabel.text = [NSString stringWithFormat:@"%@ at %@",shift.employeeName,location.name];
                }
            }
            
            /**************************** show position ***************************************/
            UILabel *lab_hour = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 116, 13, 100, 14)];
            lab_hour.textAlignment = NSTextAlignmentRight;
            lab_hour.alpha = 0.3;
            NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[shift.totalHours floatValue]]];
            lab_hour.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
            lab_hour.font = [UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:lab_hour];
            
            UILabel *lab_position = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 46, 32, 30, 18)];
            lab_position.textColor = [UIColor whiteColor];
            lab_position.textAlignment = NSTextAlignmentCenter;
            lab_position.font = [UIFont systemFontOfSize:10.0];
            lab_position.layer.masksToBounds = YES;
            lab_position.layer.cornerRadius = 9;
            
            Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
            if (position != nil) {
                
                lab_position.text = [StringManager getManyFirstLetterFromString:position.name];
                lab_position.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                detailLabel.text = [NSString stringWithFormat:@"%@ as %@",detailLabel.text,position.name];
            }
            else
            {
                lab_position.text = @"Un";
                lab_position.backgroundColor = SetColor(156, 168, 160, 1.0);
            }
            [lab_position setAdjustsFontSizeToFitWidth:YES];
            [cell.contentView addSubview:lab_position];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(50, TableViewCellHieght-1, ScreenWidth, 1)];
            line.backgroundColor = SetColor(250, 250, 250, 1.0);
            [cell.contentView addSubview:line];
        }
    }
    return cell;
}

-(void) showOrHidenSchedule:(UITapGestureRecognizer *) tap
{
    UIView *view_header = tap.view;
    NSLog(@"%lu",(long)view_header.tag);
    NSString *uuid = [arr_shiftHeader objectAtIndex:view_header.tag];
    if (selectUuid != nil && ![uuid isEqualToString:selectUuid]) {
        selectUuid = uuid;
        [_tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [arr_shiftHeader objectAtIndex:indexPath.section];
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[dict_shifts objectForKey:key]]];
    Shifts *shift = [arr_temp objectAtIndex:indexPath.row];
    
    ShiftDetailViewController_iphone *detail = [ShiftDetailViewController_iphone new];
    detail.uuid = shift.uuid;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y > 0)
    {
        
    }
    else if(translation.y < 0){
        
    }
    [self setCalendarMiniView];
    calendarExpandView.frame = CGRectMake(10, -calendarExpandView.frame.size.height, ScreenWidth-20, calendarExpandView.frame.size.height);
    
    [UIView animateWithDuration:AnimatedDuration animations:^{

        if (arr_shiftHeader.count == 0) {
            _bgImageView.hidden = NO;
        }
        else
        {
            _bgImageView.hidden = YES;
        }
        [self settableFrame:0];
        
    } completion:^(BOOL finished){
        
    }];
}

-(void)deviceOrientChange:(NSNotification *)noti
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
            break;
            
        case UIDeviceOrientationLandscapeLeft:
        {
            if (arr_shiftHeader.count != 0) {
                
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[UserEntity getCalendarDate]];
                if ([[dict objectForKey:@"state"] isEqualToString:@"1"]) {
                    
                    NSDictionary *dict = [UserEntity getFilter];
                    if ([[dict objectForKey:@"filter"] isEqualToString:@"2"] && [[dict objectForKey:@"employeeUuid"] isEqualToString:OpenShiftEmployeeUuid]) {
                    }
                    else
                    {
                        if ([[dict objectForKey:@"filter"] isEqualToString:@"3"] || [[dict objectForKey:@"filter"] isEqualToString:@"6"]) {
                            LandscapeDayViewController_iphone *dayland = [LandscapeDayViewController_iphone new];
                            dayland.dict_shifts = dict_shifts;
                            dayland.dict_filter = [UserEntity getFilter];
                            [self presentViewController:dayland animated:YES completion:nil];
                        }
                        else
                        {
//                            LandscapeViewController_iphone *land = [LandscapeViewController_iphone new];
//                            land.dict_shifts = dict_shifts;
//                            land.dict_filter = [UserEntity getFilter];
//                            [appdelegate.rootController_iphone presentViewController:land animated:YES completion:nil];
                        }
                    }
                }
                else if ([[dict objectForKey:@"state"] isEqualToString:@"0"]) {
                    //LandscapeWeekViewController_iphone *land = [LandscapeWeekViewController_iphone new];
//                    land.dict_shifts = dict_shifts;
//                    land.dict_filter = [UserEntity getFilter];
                    //[appdelegate.rootController_iphone presentViewController:land animated:YES completion:nil];
                }
            }
        }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            break;
            
        default:
            
            break;

    }
    
}

- (void)setbeginRefreshing
{
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:_refreshControl];
    }
}
-(void) refreshView:(UIRefreshControl *)refresh
{
    if (_refreshControl.refreshing) {
        [self performSelector:@selector(refreshTableView:) withObject:refresh afterDelay:0];
    }
    [DynamoDBManager getNewEmployee];
}
-(void)refreshTableView:(UIRefreshControl *)refresh{

    __block BOOL isTake = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    //同步数据表
    queryExpression.scanIndexForward = 0;
    queryExpression.indexName = @"CurrentWorkPlaceAllData-Index";
    queryExpression.keyConditionExpression = [NSString stringWithFormat:@"parentUuid = :PUUID"];
    queryExpression.expressionAttributeValues = @{@":PUUID" : appDelegate.currentWorkplace.uuid};
    [[dynamoDBObjectMapper query:[DDBDataModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [refresh endRefreshing];
            });
        }
        else
        {
            AWSDynamoDBPaginatedOutput *output = task.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *arr = output.items;
                
                isTake = [DynamoDBManager dynamodbDataSaveToLocal:arr];
                
                [self initShiftsData];
                [refresh endRefreshing];
                if (isTake == NO) {
                    KnowledgeShiftViewController_iphone *know = [KnowledgeShiftViewController_iphone new];
                    [self presentViewController:know animated:YES completion:nil];
                }
            });
        }
        return nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
