//
//  PublishShiftListViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/2/22.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "PublishShiftListViewController_iphone.h"

@interface PublishShiftListViewController_iphone ()
{
    NSMutableDictionary *dict_shifts;
    NSArray *arr_keys;
}
@end

@implementation PublishShiftListViewController_iphone
@synthesize passmessage;
@synthesize arr_shifts;
@synthesize takestate;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    dict_shifts = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in arr_shifts) {
        
        NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
        NSMutableArray *arr_temp = [dict_shifts objectForKey:time];
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_temp addObject:shift];
        }
        [dict_shifts setObject:arr_temp forKey:time];
    }
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[dict_shifts allKeys]];
    if (arr_temp.count >= 2) {
        
        for (int i = 0; i < arr_temp.count-1; i++) {
            
            NSString *time1 = [arr_temp objectAtIndex:i];
            Shifts *s1 = [[dict_shifts objectForKey:time1] objectAtIndex:0];
            
            for (int j = i+1; j<arr_temp.count; j++) {
                
                NSString *time2 = [arr_temp objectAtIndex:j];
                Shifts *s2 = [[dict_shifts objectForKey:time2] objectAtIndex:0];
                
                if ([s1.startDate longLongValue] > [s2.startDate longLongValue]) {
                    [arr_temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    
    if ([dict_shifts allKeys].count != 0) {
        arr_keys = [DatabaseManager sortedShiftByStartDate:[NSMutableArray arrayWithArray:[dict_shifts allKeys]]];
    }
    
    [_tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    _tableView.frame = CGRectMake(0, 96, ScreenWidth, ScreenHeight-96-50);
    _line.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    NSLog(@"%@",takestate);
    if ([takestate intValue] == 1) {
        _titleLabel.text = @"Publish these Shifts?";
    }
    else
    {
        _titleLabel.text = @"Recall these Shifts?";
        [_publishBtn setTitle:@"Recall All" forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr_keys.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [arr_keys objectAtIndex:section];
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[dict_shifts objectForKey:key]]];
    return arr_temp.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    if (arr_keys.count != 0) {
        
        NSString *key = [arr_keys objectAtIndex:section];
        
        UILabel *label_title = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 150, 30)];
        if (key != nil) {
            [label_title setAttributedText:SetAttributeText(key, SetColor(3, 3, 3, 0.3), SemiboldFontName, 12.0)];
             }
             [headerView addSubview:label_title];
             
             float totalHours = 0.0;
             NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[dict_shifts objectForKey:key]];
             for (Shifts *shift in arr_temp) {
                 totalHours += [shift.totalHours floatValue];
             }
             
             UILabel *lab_hour = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 116, 0, 100, 30)];
             NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2fh",totalHours]];
             lab_hour.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
             lab_hour.textColor = SetColor(0, 0, 0, 0.3);
             lab_hour.textAlignment = NSTextAlignmentRight;
             lab_hour.font = [UIFont systemFontOfSize:12.0];
             [headerView addSubview:lab_hour];
        }
             
     return headerView;
}
             
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    NSString *key = [arr_keys objectAtIndex:indexPath.section];
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[DatabaseManager sortedShiftArrayByTime:[dict_shifts objectForKey:key]]];
    Shifts *shift = [arr_temp objectAtIndex:indexPath.row];
    Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 28, 28)];
    imageview.image = [UIImage imageNamed:@"circle_red_1"];
    [cell.contentView addSubview:imageview];
    
    if([takestate intValue] == 0)
    {
        imageview.image = [UIImage imageNamed:@"circle_green_done"];
    }
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 200, 20)];
    lable.textColor = SetColor(3, 3, 3, 1.0);
    lable.text = [NSString stringWithFormat:@"%@",shift.string_time];
    [cell.contentView addSubview:lable];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 34, ScreenWidth-64, 16)];
    detailLabel.textColor = SetColor(0, 0, 0, 0.3);
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.text = [NSString stringWithFormat:@"At %@",location.name];
    [cell.contentView addSubview:detailLabel];
    
    Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
    if(employee == nil)
    {
        if([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
        {
            detailLabel.text = [NSString stringWithFormat:@"%@ At %@",OpenShiftEmployeeName,location.name];
        }
        else
        {
            detailLabel.text = [NSString stringWithFormat:@"%@ At %@",shift.employeeName,location.name];
        }
    }
    else
    {
        detailLabel.text = [NSString stringWithFormat:@"%@ At %@",employee.fullName,location.name];
    }
    
    UILabel *lab_hour = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 116, 13, 100, 14)];
    lab_hour.textAlignment = NSTextAlignmentRight;
    NSDictionary *dict = [StringManager getHourAndMin:[NSString stringWithFormat:@"%.2fh",[shift.totalHours floatValue]]];
    lab_hour.text = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"hour"],[dict objectForKey:@"min"]];
    lab_hour.alpha = 0.3;
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
    }
    else
    {
        lab_position.text = @"Un";
        lab_position.backgroundColor = SetColor(156, 168, 160, 1.0);
    }
    [lab_position setAdjustsFontSizeToFitWidth:YES];
    [cell.contentView addSubview:lab_position];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    if(indexPath.row == arr_temp.count-1)
    {
        line.hidden = YES;
    }
    if(indexPath.section == arr_keys.count-1 && indexPath.row == arr_temp.count-1)
    {
        line.hidden = NO;
        line.frame = CGRectMake(16, 59.5, ScreenWidth-16, 0.5);
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)publishAllShifts:(UIButton *)sender {
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    NSMutableArray *arr_request = [DynamoDBManager getShiftWriteRequestByTakeState:takestate andArray:arr_shifts];
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
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                
                for (Shifts *shift in arr_shifts) {
                    shift.takeState = [takestate shortValue];
                    [context save:nil];
                }
                
                if([takestate intValue] == 1)
                {
                    for (Shifts *shift in arr_shifts) {
                        
                        Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
                        NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
                        for(DeviceToken *device in arr_device)
                        {
                            if(device.deviceToken != nil && device.endPointArn != nil && setting.email_isScheduleUpdate  == 1)
                            {
                                AWSSNS *sns = [AWSSNS defaultSNS];
                                AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                                NSString *message = [NSString stringWithFormat:@"%@\n%@",@"You have a new shift\n",passmessage];
                                input.message = message;
                                input.targetArn = device.endPointArn;
                                
                                [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
                                    
                                }];
                            }
                        }
                    }
                }
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
        return nil;
    }];
}
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
