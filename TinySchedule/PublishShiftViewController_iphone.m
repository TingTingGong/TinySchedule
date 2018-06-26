//
//  PublishShiftViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "PublishShiftViewController_iphone.h"
#define datePickerHeight 200

#define placeHolder @"We will send the message by notification."

@interface PublishShiftViewController_iphone ()
{
    NSMutableArray *arr_data;
    
    NSString *selectlocationUuid;
    
    NSMutableArray *arr_selectpositionuuid;
    
    NSMutableDictionary *fromDict;
    NSMutableDictionary *toDict;
    
    NSString *message;
    
}
@end

@implementation PublishShiftViewController_iphone

-(void) getInputMessageString:(NSString *)messagestring
{
    if (![[messagestring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] && [messagestring length] > 0) {
        message = [messagestring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        message = placeHolder;
    }
}

-(void) getEmployees:(NSString *)myEmployees
{
    NSArray *arr_ori = [NSArray arrayWithArray:arr_data];
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr2 = [myEmployees componentsSeparatedByString:@","];
    for (NSString *uuid in arr2) {
        Employees *employee = [DatabaseManager getEmployeeByUuid:uuid];
        [arr addObject:employee];
    }
    for (Employees *empoyee in arr) {
        if (![arr_data containsObject:empoyee]) {
            [arr_data addObject:empoyee];
        }
    }
    if (![arr_ori isEqualToArray:arr_data]) {
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) getlocationUuid:(NSMutableArray *)arr_locationuuid
{
    if (arr_locationuuid != nil) {
        selectlocationUuid = [arr_locationuuid objectAtIndex:0];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void) getTagPositionUuid:(NSMutableArray *) arr_position_uuid
{
    arr_selectpositionuuid = nil;
    arr_selectpositionuuid = [NSMutableArray arrayWithArray:arr_position_uuid];
    
    for (NSString *positionuuid in arr_position_uuid) {
        Positions *position = [DatabaseManager getPositionByUuid:positionuuid];
        if (![arr_data containsObject:position]) {
            [arr_data addObject:position];
            [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [_tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_textview resignFirstResponder];
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, datePickerHeight);
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    message = placeHolder;
    
    arr_data = [NSMutableArray array];
    
    NSArray *arr_alllocaiton = [DatabaseManager getAllLocations];
    Locations *location = [arr_alllocaiton objectAtIndex:0];
    selectlocationUuid = location.uuid;
    
    fromDict = [StringManager getYearMonthDayWeekByDate:[NSDate date]];
    toDict = [StringManager getYearMonthDayWeekByDate:[NSDate date]];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"Publish",@"Recall",nil];
    UISegmentedControl *_segmented = [[UISegmentedControl alloc]initWithItems:segmentedData];
    _segmented.frame = CGRectMake((ScreenWidth-170)/2,30,170,24);
    _segmented.tintColor = [UIColor colorWithRed:0 green:195.0/255 blue:0 alpha:1.0];
    _segmented.selectedSegmentIndex = 0;
    [self.navBarView addSubview:_segmented];
    UIFont *font = [UIFont fontWithName:SemiboldFontName size:14.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [_segmented setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [_segmented addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
//    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-170)/2, 30, 170, 24)];
//    _imageview.image = [UIImage imageNamed:@"publish"];
//    _imageview.highlightedImage = [UIImage imageNamed:@"recall"];
//    _imageview.userInteractionEnabled = YES;
//    [self.navBarView addSubview:_imageview];
//    
//    _publishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _publishBtn.frame = CGRectMake(0, 0, _imageview.frame.size.width/2, _imageview.frame.size.height);
//    [_publishBtn addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
//    [_publishBtn setTitle:@"Publish" forState:UIControlStateNormal];
//    [_publishBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
//    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_imageview addSubview:_publishBtn];
//    
//    _recallBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _recallBtn.frame = CGRectMake(_imageview.frame.size.width/2, 0, _imageview.frame.size.width/2, _imageview.frame.size.height);
//    [_recallBtn addTarget:self action:@selector(recall:) forControlEvents:UIControlEventTouchUpInside];
//    [_recallBtn setTitle:@"Recall" forState:UIControlStateNormal];
//    [_recallBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
//    [_recallBtn setTitleColor:SetColor(0, 0, 0, 0.3) forState:UIControlStateNormal];
//    [_imageview addSubview:_recallBtn];
    
    if (ScreenWidth == 320) {
        _syncBtn.frame = CGRectMake(_syncBtn.frame.origin.x+20, _syncBtn.frame.origin.y, 70, _syncBtn.frame.size.height);
        _syncBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
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
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:_datePicker];
    }
    
    if (_datePicker2 == nil) {
        _datePicker2 = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, datePickerHeight)];
        _datePicker2.datePickerMode = UIDatePickerModeDate;
        [_datePicker2 addTarget:self action:@selector(dateChanged2:) forControlEvents:UIControlEventValueChanged];
        [_bgWhiteView addSubview:_datePicker2];
    }

    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (arr_data.count == 0) {
            return 1;
        }
        return arr_data.count;
    }
    else
    {
        return 4;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (arr_data.count == 0) {
            return 56;
        }
        else
        {
            
            if ([[arr_data objectAtIndex:indexPath.row] isKindOfClass:[Positions class]]) {
                return 44;
            }
            else
                return 56;
        }
    }
    else
    {
        if (indexPath.row == 3) {
            return 100;
        }
        return 60;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (arr_data.count == 0) {
            UIButton *btnimage = [UIButton buttonWithType:UIButtonTypeCustom];
            btnimage.frame = CGRectMake(16, 10, 36, 36);
            [btnimage setImage:[UIImage imageNamed:@"publish_default"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btnimage];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(68, 18, 150, 20)];
            title.text = @"All Employees";
            title.textColor = SetColor(0, 0, 0, 0.87);
            [cell.contentView addSubview:title];
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 55.5, ScreenWidth-16, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
        else
        {
            if ([[arr_data objectAtIndex:indexPath.row] isKindOfClass:[Positions class]]) {
                
                Positions *position = [arr_data objectAtIndex:indexPath.row];
                UILabel *lab_color = [[UILabel alloc] initWithFrame:CGRectMake(16+7, 17, 10, 10)];
                lab_color.layer.cornerRadius = 5;
                lab_color.layer.masksToBounds = YES;
                lab_color.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                [cell.contentView addSubview:lab_color];
                UILabel *positionlab = [[UILabel alloc] initWithFrame:CGRectMake(42+7, 0, ScreenWidth-52, 44)];
                positionlab.text = position.name;
                positionlab.textColor = SetColor(34, 34, 34, 1.0);
                [cell.contentView addSubview:positionlab];
            }
            else
            {
                Employees *employee = [arr_data objectAtIndex:indexPath.row];
                UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 36, 36)];
                imageview.layer.masksToBounds = YES;
                imageview.layer.cornerRadius = 18.0;
                [cell.contentView addSubview:imageview];
                
                if (employee.headPortrait != nil) {
                    imageview.image = [UIImage imageWithData:employee.headPortrait];
                }
                else
                {
                    imageview.image = [UIImage imageNamed:@"defaultEmpoyee"];
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.textColor = [UIColor whiteColor];
                    lab.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:employee.fullName]];
                    lab.font = [UIFont fontWithName:SemiboldFontName size:14.0];
                    [imageview addSubview:lab];
                }
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 0, ScreenWidth - 78, 56)];
                label.text = [NSString stringWithFormat:@"%@",employee.fullName];
                label.textColor = SetColor(0, 0, 0, 0.87);
                [cell.contentView addSubview:label];
            }
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 55.5, ScreenWidth-16, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            UIButton *btn_delete = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_delete.frame = CGRectMake(ScreenWidth-40, 13, 30, 30);
            [btn_delete setImage:[UIImage imageNamed:@"-_tag"] forState:UIControlStateNormal];
            btn_delete.tag = indexPath.row;
            [btn_delete addTarget:self action:@selector(deleteData:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_delete];
            
            if ([[arr_data objectAtIndex:indexPath.row] isKindOfClass:[Positions class]]) {
                line.frame = CGRectMake(16, 43.5, ScreenWidth-16, 0.5);
                btn_delete.frame = CGRectMake(ScreenWidth-40, 7, 30, 30);
            }
        }
        
    }
    else if (indexPath.section == 1) {
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        if (indexPath.row == 0) {
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(16, 15, 116, 30);
            [btn1 setTitle:@"  Employee" forState:UIControlStateNormal];
            [btn1 setTitleColor:AppMainColor forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"addAvailable"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn1];
            [btn1 addTarget:self action:@selector(addEmployee) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame = CGRectMake(206, 15, 100, 30);
            [btn2 setTitle:@"  Position" forState:UIControlStateNormal];
            [btn2 setTitleColor:AppMainColor forState:UIControlStateNormal];
            [btn2 setImage:[UIImage imageNamed:@"addAvailable"] forState:UIControlStateNormal];
            [cell.contentView addSubview:btn2];
            [btn2 addTarget:self action:@selector(addPosition) forControlEvents:UIControlEventTouchUpInside];
            
            if(ScreenWidth == 320)
            {
                btn2.frame = CGRectMake(ScreenWidth/2+30, btn2.frame.origin.y, btn2.frame.size.width, btn2.frame.size.height);
            }
        }
        else
        {
            UIButton *btnimage = [UIButton buttonWithType:UIButtonTypeCustom];
            btnimage.frame = CGRectMake(16, 18, 24, 24);
            [cell.contentView addSubview:btnimage];
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 60)];
            title.font = [UIFont fontWithName:SemiboldFontName size:14.0];
            [cell.contentView addSubview:title];
            
            if (indexPath.row == 1) {
                [btnimage setImage:[UIImage imageNamed:@"s_location_dark"] forState:UIControlStateNormal];
                title.text = @"LOCATION";
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, ScreenWidth-176, 60)];
                lab.textAlignment = NSTextAlignmentRight;
                Locations *locaiton = [DatabaseManager getLocationByUuid:selectlocationUuid];
                if(locaiton.name != nil)
                {
                    [lab setAttributedText:SetAttributeText(locaiton.name, TextColorAlpha_54, RegularFontName, 17.0)];
                }
                [cell.contentView addSubview:lab];
                
            }
            else if (indexPath.row == 2 || indexPath.row == 3)
            {
                if (indexPath.row == 2) {
                    title.frame = CGRectMake(50, 0, 100, 40);
                    [btnimage setImage:[UIImage imageNamed:@"day_dark"] forState:UIControlStateNormal];
                    [title setAttributedText:SetAttributeText(@"FROM", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
                    UILabel *fromlab = [[UILabel alloc] initWithFrame:CGRectMake(50, 31, 130, 16)];
                    fromlab.textColor = TextColorAlpha_54;
                    fromlab.font = [UIFont systemFontOfSize:14.0];
                    fromlab.text = [NSString stringWithFormat:@"%@, %@ %@, %@",[fromDict objectForKey:@"week"],[StringManager getEnglishMonth:[[fromDict objectForKey:@"month"] longValue]],[fromDict objectForKey:@"day"],[fromDict objectForKey:@"year"]];
                    [cell.contentView addSubview:fromlab];
                    UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2, 0,15, 60)];
                    ima.image = [UIImage imageNamed:@"s_path"];
                    [cell.contentView addSubview:ima];
                     
                     if(ScreenWidth == 320)
                     {
                         ima.frame = CGRectMake(ima.frame.origin.x+4, ima.frame.origin.y, ima.frame.size.width, ima.frame.size.height);
                     }
                    
                    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+30, 0, 100, 40)];
                    [title2 setAttributedText:SetAttributeText(@"TO", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
                    [cell.contentView addSubview:title2];
                    
                    UILabel *tolab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+30, 31, 130, 16)];
                    tolab.textColor = TextColorAlpha_54;
                    tolab.font = [UIFont systemFontOfSize:14.0];
                    tolab.text = [NSString stringWithFormat:@"%@, %@ %@, %@",[toDict objectForKey:@"week"],[StringManager getEnglishMonth:[[toDict objectForKey:@"month"] longValue]],[toDict objectForKey:@"day"],[toDict objectForKey:@"year"]];
                    [cell.contentView addSubview:tolab];
                    
                    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    btn1.frame = CGRectMake(0, 0, ScreenWidth/2, 60);
                    btn1.tag = 0;
                    [cell.contentView addSubview:btn1];
                    [btn1 addTarget:self action:@selector(setFromDate:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn1];
                    
                    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    btn2.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 60);
                    btn2.tag = 1;
                    [cell.contentView addSubview:btn2];
                    [btn2 addTarget:self action:@selector(setFromDate:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn2];
                }
                else
                {
                    title.frame = CGRectMake(50, 14, 100, 16);
                    btnimage.frame = CGRectMake(16, 10, 24, 24);
                    [btnimage setImage:[UIImage imageNamed:@"message_dark"] forState:UIControlStateNormal];
                    title.text = @"MESSAGE";
                    _textview = [[UITextView alloc] initWithFrame:CGRectMake(46, 30, ScreenWidth-66, 70)];
                    _textview.delegate = self;
                    _textview.text = message;
                    _textview.textColor = SetColor(0, 0, 0, 0.3);
                    _textview.font = [UIFont systemFontOfSize:17.0];
                    [cell.contentView addSubview:_textview];
                }
            }
        }
        if (indexPath.row < 3) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
    }
    
    return cell;
}
                     
-(void)hidebgBlackView:(UITapGestureRecognizer *)tap
{
                        
    [UIView animateWithDuration:AnimatedDuration animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, _tableView.frame.size.height);
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, datePickerHeight);
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 1) {

            LocationListViewController_iphone *locationV = [LocationListViewController_iphone new];
            locationV.delegate = self;
            locationV.locationUuid = selectlocationUuid;
            [self presentViewController:locationV animated:YES completion:nil];
        }
    }
}

-(void) addPosition
{
    TagPositionViewController_iphone *tagP = [TagPositionViewController_iphone new];
    tagP.delegate = self;
    tagP.arr_selectPositionuuid = arr_selectpositionuuid;
    [self presentViewController:tagP animated:YES completion:nil];

}

-(void) addEmployee
{
    TagEmployeeViewController_iphone *employeeV = [TagEmployeeViewController_iphone new];
    employeeV.delegate = self;
    NSMutableArray *arr = [NSMutableArray array];
    for (id object in arr_data) {
        if ([object isKindOfClass:[Employees class]]) {
            Employees *employee = object;
            [arr addObject:employee.uuid];
        }
    }
    if (arr.count != 0) {
        employeeV.employees = [arr componentsJoinedByString:@","];
    }
    [self.navigationController pushViewController:employeeV animated:YES];
}

-(void) deleteData:(UIButton *) sender
{
    if ([[arr_data objectAtIndex:sender.tag] isKindOfClass:[Positions class]]) {
        Positions *position = [arr_data objectAtIndex:sender.tag];
        [arr_data removeObject:position];
        if([arr_selectpositionuuid containsObject:position.uuid])
        {
            [arr_selectpositionuuid removeObject:position.uuid];
        }
    }
    else
    {
        Employees *employee = [arr_data objectAtIndex:sender.tag];
        [arr_data removeObject:employee];
    }
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}


-(void) setFromDate:(UIButton *) sender
{
    [UIView animateWithDuration:0.2 animations:^{
        if(NavibarHeight + 60 + 60 + 60 + arr_data.count * 56 > ScreenHeight - 200)
        {
            float interval = NavibarHeight + 60 + 60 + 60 + arr_data.count * 56 - (ScreenHeight - 200);
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            _tableView.frame = CGRectMake(0, -interval, _tableView.frame.size.width, _tableView.frame.size.height);
        }
        _bgBlackView.hidden = NO;
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        if (sender.tag == 0) {
            [self showDatePicker];
        }
        else
        {
            [self showDatePicker2];
        }
    }];
}


-(void)dateChanged:(UIDatePicker *)picker
{
    fromDict = [StringManager getYearMonthDayWeekByDate:picker.date];
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)dateChanged2:(UIDatePicker *)picker
{
    toDict = [StringManager getYearMonthDayWeekByDate:picker.date];
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)showDatePicker
{
    [_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        _datePicker.hidden = NO;
        _datePicker2.hidden = YES;
    }
    completion:^(BOOL finish){
                     }];
}

-(void)showDatePicker2
{
    [_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - datePickerHeight, ScreenWidth, datePickerHeight);
        _datePicker.hidden = YES;
        _datePicker2.hidden = NO;
    }
                     completion:^(BOOL finish){
                     }];
}
                 
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textview resignFirstResponder];
}
                     
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder])
    {
        textView.text = @"";
    }
    MessageViewController *messagevc = [MessageViewController new];
    messagevc.passMessage = textView.text;
    messagevc.delegate = self;
    [self.navigationController pushViewController:messagevc animated:YES];
    
}
-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([string length] < 1){
        textView.text = placeHolder;
    }
}
                     
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return NO;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)doSomethingInSegment:(id)sender{
    
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
        {
            [_syncBtn setTitle:@"Publish" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_syncBtn setTitle:@"Recall" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}


- (void)publish:(UIButton *)sender {
    if (_imageview.highlighted == YES) {
        _imageview.highlighted = NO;
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_recallBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_syncBtn setTitle:@"Publish" forState:UIControlStateNormal];
    }
}

- (void)recall:(UIButton *)sender {
    if (_imageview.highlighted == NO) {
        _imageview.highlighted = YES;
        [_recallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_syncBtn setTitle:@"Recall" forState:UIControlStateNormal];
    }
}

- (IBAction)publishOrRecallShift:(UIButton *)sender {
    
    [_textview resignFirstResponder];
    
    if(arr_data.count == 0)
    {
        arr_data = [NSMutableArray arrayWithArray:[DatabaseManager getAllEmployeesInLocation:selectlocationUuid]];
    }
    
    NSNumber *numner1 = [StringManager stringDateTransferTimeStamp:[NSString stringWithFormat:@"%@-%@-%@",[fromDict objectForKey:@"year"],[fromDict objectForKey:@"month"],[fromDict objectForKey:@"day"]]];
    NSNumber *numner2 = [StringManager stringDateTransferTimeStamp:[NSString stringWithFormat:@"%@-%@-%@",[toDict objectForKey:@"year"],[toDict objectForKey:@"month"],[toDict objectForKey:@"day"]]];
    
    if([numner2 longLongValue] < [numner1 longLongValue])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"We believe FROM date is supposed to be earlier than TO date, isn't it?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        arr_data = nil;
        arr_data = [NSMutableArray array];
        arr_selectpositionuuid = nil;
        arr_selectpositionuuid = [NSMutableArray array];
        [_tableView reloadData];
    }
    else
    {
        if (arr_data.count != 0) {
            NSMutableArray *arr_employee = [NSMutableArray array];
            NSMutableArray *arr_position = [NSMutableArray array];
            for (id object in arr_data) {
                if ([object isKindOfClass:[Employees class]]) {
                    Employees *employee = object;
                    [arr_employee addObject:employee];
                }
                else if ([object isKindOfClass:[Positions class]])
                {
                    Positions *positin = object;
                    [arr_position addObject:positin];
                }
            }
            NSNumber *oriTakeState = [NSNumber numberWithInt:0];
            NSNumber *takestate = [NSNumber numberWithInt:1];
            if ([sender.titleLabel.text isEqualToString:@"Publish"]) {
                takestate = [NSNumber numberWithInt:1];
                oriTakeState = [NSNumber numberWithInt:0];
            }
            else if ([sender.titleLabel.text isEqualToString:@"Recall"])
            {
                takestate = [NSNumber numberWithInt:0];
                oriTakeState = [NSNumber numberWithInt:1];
            }
            
            NSMutableArray *arr_shifts = [NSMutableArray array];
            for (Positions *position in arr_position) {
                NSMutableArray *arr = [DatabaseManager getShiftsArrayByLocationUuid:selectlocationUuid andStartStamo:numner1 andEndStamp:numner2 andPositionUuid:position.uuid andTakeState:oriTakeState];
                for (Shifts *shfit in arr) {
                    if (![arr_shifts containsObject:shfit]) {
                        [arr_shifts addObject:shfit];
                    }
                }
            }

            for (Employees *employee in arr_employee) {
                Locations *location = [DatabaseManager getLocationByUuid:selectlocationUuid];
                NSLog(@"%@",location.name);
                NSArray *arr_employeeshift = [NSArray arrayWithArray:[DatabaseManager getShiftsArrayByLocationUuid:selectlocationUuid andStartStamo:numner1 andEndStamp:numner2 andEmployeeUuid:employee.uuid andTakeState:oriTakeState]];
                for (Shifts *shift in arr_employeeshift) {
                    if (![arr_shifts containsObject:shift]) {
                        [arr_shifts addObject:shift];
                    }
                }
            }
            if (arr_shifts.count != 0) {
                PublishShiftListViewController_iphone *list = [PublishShiftListViewController_iphone new];
                list.takestate = takestate;
                list.arr_shifts = [NSMutableArray arrayWithArray:arr_shifts];
                if([_textview.text isEqualToString:placeHolder] || [_textview.text isEqualToString:@""])
                {
                    list.passmessage = @"";
                }
                else
                {
                    list.passmessage = [_textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                arr_data = nil;
                arr_data = [NSMutableArray array];
                [self presentViewController:list animated:YES completion:nil];
            }
            else
            {
                NSString *mmessage = @"According to selected conditions, there's no shift to be published.";
                if([takestate intValue] == 0)
                {
                    mmessage = @"According to selected conditions, there's no shift to be recalled.";
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:mmessage preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okButton];
                [self presentViewController:alertController animated:YES completion:nil];
                arr_data = nil;
                arr_data = [NSMutableArray array];
                [_tableView reloadData];
            }
        }
    }
}

- (IBAction)syncData:(UIButton *)sender {
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
