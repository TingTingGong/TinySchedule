//
//  KnowledgeShiftViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "KnowledgeShiftViewController_iphone.h"

@interface KnowledgeShiftViewController_iphone ()
{
    NSDictionary *dict_shifts;
    NSArray *arr_keys;
}
@end

@implementation KnowledgeShiftViewController_iphone

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    dict_shifts = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager getAllMyAcknowledgeShifts]];
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
    arr_keys = [NSArray arrayWithArray:arr_temp];
    
    [_tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = CGRectMake(0, 157, ScreenWidth, ScreenHeight-157-50);
    _line.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    if (ScreenWidth == 320) {
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
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
    NSMutableArray *arr = [dict_shifts objectForKey:key];
    return arr.count;
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
    
    
    NSString *key = [arr_keys objectAtIndex:indexPath.section];
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[dict_shifts objectForKey:key]];
    Shifts *shift = [arr_temp objectAtIndex:indexPath.row];
    Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];

    if (indexPath.row > arr_temp.count-1) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, 59.5, ScreenWidth-20, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    if (indexPath.row == 0 && arr_temp.count == 1) {
        NSInteger nextSection = indexPath.section+1;
        if (arr_keys.count-1 >= nextSection) {
            
        }
        else
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(20, 59.5, ScreenWidth-20, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 28, 28)];
    imageview.image = [UIImage imageNamed:@"circle_green"];
    [cell.contentView addSubview:imageview];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 200, 20)];
    lable.textColor = SetColor(3, 3, 3, 1.0);
    lable.text = [NSString stringWithFormat:@"%@",shift.string_time];
    [cell.contentView addSubview:lable];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 34, ScreenWidth-64, 16)];
    detailLabel.textColor = SetColor(0, 0, 0, 0.3);
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.text = [NSString stringWithFormat:@"At %@",location.name];
    [cell.contentView addSubview:detailLabel];
    
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
    
    if (shift.positionUuid != nil) {
        Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
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
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)knowAll:(UIButton *)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in arr_keys) {
        NSMutableArray *a = [dict_shifts objectForKey:key];
        for (Shifts *s in a) {
            [arr addObject:s];
        }
    }
    
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
    for (Shifts *shift in arr) {
        
        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
        
        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
        createdate.S = shift.createDate;
        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
        modifyDate.S = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        AWSDynamoDBAttributeValue *uuid = [AWSDynamoDBAttributeValue new];
        uuid.S = shift.uuid;
        AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
        employeeuuid.S = appDelegate.currentEmployee.uuid;
        AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
        employeename.S = shift.employeeName;
        AWSDynamoDBAttributeValue *namaeruuid = [AWSDynamoDBAttributeValue new];
        namaeruuid.S = shift.managerUuid;
        AWSDynamoDBAttributeValue *parentuuid = [AWSDynamoDBAttributeValue new];
        parentuuid.S = shift.parentUuid;
        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
        isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:shift.isDelete]];
        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
        tablename.S = @"Shifts";
        AWSDynamoDBAttributeValue *shift_positionUuid = [AWSDynamoDBAttributeValue new];
        if (shift.positionUuid != nil) {
            shift_positionUuid.S = shift.positionUuid;
        }
        AWSDynamoDBAttributeValue *shift_locationUuid = [AWSDynamoDBAttributeValue new];
        shift_locationUuid.S = shift.locationUuid;
        AWSDynamoDBAttributeValue *shift_startDate = [AWSDynamoDBAttributeValue new];
        shift_startDate.S = shift.startDate;
        AWSDynamoDBAttributeValue *shift_startTime = [AWSDynamoDBAttributeValue new];
        shift_startTime.S = shift.startTime;
        AWSDynamoDBAttributeValue *shift_endTime = [AWSDynamoDBAttributeValue new];
        shift_endTime.S = shift.endTime;
        AWSDynamoDBAttributeValue *shift_totalHours = [AWSDynamoDBAttributeValue new];
        shift_totalHours.S = shift.totalHours;
        AWSDynamoDBAttributeValue *shift_unPaidBreak = [AWSDynamoDBAttributeValue new];
        shift_unPaidBreak.S = shift.unpaidBreak;
        AWSDynamoDBAttributeValue *shift_notes = [AWSDynamoDBAttributeValue new];
        if (shift.notes != nil && ![shift.notes isEqualToString:@""]) {
            shift_notes.S = shift.notes;
        }
        AWSDynamoDBAttributeValue *shift_strYear = [AWSDynamoDBAttributeValue new];
        shift_strYear.S = shift.string_year;
        AWSDynamoDBAttributeValue *shift_strMonth = [AWSDynamoDBAttributeValue new];
        shift_strMonth.S = shift.string_month;
        AWSDynamoDBAttributeValue *shift_strDay = [AWSDynamoDBAttributeValue new];
        shift_strDay.S = shift.string_day;
        AWSDynamoDBAttributeValue *shift_strWeek = [AWSDynamoDBAttributeValue new];
        shift_strWeek.S = shift.string_week;
        AWSDynamoDBAttributeValue *shift_strTime = [AWSDynamoDBAttributeValue new];
        shift_strTime.S = shift.string_time;
        AWSDynamoDBAttributeValue *shift_isTake = [AWSDynamoDBAttributeValue new];
        shift_isTake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
        AWSDynamoDBAttributeValue *shift_takedState = [AWSDynamoDBAttributeValue new];
        shift_takedState.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:shift.takeState]];
        
        if (shift.positionUuid == nil && (shift.notes == nil || [shift.notes isEqualToString:@""])) {
            
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": uuid,@"managerUuid": namaeruuid,@"parentUuid": parentuuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid != nil && (shift.notes == nil || [shift.notes isEqualToString:@""]))
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": uuid,@"managerUuid": namaeruuid,@"parentUuid": parentuuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_positionUuid": shift_positionUuid,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid == nil && (shift.notes != nil && ![shift.notes isEqualToString:@""]))
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": uuid,@"managerUuid": namaeruuid,@"parentUuid": parentuuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_notes": shift_notes,@"shift_employeeName":employeename};
        }
        else
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": uuid,@"managerUuid": namaeruuid,@"parentUuid": parentuuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": shift_locationUuid,@"shift_startDate": shift_startDate,@"shift_startTime": shift_startTime,@"shift_endTime": shift_endTime,@"shift_totalHours": shift_totalHours,@"shift_unPaidBreak": shift_unPaidBreak,@"shift_strYear": shift_strYear,@"shift_strMonth": shift_strMonth,@"shift_strDay": shift_strDay,@"shift_strWeek": shift_strWeek,@"shift_strTime": shift_strTime,@"shift_isTake": shift_isTake,@"shift_takedState": shift_takedState,@"shift_positionUuid": shift_positionUuid,@"shift_notes": shift_notes,@"shift_employeeName":employeename};
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
                [self dismissViewControllerAnimated:YES completion:nil];
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
                
                for (Shifts *shift in arr) {

                    shift.isTake = 1;
                    [context save:nil];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }

        return nil;
    }];
}
@end
