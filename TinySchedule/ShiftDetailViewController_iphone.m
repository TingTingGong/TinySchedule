//
//  ShiftDetailViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "ShiftDetailViewController_iphone.h"
#import "HeadPortraitView.h"

#define placeHolder @"You can leave a message here."

@interface ShiftDetailViewController_iphone ()
{
    Shifts *passShift;
}
@end

@implementation ShiftDetailViewController_iphone
@synthesize uuid;
@synthesize swapOriPositionuuid;
@synthesize notEditShift;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    passShift = [DatabaseManager getShiftByUuid:uuid];
    if(passShift == nil)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        _dateLabel.text = [NSString stringWithFormat:@"%@, %@ %@ %@",passShift.string_week,passShift.string_month,passShift.string_day,passShift.string_year];
        
        if (_tableView != nil) {
            [_tableView reloadData];
        }
        
        [self setAllButtonState];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, ScreenHeight-NavibarHeight);
    
    passShift = [DatabaseManager getShiftByUuid:uuid];
    _dateLabel.text = [NSString stringWithFormat:@"%@, %@ %@ %@",passShift.string_week,passShift.string_month,passShift.string_day,passShift.string_year];
    
    [self initView];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (passShift.isTake == 0 && [passShift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
        _takeBtn.hidden = YES;
        _employeeTakeBtn.hidden = YES;
        [self acknowledgeShift];
    }
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
        [self.view addSubview:_bottomView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.backgroundColor = SetColor(235, 235, 235, 1.0);
        [_bottomView addSubview:line];
        
        if (_line2 == nil) {
            
            _line2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, 1, 50)];
            _line2.backgroundColor = SetColor(235, 235, 235, 1.0);
            [_bottomView addSubview:_line2];
        }

        if (_notifyBtn == nil) {
            _notifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _notifyBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
            [_notifyBtn setTitle:@"Notify" forState:UIControlStateNormal];
            [_notifyBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
            _notifyBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_notifyBtn];
            [_notifyBtn addTarget:self action:@selector(notifyEmployee) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_replaceBtn == nil) {
            _replaceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _replaceBtn.frame = CGRectMake(ScreenWidth/2+1, 1, ScreenWidth/2, 49);
            [_replaceBtn setTitle:@"Find Repalcement" forState:UIControlStateNormal];
            [_replaceBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
            _replaceBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_replaceBtn];
            [_replaceBtn addTarget:self action:@selector(findReplacement) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_takeBtn == nil) {
            _takeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _takeBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
            [_takeBtn setTitle:@"Take Shift" forState:UIControlStateNormal];
            [_takeBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
            _takeBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_takeBtn];
            [_takeBtn addTarget:self action:@selector(takeShift) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_employeeTakeBtn == nil) {
            _employeeTakeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _employeeTakeBtn.frame = CGRectMake(0, 1, ScreenWidth, 49);
            [_employeeTakeBtn setTitle:@"Take Shift" forState:UIControlStateNormal];
            [_employeeTakeBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
            _employeeTakeBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_employeeTakeBtn];
            [_employeeTakeBtn addTarget:self action:@selector(takeShift) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_assignBtn == nil) {
            _assignBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _assignBtn.frame = CGRectMake(ScreenWidth/2+1, 1, ScreenWidth/2, 49);
            [_assignBtn setTitle:@"Offer/Assign" forState:UIControlStateNormal];
            [_assignBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
            _assignBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_assignBtn];
            [_assignBtn addTarget:self action:@selector(assignShift) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_swapBtn == nil) {
            _swapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _swapBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
            [_swapBtn setTitle:@"Swap" forState:UIControlStateNormal];
            [_swapBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
            _swapBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_swapBtn];
            [_swapBtn addTarget:self action:@selector(toSwap) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_dropBtn == nil) {
            _dropBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _dropBtn.frame = CGRectMake(ScreenWidth/2+1, 1, ScreenWidth/2, 49);
            [_dropBtn setTitle:@"Drop" forState:UIControlStateNormal];
            [_dropBtn setTitleColor:SetColor(251, 166, 108, 1.0) forState:UIControlStateNormal];
            _dropBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_dropBtn];
            [_dropBtn addTarget:self action:@selector(toDrop) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (_publishBtn == nil) {
            _publishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _publishBtn.frame = CGRectMake(0, 1, ScreenWidth, 49);
            [_publishBtn setTitle:@"Publish" forState:UIControlStateNormal];
            [_publishBtn setTitleColor:SetColor(252, 103, 33, 1.0) forState:UIControlStateNormal];
            _publishBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_publishBtn];
            [_publishBtn addTarget:self action:@selector(publishShift) forControlEvents:UIControlEventTouchUpInside];
        }
        if (_requestBtn == nil) {
            _requestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _requestBtn.frame = CGRectMake(0, 1, ScreenWidth, 49);
            [_requestBtn setTitle:@"View Reuqest" forState:UIControlStateNormal];
            [_requestBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
            _requestBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [_bottomView addSubview:_requestBtn];
            [_requestBtn addTarget:self action:@selector(toDropOrSwap) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [self setAllButtonState];
}

-(void) setAllButtonState
{
    //edit,notify,replace,take,assign,swap,drop,viewRequest
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSNumber *nowStamp = [StringManager getDayTimeStamp:[NSDate date]];
    
    if (appdelegate.currentEmployee.isManager == 1) {
        
        _editBtn.hidden = NO;
        if (passShift.takeState == 0) {
            
            _line2.hidden = YES;
            _notifyBtn.hidden = YES;
            _replaceBtn.hidden = YES;
            _employeeTakeBtn.hidden = YES;
            _takeBtn.hidden = YES;
            _assignBtn.hidden = YES;
            _swapBtn.hidden = YES;
            _dropBtn.hidden = YES;
            _publishBtn.hidden = NO;
            _requestBtn.hidden = YES;
        }
        else
        {
            _publishBtn.hidden = YES;
            
            if ([passShift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                
                _notifyBtn.hidden = YES;
                _replaceBtn.hidden = YES;
                _employeeTakeBtn.hidden = YES;
                _takeBtn.hidden = NO;
                _assignBtn.hidden = NO;
                _swapBtn.hidden = YES;
                _dropBtn.hidden = YES;
                _requestBtn.hidden = YES;
            }
            else
            {
                _employeeTakeBtn.hidden = YES;
                _takeBtn.hidden = YES;
                _assignBtn.hidden = YES;
                Drop *drop = [DatabaseManager getPendingDropByShiftUuid:uuid];
                Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:uuid];
                if (drop != nil || swap != nil) {
                    _notifyBtn.hidden = YES;
                    _replaceBtn.hidden = YES;
                    _swapBtn.hidden = YES;
                    _dropBtn.hidden = YES;
                    _publishBtn.hidden = YES;
                    _requestBtn.hidden = NO;
                    _line2.hidden = YES;
                }
                else
                {
                    if ([appdelegate.currentEmployee.uuid isEqualToString:passShift.employeeUuid]) {
                        
                        _notifyBtn.hidden = YES;
                        _replaceBtn.hidden = YES;
                        if ([passShift.startTime longLongValue] <= [nowStamp longLongValue]) {
                            _swapBtn.hidden = YES;
                            _dropBtn.hidden = YES;
                            _bottomView.hidden = YES;
                        }
                        else
                        {
                            _swapBtn.hidden = NO;
                            _dropBtn.hidden = NO;
                        }
                        
                        _requestBtn.hidden = YES;
                        if (passShift.isTake == 0) {
                            
                            [_swapBtn setTitleColor:SetColor(251, 197, 159, 1.0) forState:UIControlStateNormal];
                            [_dropBtn setTitleColor:SetColor(251, 197, 159, 1.0) forState:UIControlStateNormal];
                            _swapBtn.enabled = NO;
                            _dropBtn.enabled = NO;
                            _editBtn.enabled = NO;
                        }
                        else
                        {
                            [_swapBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                            [_dropBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                            _swapBtn.enabled = YES;
                            _dropBtn.enabled = YES;
                            _editBtn.enabled = YES;
                        }
                    }
                    else
                    {
                        _notifyBtn.hidden = NO;
                        _replaceBtn.hidden = NO;
                        _requestBtn.hidden = YES;
                        _swapBtn.hidden = YES;
                        _dropBtn.hidden = YES;
                    }
                }
            }
        }
    }
    else
    {
        _publishBtn.hidden = YES;
        _editBtn.hidden = YES;
        _notifyBtn.hidden = YES;
        _replaceBtn.hidden = YES;
        _takeBtn.hidden = YES;
        _assignBtn.hidden = YES;
        _employeeTakeBtn.hidden = YES;
        
        if ([passShift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
            
            _employeeTakeBtn.hidden = NO;
            _line2.hidden = YES;
            _swapBtn.hidden = YES;
            _dropBtn.hidden = YES;
            _requestBtn.hidden = YES;
        }
        else
        {
            //drop,swap是否是nil
            Drop *drop = [DatabaseManager getPendingDropByShiftUuid:uuid];
            Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:uuid];
            if (drop != nil || swap != nil) {
                _dropBtn.hidden = YES;
                _swapBtn.hidden = YES;
                _requestBtn.hidden = NO;
                _line2.hidden = YES;
            }
            else
            {
                _requestBtn.hidden = YES;
                if ([appdelegate.currentEmployee.uuid isEqualToString:passShift.employeeUuid]) {
                    
                    if (passShift.isTake == 0) {
                        
                        [_swapBtn setTitleColor:SetColor(251, 197, 159, 1.0) forState:UIControlStateNormal];
                        [_dropBtn setTitleColor:SetColor(251, 197, 159, 1.0) forState:UIControlStateNormal];
                        _swapBtn.enabled = NO;
                        _dropBtn.enabled = NO;
                    }
                    else
                    {
                        [_swapBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                        [_dropBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                        _swapBtn.enabled = YES;
                        _dropBtn.enabled = YES;
                        if ([passShift.startTime longLongValue] <= [nowStamp longLongValue]) {
                            _swapBtn.hidden = YES;
                            _dropBtn.hidden = YES;
                            _bottomView.hidden = YES;
                        }
                    }
                }
                else
                {
                    _bottomView.hidden = YES;
                    _employeeTakeBtn.hidden = YES;
                    _swapBtn.hidden = YES;
                    _dropBtn.hidden = YES;
                    _requestBtn.hidden = YES;
                }
            }
        }
    }
    
    if (([nowStamp longLongValue] >= [passShift.endTime longLongValue] && passShift.takeState != 0) || notEditShift == YES) {
        _bottomView.hidden = YES;
        _line2.hidden = YES;
        _notifyBtn.hidden = YES;
        _replaceBtn.hidden = YES;
        _takeBtn.hidden = YES;
        _employeeTakeBtn.hidden = YES;
        _assignBtn.hidden = YES;
        _swapBtn.hidden = YES;
        _dropBtn.hidden = YES;
        _requestBtn.hidden = YES;
        _publishBtn.hidden = YES;
        if (notEditShift == YES) {
            _editBtn.hidden = YES;
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    else if (indexPath.row == 4)
    {
        return 200;
    }
    return 62;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row != 0 && indexPath.row != 4) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, ScreenWidth-32, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    
    if (indexPath.row == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 20, ScreenWidth-30, 100)];
        view.backgroundColor = SetColor(243, 243, 243, 1.0);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 12.0;
        [cell.contentView addSubview:view];
        
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[StringManager interceptionTime:passShift.string_time]];
        
        CGFloat viewWidth = view.frame.size.width;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/2-6, 38, 12, 2)];
        line.backgroundColor = SetColor(32, 32, 32, 1.0);
        [view addSubview:line];
        
        UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/2-37-100, 18, 100, 43)];
        startLabel.textColor = TextColorAlpha_87;
        startLabel.font = [UIFont fontWithName:DisplayLightFontName size:36.0];
        if([dict objectForKey:@"str1"] != nil)
        {
            startLabel.text = [dict objectForKey:@"str1"];
        }
        startLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:startLabel];
         
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(startLabel.frame.origin.x+startLabel.frame.size.width, 39, 30, 16)];
        lab1.textColor = TextColorAlpha_87;
        lab1.font = [UIFont fontWithName:SemiboldFontName size:14.0];

        NSString *str2 = [dict objectForKey:@"str2"];
        if([str2 containsString:@"a"])
        {
            str2 = @"am";
        }
        else if ([str2 containsString:@"p"])
        {
            str2 = @"pm";
        }
        if(str2 != nil)
        {
            lab1.text = str2;
        }
        
        lab1.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab1];
        
        NSString *str3 = [dict objectForKey:@"str3"];
        CGSize size = [StringManager labelAutoCalculateRectWith:str3 FontSize:36.0 MaxSize:CGSizeMake(100, 43)];
        UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/2+17, 18, size.width, 43)];
        endLabel.textAlignment = NSTextAlignmentRight;
        endLabel.textColor = TextColorAlpha_87;
        endLabel.font = [UIFont fontWithName:DisplayLightFontName size:36.0];

        if([dict objectForKey:@"str3"] != nil)
        {
            endLabel.text = [dict objectForKey:@"str3"];
        }
        endLabel.textAlignment = NSTextAlignmentLeft;
        [view addSubview:endLabel];

         UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(endLabel.frame.origin.x+endLabel.frame.size.width, 39, 35, 16)];
        lab2.textColor = TextColorAlpha_87;
        lab2.font = [UIFont fontWithName:SemiboldFontName size:14.0];

        NSString *str4 = [dict objectForKey:@"str4"];
        if([str4 containsString:@"a"])
        {
            str4 = @"am";
        }
        else if ([str4 containsString:@"p"])
        {
            str4 = @"pm";
        }
        if(str4 != nil)
        {
            lab2.text = str4;
        }
         
        lab2.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab2];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(line.frame.origin.x-80-10, 67, 80+20, 16);
        [btn1 setImage:[UIImage imageNamed:@"shiftdetail_time"] forState:UIControlStateNormal];
        [btn1 setTitle:[NSString stringWithFormat:@" %.2f hours",[passShift.totalHours floatValue]] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn1 setTitleColor:TextColorAlpha_54 forState:UIControlStateNormal];
        [view addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(endLabel.frame.origin.x, 67, 80+20, 16);
        [btn2 setImage:[UIImage imageNamed:@"shiftdetail_break"] forState:UIControlStateNormal];
        [btn2 setTitle:[NSString stringWithFormat:@" %@",passShift.unpaidBreak] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [btn2 setTitleColor:TextColorAlpha_54 forState:UIControlStateNormal];
        [view addSubview:btn2];
    }
    else
    {
        UILabel *lab_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 100, 16)];
        lab_title.textColor = SetColor(199, 199, 205, 1.0);
        lab_title.font = [UIFont fontWithName:SemiboldFontName size:14.0];
        
        UILabel *lab_content = [[UILabel alloc]initWithFrame:CGRectMake(15, 34, cell.frame.size.width-40, 20)];
        lab_content.textColor = SetColor(0, 0, 0, 0.87);
        [lab_content setAdjustsFontSizeToFitWidth:YES];
        
        if (indexPath.row == 1) {
            lab_title.text = @"Location";
            Locations *locaiton = [DatabaseManager getLocationByUuid:passShift.locationUuid];
            lab_content.text = locaiton.name;
        }
        else if (indexPath.row == 2)
        {
            lab_title.text = @"Position";
            
            UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(15, 40, 10, 10)];
            ima.backgroundColor = SetColor(157, 167, 160, 1.0);
            ima.layer.masksToBounds = YES;
            ima.layer.cornerRadius = 10/2.0;
            [cell.contentView addSubview:ima];
            
            lab_content.frame = CGRectMake(35, 30, cell.frame.size.width-40, 30);
 
            if (passShift.positionUuid != nil) {
                
                lab_content.frame = CGRectMake(35, 30, cell.frame.size.width-70, 30);
                Positions *position = [DatabaseManager getPositionByUuid:passShift.positionUuid];
                lab_content.text = position.name;
                ima.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
                if(position == nil)
                {
                    lab_content.text = @"Unassigned";
                    ima.backgroundColor = SetColor(157, 167, 160, 1.0);
                }
                
            }
            else
            {
                lab_content.text = @"Unassigned";
            }
            if (swapOriPositionuuid != nil) {
                Positions *p = [DatabaseManager getPositionByUuid:swapOriPositionuuid];
                if (p == nil) {
                    lab_content.text = @"Unassigned";
                    ima.backgroundColor = SetColor(157, 167, 160, 1.0);
                }
                else
                {
                    lab_content.text = p.name;
                    ima.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:p.color]];
                }
            }
        }
        else if (indexPath.row == 3)
        {
            lab_title.text = @"Employee";
            if (![passShift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                Employees *employee = [DatabaseManager getEmployeeByUuid:passShift.employeeUuid];
                
                if(employee == nil)
                {
                    //employee is deleted
                    lab_content.text = passShift.employeeName;
                }
                else
                {
                    lab_content.text = employee.fullName;
                }
            }
            else
            {
                lab_content.text = [NSString stringWithFormat:@"Openshift(%hd / %hd)",passShift.haveTakedEmployeesNumber,passShift.needEmployeesNumber];
            }
        }
        else
        {
            lab_title.text = @"Note";
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(12, 25, cell.frame.size.width-32, 175)];
            textView.textColor = SetColor(0, 0, 0, 0.87);
            textView.font = [UIFont systemFontOfSize:17.0];
            textView.text = passShift.notes;
            if (passShift.notes == nil || [passShift.notes isEqualToString:@""]) {
                textView.text = @"No Message";
            }
            textView.delegate = self;
            [cell.contentView addSubview:textView];
        }
        
        [cell.contentView addSubview:lab_title];
        [cell.contentView addSubview:lab_content];
    }
    
    return cell;
}
          
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
          
          
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
    if (indexPath.row == 1) {
        LocationDetailViewController_iphone *detail = [LocationDetailViewController_iphone new];
        detail.uuid = shift.locationUuid;
        detail.isEmployeeSeeDetail = YES;
        detail.isCreateLocation = NO;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.row == 2)
    {
        Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
        if(position == nil)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Position to show" message:@"This shift is not set to a specific position." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
//            if(position.isDelete == 1)
//            {
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"This position has been deleted." preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//                [alertController addAction:okAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//            }
//            else
//            {
//                PositionDetailViewController_iphone *detail = [PositionDetailViewController_iphone new];
//                detail.uuid = shift.positionUuid;
//                detail.isEmployeeSeePositionDetail = YES;
//                detail.isCreatePosition = NO;
//                [self.navigationController pushViewController:detail animated:YES];
//            }
        }
    }
    else if (indexPath.row == 3)
    {
        if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
        }
        else
        {
            EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
            Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
            if(employee == nil)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"The employee has deleted!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                edit.employeeUuid = shift.employeeUuid;
                [self.navigationController pushViewController:edit animated:YES];
            }
        }
    }
}

-(void) acknowledgeShift
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    DDBDataModel *model = [[DDBDataModel alloc]init];
    model.createDate = passShift.createDate;
    model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    model.uuid = passShift.uuid;
    model.managerUuid = passShift.managerUuid;
    model.parentUuid = passShift.parentUuid;
    model.tableIdentityID = @"Shifts";
    model.isDelete = [NSNumber numberWithShort:passShift.isDelete];
    model.shift_employeeUuid = passShift.employeeUuid;
    if([passShift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
    {
        model.shift_employeeName = OpenShiftEmployeeName;
    }
    else
    {
        Employees *employee = [DatabaseManager getEmployeeByUuid:passShift.employeeUuid];
        if(employee == nil)
        {
            model.shift_employeeName = passShift.employeeName;
        }
        else
        {
            model.shift_employeeName = employee.fullName;
        }
    }
    if (passShift.positionUuid != nil) {
        model.shift_positionUuid = passShift.positionUuid;
    }
    model.shift_locationUuid = passShift.locationUuid;
    model.shift_startDate = passShift.startDate;
    model.shift_startTime = passShift.startTime;
    model.shift_endTime = passShift.endTime;
    model.shift_totalHours = passShift.totalHours;
    model.shift_unPaidBreak = passShift.unpaidBreak;
    model.shift_employeesNumbers = [NSNumber numberWithShort:passShift.needEmployeesNumber];
    if (passShift.notes != nil && ![passShift.notes isEqualToString:@""]) {
        model.shift_notes = passShift.notes;
    }
    model.shift_strYear = passShift.string_year;
    model.shift_strMonth = passShift.string_month;
    model.shift_strDay = passShift.string_day;
    model.shift_strWeek = passShift.string_week;
    model.shift_strTime = passShift.string_time;
    model.shift_isTake = [NSNumber numberWithInt:1];
    model.shift_haveTakedEmployeesNumber = [NSNumber numberWithShort:passShift.haveTakedEmployeesNumber];
    model.shift_takedState = [NSNumber numberWithShort:passShift.takeState];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper save:model]
     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
         if (task.error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             });
         }
         else {
             if ([model isKindOfClass:[DDBDataModel class]]) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                     
                     passShift.isTake = 1;
                     
                     [context save:nil];
                     
                     [DatabaseManager syncShiftToCalendar:passShift.uuid andIsDelete:0];
                     
                     [_swapBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                     [_dropBtn setTitleColor:SetColor(251, 103, 33, 1.0) forState:UIControlStateNormal];
                     _swapBtn.enabled = YES;
                     _dropBtn.enabled = YES;
                     _editBtn.enabled = YES;

                 });
             }
         }
         return nil;
     }];
}

-(void) notifyEmployee
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Notify employee!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        Shifts *shift = [DatabaseManager getShiftByUuid:uuid];

        NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
        Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
        for(DeviceToken *device in arr_device)
        {
            if (device.endPointArn != nil && device.deviceToken != nil && ![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid] && setting.notification_isScheduleUpdate == 1) {
                [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
                AWSSNS *sns = [AWSSNS defaultSNS];
                AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                NSString *message = [NSString stringWithFormat:@"%@\n%@",Notification_NewShift,[DatabaseManager getMyselfNotificationOfShift:shift]];
                input.message = message;
                input.targetArn = device.endPointArn;
                [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
                    
                }];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) toSwap
{
    SwapViewController_iphone *change = [SwapViewController_iphone new];
    change.uuid = uuid;
    change.isShowShiftDetail = NO;
    [self.navigationController pushViewController:change animated:YES];
}

-(void) toDrop
{
    DropViewController_iphone *change = [DropViewController_iphone new];
    change.category = @"0";
    change.uuid = uuid;
    change.isShowShiftDetail = NO;
    [self.navigationController pushViewController:change animated:YES];
}

-(void)assignShift
{
    DropViewController_iphone *change = [DropViewController_iphone new];
    change.category = @"1";
    change.uuid = uuid;
    change.isShowShiftDetail = NO;
    [self.navigationController pushViewController:change animated:YES];
}

-(void) findReplacement
{
    DropViewController_iphone *change = [DropViewController_iphone new];
    change.category = @"2";
    change.uuid = uuid;
    change.isShowShiftDetail = NO;
    [self.navigationController pushViewController:change animated:YES];
}


-(void)toDropOrSwap
{
    Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
    Drop *drop = [DatabaseManager getPendingDropByShiftUuid:shift.uuid];
    Drop *swap = [DatabaseManager getPendingSwapByShiftUuid:shift.uuid];
    if (drop != nil) {
        DropViewController_iphone *drop_v = [DropViewController_iphone new];
        drop_v.category = @"0";
        drop_v.uuid = shift.uuid;
        drop_v.dropuuid = drop.uuid;
        [self.navigationController pushViewController:drop_v animated:YES];
    }
    else if(swap != nil)
    {
        SwapViewController_iphone *swap_v = [SwapViewController_iphone new];
        swap_v.uuid = shift.uuid;
        swap_v.swapuuid = swap.uuid;
        [self.navigationController pushViewController:swap_v animated:YES];
    }
}

-(void) publishShift
{
    Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
    if (shift.takeState == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
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
            if (shift.notes != nil && ![shift.notes isEqualToString:@""]) {
                model.shift_notes = shift.notes;
            }
            model.shift_strYear = shift.string_year;
            model.shift_strMonth = shift.string_month;
            model.shift_strDay = shift.string_day;
            model.shift_strWeek = shift.string_week;
            model.shift_strTime = shift.string_time;
            if(![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
            {
                model.shift_isTake = [NSNumber numberWithInt:0];
                Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
                model.shift_employeeName = employee.fullName;
            }
            else
            {
                model.shift_employeeName = OpenShiftEmployeeName;
            }
            model.shift_haveTakedEmployeesNumber = [NSNumber numberWithShort:shift.haveTakedEmployeesNumber];
            model.shift_takedState = [NSNumber numberWithInt:1];
            if (shift.openShift_employees != nil) {
                model.shift_openshift_employees = shift.openShift_employees;
            }
            
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
                             shift.employeeName = model.shift_employeeName;
                             shift.takeState = 1;
                             
                             [context save:nil];
                             
                             [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:0];

                             [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editShift:(UIButton *)sender {
    EditShiftViewController_iphone *edit = [EditShiftViewController_iphone new];
    edit.uuid = uuid;
    [self.navigationController pushViewController:edit animated:YES];
}

-(void)takeShift
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *arr_allmyshift = [DatabaseManager getAllMyShiftsArray];
    BOOL isConflictshfit = NO;
    for(Shifts *shift in arr_allmyshift)
    {
        if(!([shift.startTime longLongValue] >= [passShift.endTime longLongValue] || [shift.endTime longLongValue] <= [passShift.startTime longLongValue]))
        {
            isConflictshfit = YES;
            break;
        }
    }
    
    if ([passShift.openShift_employees containsString:appDelegate.currentEmployee.uuid]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:InternationalL(@"haveTakedShift") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (isConflictshfit == YES)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You have a conflict shift." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        
        if (passShift.needEmployeesNumber == passShift.haveTakedEmployeesNumber) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            _takeBtn.enabled = NO;
            _employeeTakeBtn.enabled = NO;
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passShift.uuid rangeKey:passShift.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
                if (task.error) {
                    
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    _takeBtn.enabled = YES;
                    _employeeTakeBtn.enabled = YES;
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        DDBDataModel *model = task.result;
                        NSManagedObjectContext *context = [appDelegate managedObjectContext];
                        
                        if ([model.tableIdentityID isEqualToString:@"Shifts"]) {
                            
                            passShift.startDate = model.shift_startDate;
                            passShift.modifyDate = model.modifyDate;
                            passShift.employeeUuid = model.shift_employeeUuid;
                            passShift.isDelete = [model.isDelete shortValue];
                            passShift.isTake = [model.shift_isTake shortValue];
                            passShift.haveTakedEmployeesNumber = [model.shift_haveTakedEmployeesNumber shortValue];
                            passShift.openShift_employees = model.shift_openshift_employees;
                            [context save:nil];
                            
                            [DatabaseManager syncShiftToCalendar:passShift.uuid andIsDelete:0];
                            
                            if (passShift.isDelete == 0) {
                                if (passShift.haveTakedEmployeesNumber < passShift.needEmployeesNumber) {
                                    [self beginTakeShiftAndSetOpenShiftHaveTakeNumbers];
                                }
                                else
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Shift has already been beat us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }
                            else
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Shift has already been deleted!" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                        else
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }
                return nil;
            }];
        }
    }
}

-(void) beginTakeShiftAndSetOpenShiftHaveTakeNumbers
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
    if ([passShift.notes isEqualToString:@""]) {
        passShift.notes = nil;
    }

    for (int i = 0 ; i < 2; i++) {
        
        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
        
        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
        rangeKeyValue.S = passShift.parentUuid;
        AWSDynamoDBAttributeValue *namaeruuid = [AWSDynamoDBAttributeValue new];
        namaeruuid.S = passShift.managerUuid;
        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
        isdelete.N = [NSString stringWithFormat:@"%hd",passShift.isDelete];
        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
        tablename.S = @"Shifts";
        AWSDynamoDBAttributeValue *shift_employeeUuid = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *shift_employeename = [AWSDynamoDBAttributeValue new];

        AWSDynamoDBAttributeValue *shift_positionUuid = [AWSDynamoDBAttributeValue new];
        if (passShift.positionUuid != nil) {
            shift_positionUuid.S = passShift.positionUuid;
        }
        AWSDynamoDBAttributeValue *shift_locationUuid = [AWSDynamoDBAttributeValue new];
        shift_locationUuid.S = passShift.locationUuid;
        AWSDynamoDBAttributeValue *shift_startDate = [AWSDynamoDBAttributeValue new];
        shift_startDate.S = passShift.startDate;
        AWSDynamoDBAttributeValue *shift_startTime = [AWSDynamoDBAttributeValue new];
        shift_startTime.S = passShift.startTime;
        AWSDynamoDBAttributeValue *shift_endTime = [AWSDynamoDBAttributeValue new];
        shift_endTime.S = passShift.endTime;
        AWSDynamoDBAttributeValue *shift_totalHours = [AWSDynamoDBAttributeValue new];
        shift_totalHours.S = passShift.totalHours;
        AWSDynamoDBAttributeValue *shift_unPaidBreak = [AWSDynamoDBAttributeValue new];
        shift_unPaidBreak.S = passShift.unpaidBreak;
        AWSDynamoDBAttributeValue *shift_openshift_employees = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *shift_employeesNumbers = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *shift_notes = [AWSDynamoDBAttributeValue new];
        if (passShift.notes != nil && [passShift.notes length] > 0) {
            shift_notes.S = passShift.notes;
        }
        AWSDynamoDBAttributeValue *shift_strYear = [AWSDynamoDBAttributeValue new];
        shift_strYear.S = passShift.string_year;
        AWSDynamoDBAttributeValue *shift_strMonth = [AWSDynamoDBAttributeValue new];
        shift_strMonth.S = passShift.string_month;
        AWSDynamoDBAttributeValue *shift_strDay = [AWSDynamoDBAttributeValue new];
        shift_strDay.S = passShift.string_day;
        AWSDynamoDBAttributeValue *shift_strWeek = [AWSDynamoDBAttributeValue new];
        shift_strWeek.S = passShift.string_week;
        AWSDynamoDBAttributeValue *shift_strTime = [AWSDynamoDBAttributeValue new];
        shift_strTime.S = passShift.string_time;
        AWSDynamoDBAttributeValue *shift_isTake = [AWSDynamoDBAttributeValue new];
        AWSDynamoDBAttributeValue *shift_takedState = [AWSDynamoDBAttributeValue new];
        shift_takedState.N = [NSString stringWithFormat:@"%hd",passShift.takeState];
        AWSDynamoDBAttributeValue *shift_haveTakedEmployeesNumber = [AWSDynamoDBAttributeValue new];

        if (i == 0) {
            //create new shift by employeeuuid
            createdate.S = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
            modifyDate.S = createdate.S;
            haskKeyValue.S = [StringManager getItemID];
            shift_employeeUuid.S = appDelegate.currentEmployee.uuid;
            Employees *employee = [DatabaseManager getEmployeeByUuid:appDelegate.currentEmployee.uuid];
            shift_employeename.S = employee.fullName;
            shift_isTake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
            
            if (passShift.positionUuid == nil && passShift.notes == nil) {
                
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_employeeName":shift_employeename};
            }
            else if (passShift.positionUuid != nil && passShift.notes == nil)
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_positionUuid": shift_positionUuid,@"shift_employeeName":shift_employeename};
            }
            else if (passShift.positionUuid == nil && passShift.notes != nil)
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_notes": shift_notes,@"shift_employeeName":shift_employeename};
            }
            else
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_notes": shift_notes,@"shift_positionUuid": shift_positionUuid,@"shift_employeeName":shift_employeename};
            }
        }
        else
        {
            //refresh openshift
            createdate.S = passShift.createDate;
            modifyDate.S = passShift.modifyDate;
            haskKeyValue.S = passShift.uuid;
            shift_employeeUuid.S = passShift.employeeUuid;
            shift_employeename.S = OpenShiftEmployeeName;
            if (passShift.openShift_employees != nil) {
                shift_openshift_employees.S = [NSString stringWithFormat:@"%@,%@",passShift.openShift_employees,appDelegate.currentEmployee.uuid];
            }
            else
            {
                shift_openshift_employees.S = appDelegate.currentEmployee.uuid;
            }
            shift_employeesNumbers.N = [NSString stringWithFormat:@"%hd",passShift.needEmployeesNumber];
            shift_isTake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
            shift_haveTakedEmployeesNumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:passShift.haveTakedEmployeesNumber + 1]];
            
            if ([shift_employeesNumbers.N isEqualToString:shift_haveTakedEmployeesNumber.N]) {
                isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
            }
            
            if (passShift.positionUuid == nil && passShift.notes == nil) {
                
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_employeesNumbers": shift_employeesNumbers,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_takedState": shift_takedState,@"shift_haveTakedEmployeesNumber": shift_haveTakedEmployeesNumber,@"shift_openshift_employees": shift_openshift_employees,@"shift_employeeName":shift_employeename};
            }
            else if (passShift.positionUuid != nil && passShift.notes == nil)
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_employeesNumbers": shift_employeesNumbers,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_takedState": shift_takedState,@"shift_haveTakedEmployeesNumber": shift_haveTakedEmployeesNumber,@"shift_positionUuid": shift_positionUuid,@"shift_openshift_employees": shift_openshift_employees,@"shift_employeeName":shift_employeename};
            }
            else if (passShift.positionUuid == nil && passShift.notes != nil)
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_employeesNumbers": shift_employeesNumbers,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_takedState": shift_takedState,@"shift_haveTakedEmployeesNumber": shift_haveTakedEmployeesNumber,@"shift_notes": shift_notes,@"shift_openshift_employees": shift_openshift_employees,@"shift_employeeName":shift_employeename};
            }
            else
            {
                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": namaeruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": shift_employeeUuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_employeesNumbers": shift_employeesNumbers,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_takedState": shift_takedState,@"shift_haveTakedEmployeesNumber": shift_haveTakedEmployeesNumber,@"shift_notes": shift_notes,@"shift_positionUuid": shift_positionUuid,@"shift_openshift_employees": shift_openshift_employees,@"shift_employeeName":shift_employeename};
            }
        }
        [arr_writeRequest addObject:writeRequest];
    }
    AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
    AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
    batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_writeRequest};
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
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                
                if (appDelegate.currentEmployee.isManager == 0) {
                    passShift.isDelete = 1;
                }
                else
                {
                    passShift.haveTakedEmployeesNumber = passShift.haveTakedEmployeesNumber + 1;
                    if (passShift.openShift_employees != nil) {
                        passShift.openShift_employees = [NSString stringWithFormat:@"%@,%@",passShift.openShift_employees,appDelegate.currentEmployee.uuid];
                    }
                    else
                    {
                        passShift.openShift_employees = appDelegate.currentEmployee.uuid;
                    }
                    AWSDynamoDBWriteRequest *writeRequest = [arr_writeRequest objectAtIndex:1];
                    NSDictionary *dict = writeRequest.putRequest.item;
                    AWSDynamoDBAttributeValue *value = [dict objectForKey:@"isDelete"];
                    passShift.isDelete = [value.N intValue];
                }
                [context save:nil];
                
                AWSDynamoDBWriteRequest *writeRequest = [arr_writeRequest objectAtIndex:0];
                NSDictionary *dict = writeRequest.putRequest.item;
                AWSDynamoDBAttributeValue *value1 = [dict objectForKey:@"createDate"];
                AWSDynamoDBAttributeValue *value2 = [dict objectForKey:@"modifyDate"];
                AWSDynamoDBAttributeValue *value3 = [dict objectForKey:@"uuid"];
                AWSDynamoDBAttributeValue *value4 = [dict objectForKey:@"managerUuid"];
                AWSDynamoDBAttributeValue *value5 = [dict objectForKey:@"parentUuid"];
                AWSDynamoDBAttributeValue *value6 = [dict objectForKey:@"isDelete"];
                AWSDynamoDBAttributeValue *value7 = [dict objectForKey:@"shift_employeeUuid"];
                AWSDynamoDBAttributeValue *value8 = [dict objectForKey:@"shift_positionUuid"];
                AWSDynamoDBAttributeValue *value9 = [dict objectForKey:@"shift_locationUuid"];
                AWSDynamoDBAttributeValue *value10 = [dict objectForKey:@"shift_startDate"];
                AWSDynamoDBAttributeValue *value11 = [dict objectForKey:@"shift_startTime"];
                AWSDynamoDBAttributeValue *value12 = [dict objectForKey:@"shift_endTime"];
                AWSDynamoDBAttributeValue *value13 = [dict objectForKey:@"shift_totalHours"];
                AWSDynamoDBAttributeValue *value14 = [dict objectForKey:@"shift_unPaidBreak"];
                AWSDynamoDBAttributeValue *value15 = [dict objectForKey:@"shift_employeesNumbers"];
                AWSDynamoDBAttributeValue *value16 = [dict objectForKey:@"shift_notes"];
                AWSDynamoDBAttributeValue *value17 = [dict objectForKey:@"shift_strYear"];
                AWSDynamoDBAttributeValue *value18 = [dict objectForKey:@"shift_strMonth"];
                AWSDynamoDBAttributeValue *value19 = [dict objectForKey:@"shift_strDay"];
                AWSDynamoDBAttributeValue *value20 = [dict objectForKey:@"shift_strWeek"];
                AWSDynamoDBAttributeValue *value21 = [dict objectForKey:@"shift_strTime"];
                AWSDynamoDBAttributeValue *value23 = [dict objectForKey:@"shift_takedState"];
                AWSDynamoDBAttributeValue *value25 = [dict objectForKey:@"shift_employeeName"];
                Shifts *shift;
                if (dict != nil) {
                    shift = [NSEntityDescription insertNewObjectForEntityForName:@"Shifts" inManagedObjectContext:context];
                    shift.createDate = value1.S;
                    shift.modifyDate = value2.S;
                    shift.uuid = value3.S;
                    shift.managerUuid = value4.S;
                    shift.parentUuid = value5.S;
                    shift.isDelete = [value6.N intValue];
                    shift.employeeUuid = value7.S;
                    shift.employeeName = value25.S;
                    shift.positionUuid = value8.S;
                    shift.locationUuid = value9.S;
                    shift.startDate = value10.S;
                    shift.startTime = value11.S;
                    shift.endTime = value12.S;
                    shift.totalHours = value13.S;
                    shift.unpaidBreak = value14.S;
                    shift.needEmployeesNumber = [value15.N intValue];
                    shift.notes = value16.S;
                    shift.string_year = value17.S;
                    shift.string_month = value18.S;
                    shift.string_day = value19.S;
                    shift.string_week = value20.S;
                    shift.string_time = value21.S;
                    shift.isTake = 1;
                    shift.haveTakedEmployeesNumber = 0;
                    shift.takeState = [value23.N intValue];
                    shift.haveTakedEmployeesNumber = 0;
                    [context save:nil];
                }
                
                [DatabaseManager syncShiftToCalendar:passShift.uuid andIsDelete:0];
                [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:0];
                
                if (passShift.isDelete == 1) {
                    [context deleteObject:passShift];
                    [context save:nil];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        return nil;
    }];
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
