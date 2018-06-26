//
//  EditShiftViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "EditShiftViewController_iphone.h"

#define HeaderImageName @"headerImageName"
#define HeaderTitle @"headerTitle"
#define placeHolder @"You can leave a message here."

#define datePickerHeight 200
#define pickerViewHeight 200

@interface EditShiftViewController_iphone ()
{
    
    UILabel *locationLabel;
    UILabel *positionLabel;
    UILabel *employeeLabel;
    
    UILabel *breakLabel;
    UILabel *hourLabel;
    
    Shifts *ori_shift;
    
    NSString *string_date;//2016-9-20
    NSString *stamp_date;//"2016-9-20" ->  "1474347600"
    NSString *stamp_startTimeStamp;//1474346700
    NSString *stamp_endTimeStamp;//1474347600
    NSString *str_year;//"2016"
    NSString *str_month;//JUN
    NSString *str_day;//18
    NSString *str_week;//Mon
    NSString *selectTime;//05:00 a.m. - 16:00 p.m.
    NSString *unbreak;
    NSString *time1;//05:00
    NSString *time2;//16:00
    NSString *employeeUuid;
    NSString *locationUuid;
    NSString *positionUuid;
    int myNumber;
    NSString *notes;
    
    NSArray *arr_header;
    
    NSMutableArray *firstTimePickerArray;
    NSMutableArray *secondTimePickerArray;
    NSMutableArray *unpaidPickerArray;
    
    NSInteger unpaidIndex;
    NSInteger firstTimeIndex;
    NSInteger secondTimeIndex;
    
    BOOL isShowPicker;
    
}
@end

@implementation EditShiftViewController_iphone
@synthesize uuid;

-(void) getlocationUuid:(NSMutableArray *)arr_locationuuid
{
    if (arr_locationuuid != nil) {
        locationUuid = [arr_locationuuid objectAtIndex:0];
        Locations *l = [DatabaseManager getLocationByUuid:locationUuid];
        locationLabel.text = l.name;
        Positions *po = [DatabaseManager getPositionByUuid:positionUuid];
        
        if (employeeUuid != nil && [l.employees containsString:employeeUuid] && [po.employees containsString:employeeUuid]) {
            
        }
        else
        {
            if (![_textView.text isEqualToString:placeHolder] && ![_textView.text isEqualToString:@""]) {
                notes = _textView.text;
            }
            else if ([_textView.text isEqualToString:placeHolder] || [_textView.text isEqualToString:@""])
            {
                notes = placeHolder;
            }
            employeeUuid = nil;
            employeeLabel.text = @"Open Shift";
            [_tableView reloadData];
        }
    }
}

-(void) getPositionUuid:(NSString *)positionuuid
{
    positionUuid = positionuuid;
    if (positionUuid == nil) {
        positionLabel.text = @"Unassigned";
    }
    Positions *po = [DatabaseManager getPositionByUuid:positionUuid];
    if (po != nil) {
        positionLabel.text = po.name;
    }
    if (![_textView.text isEqualToString:placeHolder] && ![_textView.text isEqualToString:@""]) {
        notes = _textView.text;
        _textView.textColor = TextColorAlpha_54;
    }
    else if ([_textView.text isEqualToString:placeHolder] || [_textView.text isEqualToString:@""])
    {
        notes = placeHolder;
        _textView.textColor = SetColor(0, 0, 0, 0.3);
    }
    [_tableView reloadData];
}

-(void) getEmployeeUuid:(NSString *)employeeuuid
{
    employeeUuid = employeeuuid;
    if (employeeUuid != nil) {
        Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
        employeeLabel.text = employee.fullName;
    }
    if (![_textView.text isEqualToString:placeHolder] && ![_textView.text isEqualToString:@""]) {
        notes = _textView.text;
    }
    else if ([_textView.text isEqualToString:placeHolder] || [_textView.text isEqualToString:@""])
    {
        notes = placeHolder;
    }
    [_tableView reloadData];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        unpaidIndex = 0;              //unpaid break 初始的默认显示行数
        firstTimeIndex = 20;        //time 初始的默认显示行数  －－ 0 component
        secondTimeIndex = 21;
        
        string_date = nil;
        
        isShowPicker = YES;
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self initData];
    
    [self initView];
    
    [self initPickerViewData];
    
    [self initPicker];
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    [self setOriShift];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initView
{
    self.view.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    if (_line2 == nil) {
        _line2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 1, 50)];
        _line2.backgroundColor = SetColor(240, 240, 240, 1.0);
        [_bottomView addSubview:_line2];
    }
    
    if (_unPublishBtn == nil) {
        _unPublishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _unPublishBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
        [_unPublishBtn setTitle:@"Un-Publish" forState:UIControlStateNormal];
        [_unPublishBtn setTitleColor:SetColor(252, 103, 33, 1.0) forState:UIControlStateNormal];
        _unPublishBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_unPublishBtn];
        [_unPublishBtn addTarget:self action:@selector(setUnPublish) forControlEvents:UIControlEventTouchUpInside];
        Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
        if (shift.takeState == 0) {
            _unPublishBtn.alpha = 0.5;
            _unPublishBtn.userInteractionEnabled = NO;
        }
    }
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _deleteBtn.frame = CGRectMake(ScreenWidth/2+1, 1, ScreenWidth/2, 49);
        [_deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_deleteBtn setTitleColor:SetColor(247, 40, 40, 1.0) forState:UIControlStateNormal];
        [_bottomView addSubview:_deleteBtn];
        [_deleteBtn addTarget:self action:@selector(deleteShift) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setOriShift
{
    if (ori_shift == nil) {
        
        ori_shift = [DatabaseManager getShiftByUuid:uuid];
        
        string_date = [NSString stringWithFormat:@"%@-%lu-%@",ori_shift.string_year,[StringManager getNumberMonth:ori_shift.string_month],ori_shift.string_day];
        stamp_date = ori_shift.startDate;
        stamp_startTimeStamp = ori_shift.startTime;
        stamp_endTimeStamp = ori_shift.endTime;
        str_year = ori_shift.string_year;
        str_month = ori_shift.string_month;
        str_day = ori_shift.string_day;
        str_week = ori_shift.string_week;
        selectTime = ori_shift.string_time;
        NSInteger index = [unpaidPickerArray indexOfObject:ori_shift.unpaidBreak];
        [_pickerViewUnpaid selectRow:index inComponent:0 animated:YES];
        NSDictionary *dict = [StringManager interceptionTime:selectTime];
        time1 = [dict objectForKey:@"str1"];
        time2 = [dict objectForKey:@"str3"];
        NSString *str1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
        NSString *str2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
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
        }
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
        }
        unbreak = ori_shift.unpaidBreak;
        employeeUuid = ori_shift.employeeUuid;
        if ([ori_shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
            employeeUuid = nil;
        }
        locationUuid = ori_shift.locationUuid;
        positionUuid = ori_shift.positionUuid;
        myNumber = ori_shift.needEmployeesNumber;
        notes = ori_shift.notes;
        if ([notes length] == 0 || notes == nil) {
            notes = placeHolder;
        }
        
    }
}

-(void)initData
{
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_date_dark",HeaderImageName,@"DATE",HeaderTitle, nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_time_dark",HeaderImageName,@"FROM",HeaderTitle, nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_unpaid_dark",HeaderImageName,@"UNPAID BREAK",HeaderTitle, nil];
    NSArray *arr1 = [NSArray arrayWithObjects:dict1,dict2,dict3, nil];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_location_dark",HeaderImageName,@"LOCATION",HeaderTitle, nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_position_dark",HeaderImageName,@"POSITION",HeaderTitle, nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_who_dark",HeaderImageName,@"EMPLOYEE",HeaderTitle, nil];
    NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_number",HeaderImageName,@"NUMBER",HeaderTitle, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:dict4,dict5,dict6,dict7, nil];
    
    NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_notes_dark",HeaderImageName,@"NOTE",HeaderTitle, nil];
    NSArray *arr3 = [NSArray arrayWithObjects:dict8, nil];
    
    arr_header = [NSArray arrayWithObjects:arr1,arr2,arr3, nil];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr_temp = [NSArray arrayWithArray:[arr_header objectAtIndex:section]];
    return arr_temp.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 60;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)
    {
        return 66;
    }
    else if (indexPath.section == 1 && indexPath.row == 3)
    {
        if (employeeUuid != nil) {
            _textField.hidden = YES;
            return 0;
        }
        else
        {
            _textField.hidden = NO;
            return 44;
        }
    }
    else if (indexPath.section == 2)
    {
        return 200;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *arr = [NSArray arrayWithArray:[arr_header objectAtIndex:indexPath.section]];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[arr objectAtIndex:indexPath.row]];
    
    UIImageView *imageview_header = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 24, 24)];
    imageview_header.image = [UIImage imageNamed:[dict objectForKey:HeaderImageName]];
    [cell.contentView addSubview:imageview_header];
    
    UILabel *lab_title = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 120, 44)];
    lab_title.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    lab_title.textColor = SetColor(0, 0, 0, 0.87);
    [lab_title setText:[dict objectForKey:HeaderTitle]];
    [cell.contentView addSubview:lab_title];

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-116, 44)];
            detailLabel.textAlignment = NSTextAlignmentRight;
            detailLabel.font = [UIFont fontWithName:RegularFontName size:17.0];
            detailLabel.textColor = TextColorAlpha_54;
            [cell.contentView addSubview:detailLabel];
            
            NSString *content = [NSString stringWithFormat:@"%@, %@ %@, %@",str_week,str_month,str_day,str_year];
            detailLabel.text = content;
        }
        else if (indexPath.row == 1) {
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            imageview_header.frame = CGRectMake(16, 16, 24, 24);
            lab_title.frame = CGRectMake(50, 13, 60, 16);
            lab_title.text = @"FROM";
            
            UIImageView *imageview_middle = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 16, 60)];
            imageview_middle.image = [UIImage imageNamed:@"s_path"];
            
            NSDictionary *d = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:selectTime]];
            
            UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(50, 31, 80, 16)];
            lab2.font = [UIFont systemFontOfSize:14.0];
            lab2.textColor = TextColorAlpha_54;
            lab2.text = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str1"],[d objectForKey:@"str2"]];
            
            UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(imageview_middle.frame.origin.x+16+30, 5, 80, 30)];
            lab3.text = @"TO";
            lab3.font = [UIFont fontWithName:SemiboldFontName size:14.0];
            lab3.textColor = SetColor(0, 0, 0, 0.87);
            
            UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.frame.origin.x, 31, 80, 16)];
            lab4.font = [UIFont systemFontOfSize:14.0];
            lab4.textColor = TextColorAlpha_54;
            lab4.text = [NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str3"],[d objectForKey:@"str4"]];
            
            
            [cell.contentView addSubview:imageview_middle];
            [cell.contentView addSubview:lab2];
            [cell.contentView addSubview:lab3];
            [cell.contentView addSubview:lab4];
        }
        else
        {
            breakLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-116, 44)];
            breakLabel.textAlignment = NSTextAlignmentRight;
            breakLabel.font = [UIFont fontWithName:RegularFontName size:17.0];
            breakLabel.textColor = TextColorAlpha_54;
            [cell.contentView addSubview:breakLabel];

            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth-16, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            NSString *content = unbreak;
            NSDictionary *d = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:selectTime]];
            NSString *floathour = [NSString stringWithFormat:@"%.2f",[StringManager getIntervalHoursFromTowTime:[NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str1"],[d objectForKey:@"str2"]] andTime2:[NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str3"],[d objectForKey:@"str4"]]]];
            
            if (unbreak == nil || [StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak] < 0) {
                content = @"none";
                [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
            }
            
            hourLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, _tableView.frame.size.width, 22)];
            hourLabel.font = [UIFont systemFontOfSize:12.0];
            hourLabel.textColor = TextColorAlpha_54;
            hourLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:hourLabel];
            
            if (unbreak != nil) {
                
                if ([StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak] < 0) {
                    NSDictionary *dict = [StringManager getHourAndMin:floathour];
                    hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                }
                else
                {
                    NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak]]];
                    hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                }
            }
            else
            {
                NSDictionary *dict = [StringManager getHourAndMin:floathour];
                hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
            }
            breakLabel.text = content;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row != 3) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            if (indexPath.row == 2 && employeeUuid != nil) {
                line.hidden = YES;
            }
        }
        if (indexPath.row == 0) {
            Locations *location = [DatabaseManager getLocationByUuid:locationUuid];
            locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            locationLabel.textColor = TextColorAlpha_54;
            locationLabel.text = location.name;
            locationLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:locationLabel];
        }
        else if (indexPath.row == 1)
        {
            NSString *name = @"Unassigned";
            Positions *position = [DatabaseManager getPositionByUuid:positionUuid];
            if (position != nil) {
                name = position.name;
            }
            positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            positionLabel.textColor = TextColorAlpha_54;
            positionLabel.text = name;
            positionLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:positionLabel];
        }
        else if (indexPath.row == 2)
        {
            NSString *name = @"Open Shift";
            if (employeeUuid != nil) {
                Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
                name = employee.fullName;
                if(employee == nil)
                {
                    name = ori_shift.employeeName;
                }
            }
            employeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            employeeLabel.textColor = TextColorAlpha_54;
            employeeLabel.text = name;
            employeeLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:employeeLabel];
        }
        else if (indexPath.row == 3) {
            
            _textField = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-96, 0, 80, 50)];
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textField.delegate = self;
            _textField.textColor = TextColorAlpha_54;
            _textField.textAlignment = NSTextAlignmentRight;
            if (myNumber == 0) {
                myNumber = 1;
            }
            _textField.text = [NSString stringWithFormat:@"%d",myNumber];
            [cell.contentView addSubview:_textField];
            if ([employeeUuid isEqualToString:OpenShiftEmployeeUuid] || employeeUuid == nil) {
                _textField.hidden = NO;
                imageview_header.hidden = NO;
                lab_title.hidden = NO;
            }
            else
            {
                _textField.hidden = YES;
                imageview_header.hidden = YES;
                lab_title.hidden = YES;
            }
        }
    }
    else
    {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(46, 30, _tableView.frame.size.width-66, 170)];
        _textView.delegate = self;
        _textView.textColor = TextColorAlpha_54;
        _textView.text = notes;
        _textView.font = [UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:_textView];
        UIToolbar * topKeyboardView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 30)];
        [topKeyboardView setBarStyle:UIBarStyleDefault];
        if (ScreenWidth > 400) {
            topKeyboardView.frame = CGRectMake(0, 0,ScreenWidth, 42);
        }
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Done",nil,nil) style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [topKeyboardView setItems:buttonsArray];
        
        [_textView setInputAccessoryView:topKeyboardView];
    }
    return cell;
}


-(void)dismissKeyBoard
{
    [_textView resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        _bgBlackView.hidden = NO;
        
        if (indexPath.row == 0) {
            
            [self showDatePicker];
        }
        else if (indexPath.row == 1)
        {
            [self showTimePicker];
        }
        else
        {
            [self showUnpaidPicker];
        }
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            LocationListViewController_iphone *locationV = [LocationListViewController_iphone new];
            locationV.locationUuid = locationUuid;
            locationV.delegate = self;
            [self presentViewController:locationV animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            PositionListViewController_iphone *positionV = [PositionListViewController_iphone new];
            positionV.positionUuid = positionUuid;
            positionV.delegate = self;
            [self presentViewController:positionV animated:YES completion:nil];
        }
        else if (indexPath.row == 2)
        {
            EmployeeListViewController_iphone *employeeV = [EmployeeListViewController_iphone new];
            employeeV.locationuuid = locationUuid;
            employeeV.positionuuid = positionUuid;
            employeeV.employeeUuid = employeeUuid;
            employeeV.delegate = self;
            employeeV.startTimeStamp = stamp_startTimeStamp;
            employeeV.endTimeStamp = stamp_endTimeStamp;
            employeeV.startDateStamp = stamp_date;
            [self.navigationController pushViewController:employeeV animated:YES];
        }
    }
}
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder])
    {
        textView.text = @"";
    }
    if (ScreenWidth == 320) {

        [_tableView setContentOffset:CGPointMake(0.0, 140.0) animated:YES];
    }
    else if (ScreenWidth == 375)
    {
        [_tableView setContentOffset:CGPointMake(0, 105) animated:YES];
    }
    else
    {
        [_tableView setContentOffset:CGPointMake(0.0, 70.0) animated:YES];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([string length] < 1){
        textView.text = placeHolder;
    }
    notes = _textView.text;
    [_tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_textField resignFirstResponder];
    myNumber = [_textField.text intValue];
    if (myNumber == 0) {
        myNumber = 1;
        _textField.text = @"1";
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    myNumber = [_textField.text intValue];
    notes = _textView.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUnPublish
{
    if (ori_shift.takeState == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        Shifts *shift = [DatabaseManager getShiftByUuid:ori_shift.uuid];
        if (shift != nil) {
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            DDBDataModel *model = [[DDBDataModel alloc]init];
            model.createDate = shift.createDate;
            model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
            model.uuid = shift.uuid;
            model.managerUuid = shift.managerUuid;
            model.parentUuid = shift.parentUuid;
            model.tableIdentityID = @"Shifts";
            model.isDelete = [NSNumber numberWithShort:shift.isDelete];
            model.shift_employeeUuid = shift.employeeUuid;
            if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                model.shift_employeeName = OpenShiftEmployeeName;
            }
            else
            {
                Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
                if (employee != nil) {
                    model.shift_employeeName = employee.fullName;
                }
                else
                {
                    model.shift_employeeName = shift.employeeName;
                }
            }
            if (shift.positionUuid != nil) {
                model.shift_positionUuid = shift.positionUuid;
            }
            model.shift_locationUuid = shift.locationUuid;
            model.shift_startDate = shift.startDate;
            model.shift_startTime = shift.startTime;
            model.shift_endTime = shift.endTime;
            model.shift_totalHours = shift.totalHours;
            model.shift_unPaidBreak = shift.unpaidBreak;
            model.shift_employeesNumbers = [NSNumber numberWithShort:shift.needEmployeesNumber];
            if (shift.notes != nil) {
                model.shift_notes = shift.notes;
            }
            model.shift_strYear = shift.string_year;
            model.shift_strMonth = shift.string_month;
            model.shift_strDay = shift.string_day;
            model.shift_strWeek = shift.string_week;
            model.shift_strTime = shift.string_time;
            model.shift_isTake = [NSNumber numberWithInt:0];
            model.shift_haveTakedEmployeesNumber = [NSNumber numberWithShort:shift.haveTakedEmployeesNumber];
            model.shift_takedState = [NSNumber numberWithInt:0];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper save:model]
             continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
                 if (task.error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                         NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:okAction];
                         [self presentViewController:alertController animated:YES completion:nil];
                     });
                 }
                 else {
                     if ([model isKindOfClass:[DDBDataModel class]]) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                             
                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                             NSManagedObjectContext *context = [appDelegate managedObjectContext];
                             
                             shift.isTake = 0;
                             shift.takeState = 0;
                             
                             [context save:nil];
                             
                             [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:1];

                             for (UIViewController *controller in self.navigationController.viewControllers) {
                                 if ([controller isKindOfClass:[MyScheduleViewController_phone class]] || [controller isKindOfClass:[RequestViewController_phone class]]) {
                                     [self.navigationController popToViewController:controller animated:YES];
                                 }
                             }
                         });
                     }
                 }
                 return nil;
             }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

//删除shift，删除这个shift相关的drop或swap
-(void)deleteShift
{
    Shifts *shift = [DatabaseManager getShiftByUuid:ori_shift.uuid];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    alertController.view.tintColor = AppMainColor;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Shift" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        if (shift != nil) {
            
            if(![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
            {
                //删除当下的swap或者drop
                NSMutableArray *arr_request = [DynamoDBManager getShiftAndDrop:shift.uuid];
                if (arr_request.count != 0) {
                    
                    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
                    AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
                    AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
                    batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_request};
                    batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
                    [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
                        if (task.error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                            });
                        }
                        else
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                AWSDynamoDBBatchWriteItemOutput *batchWriteItemOutput = task.result;
                                NSArray *consumedCapacity = batchWriteItemOutput.consumedCapacity;
                                NSLog(@"%lu",(unsigned long)consumedCapacity.count);
                                
                                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                
                                [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:1];
                                
                                Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
                                NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
                                
                                NSString *message = [NSString stringWithFormat:@"%@\n%@",Notification_DeletedShift,[DatabaseManager getMyselfNotificationOfShift:shift]];
                                
                                for(DeviceToken *device in arr_device)
                                {
                                    if(device.deviceToken != nil && device.endPointArn != nil && setting.email_isScheduleUpdate == 1)
                                    {
                                        AWSSNS *sns = [AWSSNS defaultSNS];
                                        AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                                        input.message = message;
                                        input.targetArn = device.endPointArn;
                                        
                                        [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
                                            
                                        }];
                                    }
                                }
                                
                                NSArray *arr_drop = [DatabaseManager getDropAndSwapByShiftUuid:shift.uuid];
                                for (Drop *drop in arr_drop) {
                                    
                                    [context deleteObject:drop];
                                    [context save:nil];
                                }
                                //删除置顶employee的shift，先像employee发送邮件通知，再本地删除
                                
                                [context deleteObject:shift];
                                [context save:nil];
                                
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                
                                for (UIViewController *controller in self.navigationController.viewControllers) {
                                    if ([controller isKindOfClass:[MyScheduleViewController_phone class]] || [controller isKindOfClass:[RequestViewController_phone class]]) {
                                        [self.navigationController popToViewController:controller animated:YES];
                                    }
                                }
                            });
                        }
                        return nil;
                    }];
                }
                else
                {
                    [self deleteOnlyOneShift:shift];
                }
            }
            else
            {
                [self deleteOnlyOneShift:shift];
            }
        }
        else
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MyScheduleViewController_phone class]] || [controller isKindOfClass:[RequestViewController_phone class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
        
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) deleteOnlyOneShift:(Shifts *) shift
{
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    DDBDataModel *model = [[DDBDataModel alloc]init];
    model.createDate = shift.createDate;
    model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    model.uuid = shift.uuid;
    model.managerUuid = shift.managerUuid;
    model.parentUuid = shift.parentUuid;
    model.tableIdentityID = @"Shifts";
    model.isDelete = [NSNumber numberWithInt:1];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper save:model]
     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
         if (task.error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                 NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                 [alertController addAction:okAction];
                 [self presentViewController:alertController animated:YES completion:nil];
             });
         }
         else {
             if ([model isKindOfClass:[DDBDataModel class]]) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     
                     [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:1];
                     
                     Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
                     NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
                     NSString *message = [NSString stringWithFormat:@"%@\n%@",Notification_DeletedShift,[DatabaseManager getMyselfNotificationOfShift:shift]];
                     for(DeviceToken *device in arr_device)
                     {
                         if(device.deviceToken != nil && device.endPointArn != nil && setting.email_isScheduleUpdate == 1)
                         {
                             AWSSNS *sns = [AWSSNS defaultSNS];
                             AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                             input.message = message;
                             input.targetArn = device.endPointArn;
                             
                             [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
                                 
                             }];
                         }
                     }
                     
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                     [context deleteObject:shift];
                     [context save:nil];
                     
                     for (UIViewController *controller in self.navigationController.viewControllers) {
                         if ([controller isKindOfClass:[MyScheduleViewController_phone class]] || [controller isKindOfClass:[RequestViewController_phone class]]) {
                             [self.navigationController popToViewController:controller animated:YES];
                         }
                     }
                 });
             }
         }
         return nil;
     }];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveModifyShift:(UIButton *)sender {
    
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    
    if ([self judgeIsChange] == NO) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        Shifts *shift = [DatabaseManager getShiftByUuid:ori_shift.uuid];
        
        DDBDataModel *model = [[DDBDataModel alloc]init];
        model.createDate = shift.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = shift.uuid;
        model.managerUuid = shift.managerUuid;
        model.parentUuid = shift.parentUuid;
        model.tableIdentityID = @"Shifts";
        model.isDelete = [NSNumber numberWithShort:shift.isDelete];
        if (employeeUuid != nil) {
            model.shift_employeeUuid = employeeUuid;
            model.shift_isTake = [NSNumber numberWithInt:0];
            Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
            if (employee != nil) {
                model.shift_employeeName = employee.fullName;
            }
            else
            {
                model.shift_employeeName = shift.employeeName;
            }
        }
        else
        {
            model.shift_employeeUuid = OpenShiftEmployeeUuid;
            model.shift_employeeName = OpenShiftEmployeeName;
            if (myNumber == 0) {
                myNumber = 1;
            }
            model.shift_employeesNumbers = [NSNumber numberWithInt:myNumber];
            model.shift_haveTakedEmployeesNumber = [NSNumber numberWithInt:0];
        }

        if (positionUuid != nil) {
            Positions *position = [DatabaseManager getPositionByUuid:positionUuid];
//            if (position.isDelete == 0 && position != nil) {
//                model.shift_positionUuid = positionUuid;
//            }
        }
        model.shift_locationUuid = locationUuid;
        model.shift_startDate = stamp_date;
        model.shift_startTime = stamp_startTimeStamp;
        model.shift_endTime = stamp_endTimeStamp;
        float interval = ([stamp_endTimeStamp longLongValue] - [stamp_startTimeStamp longLongValue])/3600.0;
        model.shift_totalHours = [NSString stringWithFormat:@"%f",interval];
        NSString *floathour = model.shift_totalHours;
        if (unbreak != nil) {
            
            if ([StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak] < 0) {
                unbreak = @"none";
                [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
            }
            else
            {
                model.shift_totalHours = [NSString stringWithFormat:@"%.2f",[StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak]];
            }
        }
        else {
            unbreak = @"none";
            [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
        }
        model.shift_unPaidBreak = unbreak;
        if ([notes length] != 0 && notes != nil && ![notes isEqualToString:@""] && ![notes isEqualToString:placeHolder]) {
            model.shift_notes = notes;
        }
        model.shift_strYear = str_year;
        model.shift_strMonth = str_month;
        model.shift_strDay = str_day;
        model.shift_strWeek = str_week;
        model.shift_strTime = selectTime;
        model.shift_takedState = [NSNumber numberWithShort:shift.takeState];
        
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        [[dynamoDBObjectMapper save:model]
         continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
             if (task.error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:okAction];
                     [self presentViewController:alertController animated:YES completion:nil];
                 });
             }
             else {
                 if ([model isKindOfClass:[DDBDataModel class]]) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         NSManagedObjectContext *context = [appDelegate managedObjectContext];
                         
                         shift.modifyDate = model.modifyDate;
                         shift.employeeUuid = model.shift_employeeUuid;
                         shift.employeeName = model.shift_employeeName;
                         shift.locationUuid = model.shift_locationUuid;
                         shift.positionUuid = model.shift_positionUuid;
                         shift.startDate = model.shift_startDate;
                         shift.startTime = model.shift_startTime;
                         shift.endTime = model.shift_endTime;
                         shift.totalHours = model.shift_totalHours;
                         shift.unpaidBreak = model.shift_unPaidBreak;
                         shift.notes = model.shift_notes;
                         shift.string_year = model.shift_strYear;
                         shift.string_month = model.shift_strMonth;
                         shift.string_day = model.shift_strDay;
                         shift.string_week = model.shift_strWeek;
                         shift.string_time = model.shift_strTime;
                         shift.needEmployeesNumber = [model.shift_employeesNumbers shortValue];
                         
                         [context save:nil];
                         
                         [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:0];
                         
                         if(![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
                         {
                             NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
                             NSString *message = [NSString stringWithFormat:@"%@\n%@",Notification_ModifiedShift,[DatabaseManager getMyselfNotificationOfShift:shift]];
                             for (DeviceToken *device in arr_device) {

                                 Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
                                 if(device.deviceToken != nil && device.endPointArn != nil && setting.notification_isScheduleUpdate == 1)
                                 {
                                     AWSSNS *sns = [AWSSNS defaultSNS];
                                     AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                                     input.message = message;
                                     input.targetArn = device.endPointArn;
                                     [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
 
                                     }];
                                 }
                             }
                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else
                         {
                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     });
                 }
             }
             return nil;
         }];
    }
}


-(BOOL)judgeIsChange
{
    BOOL isChange = NO;
    if (![ori_shift.employeeUuid isEqualToString:employeeUuid]) {
        isChange = YES;
    }
    else if(![ori_shift.locationUuid isEqualToString:locationUuid])
    {
        isChange = YES;
    }
    else if (![ori_shift.startDate isEqualToString:stamp_date])
    {
        isChange = YES;
    }
    else if (![ori_shift.startTime isEqualToString:stamp_startTimeStamp])
    {
        isChange = YES;
    }
    else if (![ori_shift.endTime isEqualToString:stamp_endTimeStamp])
    {
        isChange = YES;
    }
    else if (![ori_shift.unpaidBreak isEqualToString:unbreak])
    {
        isChange = YES;
    }
    else if (ori_shift.needEmployeesNumber != myNumber)
    {
        isChange = YES;
    }
    else if (ori_shift.notes != nil && notes != nil)
    {
        if (![ori_shift.notes isEqualToString:notes]) {
            isChange = YES;
        }
        else
        {
            if (ori_shift.positionUuid == nil && positionUuid == nil) {
                isChange = NO;
            }
            else
            {
                if (![ori_shift.positionUuid isEqualToString:positionUuid]) {
                    isChange = YES;
                }
            }
        }
    }
    else
    {
        if (ori_shift.positionUuid == nil && positionUuid == nil) {
            isChange = NO;
        }
        else
        {
            if (![ori_shift.positionUuid isEqualToString:positionUuid]) {
                isChange = YES;
            }
        }
    }
    return isChange;
}

/***************************    dispose date and time     *********************************/
-(void)initPicker
{
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
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        Shifts *shi = [DatabaseManager getShiftByUuid:uuid];
        NSNumber *numner = [NSNumber numberWithLong:(long)[shi.startDate longLongValue]];
        NSDate *shiftDate = [StringManager timeStampTransferDate:numner];
        _datePicker.date = shiftDate;
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
        [_pickerViewUnpaid selectedRowInComponent:unpaidIndex];
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
    firstTimePickerArray = (NSMutableArray *)[firstTimePickerArray subarrayWithRange:NSMakeRange(0, 96)];
    
    Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
    NSDictionary *dict = [StringManager interceptionTime:shift.string_time];
    NSString *mytime1 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
    NSString *mytime2 = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
    
    
    firstTimeIndex = [firstTimePickerArray indexOfObject:mytime1];
    secondTimeIndex = [secondTimePickerArray indexOfObject:mytime2];
}

-(void)dateChanged:(UIDatePicker *)picker
{
    NSDate *mydate = picker.date;
    [self changeDateLabel:mydate];
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
            unbreak = [NSString stringWithFormat:@"%@",[unpaidPickerArray objectAtIndex:row]];
            breakLabel.text = unbreak;
            if (row == 0) {
                unbreak = nil;
                breakLabel.text = @"none";
                [_pickerViewUnpaid selectRow:0 inComponent:0 animated:YES];
            }
            
            NSDictionary *d = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:selectTime]];
            NSString *floathour = [NSString stringWithFormat:@"%.2f",[StringManager getIntervalHoursFromTowTime:[NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str1"],[d objectForKey:@"str2"]] andTime2:[NSString stringWithFormat:@"%@ %@",[d objectForKey:@"str3"],[d objectForKey:@"str4"]]]];
            
            if (unbreak != nil) {
                
                if ([StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak] < 0) {
                    NSDictionary *dict = [StringManager getHourAndMin:floathour];
                    hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                }
                else
                {
                    NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2f",[StringManager isCorrectUnPaidBreak:[floathour floatValue] andUnPaid:unbreak]]];
                    hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
                }
            }
            else
            {
                NSDictionary *dict = [StringManager getHourAndMin:floathour];
                hourLabel.text = [NSString stringWithFormat:@"Total: %@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
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
            if (row == 0 || row == secondTimePickerArray.count-1) {
                firstTimeIndex = 0;
            }
            else
            {
                if (row <= firstTimeIndex) {
                    
                    firstTimeIndex = row-1;
                }
            }
            [_pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
            //当前选择的时间是否大于开始的时间，若小于，则更新conpoment 0
            NSString *time_1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
            NSString *time_2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
            [self changeTimeLabel:time_1 and:time_2];
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
    
    stamp_date = [NSString stringWithFormat:@"%@",[StringManager stringDateTransferTimeStamp:temp]];
    str_year = [NSString stringWithFormat:@"%lu",(unsigned long)year];
    str_month = [NSString stringWithFormat:@"%@",[StringManager getEnglishMonth:month]];
    str_day = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    str_week = [StringManager featureWeekdayWithDate:year andMonth:month andDay:day];
    
    
    NSString *time_1 = [NSString stringWithFormat:@"%@ %@",temp,time1];
    stamp_startTimeStamp = [NSString stringWithFormat:@"%@",[StringManager stringDateTimeTransferTimeStamp:time_1]];
    NSString *time_2 = [NSString stringWithFormat:@"%@ %@",temp,time2];
    stamp_endTimeStamp = [NSString stringWithFormat:@"%@",[StringManager stringDateTimeTransferTimeStamp:time_2]];
    
    [_tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)changeTimeLabel:(NSString *)str1 and:(NSString *)str2
{
    selectTime = [NSString stringWithFormat:@"%@ - %@",str1,str2];
    
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
    stamp_startTimeStamp = [NSString stringWithFormat:@"%@",[StringManager stringDateTimeTransferTimeStamp:str1]];
    
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
    stamp_endTimeStamp = [NSString stringWithFormat:@"%@",[StringManager stringDateTimeTransferTimeStamp:str2]];
    
    [_tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
