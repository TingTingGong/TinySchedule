//
//  CreateRequestViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "CreateRequestViewController_iphone.h"

#define datePickerHeight 200
#define HeaderViewHeight1 50
#define HeaderViewHeight2 60
#define LabelTitlewidth 120

#define HeaderImageName @"headerImageName"
#define HeaderTitle @"headerTitle"

#define placeHolder @"You can leave a message here."


@interface CreateRequestViewController_iphone ()
{
    NSMutableArray *arr_header;
    NSArray *arr_type;
    UILabel *lab_name;
    UILabel *lab_type;
    NSString *type;
    UISwitch *partialSwitch;
    BOOL isOpen;
    UITextField *field_hour;
    UITextView *message_textview;
    UILabel *label_date;
    UILabel *fromLabel;
    UILabel *toLabel;
    
    UIPickerView *pickerViewTime;
    UIDatePicker *datePicker;//partial day
    UIDatePicker *datePicker2;//wholeday1
    UIDatePicker *datePicker3;//wholeday2
    
    NSMutableArray *firstTimePickerArray;
    NSMutableArray *secondTimePickerArray;
    NSMutableArray *unpaidPickerArray;
    NSInteger firstTimeIndex;
    NSInteger secondTimeIndex;
    
    //仅仅是whole day
    NSString *whoday1;//Mon, JUN 18, 2016
    NSString *whoday2;//Mon, JUN 18, 2016
    
    //仅仅是partial day才有数据
    NSString *partialday;//Mon, JUN 18, 2016
    NSString *string_date;//2016-12-12
    NSString *time1;//05:00
    NSString *time2;//16:00
    
    NSNumber *stamp_startTimeStamp;//1474346700  可能是 2016-10-21 或 2016-10-21 8:00 a.m.
    NSNumber *stamp_endTimeStamp;//1474347600

}
@end

@implementation CreateRequestViewController_iphone

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arr_header = [NSMutableArray array];
        arr_type = [NSArray array];
        partialSwitch.on = NO;
        isOpen = NO;
        
        firstTimeIndex = 48;        //time 初始的默认显示行数  －－ 0 component
        secondTimeIndex = 49;       //time 初始的默认显示行数  －－ 1 component      //unpaid break  选中的value

        stamp_startTimeStamp = 0;
        stamp_endTimeStamp = 0;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    for (int i = 0; i < 7; i++) {
        NSMutableDictionary *dit = [NSMutableDictionary dictionary];
        if (i == 0) {
            [dit setObject:@"employee_dark" forKey:HeaderImageName];
            [dit setObject:@"WHO" forKey:HeaderTitle];
        }
        else if (i == 1) {
            [dit setObject:@"type_dark" forKey:HeaderImageName];
            [dit setObject:@"TIME-OFF TYPE" forKey:HeaderTitle];
        }
        else if (i == 2) {
            [dit setObject:@"partialDay" forKey:HeaderImageName];
            [dit setObject:@"PARTIAL DAY" forKey:HeaderTitle];
        }
        else if (i == 3) {
            [dit setObject:@"paidHours" forKey:HeaderImageName];
            [dit setObject:@"PAID HOURS" forKey:HeaderTitle];
        }
        else if (i == 4) {
            [dit setObject:@"s_date_dark" forKey:HeaderImageName];
            [dit setObject:@"DATE" forKey:HeaderTitle];
        }
        else if (i == 5) {
            [dit setObject:@"day_dark" forKey:HeaderImageName];
            [dit setObject:@"FROM" forKey:HeaderTitle];
        }
        else if (i == 6) {
            [dit setObject:@"message_dark" forKey:HeaderImageName];
            [dit setObject:@"MESSAGE" forKey:HeaderTitle];
        }
        [arr_header addObject:dit];
    }
    arr_type = [NSArray arrayWithObjects:@"Unpaid",@"Paid (PTO)",@"Sick",@"Holiday", nil];
    type = [arr_type objectAtIndex:0];
    
    NSString *pickerPath = [[NSBundle mainBundle] pathForResource:@"UnPaidBreakPlist" ofType:@"plist"];
    unpaidPickerArray = [NSMutableArray arrayWithContentsOfFile:pickerPath];
    
    NSString *timePlistPath = [[NSBundle mainBundle] pathForResource:@"TimePlist" ofType:@"plist"];
    firstTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    secondTimePickerArray = [NSMutableArray arrayWithContentsOfFile:timePlistPath];
    
    NSDate *currentDate = [NSDate date];
    [self changeDateLabel2:currentDate];
    [self changeDateLabel3:currentDate];
    
    if (_bgBlackView == nil) {
        
        _bgBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgBlackView.backgroundColor = SetColor(0, 0, 0, 0.1);
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
    
    if (datePicker == nil) {
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:datePicker];
    }
    if (datePicker2 == nil) {
        datePicker2 = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        datePicker2.datePickerMode = UIDatePickerModeDate;
        [datePicker2 addTarget:self action:@selector(dateChanged2:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:datePicker2];
    }
    if (datePicker3 == nil) {
        datePicker3 = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        datePicker3.datePickerMode = UIDatePickerModeDate;
        [datePicker3 addTarget:self action:@selector(dateChanged3:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:datePicker3];
    }
    if (pickerViewTime == nil) {
        pickerViewTime = [[UIPickerView alloc]initWithFrame:CGRectMake(0 , 0, ScreenWidth , datePickerHeight)];
        pickerViewTime.delegate = self;
        pickerViewTime.dataSource = self;
        [pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
        [pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
        [_bgWhiteView addSubview:pickerViewTime];
//        [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    }
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr_header.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        if (![type isEqualToString:[arr_type objectAtIndex:1]]) {
            field_hour.hidden = YES;
            return 0;
        }
        else
        {
            field_hour.hidden = NO;
            return HeaderViewHeight1;
        }
    }
    else if (section == 4 && partialSwitch.on == NO)
    {
        return 0;
    }
    else if (section == 5) {
        return HeaderViewHeight2;
    }
    else if (section == 6) {
        return 150;
    }
    return HeaderViewHeight1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 && isOpen == YES) {
        return arr_type.count;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeaderViewHeight1)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.tag = section;
    
    float_t wid = headerView.frame.size.width;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 24, 24)];
    imageView.image = [UIImage imageNamed:[[arr_header objectAtIndex:section] objectForKey:HeaderImageName]];
    [headerView addSubview:imageView];
    
    UILabel *label_title = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 120, HeaderViewHeight1)];
    label_title.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    label_title.textColor = TextColorAlpha_87;
    label_title.text = [NSString stringWithFormat:@"%@",[[arr_header objectAtIndex:section] objectForKey:HeaderTitle]];
    [headerView addSubview:label_title];
    
    if (section != 6) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, HeaderViewHeight1 - 0.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [headerView addSubview:line];
        if (section == 5) {
            line.frame = CGRectMake(16, HeaderViewHeight2 - 0.5, ScreenWidth, 0.5);
            imageView.frame = CGRectMake(15, 22, 25, 25);
        }
    }
    if (section == 6) {
        imageView.frame = CGRectMake(15, 7, 25, 25);
        label_title.frame = CGRectMake(50, 0, 120, 40);
    }
    
    if (section == 0) {
        lab_name = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, wid - 146, HeaderViewHeight1)];
        lab_name.textColor = TextColorAlpha_54;
        lab_name.font = [UIFont systemFontOfSize:17.0];
        lab_name.textAlignment = NSTextAlignmentRight;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        lab_name.text = appDelegate.currentEmployee.fullName;
        [headerView addSubview:lab_name];
    }
    else if (section == 1) {
        lab_type = [[UILabel alloc]initWithFrame:CGRectMake(130, 0, wid - 146, HeaderViewHeight1)];
        lab_type.textColor = TextColorAlpha_54;
        lab_type.font = [UIFont systemFontOfSize:17.0];
        lab_type.textAlignment = NSTextAlignmentRight;
        lab_type.text = type;
        [headerView addSubview:lab_type];
    }
    else if (section == 2) {
        
        partialSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(wid-66, 10, 0, 0)];
        partialSwitch.on = NO;
        [partialSwitch addTarget:self action:@selector(switchValueChange) forControlEvents:UIControlEventValueChanged];
        [headerView addSubview:partialSwitch];
    }
    else if (section == 3) {
        
        field_hour = [[UITextField alloc]initWithFrame:CGRectMake(160, 0, wid-176, HeaderViewHeight1)];
        field_hour.textColor = TextColorAlpha_54;
        field_hour.textAlignment = NSTextAlignmentRight;
        field_hour.keyboardType = UIKeyboardTypeNumberPad;
        field_hour.delegate = self;
        field_hour.placeholder = @"0";
        field_hour.font = [UIFont systemFontOfSize:17.0];
        [headerView addSubview:field_hour];
    }
    else if(section == 4){
        label_date = [[UILabel alloc]initWithFrame:CGRectMake(133, 0, wid - 149, HeaderViewHeight1)];
        label_date.textColor = TextColorAlpha_54;
        label_date.font = [UIFont systemFontOfSize:17.0];
        label_date.textAlignment = NSTextAlignmentRight;
        label_date.text = partialday;
        [headerView addSubview:label_date];
    }
    else if(section == 5){
        
        imageView.frame = CGRectMake(16, 18, 24, 24);
        label_title.frame = CGRectMake(50, 13, ScreenWidth-66, 16);
        UILabel *lab_title2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+30, 13, 60, 16)];
        lab_title2.font = [UIFont fontWithName:SemiboldFontName size:14.0];
        lab_title2.text = @"TO";

        [headerView addSubview:lab_title2];
        
        fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 31, ScreenWidth/2-30, 16)];
        fromLabel.textColor = TextColorAlpha_54;
        fromLabel.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:fromLabel];
        
        toLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab_title2.frame.origin.x, 31, ScreenWidth/2-30, 16)];
        toLabel.textColor = TextColorAlpha_54;
        toLabel.font = [UIFont systemFontOfSize:14.0];
        if (partialSwitch.on == NO) {
            fromLabel.text = whoday1;
            toLabel.text = whoday2;
        }
        else
        {
            fromLabel.text = time1;
            toLabel.text = time2;
        }
        [headerView addSubview:toLabel];
        
        UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 15, HeaderViewHeight2)];
        ima.image = [UIImage imageNamed:@"s_path"];
        [headerView addSubview:ima];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(0, 0, ScreenWidth/2, HeaderViewHeight2);
        btn1.tag = 0;
        [headerView addSubview:btn1];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn2.frame = CGRectMake(ScreenWidth/2+30, 0, ScreenWidth/2, HeaderViewHeight2);
        btn2.tag = 1;
        [headerView addSubview:btn2];
        [btn1 addTarget:self action:@selector(selectFromTime:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(selectFromTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        message_textview = [[UITextView alloc] initWithFrame:CGRectMake(45, 30, ScreenWidth-60, 80)];
        message_textview.delegate = self;
        message_textview.textColor = TextColorAlpha_54;
        message_textview.font = [UIFont systemFontOfSize:17.0];
        if ([message_textview.text length] == 0) {
            message_textview.text = placeHolder;
        }
        [headerView addSubview:message_textview];
        UIToolbar * topKeyboardView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 30)];
        [topKeyboardView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Done",nil,nil) style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
        [topKeyboardView setItems:buttonsArray];
        
        if (ScreenWidth == 414) {
            topKeyboardView.frame = CGRectMake(0, 0, ScreenWidth, 42);
        }
        
        [message_textview setInputAccessoryView:topKeyboardView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewTap:)];
    [headerView addGestureRecognizer:tap];
    
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"RequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.backgroundColor = SetColor(243, 243, 243, 1.0);
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"         %@",[arr_type objectAtIndex:indexPath.row]];
        cell.textLabel.textColor = SetColor(0, 0, 0, 0.54);
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth-40, 7, 30, 30);
        [btn setImage:[UIImage imageNamed:@"group_dark"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"group_green"] forState:UIControlStateHighlighted];
        [cell.contentView addSubview:btn];
        btn.highlighted = NO;
        if ([type isEqualToString:[arr_type objectAtIndex:indexPath.row]]) {
            btn.highlighted = YES;
        }
        if (indexPath.row != arr_type.count-1) {
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(50, 44, ScreenWidth, 0.5)];
            line.backgroundColor = SetColor(0, 0, 0, 0.1);
            [cell.contentView addSubview:line];
        }
    }
    
    return cell;
}

-(void)headerViewTap:(UITapGestureRecognizer *)tap
{
    UIView *view_header = tap.view;
    if (view_header.tag == 0) {
        [field_hour resignFirstResponder];
        [message_textview resignFirstResponder];
    }
    else if (view_header.tag == 1) {
        [field_hour resignFirstResponder];
        [message_textview resignFirstResponder];
        if (isOpen == YES) {
            isOpen = NO;
        }
        else
        {
            isOpen = YES;
        }
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (view_header.tag == 4) {
        //date
        [field_hour resignFirstResponder];
        [message_textview resignFirstResponder];
        _bgBlackView.hidden = NO;
        [self showDatePicker1];
    }
    else if(view_header.tag == 6)
    {
        [field_hour resignFirstResponder];
    }
    if (view_header.tag != 1) {
        [self takeOffTableviewSectionOneOpen];
    }
}

-(void) takeOffTableviewSectionOneOpen
{
    if (isOpen == YES) {
        isOpen = NO;
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)hidebgBlackView:(UITapGestureRecognizer *)tap
{
    
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, datePickerHeight);
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}

-(void)dismissKeyBoard
{
    [message_textview resignFirstResponder];
    [_tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self takeOffTableviewSectionOneOpen];
    [message_textview resignFirstResponder];
}

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    
    if([textView.text isEqualToString:placeHolder])
    {
        textView.text = @"";
    }
    
    [self takeOffTableviewSectionOneOpen];
    [field_hour resignFirstResponder];
    
    if (ScreenWidth == 414) {
        
    }
    else if (ScreenWidth == 375)
    {
        [_tableView setContentOffset:CGPointMake(0.0, 10.0) animated:YES];
    }
    else if (ScreenWidth == 320)
    {
        [_tableView setContentOffset:CGPointMake(0.0, 30.0) animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [message_textview resignFirstResponder];
    [field_hour resignFirstResponder];
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([string length] < 1){
        textView.text = placeHolder;
    }
    [_tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [_tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

-(void) selectFromTime:(UIButton *) sender
{
    if (partialSwitch.on == YES) {
        [field_hour resignFirstResponder];
        [message_textview resignFirstResponder];
        _bgBlackView.hidden = NO;
        [self showTimePicker];
    }
    else
    {
        if (sender.tag == 0) {
            
            [field_hour resignFirstResponder];
            [message_textview resignFirstResponder];
            _bgBlackView.hidden = NO;
            [self showDatePicker2];
        }
        else
        {
            [field_hour resignFirstResponder];
            [message_textview resignFirstResponder];
            _bgBlackView.hidden = NO;
            [self showDatePicker3];
        }
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [field_hour resignFirstResponder];
    [message_textview resignFirstResponder];
}

-(void) switchValueChange
{
    [self takeOffTableviewSectionOneOpen];

    [field_hour resignFirstResponder];
    [message_textview resignFirstResponder];
    
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
    if (partialSwitch.on == NO) {
        
        [self changeDateLabel2:[NSDate date]];
        [self changeDateLabel3:[NSDate date]];
    }
    else
    {
        time1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
        time2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
        [self changePartialDay:[NSDate date]];
        
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:5] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        type = [arr_type objectAtIndex:indexPath.row];
        lab_type.text = type;
        isOpen = NO;
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        if (indexPath.row == 1) {
            [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
-(void)dateChanged:(UIDatePicker *)picker
{
    [message_textview resignFirstResponder];
    NSDate *mydate = picker.date;
    [self changePartialDay:mydate];
}
-(void)dateChanged2:(UIDatePicker *)picker
{
    [message_textview resignFirstResponder];
    NSDate *mydate = picker.date;
    [self changeDateLabel2:mydate];
}
-(void)dateChanged3:(UIDatePicker *)picker
{
    [message_textview resignFirstResponder];
    NSDate *mydate = picker.date;
    [self changeDateLabel3:mydate];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return firstTimePickerArray.count;
    }
    else
        return secondTimePickerArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [firstTimePickerArray objectAtIndex:row];
    } else {
        return [secondTimePickerArray objectAtIndex:row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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
        
        [pickerViewTime selectRow:secondTimeIndex inComponent:1 animated:YES];
        
        [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    }
    else {
        
        secondTimeIndex = row;
        
        //当前选择的时间是否大于开始的时间，若小于，则更新conpoment 0
        NSString *time_1 = [firstTimePickerArray objectAtIndex:firstTimeIndex];
        NSString *time_2 = [secondTimePickerArray objectAtIndex:secondTimeIndex];
        float timeInterval = [StringManager getIntervalHoursFromTowTime:time_1 andTime2:time_2];
        if (timeInterval <= 0) {
            
            if (row == 0) {
                firstTimeIndex = firstTimePickerArray.count - 1;
            }
            else
            {
                firstTimeIndex = row - 1;
            }
            
            [pickerViewTime selectRow:firstTimeIndex inComponent:0 animated:YES];
        }
        [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
        
        
    }
}

-(void)changePartialDay:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    
    string_date = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    
    [self changeTimeLabel:[firstTimePickerArray objectAtIndex:firstTimeIndex] and:[secondTimePickerArray objectAtIndex:secondTimeIndex]];
    partialday = [NSString stringWithFormat:@"%@, %@ %lu, %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];
    
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:4] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)changeDateLabel2:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    
    fromLabel.text = [NSString stringWithFormat:@"%@, %@ %lu, %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];
    stamp_startTimeStamp = [StringManager stringDateTransferTimeStamp:temp];
    whoday1 = [NSString stringWithFormat:@"%@, %@ %lu, %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];
}
-(void)changeDateLabel3:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    
    toLabel.text = [NSString stringWithFormat:@"%@, %@ %lu, %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];
    stamp_endTimeStamp = [StringManager stringDateTransferTimeStamp:temp];
    whoday2 = [NSString stringWithFormat:@"%@, %@ %lu, %lu",[StringManager featureWeekdayWithDate:year andMonth:month andDay:day],[StringManager getEnglishMonth:month],day,year];
}
-(void)changeTimeLabel:(NSString *)str1 and:(NSString *)str2
{
    time1 = str1;
    time2 = str2;
    
    if (string_date == nil) {
        string_date = [StringManager dateTransferString:[NSDate date]];
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
        str1 = [NSString stringWithFormat:@"%@ %@",string_date,str1];
    }
    else
    {
        str1 = [str1 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
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
        str2 = [NSString stringWithFormat:@"%@ %@",string_date,str2];
    }
    else
    {
        str2 = [str2 stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
        str2 = [NSString stringWithFormat:@"%@ %@",string_date,str2];
    }
    stamp_endTimeStamp = [StringManager stringDateTimeTransferTimeStamp:str2];
    
     [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:5] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)showDatePicker1
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        datePicker.hidden = NO;
        datePicker2.hidden = YES;
        datePicker3.hidden = YES;
        pickerViewTime.hidden = YES;
    }
                     completion:^(BOOL finish){
                     }];
}


-(void)showDatePicker2
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        datePicker.hidden = YES;
        datePicker2.hidden = NO;
        datePicker3.hidden = YES;
        pickerViewTime.hidden = YES;
    }
                     completion:^(BOOL finish){
                     }];
}

-(void)showDatePicker3
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        datePicker.hidden = YES;
        datePicker2.hidden = YES;
        datePicker3.hidden = NO;
        pickerViewTime.hidden = YES;
    }
                     completion:^(BOOL finish){
                     }];
}

-(void)showTimePicker
{
    [self takeOffTableviewSectionOneOpen];
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        datePicker.hidden = YES;
        datePicker2.hidden = YES;
        datePicker3.hidden = YES;
        pickerViewTime.hidden = NO;
    }
                     completion:^(BOOL finish){
                     }];
}

- (IBAction)back:(UIButton *)sender {
    [UIView animateWithDuration:1.5 animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    completion:^(BOOL finish){
    }];

}

- (IBAction)sendRequest:(UIButton *)sender {
    
    [field_hour resignFirstResponder];
    [message_textview resignFirstResponder];
    //1、结束时间要大于当前时间
    if ([stamp_endTimeStamp longLongValue] < [stamp_startTimeStamp longLongValue]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"To time is less than from time!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        //2、是否有已经创建了的时间相同的request
        Requests *conflictRequest = [DatabaseManager getSelfConfilictRequest:stamp_startTimeStamp andRequestEndTimeStamp:stamp_endTimeStamp andTime1:time1 andTime2:time2];
        if (conflictRequest != nil) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You already have a request in this period of time!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            //3、除了sick以外，其他类型的开始时间要大于当前时间
            NSNumber *nowStamp = [StringManager getDayTimeStamp:[NSDate date]];
            if (![type isEqualToString:[arr_type objectAtIndex:2]] && [stamp_startTimeStamp longLongValue] < [nowStamp longLongValue]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Time-off Request from a past time doesn’t make sense!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                //4、创建request时，period下，hour要有限制,每天最多支付8小时
                long moreHours = 0;
                long canUseHours = 0;
                if (partialSwitch.on == NO) {
                    NSDate *date1 = [StringManager timeStampTransferDate:[NSNumber numberWithLong:[stamp_startTimeStamp longValue]]];
                    NSDate *date2 = [StringManager timeStampTransferDate:[NSNumber numberWithLong:[stamp_endTimeStamp longValue]]];
                    NSInteger re = [StringManager calcDaysFromBegin:date1 end:date2]+1;//日期间隔天数
                    moreHours = 24;
                    canUseHours = 8*re;
                }
                else
                {
                    moreHours = (long)([stamp_endTimeStamp longLongValue] - [stamp_startTimeStamp longLongValue])/3600;
                    canUseHours = moreHours;
                    if (canUseHours > 8) {
                        canUseHours = 8;
                    }
                }
                NSString *message = [NSString stringWithFormat:@"Maximum Paid Hours to request is %lu hours.",canUseHours];
                if ([field_hour.text intValue] > canUseHours) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
                    
                    [field_hour resignFirstResponder];
                    [message_textview resignFirstResponder];
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (appdelegate.currentEmployee.isManager == 0) {
                        [dict setObject:@"0" forKey:@"requeststate"];
                    }
                    else
                    {
                        [dict setObject:@"1" forKey:@"requeststate"];
                    }
                    [dict setObject:stamp_startTimeStamp forKey:@"startStamp"];
                    [dict setObject:stamp_endTimeStamp forKey:@"endStamp"];
                    if ([field_hour.text isEqualToString:@""]) {
                        [dict setObject:[NSNumber numberWithInt:0] forKey:@"hours"];
                    }
                    else
                    {
                        [dict setObject:[NSNumber numberWithInt:[field_hour.text intValue]] forKey:@"hours"];
                    }
                    if ([type isEqualToString:[arr_type objectAtIndex:0]]) {
                        [dict setObject:@"0" forKey:@"type"];
                    }
                    else if ([type isEqualToString:[arr_type objectAtIndex:1]]) {
                        [dict setObject:@"1" forKey:@"type"];
                    }
                    else if ([type isEqualToString:[arr_type objectAtIndex:2]]) {
                        [dict setObject:@"2" forKey:@"type"];
                    }
                    else if ([type isEqualToString:[arr_type objectAtIndex:3]]) {
                        [dict setObject:@"3" forKey:@"type"];
                    }
                    if (partialSwitch.on == YES) {
                        [dict setObject:@"1" forKey:@"state"];
                        [dict setObject:time1 forKey:@"startTime"];
                        [dict setObject:time2 forKey:@"endTime"];
                    }
                    [dict setObject:message_textview.text forKey:@"message"];
                    if ([message_textview.text isEqualToString:placeHolder]) {
                        [dict setObject:@"" forKey:@"message"];
                    }
                    
                    DDBDataModel *model = [DynamoDBManager getRequestDataModelByRequestUuid:nil and:dict andState:@"0"];
                    
                    //先同步到服务器，再在本地保存
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
                                     
                                     Requests *request = [NSEntityDescription insertNewObjectForEntityForName:@"Requests" inManagedObjectContext:context];
                                     request.createDate = model.createDate;
                                     request.disposeDate = model.modifyDate;
                                     request.uuid = model.uuid;
                                     request.employeeUuid = model.request_employeeUuid;
                                     request.parentUuid = model.parentUuid;
                                     request.managerUuid = model.managerUuid;
                                     request.isDelete = [model.isDelete shortValue];
                                     request.type = model.request_type;
                                     request.stamp_startDate = model.request_stamp_startDate;
                                     request.stamp_endDate = model.request_stamp_endDate;
                                     request.string_startTime = model.request_string_startTime;
                                     request.string_endTime = model.request_string_endTime;
                                     request.paidHours = [model.request_paidHours shortValue];
                                     request.message = model.request_message;
                                     request.waitType = model.request_waitType;
                                     
                                     [context save:nil];
                                     
                                     RequestAllDisposeState *dispose = [NSEntityDescription insertNewObjectForEntityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
                                     
                                     NSString *mystring = model.request_disposeStateTable;
                                     if (mystring != nil) {
                                         NSDictionary *dict = [StringManager getDictionaryByJsonString:mystring];
                                         dispose.parentUuid = [dict objectForKey:RequestDisposeState_ParentUuid];
                                         dispose.parentRequestUuid = [dict objectForKey:RequestDisposeState_ParentRequestUuid];
                                         dispose.sendRequestEmployeeUuid = [dict objectForKey:RequestDisposeState_SendRequestEmployeeUuid];
                                         dispose.disposeTime = [dict objectForKey:RequestDisposeState_DisposeTime];
                                         dispose.disposeState = [dict objectForKey:RequestDisposeState_State];
                                         
                                         [context save:nil];
                                     }
                                     
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 });
                             }
                         }
                         return nil;
                     }];
                }
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
