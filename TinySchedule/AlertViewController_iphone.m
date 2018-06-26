//
//  AlertViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "AlertViewController_iphone.h"

@interface AlertViewController_iphone ()
{
    NSArray *arr_title;
    Setting *setting;
    int16_t number1;
    int16_t number2;
    int16_t number3;
    int16_t number4;
    int16_t number5;
    NSString *string1;
    NSString *string2;
    UILabel *timeLabel;
}
@end

@implementation AlertViewController_iphone
@synthesize category;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    setting = [DatabaseManager getEmployeeSetting:appdelegate.currentEmployee.uuid];
    
    if ([category isEqualToString:@"0"]) {
        number1 = setting.email_isTimeOffTequest;
        number2 = setting.email_isDropRequest;
        number3 = setting.email_isScheduleUpdate;
        number4 = setting.email_isNewEmployee;
        number5 = setting.email_isAvailabilityChange;
        if (setting.email_noNotifyStartTime == nil) {
            string1 = nil;
            string2 = nil;
        }
        else
        {
            string1 = setting.email_noNotifyStartTime;
            string2 = setting.email_noNotifyEndTime;
        }
        _titleLabel.text = @"Email-Alert";
    }
    else
    {
        number1 = setting.notification_isTimeOffTequest;
        number2 = setting.notification_isDropRequest;
        number3 = setting.notification_isScheduleUpdate;
        number4 = setting.notification_isNewEmployee;
        number5 = setting.notification_isAvailabilityChange;
        if (setting.notification_noNotifyStartTime == nil) {
            string1 = nil;
            string2 = nil;
        }
        else
        {
            string1 = setting.notification_noNotifyStartTime;
            string2 = setting.notification_noNotifyEndTime;
        }
        _titleLabel.text = @"Notification";
    }
    
    if (appdelegate.currentEmployee.isManager == 0) {
        arr_title = [NSArray arrayWithObjects:@"Time-Off Request",@"Swap / Drop in Requests",@"Schedule Updates", nil];
        //_tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, 216);
    }
    else
    {
        arr_title = [NSArray arrayWithObjects:@"Time-Off Request",@"Swap / Drop in Requests",@"Schedule Updates",@"New Employees",@"Availability Change", nil];
    }
    
    [_tableView reloadData];

    // Do any additional setup after loading the view from its nib.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, ScreenWidth-16, 35)];
    headerLabel.textColor = SetColor(0, 0, 0, 0.3);
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    if ([category isEqualToString:@"0"]) {
        headerLabel.text = @"E-mail Alert";
    }
    else
    {
        headerLabel.text = @"Notification Setting";
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_title.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"notificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [arr_title objectAtIndex:indexPath.row];
    cell.textLabel.textColor = SetColor(0, 0, 0, 0.87);
    
    if (indexPath.row < arr_title.count) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }

    UISwitch *myswitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-66, 6, 0, 0)];
    myswitch.tag = indexPath.row;
    myswitch.on = NO;
    [myswitch addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:myswitch];
    
    if (indexPath.row == 0 && number1 == 1) {
        myswitch.on = YES;
    }
    else if (indexPath.row == 1 && number2 == 1)
    {
        myswitch.on = YES;
    }
    else if (indexPath.row == 2 && number3 == 1)
    {
        myswitch.on = YES;
    }
    else if (indexPath.row == 3 && number4 == 1)
    {
        myswitch.on = YES;
    }
    else if (indexPath.row == 4 && number5 == 1)
    {
        myswitch.on = YES;
    }
    
    
    return cell;
}

-(void) changeValue:(UISwitch *) sender
{
    int16_t statenumber = 0;
    
    if ([sender isOn] == YES) {
        sender.on = NO;
    }
    else
    {
        sender.on = YES;
        statenumber = 1;
    }
    
    
    if (sender.tag == 0) {
        number1 = statenumber;
    }
    else if (sender.tag == 1) {
        number2 = statenumber;
    }
    else if (sender.tag == 2) {
        number3 = statenumber;
    }
    else if (sender.tag == 3) {
        number4 = statenumber;
    }
    else if (sender.tag == 4) {
        number5 = statenumber;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([category isEqualToString:@"0"] && (number1 != setting.email_isTimeOffTequest || number2 != setting.email_isDropRequest || number3 != setting.email_isScheduleUpdate || number4 != setting.email_isNewEmployee || number5 != setting.email_isAvailabilityChange || (string1 != nil && ![string1 isEqualToString:setting.email_noNotifyStartTime]) || (string2 != nil && ![string2 isEqualToString:setting.email_noNotifyEndTime]))) {
        
        DDBDataModel *model = [[DDBDataModel alloc]init];
        model.createDate = setting.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = setting.uuid;
        model.managerUuid = setting.managerUuid;
        model.parentUuid = setting.parentUuid;
        model.setting_employeeUuid = appDelegate.currentEmployee.uuid;
        model.isDelete = [NSNumber numberWithShort:setting.isDelete];
        model.tableIdentityID = @"Setting";
        model.setting_email_isTimeOffTequest = [NSNumber numberWithShort:number1];
        model.setting_email_isDropRequest = [NSNumber numberWithShort:number2];
        model.setting_emailg_isScheduleUpdate = [NSNumber numberWithShort:number3];
        model.setting_email_isNewEmployee = [NSNumber numberWithShort:number4];
        model.setting_email_isAvailabilityChange = [NSNumber numberWithShort:number5];
        model.setting_notification_isTimeOffTequest = [NSNumber numberWithShort:setting.notification_isTimeOffTequest];
        model.setting_notification_isDropRequest = [NSNumber numberWithShort:setting.notification_isDropRequest];
        model.setting_notification_isScheduleUpdate = [NSNumber numberWithShort:setting.notification_isScheduleUpdate];
        model.setting_notification_isNewEmployee = [NSNumber numberWithShort:setting.notification_isNewEmployee];
        model.setting_notification_isAvailabilityChange = [NSNumber numberWithShort:setting.notification_isAvailabilityChange];
        if (string1 != nil && string2 != nil) {
            model.setting_email_noNotifyStartTime = string1;
            model.setting_email_noNotifyEndTime = string2;
        }
        if (setting.notification_noNotifyStartTime != nil && setting.notification_noNotifyEndTime != nil) {
            model.setting_notification_noNotifyStartTime = setting.notification_noNotifyStartTime;
            model.setting_notification_noNotifyEndTime = setting.notification_noNotifyEndTime;
        }
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        [[dynamoDBObjectMapper save:model]
         continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
             if (task.error) {
                 dispatch_async(dispatch_get_main_queue(), ^{

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
                         
                         NSManagedObjectContext *context = [appDelegate managedObjectContext];
                         
                         setting.modifyDate = model.modifyDate;
                         setting.email_isTimeOffTequest = [model.setting_email_isTimeOffTequest shortValue];
                         setting.email_isDropRequest = [model.setting_email_isDropRequest shortValue];
                         setting.email_isScheduleUpdate = [model.setting_emailg_isScheduleUpdate shortValue];
                         setting.email_isNewEmployee = [model.setting_email_isNewEmployee shortValue];
                         setting.email_isAvailabilityChange = [model.setting_email_isAvailabilityChange shortValue];
                         setting.notification_isTimeOffTequest = [model.setting_notification_isTimeOffTequest shortValue];
                         setting.notification_isDropRequest = [model.setting_notification_isDropRequest shortValue];
                         setting.notification_isScheduleUpdate = [model.setting_notification_isScheduleUpdate shortValue];
                         setting.notification_isNewEmployee = [model.setting_notification_isNewEmployee shortValue];
                         setting.notification_isAvailabilityChange = [model.setting_notification_isAvailabilityChange shortValue];
                         setting.email_noNotifyStartTime = model.setting_email_noNotifyStartTime;
                         setting.email_noNotifyEndTime = model.setting_email_noNotifyEndTime;
                         setting.notification_noNotifyStartTime = model.setting_notification_noNotifyStartTime;
                         setting.notification_noNotifyEndTime = model.setting_notification_noNotifyStartTime;
                         
                         [context save:nil];
                         
                     });
                 }
             }
             return nil;
         }];
    }
    else if ([category isEqualToString:@"1"] && (number1 != setting.notification_isTimeOffTequest || number2 != setting.notification_isDropRequest || number3 != setting.notification_isScheduleUpdate || number4 != setting.notification_isNewEmployee || number5!= setting.notification_isAvailabilityChange || (string1 != nil && ![string1 isEqualToString:setting.notification_noNotifyStartTime]) || (string2 != nil && ![string2 isEqualToString:setting.notification_noNotifyEndTime])))
    {
        
        DDBDataModel *model = [[DDBDataModel alloc]init];
        model.createDate = setting.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = setting.uuid;
        model.managerUuid = setting.managerUuid;
        model.parentUuid = setting.parentUuid;
        model.isDelete = [NSNumber numberWithShort:setting.isDelete];
        model.tableIdentityID = @"Setting";
        model.setting_employeeUuid = appDelegate.currentEmployee.uuid;;
        model.setting_email_isTimeOffTequest = [NSNumber numberWithShort:setting.email_isTimeOffTequest];
        model.setting_email_isDropRequest = [NSNumber numberWithShort:setting.email_isDropRequest];
        model.setting_emailg_isScheduleUpdate = [NSNumber numberWithShort:setting.email_isScheduleUpdate];
        model.setting_email_isNewEmployee = [NSNumber numberWithShort:setting.email_isNewEmployee];
        model.setting_email_isAvailabilityChange = [NSNumber numberWithShort:setting.email_isAvailabilityChange];
        model.setting_notification_isTimeOffTequest = [NSNumber numberWithShort:number1];
        model.setting_notification_isDropRequest = [NSNumber numberWithShort:number2];
        model.setting_notification_isScheduleUpdate = [NSNumber numberWithShort:number3];
        model.setting_notification_isNewEmployee = [NSNumber numberWithShort:number4];
        model.setting_notification_isAvailabilityChange = [NSNumber numberWithShort:number5];
        if (string1 != nil && string2 != nil) {
            model.setting_notification_noNotifyStartTime = string1;
            model.setting_notification_noNotifyEndTime = string2;
        }
        if (setting.email_noNotifyStartTime != nil && setting.email_noNotifyEndTime != nil) {
            model.setting_email_noNotifyStartTime = setting.email_noNotifyStartTime;
            model.setting_email_noNotifyEndTime = setting.email_noNotifyEndTime;
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
                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         NSManagedObjectContext *context = [appDelegate managedObjectContext];
                         
                         setting.modifyDate = model.modifyDate;
                         setting.email_isTimeOffTequest = [model.setting_email_isTimeOffTequest shortValue];
                         setting.email_isDropRequest = [model.setting_email_isDropRequest shortValue];
                         setting.email_isScheduleUpdate = [model.setting_emailg_isScheduleUpdate shortValue];
                         setting.email_isNewEmployee = [model.setting_email_isNewEmployee shortValue];
                         setting.email_isAvailabilityChange = [model.setting_email_isAvailabilityChange shortValue];
                         setting.notification_isTimeOffTequest = [model.setting_notification_isTimeOffTequest shortValue];
                         setting.notification_isDropRequest = [model.setting_notification_isDropRequest shortValue];
                         setting.notification_isScheduleUpdate = [model.setting_notification_isScheduleUpdate shortValue];
                         setting.notification_isNewEmployee = [model.setting_notification_isNewEmployee shortValue];
                         setting.notification_isAvailabilityChange = [model.setting_notification_isAvailabilityChange shortValue];
                         setting.email_noNotifyStartTime = model.setting_email_noNotifyStartTime;
                         setting.email_noNotifyEndTime = model.setting_email_noNotifyEndTime;
                         setting.notification_noNotifyStartTime = model.setting_notification_noNotifyStartTime;
                         setting.notification_noNotifyEndTime = model.setting_notification_noNotifyStartTime;
                         
                         [context save:nil];
                         
                     });
                 }
             }
             return nil;
         }];
    }
}
@end
