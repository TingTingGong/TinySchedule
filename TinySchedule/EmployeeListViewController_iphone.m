//
//  EmployeeListViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "EmployeeListViewController_iphone.h"

@interface EmployeeListViewController_iphone ()
{
    NSMutableDictionary *dict_employees;
    NSArray *arr_keys;
    NSString *selectEmployeeUuid;
}
@end

@implementation EmployeeListViewController_iphone
@synthesize locationuuid;
@synthesize positionuuid;
@synthesize employeeUuid;
@synthesize startDateStamp;
@synthesize startTimeStamp;
@synthesize endTimeStamp;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    dict_employees = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager getEmployeesByLocationUuid:locationuuid andPositionUuid:positionuuid]];
    arr_keys = [[dict_employees allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, ScreenHeight - NavibarHeight);
    
    dict_employees = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager getEmployeesByLocationUuid:locationuuid andPositionUuid:positionuuid]];
    arr_keys = [[dict_employees allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+arr_keys.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if (arr_keys.count != 0) {
            NSString *key = [arr_keys objectAtIndex:section-1];
            NSMutableArray *arr= [dict_employees objectForKey:key];
            return arr.count;
        }
        return 0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 26)];
        headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
        
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, headerView.frame.size.width, headerView.frame.size.height)];
        NSString *title = @"";
        
        if (arr_keys.count != 0) {
            NSString *key = [arr_keys objectAtIndex:section-1];
            title = key;
        }
        
        if (title != nil) {
            [titlelabel setAttributedText:SetAttributeText(title, SetColor(0, 0, 0, 0.3), SemiboldFontName, 14.0)];
        }
         [headerView addSubview:titlelabel];
         
         return headerView;
    }
         return nil;
}


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 26;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.tintColor = AppMainColor;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"employee";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"s_openShift"];
        cell.textLabel.text = @"Open Shift";
        cell.textLabel.textColor = SetColor(0, 0, 0, 0.87);
        cell.detailTextLabel.text = @"Allow your team to request this shift";
        cell.detailTextLabel.textColor = SetColor(0, 0, 0, 0.3);
        if (employeeUuid == nil) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(68, 59.5, ScreenWidth-68, 0.5)];
        line.backgroundColor = SetColor(250, 250, 250, 1.0);
        [cell.contentView addSubview:line];
        
        //UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //testActivityIndicator.center = CGPointMake(ScreenWidth-26, 30);
        //[cell.contentView addSubview:testActivityIndicator];
        //testActivityIndicator.color = AppMainColor;
        //[testActivityIndicator startAnimating];
    }
    else
    {
        if (arr_keys.count != 0) {
            
            NSString *key = [arr_keys objectAtIndex:indexPath.section - 1];
            NSMutableArray *arr= [dict_employees objectForKey:key];
            if (arr.count > indexPath.row) {
                
                Employees *employee = [arr objectAtIndex:indexPath.row];
                
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
                    lab.font = [UIFont fontWithName:RegularFontName size:14.0];
                    lab.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:employee.fullName]];
                    [imageview addSubview:lab];
                }
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 18, ScreenWidth - 84, 20)];
                label.textColor = SetColor(0, 0, 0, 0.87);
                label.text = [NSString stringWithFormat:@"%@",employee.fullName];
                [cell.contentView addSubview:label];

                Shifts *shift = [DatabaseManager getShiftByEmployeeUuid:employee.uuid andStartTimeStamp:startTimeStamp andEndTimeStamp:endTimeStamp];
                Requests *request = [DatabaseManager getConfilictRequestByEmployeeUuid:employee.uuid andShifStartTimeStamp:startTimeStamp andShifEndTimeStamp:endTimeStamp];
                NSDictionary *dict_unavai = [DatabaseManager getConilictAvailabilityByEmployeeUuid:startDateStamp andShiftStartTimeStamp:startTimeStamp andShiftEndTimeStamp:endTimeStamp andEmployeeUuid:employee.uuid andAvailabilityState:@"1"];
                NSDictionary *dict_prefer = [DatabaseManager getConilictAvailabilityByEmployeeUuid:startDateStamp andShiftStartTimeStamp:startTimeStamp andShiftEndTimeStamp:endTimeStamp andEmployeeUuid:employee.uuid andAvailabilityState:@"0"];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-76, 0, 60, 56)];
                lab.textAlignment = NSTextAlignmentRight;
                lab.font = [UIFont fontWithName:SemiboldFontName size:10.0];
                [cell.contentView addSubview:lab];
                
                if (shift != nil || request != nil || [dict_unavai allKeys].count != 0) {
                    lab.text = @"Unavailable";
                    lab.textColor = SetColor(250, 67, 63, 1.0);
                }
                else if ([dict_prefer allKeys].count != 0)
                {
                    lab.text = @"Preferred";
                    lab.textColor = AppMainColor;
                }
                
                
                if ([employeeUuid isEqualToString:employee.uuid]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    lab.hidden = YES;
                }
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(68, 59.5, ScreenWidth-68, 0.5)];
                line.backgroundColor = SepearateLineColor;
                [cell.contentView addSubview:line];
            }
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.delegate getEmployeeUuid:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *key = [arr_keys objectAtIndex:indexPath.section - 1];
        NSMutableArray *arr= [dict_employees objectForKey:key];
        Employees *employee = [arr objectAtIndex:indexPath.row];
        selectEmployeeUuid = employee.uuid;
        
        Shifts *shift = [DatabaseManager getShiftByEmployeeUuid:employee.uuid andStartTimeStamp:startTimeStamp andEndTimeStamp:endTimeStamp];
        if (shift != nil) {
            Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
            NSString *message = [NSString stringWithFormat:@"%@ has a shift : %@, %@.",employee.fullName,shift.string_time,location.name];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            UIAlertAction *rideAction = [UIAlertAction actionWithTitle:@"Override" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self.delegate getEmployeeUuid:selectEmployeeUuid];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:rideAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            Requests *request = [DatabaseManager getConfilictRequestByEmployeeUuid:employee.uuid andShifStartTimeStamp:startTimeStamp andShifEndTimeStamp:endTimeStamp];
            if(request != nil)
            {
                NSString *type = nil;
                if([request.type isEqualToString:@"0"])
                {
                    type = @"Unpaid";
                }
                else if ([request.type isEqualToString:@"1"])
                {
                    type = @"PTO";
                }
                else if ([type isEqualToString:@"2"])
                {
                    type = @"Sick";
                }
                else
                {
                    type = @"Holiday";
                }
                Employees *employee = [DatabaseManager getEmployeeByUuid:request.employeeUuid];
                NSString *message = nil;
                if([request.type isEqualToString:@"0"])
                {
                    message = [NSString stringWithFormat:@"%@ requested an %@ time-off : ",employee.fullName,type];
                }
                else
                {
                    message = [NSString stringWithFormat:@"%@ requested a %@ time-off : ",employee.fullName,type];
                }
                if (request.string_startTime == nil) {
                    NSDictionary *dict1 = [StringManager getYearMonthDay:request.stamp_startDate];
                    NSDictionary *dict2 = [StringManager getYearMonthDay:request.stamp_endDate];
                    message = [NSString stringWithFormat:@"%@%@ %@ %@ - %@ %@ %@",message,[StringManager getEnglishMonth:[[dict1 objectForKey:@"month"] longValue]],[dict1 objectForKey:@"day"],[dict1 objectForKey:@"year"],[StringManager getEnglishMonth:[[dict2 objectForKey:@"month"] longValue]],[dict2 objectForKey:@"day"],[dict2 objectForKey:@"year"]];
                }
                else
                {
                    message = [NSString stringWithFormat:@"%@ - %@",request.string_startTime,request.string_endTime];
                }
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:cancelAction];
                UIAlertAction *rideAction = [UIAlertAction actionWithTitle:InternationalL(@"override") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self.delegate getEmployeeUuid:selectEmployeeUuid];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:rideAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                NSDictionary *dict = [DatabaseManager getConilictAvailabilityByEmployeeUuid:startDateStamp andShiftStartTimeStamp:startTimeStamp andShiftEndTimeStamp:endTimeStamp andEmployeeUuid:employee.uuid andAvailabilityState:@"1"];
                Availability *ava = [DatabaseManager getAvailabilitybyUuid:[dict objectForKey:Availability_ParentUuid]];
                if(dict != nil && [dict allKeys].count != 0 && ava != nil)
                {
                    NSString *message = [NSString stringWithFormat:@"%@ has conflicting availability preferences through",employee.fullName];
                    if([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"])
                    {
                        message = [NSString stringWithFormat:@"%@ all day",message];
                    }
                    else
                    {
                        message = [NSString stringWithFormat:@"%@ %@-%@",message,[dict objectForKey:Availability_FromTime],[dict objectForKey:Availability_ToTime]];
                    }
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:cancelAction];
                    UIAlertAction *rideAction = [UIAlertAction actionWithTitle:InternationalL(@"override") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self.delegate getEmployeeUuid:selectEmployeeUuid];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:rideAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [self.delegate getEmployeeUuid:employee.uuid];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEmployee:(UIButton *)sender {
    EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
    edit.defaultLocationuuid = locationuuid;
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
