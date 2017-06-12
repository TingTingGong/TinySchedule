//
//  SaveShiftViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SaveShiftViewController_iphone.h"

#define HeaderImageName @"headerImageName"
#define HighlitedHeaderImageName @"highlitedHeaderImageName"
#define HeaderTitle @"headerTitle"
#define placeHolder @"You can leave a message here."

@interface SaveShiftViewController_iphone ()
{
    NSMutableArray *arr_header;
    NSString *locationUuid;
    NSString *positionUuid;
    NSString *employeeUuid;
    
    UILabel *locationLabel;
    UILabel *positionLabel;
    UILabel *employeeLabel;
    int myNumber;
    NSString *notes;
    UITextField *textField;
    UITextView *mytextView;
}
@end

@implementation SaveShiftViewController_iphone
@synthesize dict_pass;

-(void) getlocationUuid:(NSMutableArray *) arr_locationuuid
{
    if (arr_locationuuid.count != 0) {
        locationUuid = [arr_locationuuid objectAtIndex:0];
    }
    Locations *l = [DatabaseManager getLocationByUuid:locationUuid];
    locationLabel.text = l.name;
    Positions *po = [DatabaseManager getPositionByUuid:positionUuid];

    if (employeeUuid != nil && [l.employees containsString:employeeUuid] && [po.employees containsString:employeeUuid]) {

    }
    else
    {
        if (![mytextView.text isEqualToString:placeHolder] && ![mytextView.text isEqualToString:@""]) {
            notes = mytextView.text;
        }
        else if ([mytextView.text isEqualToString:placeHolder] || [mytextView.text isEqualToString:@""])
        {
            notes = placeHolder;
        }
        employeeUuid = nil;
        employeeLabel.text = @"Open Shift";
        [self setTableViewFrame];
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
    if (![mytextView.text isEqualToString:placeHolder] && ![mytextView.text isEqualToString:@""]) {
        notes = mytextView.text;
    }
    else if ([mytextView.text isEqualToString:placeHolder] || [mytextView.text isEqualToString:@""])
    {
        notes = placeHolder;
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
    if (![mytextView.text isEqualToString:placeHolder] && ![mytextView.text isEqualToString:@""]) {
        notes = mytextView.text;
    }
    else if ([mytextView.text isEqualToString:placeHolder] || [mytextView.text isEqualToString:@""])
    {
        notes = placeHolder;
    }
    [self setTableViewFrame];
}

-(void)setTableViewFrame
{
    if (employeeUuid == nil ) {
        
        _tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, 44 * 4 + 110);
    }
    else
    {
        _tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, 44 * 3 + 110);
    }
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    notes = placeHolder;
    myNumber = 1;
    
    for (int i = 0; i < 4; i++) {
        
        NSMutableDictionary *dit = [NSMutableDictionary dictionary];
        if (i == 0) {
            [dit setObject:@"s_location_dark" forKey:HeaderImageName];
            [dit setObject:@"LOCATION" forKey:HeaderTitle];
        }
        else if (i == 1) {
            [dit setObject:@"s_position_dark" forKey:HeaderImageName];
            [dit setObject:@"POSITION" forKey:HeaderTitle];
        }
        else if (i == 2) {
            [dit setObject:@"s_who_dark" forKey:HeaderImageName];
            [dit setObject:@"WHO" forKey:HeaderTitle];
        }
        else if (i == 3) {
            [dit setObject:@"s_number" forKey:HeaderImageName];
            [dit setObject:@"NUMBER" forKey:HeaderTitle];
        }
        if (arr_header == nil) {
            arr_header = [NSMutableArray arrayWithObject:dit];
        }
        else
        {
            [arr_header addObject:dit];
        }
    }
    
    locationUuid = [DatabaseManager getDefaultLocationUuid];
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavibarHeight, ScreenWidth, 44 * 4 + 110) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self.view addSubview:_tableView];
    }
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;

    // Do any additional setup after loading the view from its nib.
}

/************************************  table view  ************************************/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    view.backgroundColor = SetColor(251, 251, 251, 1.0);
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            if (employeeUuid != nil) {
                textField.hidden = YES;
                return 0;
            }
            else
            {
                textField.hidden = NO;
                return 44;
            }
        }
        return 44;
    }
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row != 3 && indexPath.section != 1)
    {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        if(indexPath.section == 1)
        {
            line.frame = CGRectMake(16, 99.5, ScreenWidth-16, 0.5);
        }
        if (indexPath.row == 2 && employeeUuid != nil) {
            line.hidden = YES;
        }
    }
    
    if (indexPath.section == 0) {
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        imageview.image = [UIImage imageNamed:[[arr_header objectAtIndex:indexPath.row] objectForKey:HeaderImageName]];
        [cell.contentView addSubview:imageview];
        
        UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
        if([[arr_header objectAtIndex:indexPath.row] objectForKey:HeaderTitle] != nil)
        {
            [lab_title setAttributedText:SetAttributeText([[arr_header objectAtIndex:indexPath.row] objectForKey:HeaderTitle], SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
        }
         [cell.contentView addSubview:lab_title];
        
        if (indexPath.row == 0) {
            Locations *location = [DatabaseManager getLocationByUuid:locationUuid];
            locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            locationLabel.textColor = TextColorAlpha_54;
            locationLabel.font = [UIFont systemFontOfSize:17.0];
            locationLabel.text = location.name;
            locationLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:locationLabel];
        }
        else if (indexPath.row == 1)
        {
            NSString *name = @"Unassigned";
            if (positionUuid != nil) {
                Positions *position = [DatabaseManager getPositionByUuid:positionUuid];
                name = position.name;
            }
            positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            positionLabel.textColor = TextColorAlpha_54;
            positionLabel.font = [UIFont systemFontOfSize:17.0];
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
            }
            employeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            employeeLabel.textColor = TextColorAlpha_54;
            employeeLabel.font = [UIFont systemFontOfSize:17.0];
            employeeLabel.text = name;
            employeeLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:employeeLabel];
        }
        else
        {
            textField = [[UITextField alloc]initWithFrame:CGRectMake(150, 0, ScreenWidth-166, 44)];
            textField.delegate = self;
            if (myNumber != 0) {
                textField.text = [NSString stringWithFormat:@"%d",myNumber];
            }
            textField.textAlignment = NSTextAlignmentRight;
            textField.textColor = TextColorAlpha_54;
            textField.tintColor = AppMainColor;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:textField];
            
            if(employeeUuid != nil)
            {
                imageview.hidden = YES;
                lab_title.hidden = YES;
                textField.hidden = YES;
            }
        }
    }
    else
    {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 25, 25)];
        imageview.image = [UIImage imageNamed:@"s_notes_dark"];
        [cell.contentView addSubview:imageview];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 60, 25)];
        lab.text = @"NOTES";
        lab.font = [UIFont fontWithName:SemiboldFontName size:14.0];
        [cell.contentView addSubview:lab];
        
        mytextView = [[UITextView alloc]initWithFrame:CGRectMake(46, 35, ScreenWidth-62, 64)];
        mytextView.textColor = TextColorAlpha_54;
        mytextView.delegate = self;
        mytextView.text = notes;
        mytextView.font = [UIFont systemFontOfSize:17.0];
        [cell.contentView addSubview:mytextView];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textField resignFirstResponder];
    if (indexPath.section == 0) {
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
            employeeV.startTimeStamp = [dict_pass objectForKey:@"start_timeStamp"];
            employeeV.endTimeStamp = [dict_pass objectForKey:@"end_timeStamp"];
            employeeV.startDateStamp = [dict_pass objectForKey:@"start_dateStamp"];
            [self.navigationController pushViewController:employeeV animated:YES];
        }
    }
}
         
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
    [mytextView resignFirstResponder];
}
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder])
    {
        textView.text = @"";
    }
}
-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = textView.text;
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([string length] < 1){
        textView.text = placeHolder;
    }
}
             
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
     if ([text isEqualToString:@"\n"]) {
      [textView resignFirstResponder];
           return NO;
      }
      return YES;
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Save",@"Save & Publish", nil];
    for (int i = 0; i < arr.count; i++) {
        
        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:[arr objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self alertHandle:i];
        }];
        [alertController addAction:otherButton];
        alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
             
-(void) alertHandle:(NSInteger) index
{
    [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
    [textField resignFirstResponder];
    [mytextView resignFirstResponder];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DDBDataModel *model = [[DDBDataModel alloc]init];
    model.createDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    model.modifyDate = model.createDate;
    model.uuid = [StringManager getItemID];
    model.managerUuid = appDelegate.currentEmployee.uuid;
    model.parentUuid = appDelegate.currentWorkplace.uuid;
    model.tableIdentityID = @"Shifts";
    model.isDelete = [NSNumber numberWithInt:0];
    model.shift_employeeUuid = employeeUuid;
    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    model.shift_employeeName = employee.fullName;
    if (employeeUuid == nil) {
        model.shift_employeeUuid = OpenShiftEmployeeUuid;
        model.shift_employeeName = OpenShiftEmployeeName;
    }
    else
    {
        //指定了employee，若指定manager自己，则直接knowledge
        if([employeeUuid isEqualToString:appDelegate.currentEmployee.uuid] || employeeUuid == nil)
        {
            model.shift_isTake = [NSNumber numberWithInt:1];
        }
        else
        {
            model.shift_isTake = [NSNumber numberWithInt:0];
        }
    }
    if (positionUuid != nil) {
        model.shift_positionUuid = positionUuid;
    }
    model.shift_locationUuid = locationUuid;
    model.shift_startDate = [dict_pass objectForKey:@"start_dateStamp"];
    model.shift_startTime = [dict_pass objectForKey:@"start_timeStamp"];
    model.shift_endTime = [dict_pass objectForKey:@"end_timeStamp"];
    model.shift_totalHours = [dict_pass objectForKey:@"total_hours"];
    model.shift_unPaidBreak = [dict_pass objectForKey:@"select_unpaidBreak"];
    model.shift_employeesNumbers = [NSNumber numberWithInt:0];
    if (employeeUuid == nil) {
        model.shift_employeesNumbers = [NSNumber numberWithInt:[textField.text intValue]];
    }
    mytextView.text = [mytextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([mytextView.text length] > 0 && ![mytextView.text isEqualToString:placeHolder]) {
        model.shift_notes = mytextView.text;
    }
    model.shift_strYear = [dict_pass objectForKey:@"year"];
    model.shift_strMonth = [dict_pass objectForKey:@"month"];
    model.shift_strDay = [dict_pass objectForKey:@"day"];
    model.shift_strWeek = [dict_pass objectForKey:@"week"];
    model.shift_strTime = [dict_pass objectForKey:@"select_time"];
    model.shift_haveTakedEmployeesNumber = [NSNumber numberWithInt:0];
    
    //save
    if (index == 0) {
        
        model.shift_takedState = [NSNumber numberWithInt:0];
    }
    //save & publish
    else if (index == 1)
    {
        model.shift_takedState = [NSNumber numberWithInt:1];
    }
    
    if (employeeUuid == nil && [textField.text intValue] == 0) {
        
        model.shift_employeesNumbers = [NSNumber numberWithInt:1];
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
                     
                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                     Shifts *shift = [NSEntityDescription insertNewObjectForEntityForName:@"Shifts" inManagedObjectContext:context];
                     shift.createDate = model.createDate;
                     shift.modifyDate = model.modifyDate;
                     shift.uuid = model.uuid;
                     shift.parentUuid = model.parentUuid;
                     shift.managerUuid = model.managerUuid;
                     shift.isDelete = [model.isDelete shortValue];
                     shift.isTake = [model.shift_isTake shortValue];
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
                     shift.haveTakedEmployeesNumber = 0;
                     shift.takeState = [model.shift_takedState shortValue];
                     
                     [context save:nil];
                     
                     //是否同步数据到calendar
                     [DatabaseManager syncShiftToCalendar:shift.uuid andIsDelete:0];
                     
                     HistoryShiftTime *history = [DatabaseManager getExistShiftTime:shift];
                     if (history == nil) {
                         history = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryShiftTime" inManagedObjectContext:context];
                         NSDictionary *dict = [StringManager interceptionTime:shift.string_time];
                         history.string_startTime = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]];
                         history.string_endTime = [NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]];
                         history.string_break = shift.unpaidBreak;
                         history.string_hours = shift.totalHours;
                         
                         [context save:nil];
                     }
                     
                     if(![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
                     {
                         [self afterSaveDataReturnLastView:shift];
                         
                         Setting *setting = [DatabaseManager getEmployeeSetting:shift.employeeUuid];
                         NSArray *arr_device = [DatabaseManager getDeviceTokenByEmployeeUuid:shift.employeeUuid];
                         NSString *timestring = [DatabaseManager getMyselfNotificationOfShift:shift];
                         for(DeviceToken *device in arr_device)
                         {
                             if(device.deviceToken != nil && device.endPointArn != nil && setting.email_isScheduleUpdate  == 1)
                             {
                                 AWSSNS *sns = [AWSSNS defaultSNS];
                                 AWSSNSPublishInput *input = [AWSSNSPublishInput new];
                                 NSString *message = [NSString stringWithFormat:@"%@\n%@",Notification_NewShift,timestring];
                                 input.message = message;
                                 input.targetArn = device.endPointArn;
                                 
                                 [sns publish:input completionHandler:^(AWSSNSPublishResponse *response, NSError *error){
                                     
                                 }];
                             }
                         }
                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                         
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                     else
                     {
                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];;
                         
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                 });
                 
             }
         }
         return nil;
     }];
}

         
-(void) afterSaveDataReturnLastView:(Shifts *) newShift
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
             
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
