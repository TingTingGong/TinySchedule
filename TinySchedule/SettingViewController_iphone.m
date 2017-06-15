//
//  SettingViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SettingViewController_iphone.h"

@interface SettingViewController_iphone ()
{
    NSMutableDictionary *dict;
    NSMutableArray *arr_calendarSubscribe;
}
@end

@implementation SettingViewController_iphone

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [_tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) initData
{
    dict = [NSMutableDictionary dictionary];
    //NSArray *arr = [NSArray arrayWithObjects:@"Publish & Notify",@"Calendar Sync",@"Push Notification",@"E-mail Alert",@"Profile Settings", nil];
    NSArray *arr0 = [NSArray arrayWithObjects:@"My Workplace",@"My Profile", nil];
    NSArray *arr = [NSArray arrayWithObjects:@"Publish & Notify",@"Calendar Sync",@"Push Notification",@"Email Alert", nil];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 0) {
        //arr = [NSArray arrayWithObjects:@"Calendar Sync",@"Push Notification",@"E-mail Alert",@"Profile Settings", nil];
        arr = [NSArray arrayWithObjects:@"Calendar Sync",@"Push Notification",@"Email Alert", nil];
    }
    [dict setObject:arr0 forKey:@"-1"];
    [dict setObject:arr forKey:@"0"];
    NSArray *arr2 = [NSArray arrayWithObjects:@"Help & Feedback",@"Change Paassword",@"Log Out", nil];
    [dict setObject:arr2 forKey:@"1"];
    
    arr_calendarSubscribe = [NSMutableArray arrayWithObjects:@"Your Schedule",@"Open Shifts",@"Entire Schedule", nil];
    NSArray *arr_location = [DatabaseManager getAllLocations];
    for (Locations *location in arr_location) {
        [arr_calendarSubscribe addObject:location];
    }
    
    [_tableView reloadData];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dict allKeys].count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *arr = [dict objectForKey:@"-1"];
        return arr.count;
    }
    else if (section == 1)
    {
        NSArray *arr = [dict objectForKey:@"0"];
        return arr.count;
    }
    else
    {
        NSArray *arr = [dict objectForKey:@"1"];
        return arr.count;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 2) {
        return 44;
    }
    return 60;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!(indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2))) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *arr = nil;
    if (indexPath.section == 0) {
        arr = [dict objectForKey:@"-1"];
    }
    else if (indexPath.section == 1) {
        arr = [dict objectForKey:@"0"];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ((indexPath.row == 1 && appdelegate.currentEmployee.isManager == 0) || (indexPath.row == 2 && appdelegate.currentEmployee.isManager == 1)) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-115, 0, 80, 60)];
            lab.textColor = SetColor(0, 0, 0, 0.3);
            lab.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:lab];
            if ([DatabaseManager userIsOpenNotification] == YES) {
                lab.text = @"On";
            }
            else
            {
                lab.text = @"Off";
            }
        }
    }
    else
    {
        arr = [dict objectForKey:@"1"];
        if (indexPath.row == 2) {
            cell.textLabel.textColor = SetColor(250, 67, 63, 1.0);
        }
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = SetColor(0, 0, 0, 0.87);
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ((indexPath.section == 1 && indexPath.row != 3 && appdelegate.currentEmployee.isManager == 1) || (indexPath.section == 1 && indexPath.row != 2 && appdelegate.currentEmployee.isManager == 0) || (indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 2)) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        if (indexPath.section == 2 && indexPath.row == 2) {
            line.frame = CGRectMake(16, 43.5, ScreenWidth-16, 0.5);
        }
    }

    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.textLabel.textColor = SetColor(250, 67, 63, 1.0);
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appdelegate.currentEmployee.isManager == 1) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                WorkPlacesViewController_iphone *place = [WorkPlacesViewController_iphone new];
                [self.navigationController pushViewController:place animated:YES];
            }
            else if (indexPath.row == 1)
            {
                EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                edit.employeeUuid = appdelegate.currentEmployee.uuid;
                [self.navigationController pushViewController:edit animated:YES];
            }
        }
        else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                PublishShiftViewController_iphone *publish = [PublishShiftViewController_iphone new];
                [self.navigationController pushViewController:publish animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [UIApplication sharedApplication].keyWindow.tintColor = SetColor(0 ,195, 0,1.0);
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Subscribe To:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelButton];
                
                for (int i = 0; i < arr_calendarSubscribe.count; i++) {
                    if (i < 3) {
                        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:[arr_calendarSubscribe objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self alertHandle:i];
                        }];
                        [alertController addAction:otherButton];
                        alertController.view.tintColor = AppMainColor;
                    }
                    else
                    {
                        Locations *location = [arr_calendarSubscribe objectAtIndex:i];
                        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:location.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self alertHandle:i];
                        }];
                        [alertController addAction:otherButton];
                        alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
                    }
                }
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (indexPath.row == 2)
            {
                if ([DatabaseManager userIsOpenNotification] == NO) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Tiny Schedule does not have access to your notification. To enable access, tap Settings and turn on Notification." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                        
                    }];
                    [alertController addAction:okAction];
                    [alertController addAction:changeAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    AlertViewController_iphone *alert = [AlertViewController_iphone new];
                    alert.category = @"1";
                    [self.navigationController pushViewController:alert animated:YES];
                }
            }
            else if (indexPath.row == 3)
            {
                AlertViewController_iphone *alert = [AlertViewController_iphone new];
                alert.category = @"0";
                [self.navigationController pushViewController:alert animated:YES];
            }
        }
        else
        {
            if (indexPath.row == 0) {
                HelpViewController_iphone *help = [HelpViewController_iphone new];
                [self.navigationController pushViewController:help animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [self startModifyPassword];
            }
            else
            {
                [self startLogOut];
            }
        }
    }
    else
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                WorkPlacesViewController_iphone *place = [WorkPlacesViewController_iphone new];
                [self.navigationController pushViewController:place animated:YES];
            }
            else if (indexPath.row == 1)
            {
                EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                edit.employeeUuid = appdelegate.currentEmployee.uuid;
                [self.navigationController pushViewController:edit animated:YES];
            }
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                
                [UIApplication sharedApplication].keyWindow.tintColor = AppMainColor;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Subscribe To:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelButton];
                
                UIAlertAction *otherButton1 = [UIAlertAction actionWithTitle:[arr_calendarSubscribe objectAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self alertHandle:0];
                }];
                [alertController addAction:otherButton1];
                alertController.view.tintColor = AppMainColor;
                UIAlertAction *otherButton2 = [UIAlertAction actionWithTitle:[arr_calendarSubscribe objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self alertHandle:1];
                }];
                [alertController addAction:otherButton2];
                alertController.view.tintColor = AppMainColor;
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (indexPath.row == 1)
            {
                if ([DatabaseManager userIsOpenNotification] == NO) {

    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification" message:@"Tiny Schedule does not have access to your notification. To enable access, tap Settings and turn on Notification." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        }
                    }];
                    [alertController addAction:okAction];
                    [alertController addAction:changeAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    AlertViewController_iphone *alert = [AlertViewController_iphone new];
                    alert.category = @"1";
                    [self.navigationController pushViewController:alert animated:YES];
                }
            }
            else if (indexPath.row == 2)
            {
                AlertViewController_iphone *alert = [AlertViewController_iphone new];
                alert.category = @"0";
                [self.navigationController pushViewController:alert animated:YES];
            }
        }
        else
        {
            if (indexPath.row == 0) {
                HelpViewController_iphone *help = [HelpViewController_iphone new];
                [self.navigationController pushViewController:help animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [self startModifyPassword];
            }
            else
            {
                [self startLogOut];
            }
        }
    }
}

-(void)startModifyPassword
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *message = [NSString stringWithFormat:@"An email will been sent into %@.\n%@\n%@",appdelegate.currentEmployee.email,@"Follow the link in it.",@"Your password will be reset in a minute."];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Change Password" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    }];
    [alertController addAction:changeAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) startLogOut
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log out" message:@"Sure to log out?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:InternationalL(@"Sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [UserEntity loginOut];
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    }];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) alertHandle:(NSInteger) index
{
    NSArray *arr_saveToCalendar = nil;
    NSString *subscribeuuid = nil;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (index < 3) {
        if (index == 0) {
            arr_saveToCalendar = [NSArray arrayWithArray:[DatabaseManager getAllMyShiftsArray]];
            subscribeuuid = @"0";
        }
        else if (index == 1)
        {
            subscribeuuid = @"1";
            if (appdelegate.currentEmployee.isManager == 0) {
                arr_saveToCalendar = [NSArray arrayWithArray:[DatabaseManager getEmployeeOpenShiftsArray]];
            }
            else
            {
                arr_saveToCalendar = [NSArray arrayWithArray:[DatabaseManager getManagerOpenShittArray]];
            }
        }
        else if (index == 2)
        {
            subscribeuuid = @"2";
            arr_saveToCalendar = [NSArray arrayWithArray:[DatabaseManager getEntireShiftsArray]];
        }
    }
    else
    {
        Locations *location = [arr_calendarSubscribe objectAtIndex:index];
        arr_saveToCalendar = [NSArray arrayWithArray:[DatabaseManager getShiftsArrayByLocationUuid:location.uuid]];
        subscribeuuid = location.uuid;
    }
    [SyncNewCalendar subscribeEventToMyCalendar:arr_saveToCalendar andSubscribeUuid:subscribeuuid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
