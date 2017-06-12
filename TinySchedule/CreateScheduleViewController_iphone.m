//
//  CreateScheduleViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/31.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "CreateScheduleViewController_iphone.h"

#define datePickerHeight 200
#define pickerViewHeight 200

#define lightBGViewColor [UIColor colorWithRed:0 green:196/255.0 blue:13/255.0 alpha:1.0]
#define lightTextColor [UIColor whiteColor]
#define darkBGViewColor [UIColor whiteColor]
#define darkTextColor [UIColor blackColor]
#define darkDetailTextColor [UIColor lightGrayColor]

@interface CreateScheduleViewController_iphone ()
{
    NSMutableArray *firstTimePickerArray;
    NSMutableArray *secondTimePickerArray;
    NSMutableArray *unpaidPickerArray;
    
    NSString *selectUnpaidTime;//30 min
    
    
    //NSInteger unpaidIndex;
    NSInteger firstTimeIndex;
    NSInteger secondTimeIndex;
    
    NSString *string_date;//2016-9-20
    NSNumber *stamp_date;//"2016-9-20" ->  "1474347600"
    NSNumber *stamp_startTimeStamp;//1474346700
    NSNumber *stamp_endTimeStamp;//1474347600
    NSString *str_year;//"2016"
    NSString *str_month;//JUN
    NSString *str_day;//18
    NSString *str_week;//Mon
    NSString *selectTime;//05:00 a.m. - 16:00 p.m.
    NSString *time1;//05:00
    NSString *time2;//16:00
    
    NSMutableArray *arr_historyShiftTime;
    
    UIView *bgClearView;
}
@end

@implementation CreateScheduleViewController_iphone

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //unpaidIndex = 0;              //unpaid break 初始的默认显示行数
        firstTimeIndex = 48;        //time 初始的默认显示行数  －－ 0 component
        secondTimeIndex = 49;       //time 初始的默认显示行数  －－ 1 component
        selectUnpaidTime = nil;       //unpaid break  选中的value
        selectTime = nil;           //time  选中的value
        
        string_date = nil;
        stamp_date = 0;
        stamp_startTimeStamp = 0;
        stamp_endTimeStamp = 0;
        
        str_year = nil;
        str_month = nil;
        str_day = nil;
        str_week = nil;
        
        time1 = nil;
        time2 = nil;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    _dateImageVIew.highlighted = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPickerViewData];
    
    NSDate *currentDate = [NSDate date];
    [self changeDateLabel:currentDate];
    
    [self initPicker];
    
    UITapGestureRecognizer *tap_dateView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelectDate:)];
    tap_dateView.numberOfTapsRequired = 1;
    [_dateView addGestureRecognizer:tap_dateView];
    
    UITapGestureRecognizer *tap_timeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelectTime:)];
    tap_dateView.numberOfTapsRequired = 1;
    [_timeView addGestureRecognizer:tap_timeView];
    
    UITapGestureRecognizer *tap_unBreakView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toSelectUnBreakTime:)];
    tap_dateView.numberOfTapsRequired = 1;
    [_unBreakView addGestureRecognizer:tap_unBreakView];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    // Do any additional setup after loading the view from its nib.
}
-(void)initPicker
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 258, ScreenWidth-30, ScreenHeight-258) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = SetColor(245, 245, 245, 1.0);
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 10.0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    if (_bgBlackView == nil) {
        
        _bgBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgBlackView.backgroundColor = SetColor(0, 0, 0, 0.2);
        [self.view addSubview:_bgBlackView];
        
        _bgBlackView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidebgBlackView:)];
        [_bgBlackView addGestureRecognizer:tap];
    }
    if (_bgWhiteView == nil) {
        _bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, datePickerHeight)];
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        [_bgBlackView addSubview:_bgWhiteView];
    }
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth , pickerViewHeight)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:_datePicker];
    }
    if (_pickerViewTime == nil) {
        _pickerViewTime = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth , pickerViewHeight)];
        _pickerViewTime.delegate = self;
        _pickerViewTime.dataSource = self;
        [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
        [_pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
        [_bgWhiteView addSubview:_pickerViewTime];
        [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    }
    if (_pickerViewUnpaid == nil) {
        _pickerViewUnpaid = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth , pickerViewHeight)];
        _pickerViewUnpaid.delegate = self;
        _pickerViewUnpaid.dataSource = self;
        [_pickerViewUnpaid selectedRowInComponent:0];
        //                selectUnpaidTime = [unpaidPickerArray objectAtIndex:unpaidIndex];
        [_bgWhiteView addSubview:_pickerViewUnpaid];
    }
}

-(void)initPickerViewData
{
    NSString *pickerPath = [[NSBundle mainBundle] pathForResource:@"UnPaidBreakPlist" ofType:@"plist"];
    unpaidPickerArray = [NSMutableArray arrayWithContentsOfFile:pickerPath];
    
    NSString *timePlistPath = [[NSBundle mainBundle] pathForResource:@"TimePlist" ofType:@"plist"];
    firstTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    secondTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    
    arr_historyShiftTime = [NSMutableArray arrayWithArray:[DatabaseManager getHistoryShiftTime]];
}

-(void)dateChanged:(UIDatePicker *)picker
{
    NSDate *mydate = picker.date;
    [self changeDateLabel:mydate];
}

-(void)toSelectDate:(UITapGestureRecognizer *)tap
{
    _bgBlackView.hidden = NO;
    [self showDatePicker];
}
-(void)toSelectTime:(UITapGestureRecognizer *)tap
{
    _bgBlackView.hidden = NO;
    [self showTimePicker];
}

-(void)toSelectUnBreakTime:(UITapGestureRecognizer *)tap
{
    _bgBlackView.hidden = NO;
    [self showUnpaidPicker];
}

-(void)showDatePicker
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        _datePicker.hidden = NO;
        _pickerViewTime.hidden = YES;
        _pickerViewUnpaid.hidden = YES;
    }
                     completion:^(BOOL finish){
                     }];
}

-(void)showTimePicker
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - pickerViewHeight, ScreenWidth, pickerViewHeight);
        _datePicker.hidden = YES;
        _pickerViewTime.hidden = NO;
        _pickerViewUnpaid.hidden = YES;
    }
                     completion:^(BOOL finish){
                     }];
}

-(void)showUnpaidPicker
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - pickerViewHeight, ScreenWidth, pickerViewHeight);
        _datePicker.hidden = YES;
        _pickerViewTime.hidden = YES;
        _pickerViewUnpaid.hidden = NO;
    }
                     completion:^(BOOL finish){
                     }];
}

-(void)hidebgBlackView:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, pickerViewHeight);
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([pickerView isEqual:_pickerViewUnpaid]) {
        return 1;
    }
    else
        return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:_pickerViewUnpaid]) {
        return unpaidPickerArray.count;
    }
    else{
        if (component == 0) {
            return firstTimePickerArray.count;
        }
        else
            return secondTimePickerArray.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:_pickerViewUnpaid]) {
        return [unpaidPickerArray objectAtIndex:row];
    }
    else{
        if (component == 0) {
            return [firstTimePickerArray objectAtIndex:row];
        } else {
            return [secondTimePickerArray objectAtIndex:row];
        }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:_pickerViewUnpaid]) {
        
        [UIView animateWithDuration:AnimatedDuration animations:^{
            //unpaidIndex = row;
            selectUnpaidTime = [NSString stringWithFormat:@"%@",[unpaidPickerArray objectAtIndex:row]];
            if (row == 0) {
                selectUnpaidTime = nil;
                [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
            }
            _unBreakTimeLabel.text = [NSString stringWithFormat:@"%@",selectUnpaidTime];
            
            NSString *floathour = [NSString stringWithFormat:@"%.2fh",[StringManager getIntervalHoursFromTowTime:_startTimeLabel.text andTime2:_endTimeLabel.text]];
            if (selectUnpaidTime == nil || [StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:selectUnpaidTime] < 0) {
                NSDictionary *dict = [StringManager getHourAndMin:floathour];
                _totalHoursLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                _unBreakTimeLabel.text = @"none";
                selectUnpaidTime = nil;
                [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
            }
            else
            {
                NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:selectUnpaidTime]]];
                _totalHoursLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
            }
            
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        if (component == 0) {
            
            firstTimeIndex = row;
            
            if (row == firstTimePickerArray.count-1) {
                secondTimeIndex = 0;
            }
            else
            {
                if (row == 0) {
                    secondTimeIndex = 1;
                }
                else
                {
                    if (secondTimeIndex <= row) {
                        secondTimeIndex = row + 1;
                    }
                }
            }
            
            [_pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
            
            [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
            
        }
        else {
            
            secondTimeIndex = row;
            
            //当前选择的时间是否大于开始的时间，若小于，则更新conpoment 0
            NSString *time_1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
            NSString *time_2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
            float timeInterval = [StringManager getIntervalHoursFromTowTime:time_1 andTime2:time_2];
            if (timeInterval < 0) {
                
                if (row == 0) {
                    firstTimeIndex = firstTimePickerArray.count - 1;
                }
                else
                {
                    firstTimeIndex = row - 1;
                }
                
                [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
            }
            [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
        }
    }
}

-(void)changeDateLabel:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    string_date = temp;
    stamp_date = [StringManager stringDateTransferTimeStamp:temp];
    str_year = [NSString stringWithFormat:@"%lu",(unsigned long)year];
    str_month = [NSString stringWithFormat:@"%@",[StringManager getEnglishMonth:month]];
    str_day = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    str_week = [StringManager featureWeekdayWithDate:year andMonth:month andDay:day];
    
    _dateLabel.text = [NSString stringWithFormat:@"%@, %@ %lu, %lu",str_week,[StringManager getEnglishMonth:month],day,year];
    
    if (time1 == nil) {
        time1 = @"5:00";
    }
    if (time2 == nil) {
        time2 = @"5:15";
    }
    NSString *time_1 = [NSString stringWithFormat:@"%@ %@",temp,time1];
    stamp_startTimeStamp = [StringManager stringDateTimeTransferTimeStamp:time_1];
    NSString *time_2 = [NSString stringWithFormat:@"%@ %@",temp,time2];
    stamp_endTimeStamp = [StringManager stringDateTimeTransferTimeStamp:time_2];
}
-(void)changeTimeLabel:(NSString *)str1 and:(NSString *)str2
{
    selectTime = [NSString stringWithFormat:@"%@ - %@",str1,str2];
    _startTimeLabel.text = [NSString stringWithFormat:@"%@",str1];
    _endTimeLabel.text = [NSString stringWithFormat:@"%@",str2];
    
    NSString *floathour = [NSString stringWithFormat:@"%.2fh",[StringManager getIntervalHoursFromTowTime:str1 andTime2:str2]];
    if (selectUnpaidTime == nil || [StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:selectUnpaidTime] < 0) {
        NSDictionary *dict = [StringManager getHourAndMin:floathour];
        _totalHoursLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
        _unBreakTimeLabel.text = @"none";
        selectUnpaidTime = nil;
        [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:selectUnpaidTime]]];
        _totalHoursLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
    }
    
    if ([str1 containsString:@"p.m."]) {
        NSRange range = [str1 rangeOfString:@":"];
        NSString *preTwo = [str1 substringToIndex:range.location];
        NSInteger re = [preTwo intValue];
        if (![preTwo containsString:@"12"]) {
            re = [preTwo intValue] + 12;
        }
        str1 = [str1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:",preTwo] withString:[NSString stringWithFormat:@"%lu:",(long)re]];
        str1 = [str1 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
        time1 = str1;
        str1 = [NSString stringWithFormat:@"%@ %@",string_date,str1];
    }
    else
    {
        str1 = [str1 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
        time1 = str1;
        str1 = [NSString stringWithFormat:@"%@ %@",string_date,str1];
    }
    stamp_startTimeStamp = [StringManager stringDateTimeTransferTimeStamp:str1];
    
    if ([str2 containsString:@"p.m."]) {
        NSRange range = [str2 rangeOfString:@":"];
        NSString *preTwo = [str2 substringToIndex:range.location];
        NSInteger re = [preTwo intValue];
        if (![preTwo containsString:@"12"]) {
            re = [preTwo intValue] + 12;
        }
        str2 = [str2 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:",preTwo] withString:[NSString stringWithFormat:@"%lu:",(long)re]];
        str2 = [str2 stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
        time2 = str2;
        str2 = [NSString stringWithFormat:@"%@ %@",string_date,str2];
    }
    else
    {
        str2 = [str2 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
        time2 = str2;
        str2 = [NSString stringWithFormat:@"%@ %@",string_date,str2];
    }
    stamp_endTimeStamp = [StringManager stringDateTimeTransferTimeStamp:str2];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_historyShiftTime.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }
    return 60;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"history";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    cell.backgroundColor = SetColor(245, 245, 245, 1.0);
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.row == 0) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 100, 39)];
        lab.text = @"History";
        lab.textColor = SetColor(0, 0, 0, 0.87);
        lab.font = [UIFont fontWithName:SemiboldFontName size:14.0];
        [cell.contentView addSubview:lab];
    }
    else
    {
        if (arr_historyShiftTime.count != 0) {
            
            HistoryShiftTime *history = [arr_historyShiftTime objectAtIndex:indexPath.row-1];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 200, 20)];
            label.text = [NSString stringWithFormat:@"%@ - %@",history.string_startTime,history.string_endTime];
            label.textColor = SetColor(0, 0, 0, 0.87);
            [cell.contentView addSubview:label];
            UIImageView *ima1 = [[UIImageView alloc]initWithFrame:CGRectMake(16, 34, 16, 16)];
            ima1.image = [UIImage imageNamed:@"shiftdetail_time"];
            UIImageView *ima2 = [[UIImageView alloc]initWithFrame:CGRectMake(128, 34, 16, 16)];
            ima2.image = [UIImage imageNamed:@"shiftdetail_break"];
            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(38, 34, 80, 16)];
            lab1.alpha = 0.54;
            lab1.font = [UIFont systemFontOfSize:12.0];
            lab1.text = [NSString stringWithFormat:@"%.2f hours",[history.string_hours floatValue]];
            UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(150, 34, 80, 16)];
            lab2.textColor = TextColorAlpha_54;
            lab2.font = [UIFont systemFontOfSize:12.0];
            lab2.text = history.string_break;
            
            
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(_tableView.frame.size.width-60, 0, 60, 60);
            [addBtn setImage:[UIImage imageNamed:@"addAvailable"] forState:UIControlStateNormal];
            addBtn.userInteractionEnabled = NO;
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, 59.5, _tableView.frame.size.width-16, 0.5)];
            line.backgroundColor = SetColor(0, 0, 0, 0.1);
            
            [cell.contentView addSubview:ima1];
            [cell.contentView addSubview:ima2];
            [cell.contentView addSubview:lab1];
            [cell.contentView addSubview:lab2];
            [cell.contentView addSubview:addBtn];
            [cell.contentView addSubview:line];
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HistoryShiftTime *history = [arr_historyShiftTime objectAtIndex:indexPath.row-1];
    _unBreakTimeLabel.text = history.string_break;
    selectUnpaidTime = history.string_break;
    [self changeTimeLabel:history.string_startTime and:history.string_endTime];
    
    firstTimeIndex = [firstTimePickerArray indexOfObject:history.string_startTime];
    secondTimeIndex = [secondTimePickerArray indexOfObject:history.string_endTime];
    [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
    [_pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
    [_pickerViewTime reloadAllComponents];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        HistoryShiftTime *history = [arr_historyShiftTime objectAtIndex:indexPath.row-1];
        [arr_historyShiftTime removeObject:history];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [context deleteObject:history];
    }
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)next:(UIButton *)sender {
    //SaveShiftViewController_iphone
    SaveShiftViewController_iphone *save = [SaveShiftViewController_iphone new];
    NSMutableDictionary *dict_temp = [NSMutableDictionary dictionary];
    [dict_temp setObject:[NSString stringWithFormat:@"%@",stamp_date] forKey:@"start_dateStamp"];
    [dict_temp setObject:[NSString stringWithFormat:@"%@",stamp_startTimeStamp] forKey:@"start_timeStamp"];
    [dict_temp setObject:[NSString stringWithFormat:@"%@",stamp_endTimeStamp] forKey:@"end_timeStamp"];
    float interval = ([stamp_endTimeStamp longValue] - [stamp_startTimeStamp longValue])/3600.0;
    [dict_temp setObject:[NSString stringWithFormat:@"%f",interval] forKey:@"total_hours"];
    if(selectUnpaidTime == nil)
    {
        selectUnpaidTime = @"none";
        [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
    }
    [dict_temp setObject:selectUnpaidTime forKey:@"select_unpaidBreak"];
    [dict_temp setObject:str_year forKey:@"year"];
    [dict_temp setObject:str_month forKey:@"month"];
    [dict_temp setObject:str_day forKey:@"day"];
    [dict_temp setObject:str_week forKey:@"week"];
    [dict_temp setObject:selectTime forKey:@"select_time"];
    save.dict_pass = [NSMutableDictionary dictionaryWithDictionary:dict_temp];
    [self.navigationController pushViewController:save animated:YES];
}

@end
