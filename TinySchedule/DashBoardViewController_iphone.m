//
//  DashBoardViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/18.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "DashBoardViewController_iphone.h"

#define footerHeight 10
#define zeroRowHeight 50
#define timeIntervalRowHeight 40
#define scheduleHeight 60
#define seeAllHeight 40
#define myScheduleRowHeight 60
#define MapViewHeight 120
#define sectionTwoRowHeight 60
#define availableRowHeight 44

#define leftTableViewWidth 100
#define RightTableViewRowWidth 80
#define TimeIntervalLabelWidth 31
#define TimeIntervalLabelHeight 30

@interface DashBoardViewController_iphone ()<UIViewControllerTransitioningDelegate>
{
    AppDelegate *appDelegate;
    float tableViewHeight;
    BOOL isManager;
    
    NSMutableArray *arr_allLocations;
    long locationIndex;
    NSMutableDictionary *dict_todayEmployeeShifts;
    NSArray *arr_todayOpenShifts;
    
    NSMutableArray *arr_myscheduleShift;
    
    NSArray *arr_todayAvailability;
    
    NSString *weekday;
    
    NSArray *arr_timeInterval;
    
    UILabel *lab_selectlocation;
    NSString *selectLocationName;
    
    UIImageView *addshitimageView;
}
@end

@implementation DashBoardViewController_iphone

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arr_myscheduleShift = nil;
        arr_myscheduleShift = [NSMutableArray array];
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        arr_todayAvailability = [NSArray array];
        
        weekday = @"";
        
        locationIndex = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];

    if (appDelegate.currentEmployee != nil && appDelegate.currentWorkplace != nil) {
        isManager = YES;
        if (appDelegate.currentEmployee.isManager == 0) {
            isManager = NO;
        }
        
        if (isManager == NO) {
            _addBtn.hidden = YES;
        }
        
        [self initData];
    }
    else
    {
        FirstEnterAppViewController_iphone *first = [FirstEnterAppViewController_iphone new];
        [self.navigationController pushViewController:first animated:NO];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (IBAction)showSidebar:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSidebarMenu object:self userInfo:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (IBAction)createShift:(UIButton *)sender {
    CreateScheduleViewController_iphone *schedule = [CreateScheduleViewController_iphone new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:schedule];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)initData
{
    if (appDelegate.currentEmployee != nil && appDelegate.currentWorkplace != nil) {
        arr_myscheduleShift = nil;
        arr_myscheduleShift = [NSMutableArray array];
        NSArray *arr_mySchedule = [NSArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[NSMutableArray arrayWithArray:[DatabaseManager getDashboardMySchedule]]]];
        
        NSNumber *nowTimeStamp = [StringManager getDayTimeStamp:[NSDate date]];
        
        int i = 0;
        for (Shifts *shift in arr_mySchedule) {
            
            if ([shift.startTime longLongValue] >= [nowTimeStamp longLongValue] || [shift.endTime longLongValue] > [nowTimeStamp longLongValue]) {
                [arr_myscheduleShift addObject:shift];
                if (arr_mySchedule.count-1 >= i+1) {
                    [arr_myscheduleShift addObject:[arr_mySchedule objectAtIndex:i+1]];
                }
                break;
            }
            i++;
        }
        
        if (appDelegate.currentEmployee.isManager == 0) {
            
            isManager = NO;
        }
        else
        {
            isManager = YES;
            
            arr_allLocations = [NSMutableArray arrayWithArray:[DatabaseManager getAllLocations]];
            if (arr_allLocations.count != 0) {
                int j = 0;
                for (Locations *locaiton in arr_allLocations) {
                    dict_todayEmployeeShifts = [NSMutableDictionary dictionaryWithDictionary: [DatabaseManager getDayShiftsByEmployeeFullName:[StringManager getDayDateStamp:[NSDate date]] andLocationUuid:locaiton.uuid]];
                    if ([dict_todayEmployeeShifts allKeys].count > 0) {
                        [arr_allLocations exchangeObjectAtIndex:j withObjectAtIndex:0];
                        break;
                    }
                    j++;
                }
            }
        }
        
        arr_todayOpenShifts = [DatabaseManager getEmployeeAvailableOpenshift];
        
        if (addshitimageView == nil) {
            addshitimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavibarHeight, ScreenWidth, 100)];
            addshitimageView.image = [UIImage imageNamed:@"addShift"];
            [self.view addSubview:addshitimageView];
            if (ScreenWidth == 320) {
                addshitimageView.image = [UIImage imageNamed:@"addShift_5"];
            }
        }
        
        if([DatabaseManager getAllShifts].count == 0 && appDelegate.currentEmployee.isManager == 1)
        {
            addshitimageView.hidden = NO;
            [self setTableFrame:YES];
        }
        else
        {
            addshitimageView.hidden = YES;
            [self setTableFrame:NO];
        }
        
        arr_todayAvailability = [DatabaseManager getDayAvailabilityByEmployeeUuid:[NSDate date] andEmployeeUuid:appDelegate.currentEmployee.uuid];
        
        long week = [StringManager getWeekDay:[NSDate date]];
        if (week == 1) {
            weekday = @"Monday";
        }
        else if (week == 2) {
            weekday = @"Tuesday";
        }
        else if (week == 3) {
            weekday = @"Wednesday";
        }
        else if (week == 4) {
            weekday = @"Thursday";
        }
        else if (week == 5) {
            weekday = @"Friday";
        }
        else if (week == 6) {
            weekday = @"Saturday";
        }
        else if (week == 7) {
            weekday = @"Sunday";
        }
        
        [_tableView reloadData];
    }
}

-(void) setTableFrame:(BOOL) isFirst
{
    if (isFirst == YES) {
        _tableView.frame = CGRectMake(0, 100+NavibarHeight, ScreenWidth, ScreenHeight-100-NavibarHeight);
    }
    else
    {
        _tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, ScreenHeight-NavibarHeight);
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    [self setbeginRefreshing];
    
    [DynamoDBManager getNewEmployee];
   
    arr_allLocations = [NSMutableArray arrayWithArray:[DatabaseManager getAllLocations]];

    arr_timeInterval = [NSArray arrayWithObjects:@"1am",@"2am",@"3am",@"4am",@"5am",@"6am",@"7am",@"8am",@"9am",@"10am",@"11am",@"12am",@"1pm",@"2pm",@"3pm",@"4pm",@"5pm",@"6pm",@"7pm",@"8pm",@"9pm",@"10pm",@"11pm",@"12pm", nil];
    
    CGAffineTransform newTRansform = CGAffineTransformMakeScale(0, 0);
    
    [_tableView setTransform:newTRansform];
    
        [UIView animateWithDuration:0.5 animations:^{
            
            CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.0, 1.0);
            
            [_tableView setTransform:newTRansform];
            
        } completion:^(BOOL finished){
        }];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_leftTableview] || [tableView isEqual:_rightTableview])
    {
        return 1;
    }
    else
    {
        if (isManager == YES) {
            return 4;
        }
        else
        {
            return 3;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_leftTableview] || [tableView isEqual:_rightTableview])
    {
        return [dict_todayEmployeeShifts allKeys].count;
    }
    else
    {
        if (isManager == YES) {
            if (section == 0) {
                return 3;
            }
            else if (section == 1)
            {
                if (arr_myscheduleShift.count == 0) {
                    return 2;
                }
                return arr_myscheduleShift.count+1;
            }
            else if (section == 2)
            {
                return 2;
            }
            else if (section == 3)
            {
                if (arr_todayAvailability.count == 0) {
                    return 1;
                }
                else
                {
                    return arr_todayAvailability.count+1;
                }
            }
        }
        else
        {
            if (section == 0) {
                if (arr_myscheduleShift.count == 0) {
                    return 2;
                }
                return arr_myscheduleShift.count+2;
            }
            else if (section == 1)
            {
                return 2;
            }
            else if (section == 2)
            {
                if (arr_todayAvailability.count == 0) {
                    return 1;
                }
                else
                {
                    return arr_todayAvailability.count+1;
                }
            }
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:_leftTableview] || [tableView isEqual:_rightTableview])
    {
        return 0;
    }
    else
    {
        if (isManager == YES) {
            if (section == 0) {
                if (arr_todayOpenShifts.count == 0 && [dict_todayEmployeeShifts allKeys].count == 0) {
                    return 0;
                }
            }
        }
        return footerHeight;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = SetColor(250, 250, 250, 1.0);
    if (isManager == NO) {
        if (section == 2) {
            view.tintColor = SetColor(255, 255, 255, 1.0);
        }
    }
    else
    {
        if (section == 3) {
            view.tintColor = SetColor(255, 255, 255, 1.0);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_leftTableview] || [tableView isEqual:_rightTableview])
    {
        return 36;
    }
    else
    {
        if (isManager == YES) {
            if (indexPath.section == 0) {
                if ([dict_todayEmployeeShifts allKeys].count == 0) {
                    return 0;
                }
                else
                {
                    if (indexPath.row == 0) {
                        return zeroRowHeight;
                    }
                    else if (indexPath.row == 1)
                    {
                        unsigned long height = TimeIntervalLabelHeight;
                        height += [dict_todayEmployeeShifts allKeys].count * 36;
                        if (height > 250) {
                            height = 250;
                        }
                        return height;
                    }
                    else
                    {
                        return seeAllHeight;
                    }
                }
            }
            else if (indexPath.section == 1)
            {
                if (indexPath.row == 0) {
                    
                    return zeroRowHeight;
                }
                else
                {
                    return myScheduleRowHeight;
                }
            }
            else if (indexPath.section == 2)
            {
                return sectionTwoRowHeight;
            }
            else if (indexPath.section == 3)
            {
                return availableRowHeight;
            }
        }
        else
        {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    
                    return zeroRowHeight;
                }
                else
                {
                    if (arr_myscheduleShift.count == 0) {
                        return myScheduleRowHeight;
                    }
                    else
                    {
                        if (indexPath.row == 1) {
                            return MapViewHeight;
                        }
                        return myScheduleRowHeight;
                    }
                }
            }
            else if (indexPath.section == 1)
            {
                return sectionTwoRowHeight;
            }
            else if (indexPath.section == 2)
            {
                return availableRowHeight;
            }
        }
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView])
    {
        NSString *identity = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (isManager == YES) {
            
            
            if (indexPath.section == 0) {
                
                if ([dict_todayEmployeeShifts allKeys].count != 0) {
                    
                    if (indexPath.row == 0) {
                        
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, zeroRowHeight-0.5, ScreenWidth, 0.5)];
                        line.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line];
                        
                        UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 150, zeroRowHeight)];
                        [lab_title setAttributedText:SetAttributeText(@"Schedule Today", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                        [cell.contentView addSubview:lab_title];
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        btn.frame = CGRectMake(150, 0, ScreenWidth-166, zeroRowHeight);
                        [cell.contentView addSubview:btn];
                        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.size.width-10, (zeroRowHeight-5)/2+2, 10, 5)];
                        imag.image = [UIImage imageNamed:@"pullDown"];
                        [btn addSubview:imag];
                        lab_selectlocation = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btn.frame.size.width-imag.frame.size.width-10, btn.frame.size.height)];
                        lab_selectlocation.textAlignment = NSTextAlignmentRight;
                        lab_selectlocation.textColor = AppMainColor;
                        lab_selectlocation.font = [UIFont fontWithName:SemiboldFontName size:14.0];
                        [btn addSubview:lab_selectlocation];
                        if (arr_allLocations.count-1 >= locationIndex) {
                            Locations *lo = [arr_allLocations objectAtIndex:locationIndex];
                            lab_selectlocation.text = lo.name;
                        }
                         if(selectLocationName != nil)
                         {
                             lab_selectlocation.text = selectLocationName;
                         }
                        [btn addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else if (indexPath.row == 1)
                    {
                        NSDate *now = [NSDate date];
                        NSCalendar *calendar = [NSCalendar currentCalendar];
                        NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
                        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
                        long hour = [dateComponent hour];
                        long minute = [dateComponent minute];
                        
                        UIScrollView *_scrollView = [[UIScrollView alloc] init];
                        unsigned long height = TimeIntervalLabelHeight;
                        height += [dict_todayEmployeeShifts allKeys].count * 36;
                        if (height > 250) {
                            height = 250;
                        }
                        
                        _scrollView.frame = CGRectMake(leftTableViewWidth+0.5 , 0 ,ScreenWidth-leftTableViewWidth-0.5,height);
                        _scrollView.contentSize = CGSizeMake(RightTableViewRowWidth*23.5, 0);
                        //_scrollView.contentSize = CGSizeMake((hour-1)*RightTableViewRowWidth+(RightTableViewRowWidth/60)*minute+RightTableViewRowWidth*3, 0);
                        _scrollView.showsVerticalScrollIndicator = NO;
                        _scrollView.showsHorizontalScrollIndicator = NO;
                        [_scrollView setContentOffset:CGPointMake((hour-1)*RightTableViewRowWidth+(RightTableViewRowWidth/60)*minute-RightTableViewRowWidth*1.5, 0) animated:YES];
                        [cell.contentView addSubview:_scrollView];
                        
                        UIView *line0 = [[UIView alloc]initWithFrame:CGRectMake(0, TimeIntervalLabelHeight, leftTableViewWidth, 0.5)];
                        line0.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line0];
                        
                        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(leftTableViewWidth, TimeIntervalLabelHeight+1, 0.5, height-TimeIntervalLabelHeight-1)];
                        line1.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line1];
                        
                        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, TimeIntervalLabelHeight, _scrollView.contentSize.width, 0.5)];
                        line2.backgroundColor = SepearateLineColor;
                        [_scrollView addSubview:line2];
                        
                        for (int i = 0; i < arr_timeInterval.count; i++) {
                            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i * RightTableViewRowWidth - TimeIntervalLabelWidth/2, 0, TimeIntervalLabelWidth, TimeIntervalLabelHeight)];
                            if (i == 0) {
                                lab.frame = CGRectMake(0, 0, TimeIntervalLabelWidth, TimeIntervalLabelHeight);
                            }
                            lab.text = [arr_timeInterval objectAtIndex:i];
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor grayColor];
                            lab.font = [UIFont systemFontOfSize:12.0];
                            if(i == 21 || i == 22 || i == 23)
                            {
                                lab.font = [UIFont systemFontOfSize:11.0];
                            }
                            [_scrollView addSubview:lab];
                        }
                        [_leftTableview removeFromSuperview];
                        _leftTableview = nil;
                        _leftTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, TimeIntervalLabelHeight+1, leftTableViewWidth, height-TimeIntervalLabelHeight-1)];
                        _leftTableview.delegate = self;
                        _leftTableview.dataSource = self;
                        _leftTableview.showsVerticalScrollIndicator = NO;
                        [cell.contentView addSubview:_leftTableview];
                        _leftTableview.frame = CGRectMake(0, TimeIntervalLabelHeight+1, leftTableViewWidth, height-TimeIntervalLabelHeight-1);
                        [_leftTableview reloadData];
                        
                        if ([_leftTableview respondsToSelector:@selector(setSeparatorInset:)]) {
                            [_leftTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
                        }
                        
                        if ([_leftTableview respondsToSelector:@selector(setLayoutMargins:)]) {
                            [_leftTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
                        }
                        
                        [_rightTableview removeFromSuperview];
                        _rightTableview = nil;
                        _rightTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, _leftTableview.frame.origin.y, _scrollView.contentSize.width, height-TimeIntervalLabelHeight-1)];
                        _rightTableview.delegate = self;
                        _rightTableview.dataSource = self;
                        _rightTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
                        [_scrollView addSubview:_rightTableview];
                        _rightTableview.frame = CGRectMake(0, _leftTableview.frame.origin.y, _scrollView.contentSize.width, height-TimeIntervalLabelHeight-1);
                        [_rightTableview reloadData];

                        UILabel *currentTimeLine = [[UILabel alloc]initWithFrame:CGRectMake((hour-1)*RightTableViewRowWidth+(RightTableViewRowWidth/60)*minute, 0, 0.5, _rightTableview.frame.size.height)];
                        currentTimeLine.backgroundColor = AppMainColor;
                        UILabel *roundLab = [[UILabel alloc] initWithFrame:CGRectMake(currentTimeLine.frame.origin.x-3, 0, 6.5, 6.5)];
                        roundLab.layer.masksToBounds = YES;
                        roundLab.layer.cornerRadius = 6.5/2;
                        roundLab.backgroundColor = AppMainColor;
                        [_rightTableview addSubview:roundLab];
                        [_rightTableview addSubview:currentTimeLine];
                    }
                    else if (indexPath.row == 2)
                    {
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
                        line.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line];
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        btn.frame = CGRectMake(0, 0, ScreenWidth, seeAllHeight);
                        [btn setTitle:@"See All" forState:UIControlStateNormal];
                        [btn setTitleColor:AppMainColor forState:UIControlStateNormal];
                        [btn.titleLabel setFont:[UIFont fontWithName:SemiboldFontName size:14.0]];
                        [cell.contentView addSubview:btn];
                        [btn addTarget:self action:@selector(seeAllSchedules) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
            else if (indexPath.section == 1)
            {
                if (indexPath.row == 0) {
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, zeroRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 150, zeroRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"My Schedule", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                    
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-24, (zeroRowHeight-14)/2, 8, 14)];
                    imageview.image = [UIImage imageNamed:@"indicator"];
                    [cell.contentView addSubview:imageview];
                }
                else
                {
                    if(arr_myscheduleShift.count == 0)
                    {
                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, ScreenWidth-16, myScheduleRowHeight)];
                        lab.text = @"You do not have shift";
                        lab.textColor = [UIColor lightGrayColor];
                        [cell.contentView addSubview:lab];
                    }
                    else if(arr_myscheduleShift.count >= indexPath.row-1 && arr_myscheduleShift.count >= 1)
                    {
                        Shifts *shift = [arr_myscheduleShift objectAtIndex:indexPath.row-1];
                        Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
                        Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                        UIView *fontview = [[UIView alloc] initWithFrame:CGRectMake(16, 12, 30, myScheduleRowHeight-12*2)];
                        UILabel *lab_week = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontview.frame.size.width, 12)];
                        lab_week.textAlignment = NSTextAlignmentCenter;
                        UILabel *lab_day = [[UILabel alloc] initWithFrame:CGRectMake(0, lab_week.frame.size.height, fontview.frame.size.width, 24)];
                        lab_day.textAlignment = NSTextAlignmentCenter;
                        NSString *day = shift.string_day;
                        if([day length] == 1)
                        {
                            day = [NSString stringWithFormat:@"0%@",day];
                        }
                        [lab_week setAttributedText:SetAttributeText(shift.string_week, PositionUnassignedColor, SemiboldFontName, 10.0)];
                         
                        [lab_day setAttributedText:SetAttributeText(day, PositionUnassignedColor, SemiboldFontName, 20.0)];
                         
                        if(position != nil)
                        {
                            [lab_week setAttributedText:SetAttributeText(shift.string_week, [MostColor getPositionColor:[NSNumber numberWithShort:position.color]], SemiboldFontName, 10.0)];
                            [lab_day setAttributedText:SetAttributeText(day, [MostColor getPositionColor:[NSNumber numberWithShort:position.color]], SemiboldFontName, 20.0)];
                        }
                             
                        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(56, 10, 200, 20)];
                        lable.textColor = SetColor(3, 3, 3, 1.0);
                        lable.text = [NSString stringWithFormat:@"%@",shift.string_time];
                        
                        Drop *drop = [DatabaseManager getPendingDropByShiftUuid:shift.uuid];
                        Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:shift.uuid];
                        if (drop != nil || swap != nil) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.frame = CGRectMake(230, 5, 30, 30);
                            [btn setImage:[UIImage imageNamed:@"s_alerm"] forState:UIControlStateNormal];
                            [cell.contentView addSubview:btn];
                        }

                        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 34, ScreenWidth-64, 16)];
                        detailLabel.textColor = SetColor(0, 0, 0, 0.3);
                        detailLabel.font = [UIFont systemFontOfSize:14.0];

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
                        lab_position.text = @"Un";
                        lab_position.backgroundColor = PositionUnassignedColor;
                             
                        if (position != nil) {
                                 
                            lab_position.text = [StringManager getManyFirstLetterFromString:position.name];
                            lab_position.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                        }
                        [lab_position setAdjustsFontSizeToFitWidth:YES];
                             
                             if(arr_myscheduleShift.count >= 2 && indexPath.row == 1)
                             {
                                 UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, myScheduleRowHeight-0.5, ScreenWidth-16, 0.5)];
                                 line.backgroundColor = SepearateLineColor;
                                 [cell.contentView addSubview:line];
                             }
                             
                        [cell.contentView addSubview:fontview];
                        [fontview addSubview:lab_week];
                        [fontview addSubview:lab_day];
                        [cell.contentView addSubview:lable];
                        [cell.contentView addSubview:detailLabel];
                        [cell.contentView addSubview:lab_position];
                    }
                }
            }
            else if (indexPath.section == 2)
            {
                UILabel *lab_count = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-34-28, (sectionTwoRowHeight-28)/2, 28, 28)];
                lab_count.layer.masksToBounds = YES;
                lab_count.layer.cornerRadius = 28/2.0;
                lab_count.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lab_count];
                
                if (indexPath.row == 0) {
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, sectionTwoRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, sectionTwoRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"Requests & Time Off", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                    lab_count.backgroundColor = SetColor(249, 104, 43, 1.0);
                    NSArray *arr_request = [[DatabaseManager getAllRequests] objectForKey:@"0"];
                    NSString *sstring = [NSString stringWithFormat:@"%ld",(long)arr_request.count];
                    [lab_count setAttributedText:SetAttributeText(sstring, [UIColor whiteColor], SemiboldFontName, 12.0)];
                     
                    if (arr_request.count == 0) {
                        lab_count.backgroundColor = [UIColor clearColor];
                        [lab_count setAttributedText:SetAttributeText(sstring, SetColor(0, 0, 0, 0.3), SemiboldFontName, 17.0)];
                    }
                }
                else if (indexPath.row == 1)
                {
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, sectionTwoRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"Open Shifts Availability", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                     lab_count.backgroundColor = SetColor(23, 128, 249, 1.0);
                    lab_count.backgroundColor = SetColor(23, 128, 249, 1.0);
                    NSString *sstring = [NSString stringWithFormat:@"%ld",(long)arr_todayOpenShifts.count];
                    [lab_count setAttributedText:SetAttributeText(sstring, [UIColor whiteColor], SemiboldFontName, 12.0)];
                    if (arr_todayOpenShifts.count == 0) {
                        lab_count.backgroundColor = [UIColor clearColor];
                        [lab_count setAttributedText:SetAttributeText(sstring, SetColor(0, 0, 0, 0.3), SemiboldFontName, 17.0)];
                    }
                }
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-16-8, (sectionTwoRowHeight-14)/2, 8, 14)];
                imageview.image = [UIImage imageNamed:@"indicator"];
                [cell.contentView addSubview:imageview];
                
            }
            else if(indexPath.section == 3)
            {
                if (indexPath.row == 0) {
                    
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, availableRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, availableRowHeight)];
                    lab.text = @"My Availability";
                    lab.textColor = SetColor(0, 0, 0, 0.87);
                    [cell.contentView addSubview:lab];
                    
                    UILabel *lab_week = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-134, (availableRowHeight-30)/2, 100, 30)];
                    lab_week.font = [UIFont systemFontOfSize:14.0];
                    lab_week.textColor = [UIColor lightGrayColor];
                    lab_week.textAlignment = NSTextAlignmentRight;
                    lab_week.text = weekday;
                    [cell.contentView addSubview:lab_week];
                    
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-24, (availableRowHeight-14)/2, 8, 14)];
                    imageview.image = [UIImage imageNamed:@"indicator"];
                    [cell.contentView addSubview:imageview];
                }
                else
                {
                    if (arr_todayAvailability.count != 0) {
                        
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, availableRowHeight-0.5, ScreenWidth, 0.5)];
                        line.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line];
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(16, 12, 20, 20);
                        [cell.contentView addSubview:btn];
                        
                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, ScreenWidth-74, 20)];
                        lab.textColor = SetColor(3, 3, 3, 1);
                        [cell.contentView addSubview:lab];
                        
                        NSDictionary *dict = [arr_todayAvailability objectAtIndex:indexPath.row-1];
                        if ([[dict objectForKey:Availability_IsAllDay] intValue] == 1) {
                            
                            lab.text = @"All Day";
                        }
                        else
                        {
                            lab.text = [NSString  stringWithFormat:@"%@ - %@",[dict objectForKey:Availability_FromTime],[dict objectForKey:Availability_ToTime]];
                        }
                        
                        if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
                            
                            [btn setImage:[UIImage imageNamed:@"preferred"] forState:UIControlStateNormal];
                        }
                        else if ([[dict objectForKey:Availability_State] isEqualToString:@"1"])
                        {
                            [btn setImage:[UIImage imageNamed:@"unavailable"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
        }
        else
        {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, zeroRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 150, zeroRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"My Schedule", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                     
                     UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-24, (zeroRowHeight-14)/2, 8, 14)];
                     imageview.image = [UIImage imageNamed:@"indicator"];
                     [cell.contentView addSubview:imageview];
                }
                else
                {
                    if(arr_myscheduleShift.count == 0)
                    {
                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, ScreenWidth-16, myScheduleRowHeight)];
                        lab.text = @"You do not have shift";
                        lab.textColor = [UIColor lightGrayColor];
                        [cell.contentView addSubview:lab];
                    }
                    else
                    {
                        if(indexPath.row == 1)
                        {
                            
                            Shifts *shift = [arr_myscheduleShift objectAtIndex:indexPath.row-1];
                            Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
                            
                            GMSMapView *mapView_ = [[GMSMapView alloc]initWithFrame:CGRectMake(10, 0,self.view.frame.size.width-20, MapViewHeight)];
                            
                            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude  longitude:location.longitude zoom:15];
                            mapView_ = [GMSMapView mapWithFrame:mapView_.frame camera:camera];
                            GMSMarker *marker = [[GMSMarker alloc] init];
                            marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
                            marker.title = location.name;
                            marker.snippet = location.address;
                            marker.map = mapView_;
                            
                            [cell.contentView addSubview:mapView_];
                        }
                        else
                        {
                            Shifts *shift = [arr_myscheduleShift objectAtIndex:indexPath.row-2];
                            Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
                            Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                            
                            UIView *fontview = [[UIView alloc] initWithFrame:CGRectMake(13, 12, 30, myScheduleRowHeight-12*2)];
                            UILabel *lab_week = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontview.frame.size.width, 12)];
                            lab_week.textAlignment = NSTextAlignmentCenter;
                            UILabel *lab_day = [[UILabel alloc] initWithFrame:CGRectMake(0, lab_week.frame.size.height, fontview.frame.size.width, 24)];
                            lab_day.textAlignment = NSTextAlignmentCenter;
                            NSString *day = shift.string_day;
                            if([day length] == 1)
                            {
                                day = [NSString stringWithFormat:@"0%@",day];
                            }
                            [lab_week setAttributedText:SetAttributeText(shift.string_week, PositionUnassignedColor, SemiboldFontName, 10.0)];
                            [lab_day setAttributedText:SetAttributeText(day, PositionUnassignedColor, SemiboldFontName, 20.0)];
                            if(position != nil)
                            {
                                [lab_week setAttributedText:SetAttributeText(shift.string_week, [MostColor getPositionColor:[NSNumber numberWithShort:position.color]], SemiboldFontName, 10.0)];
                                [lab_day setAttributedText:SetAttributeText(day, [MostColor getPositionColor:[NSNumber numberWithShort:position.color]], SemiboldFontName, 20.0)];
                            }
                                    
                            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(56, 10, 200, 20)];
                            lable.textColor = SetColor(3, 3, 3, 1.0);
                            lable.text = [NSString stringWithFormat:@"%@",shift.string_time];
                                    
                            Drop *drop = [DatabaseManager getPendingDropByShiftUuid:shift.uuid];
                            Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:shift.uuid];
                            if (drop != nil || swap != nil) {
                                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                                btn.frame = CGRectMake(230, 5, 30, 30);
                                [btn setImage:[UIImage imageNamed:@"s_alerm"] forState:UIControlStateNormal];
                                [cell.contentView addSubview:btn];
                            }
                                    
                            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 34, ScreenWidth-64, 16)];
                            detailLabel.textColor = SetColor(0, 0, 0, 0.3);
                            detailLabel.font = [UIFont systemFontOfSize:14.0];
                                    
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
                                    
                            UILabel *lab_hour = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 116, 13, 100, 14)];
                            lab_hour.textAlignment = NSTextAlignmentRight;
                            lab_hour.alpha = 0.3;
                            NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[shift.totalHours floatValue]]];
                            lab_hour.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                            lab_hour.font = [UIFont systemFontOfSize:12.0];
                                    
                            UILabel *lab_position = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 46, 32, 30, 18)];
                            lab_position.textColor = [UIColor whiteColor];
                            lab_position.textAlignment = NSTextAlignmentCenter;
                            lab_position.font = [UIFont systemFontOfSize:10.0];
                            lab_position.layer.masksToBounds = YES;
                            lab_position.layer.cornerRadius = 9;
                            lab_position.text = @"Un";
                            lab_position.backgroundColor = PositionUnassignedColor;
                                    
                            if (position != nil) {
                                        
                                lab_position.text = [StringManager getManyFirstLetterFromString:position.name];
                                lab_position.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                            }
                            [lab_position setAdjustsFontSizeToFitWidth:YES];
                                    
                            if(arr_myscheduleShift.count >= 2 && indexPath.row == 2)
                                    {
                                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, myScheduleRowHeight-0.5, ScreenWidth-16, 0.5)];
                                line.backgroundColor = SepearateLineColor;
                                [cell.contentView addSubview:line];
                            }
                                    
                            [cell.contentView addSubview:fontview];
                            [fontview addSubview:lab_week];
                            [fontview addSubview:lab_day];
                            [cell.contentView addSubview:lable];
                            [cell.contentView addSubview:lab_hour];
                            [cell.contentView addSubview:detailLabel];
                            [cell.contentView addSubview:lab_position];
                        }
                    }
                }
            }
            else if (indexPath.section == 1)
            {
                UILabel *lab_count = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-34-28, (sectionTwoRowHeight-28)/2, 28, 28)];
                lab_count.layer.masksToBounds = YES;
                lab_count.layer.cornerRadius = 28/2.0;
                lab_count.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lab_count];
                
                if (indexPath.row == 0) {
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, sectionTwoRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, sectionTwoRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"Requests & Time Off", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                    
                    lab_count.backgroundColor = SetColor(249, 104, 43, 1.0);
                    NSArray *arr_request = [[DatabaseManager getAllMyRequests] objectForKey:@"0"];
                    NSString *sstring = [NSString stringWithFormat:@"%lu",(long)arr_request.count];
                    [lab_count setAttributedText:SetAttributeText(sstring, [UIColor whiteColor], SemiboldFontName, 12.0)];
                    if (arr_request.count == 0) {
                        lab_count.backgroundColor = [UIColor clearColor];
                        [lab_count setAttributedText:SetAttributeText(sstring, SetColor(0, 0, 0, 0.3), SemiboldFontName, 17.0)];
                    }
                }
                else if (indexPath.row == 1)
                         {
                    UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, sectionTwoRowHeight)];
                    [lab_title setAttributedText:SetAttributeText(@"Open Shifts Availability", SetColor(0, 0, 0, 0.87), RegularFontName, 17.0)];
                     [cell.contentView addSubview:lab_title];
                    lab_count.backgroundColor = SetColor(23, 128, 249, 1.0);
                    NSArray *arr_openshift = [DatabaseManager getEmployeeNeedActionOpenShift_array];
                    NSString *sstring = [NSString stringWithFormat:@"%ld",(long)arr_openshift.count];
                    [lab_count setAttributedText:SetAttributeText(sstring, [UIColor whiteColor], SemiboldFontName, 12.0)];
                     lab_count.font = [UIFont fontWithName:SemiboldFontName size:12.0];
                    if (arr_openshift.count == 0) {
                        lab_count.backgroundColor = [UIColor clearColor];
                        [lab_count setAttributedText:SetAttributeText(sstring, SetColor(0, 0, 0, 0.3), SemiboldFontName, 17.0)];
                    }
                }
                
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-16-8, (sectionTwoRowHeight-14)/2, 8, 14)];
                imageview.image = [UIImage imageNamed:@"indicator"];
                [cell.contentView addSubview:imageview];
            }
            else
            {
                if (indexPath.row == 0) {
                    
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, availableRowHeight-0.5, ScreenWidth, 0.5)];
                    line.backgroundColor = SepearateLineColor;
                    [cell.contentView addSubview:line];
                    
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 200, availableRowHeight)];
                    lab.text = @"My Availability";
                    lab.textColor = SetColor(0, 0, 0, 0.87);
                    [cell.contentView addSubview:lab];
                    
                    UILabel *lab_week = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-134, (availableRowHeight-30)/2, 100, 30)];
                    lab_week.font = [UIFont systemFontOfSize:14.0];
                    lab_week.textColor = [UIColor lightGrayColor];
                    lab_week.textAlignment = NSTextAlignmentRight;
                    lab_week.text = weekday;
                    [cell.contentView addSubview:lab_week];
                    
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-24, (availableRowHeight-14)/2, 8, 14)];
                    imageview.image = [UIImage imageNamed:@"indicator"];
                    [cell.contentView addSubview:imageview];
                }
                else
                {
                    if (arr_todayAvailability.count != 0) {
                        
                        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, availableRowHeight-0.5, ScreenWidth, 0.5)];
                        line.backgroundColor = SepearateLineColor;
                        [cell.contentView addSubview:line];
                        
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.frame = CGRectMake(16, 12, 20, 20);
                        [cell.contentView addSubview:btn];
                        
                        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, ScreenWidth-74, 20)];
                        lab.textColor = SetColor(3, 3, 3, 1);
                        [cell.contentView addSubview:lab];
                        
                        NSDictionary *dict = [arr_todayAvailability objectAtIndex:indexPath.row-1];
                        if ([[dict objectForKey:Availability_IsAllDay] intValue] == 1) {
                            
                            lab.text = @"All Day";
                        }
                        else
                        {
                            lab.text = [NSString  stringWithFormat:@"%@ - %@",[dict objectForKey:Availability_FromTime],[dict objectForKey:Availability_ToTime]];
                        }
                        
                        if ([[dict objectForKey:Availability_State] isEqualToString:@"0"]) {
                            
                            [btn setImage:[UIImage imageNamed:@"preferred"] forState:UIControlStateNormal];
                        }
                        else if ([[dict objectForKey:Availability_State] isEqualToString:@"1"])
                        {
                            [btn setImage:[UIImage imageNamed:@"unavailable"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
        }
        
        return cell;
    }
    else if ([tableView isEqual:_leftTableview] && isManager == YES)
    {
        NSString *identity = @"leftcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([dict_todayEmployeeShifts allKeys].count-1 >= indexPath.row) {
            cell.textLabel.text = [[dict_todayEmployeeShifts allKeys] objectAtIndex:indexPath.row];
            cell.textLabel.textColor = SetColor(0, 0, 0, 0.87);
            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        }
        return cell;
    }
    else//right Tablebiew
    {
        if (isManager == YES) {
            NSString *identity = @"rightcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if ([dict_todayEmployeeShifts allKeys].count-1 >= indexPath.row) {
                
                //for (UIView *view in cell.contentView.subviews) {
                //[view removeFromSuperview];
                //}
                
                for (int i = 1; i < 24; i++) {
                    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(i*80, 0, 1, 36)];
                    line2.backgroundColor = SetColor(245, 245, 245, 1.0);
                    [cell.contentView addSubview:line2];
                }
                
                
                NSMutableArray *arr_temp = [dict_todayEmployeeShifts objectForKey:[[dict_todayEmployeeShifts allKeys] objectAtIndex:indexPath.row]];
                arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:arr_temp]];
                
                if (arr_temp.count == 1) {
                    
                    Shifts *shift = [arr_temp objectAtIndex:0];
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift.string_time]];
                    NSString *time1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
                    NSString *time2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
                    float interval1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1];
                    float interval2 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2];
                    float lable_x = interval1 * RightTableViewRowWidth;
                    float label_w =  (interval2-interval1) * RightTableViewRowWidth;
                    UILabel *labShow = [[UILabel alloc]initWithFrame:CGRectMake(lable_x, 13, label_w, 9)];
                    if (shift.positionUuid == nil) {
                        
                        labShow.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                        labShow.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow.layer.masksToBounds = YES;
                    labShow.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow];
                }
                else if (arr_temp.count == 2)
                {
                    Shifts *shift1 = [arr_temp objectAtIndex:0];
                    Shifts *shift2 = [arr_temp objectAtIndex:1];
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift1.string_time]];
                    NSString *time1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
                    NSString *time2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
                    float interval1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1];
                    float interval2 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2];
                    float lable_x = interval1 * RightTableViewRowWidth;
                    float label_w =  (interval2-interval1) * RightTableViewRowWidth;
                    UILabel *labShow = [[UILabel alloc]initWithFrame:CGRectMake(lable_x, 6, label_w, 9)];
                    if (shift1.positionUuid == nil) {
                        
                        labShow.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift1.positionUuid];
                        labShow.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow.layer.masksToBounds = YES;
                    labShow.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow];
                    
                    NSDictionary *dict2 = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift2.string_time]];
                    NSString *time1_1 = [NSString stringWithFormat:@"%@ %@",[dict2 objectForKey:@"str1"],[dict2 objectForKey:@"str2"]];
                    NSString *time2_1 = [NSString stringWithFormat:@"%@ %@",[dict2 objectForKey:@"str3"],[dict2 objectForKey:@"str4"]];
                    float interval1_1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1_1];
                    float interval2_1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2_1];
                    float lable_x2 = interval1_1 * RightTableViewRowWidth;
                    float label_w2 =  (interval2_1-interval1_1) * RightTableViewRowWidth;
                    UILabel *labShow2 = [[UILabel alloc]initWithFrame:CGRectMake(lable_x2, 21, label_w2, 9)];
                    if (shift2.positionUuid == nil) {
                        
                        labShow2.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift2.positionUuid];
                        labShow2.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow2.layer.masksToBounds = YES;
                    labShow2.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow2];
                }
                else if(arr_temp.count >= 3)
                {
                    arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:arr_temp]];
                    Shifts *shift1 = [arr_temp objectAtIndex:0];
                    Shifts *shift2 = [arr_temp objectAtIndex:1];
                    Shifts *shift3 = [arr_temp objectAtIndex:2];
                    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift1.string_time]];
                    NSString *time1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
                    NSString *time2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
                    float interval1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1];
                    float interval2 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2];
                    float lable_x = interval1 * RightTableViewRowWidth;
                    float label_w =  (interval2-interval1) * RightTableViewRowWidth;
                    UILabel *labShow = [[UILabel alloc]initWithFrame:CGRectMake(lable_x, 2.25, label_w, 9)];
                    if (shift1.positionUuid == nil) {
                        
                        labShow.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift1.positionUuid];
                        labShow.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow.layer.masksToBounds = YES;
                    labShow.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow];
                    
                    NSDictionary *dict2 = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift2.string_time]];
                    NSString *time1_1 = [NSString stringWithFormat:@"%@ %@",[dict2 objectForKey:@"str1"],[dict2 objectForKey:@"str2"]];
                    NSString *time2_1 = [NSString stringWithFormat:@"%@ %@",[dict2 objectForKey:@"str3"],[dict2 objectForKey:@"str4"]];
                    float interval1_1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1_1];
                    float interval2_1 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2_1];
                    float lable_x2 = interval1_1 * RightTableViewRowWidth;
                    float label_w2 =  (interval2_1-interval1_1) * RightTableViewRowWidth;
                    UILabel *labShow2 = [[UILabel alloc]initWithFrame:CGRectMake(lable_x2, 14, label_w2, 9)];
                    if (shift2.positionUuid == nil) {
                        
                        labShow2.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift2.positionUuid];
                        labShow2.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow2.layer.masksToBounds = YES;
                    labShow2.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow2];
                    
                    NSDictionary *dict3 = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:shift3.string_time]];
                    NSString *time1_3 = [NSString stringWithFormat:@"%@ %@",[dict3 objectForKey:@"str1"],[dict3 objectForKey:@"str2"]];
                    NSString *time2_3 = [NSString stringWithFormat:@"%@ %@",[dict3 objectForKey:@"str3"],[dict3 objectForKey:@"str4"]];
                    float interval1_3 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time1_3];
                    float interval2_3 = [StringManager getIntervalHoursFromTowTime:@"1:00 a.m." andTime2:time2_3];
                    float lable_x3 = interval1_3 * RightTableViewRowWidth;
                    float label_w3 =  (interval2_3-interval1_3) * RightTableViewRowWidth;
                    UILabel *labShow3 = [[UILabel alloc]initWithFrame:CGRectMake(lable_x3, 25.5, label_w3, 9)];
                    if (shift3.positionUuid == nil) {
                        
                        labShow3.backgroundColor = SetColor(156, 168, 160, 1.0);
                    }
                    else
                    {
                        Positions *position = [DatabaseManager getPositionByUuid:shift3.positionUuid];
                        labShow3.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                    }
                    labShow3.layer.masksToBounds = YES;
                    labShow3.layer.cornerRadius = 5;
                    [cell.contentView addSubview:labShow3];
                }
                if (indexPath.row < [dict_todayEmployeeShifts allKeys].count) {
                    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 23*RightTableViewRowWidth, 1)];
                    line.backgroundColor = SetColor(245, 245, 245, 1.0);
                    [cell.contentView addSubview:line];
                }
            }
            return cell;
        }
        else
        {
            NSString *identity = @"othercell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
            }
            return cell;
        }
    }
}

-(void)seeAllSchedules
{
    [UserEntity setFilter:[NSDictionary dictionaryWithObject:@"0" forKey:@"filter"]];
    MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
    [self.navigationController pushViewController:schedule animated:YES];
}

-(void) selectLocation
{
    arr_allLocations = nil;
    arr_allLocations = [NSMutableArray arrayWithArray:[DatabaseManager getAllLocations]];
    [UIApplication sharedApplication].keyWindow.tintColor = SetColor(0 ,195, 0,1.0);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"All Locations:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    
    for (int i = 0; i < arr_allLocations.count; i++) {
        Locations *location = [arr_allLocations objectAtIndex:i];
        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:location.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self alertHandle:i];
        }];
        [alertController addAction:otherButton];
        alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) alertHandle:(NSInteger) index
{
    Locations *location = [arr_allLocations objectAtIndex:index];
    dict_todayEmployeeShifts = nil;
    dict_todayEmployeeShifts = [DatabaseManager getDayShiftsByEmployeeFullName:[StringManager getDayDateStamp:[NSDate date]] andLocationUuid:location.uuid];
    if ([dict_todayEmployeeShifts allKeys].count == 0) {
    }
    else
    {
        selectLocationName = location.name;
        [_tableView reloadData];
        [_leftTableview reloadData];
        [_rightTableview reloadData];
    }
}
                         

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (isManager == YES) {
        
        if (indexPath.section == 0) {
            
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0) {
                
                [UserEntity setFilter:[NSDictionary dictionaryWithObject:@"1" forKey:@"filter"]];
                MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
                [self.navigationController pushViewController:schedule animated:YES];
            }
            else
            {
                if(arr_myscheduleShift.count >= 1)
                {
                    ShiftDetailViewController_iphone *detail = [ShiftDetailViewController_iphone new];
                    Shifts *shift = [arr_myscheduleShift objectAtIndex:indexPath.row-1];
                    detail.uuid = shift.uuid;
                    [self.navigationController pushViewController:detail animated:YES];
                }
            }
        }
        else if (indexPath.section == 2)
        {
            if (indexPath.row == 0) {
                RequestViewController_phone *request = [RequestViewController_phone new];
                [self.navigationController pushViewController:request animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [UserEntity setFilter:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"filter",OpenShiftEmployeeUuid,@"employeeUuid", nil]];
                MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
                [self.navigationController pushViewController:schedule animated:YES];
            }
        }
        else if (indexPath.section == 3)
        {
            if (indexPath.row == 0) {
                AvailabilityViewController_iphone *avai = [AvailabilityViewController_iphone new];
                avai.employeeUuid = appDelegate.currentEmployee.uuid;
                [self.navigationController pushViewController:avai animated:YES];
            }
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                
                [UserEntity setFilter:[NSDictionary dictionaryWithObject:@"1" forKey:@"filter"]];
                MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
                [self.navigationController pushViewController:schedule animated:YES];
            }
            else
            {
                if(indexPath.row >= 2)
                {
                    ShiftDetailViewController_iphone *detail = [ShiftDetailViewController_iphone new];
                    Shifts *shift = [arr_myscheduleShift objectAtIndex:indexPath.row-2];
                    detail.uuid = shift.uuid;
                    [self.navigationController pushViewController:detail animated:YES];
                }
                
            }
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0) {

                RequestViewController_phone *request = [RequestViewController_phone new];
                [self.navigationController pushViewController:request animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [UserEntity setFilter:[NSDictionary dictionaryWithObject:@"9" forKey:@"filter"]];
                MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
                [self.navigationController pushViewController:schedule animated:YES];
            }
        }
        else if (indexPath.section == 2)
        {
            if (indexPath.row == 0) {
                
                AvailabilityViewController_iphone *avai = [AvailabilityViewController_iphone new];
                avai.employeeUuid = appDelegate.currentEmployee.uuid;
                [self.navigationController pushViewController:avai animated:YES];
            }
        }
    }
}
                         
                         

- (void)setbeginRefreshing
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
}
-(void) refreshView:(UIRefreshControl *)refresh
{
    if (_refreshControl.refreshing) {
        //_refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"refreshing..."];
        [self performSelector:@selector(refreshTableView:) withObject:refresh afterDelay:0];
    }
    [DynamoDBManager getNewEmployee];
    
}
-(void)refreshTableView:(UIRefreshControl *)refresh{
    
    if(appDelegate.currentWorkplace.uuid != nil)
    {
        //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        __block BOOL isTake = YES;
        
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
                    
                    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
            }
            else
            {
                AWSDynamoDBPaginatedOutput *output = task.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    NSArray *arr = output.items;
                    
                    isTake = [DynamoDBManager dynamodbDataSaveToLocal:arr];
                    
                    [self initData];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
