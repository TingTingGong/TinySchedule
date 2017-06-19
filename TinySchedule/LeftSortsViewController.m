//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by TinyWorks_Dev on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "MyScheduleViewController_phone.h"
#import "RequestViewController_phone.h"
#import "AvailabilityViewController_iphone.h"
#import "EmployeesViewController_iphone.h"
#import "PositionsViewController_iphone.h"
#import "LocationsViewController_iphone.h"
#import "SettingViewController_iphone.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arr_mainTitle;
    NSArray *arr_images;
    UILabel *label_name;
    UILabel *label_identity;
}
@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(updateSidebar:) name:UpdateSidebarMenu object: nil];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    [self initLeftData];
}

-(void)updateSidebar:(NSNotification *)noti
{
    [self initLeftData];
}

-(void) initLeftData
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.currentEmployee != nil && appDelegate.currentWorkplace != nil) {
        if (appDelegate.currentEmployee.isManager == 1) {
            arr_mainTitle = [NSArray arrayWithObjects:@"Schedule",@"Requests",@"Availability",@"Employees",@"Positions",@"Locations",@"Settings", nil];
            arr_images = [NSArray arrayWithObjects:@"l_schedule",@"l_request",@"l_available",@"l_employee",@"l_position",@"l_location",@"l_setting", nil];
        }
        else
        {
            arr_mainTitle = [NSArray arrayWithObjects:@"Schedule",@"Requests",@"Availability",@"Coworkers",@"Settings", nil];
            arr_images = [NSArray arrayWithObjects:@"l_schedule",@"l_request",@"l_available",@"l_employee",@"l_setting", nil];
        }
    }
    [self.tableview reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return arr_mainTitle.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 143;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeAllSubviews];
    }
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if (indexPath.section == 0) {
        
        cell.backgroundColor = SetColor(250, 250, 250, 1.0);
        if (appdelegate.currentEmployee.headPortrait == nil) {
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-76)/2-56/2, 23, 56, 56)];
            label1.backgroundColor = SetColor(26, 131, 255, 1.0);
            label1.textAlignment = NSTextAlignmentCenter;
            label1.textColor = [UIColor whiteColor];
            label1.font = [UIFont boldSystemFontOfSize:16.0];
            label1.layer.masksToBounds = YES;
            label1.layer.cornerRadius = 56/2.0;
            label1.text = [StringManager getManyFirstLetterFromString:appdelegate.currentEmployee.fullName];
            [cell.contentView addSubview:label1];
        }
        else
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-76)/2-56/2, 23, 56, 56)];
            imageView.image = [UIImage imageWithData:appdelegate.currentEmployee.headPortrait];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 56/2.0;
            [cell.contentView addSubview:imageView];
        }
        
        if (label_name == nil) {
            label_name = [[UILabel alloc]initWithFrame:CGRectMake(0, 91, ScreenWidth-76, 20)];
            label_name.textAlignment = NSTextAlignmentCenter;
            label_name.textColor = TextColorAlpha_54;
            label_name.font = [UIFont fontWithName:SemiboldFontName size:17.0];
            [cell.contentView addSubview:label_name];
        }
        if(appdelegate.currentEmployee.fullName != nil)
        {
            label_name.text = appdelegate.currentEmployee.fullName;
        }
        
        if (label_identity == nil) {
            label_identity = [[UILabel alloc]initWithFrame:CGRectMake(0, 111, ScreenWidth-76, 14)];
            label_identity.textAlignment = NSTextAlignmentCenter;
            label_identity.textColor = SetColor(0, 0, 0, 0.3);
            label_identity.font = [UIFont systemFontOfSize:12.0];
            [cell.contentView addSubview:label_identity];
        }

        if (appdelegate.currentEmployee.isManager == 0) {
            label_identity.text = @"Employee";
        }
        else
        {
            label_identity.text = @"Manager";
        }
    }
    else
    {
        cell.textLabel.text = [arr_mainTitle objectAtIndex:indexPath.row];
        [cell.textLabel setAttributedText:SetAttributeText([arr_mainTitle objectAtIndex:indexPath.row], [UIColor colorWithRed:81/255.0 green:92/255.0 blue:81/255.0 alpha:1.0], LightFontName, 17.0)];
        cell.imageView.image = [UIImage imageNamed:[arr_images objectAtIndex:indexPath.row]];
        
        if(indexPath.row == 1 || indexPath.row == 3)
        {
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-100-16-30, 12, 30, 20)];
            lab.backgroundColor = SetColor(255, 103, 1, 1.0);
            lab.layer.cornerRadius = 10;
            lab.layer.masksToBounds = YES;
            lab.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:lab];
            
            
            NSArray *arr= [[DatabaseManager getAllRequests] objectForKey:@"0"];
            NSString *string = [NSString stringWithFormat:@"%lu",(long)arr.count];
            
            NSArray *arr2= [DatabaseManager getNoJoinedEmployees];
            NSString *string2 = [NSString stringWithFormat:@"%lu",(long)arr2.count];
            
            if (indexPath.row == 1) {
                [lab setAttributedText:SetAttributeText(string, [UIColor whiteColor], SemiboldFontName, 14.0)];
                [cell.contentView addSubview:lab];
                if (arr.count == 0) {
                    lab.hidden = YES;
                }
            }
            else if (indexPath.row == 3 && appdelegate.currentEmployee.isManager == 1)
            {
                [lab setAttributedText:SetAttributeText(string2, [UIColor whiteColor], SemiboldFontName, 14.0)];
                 [cell.contentView addSubview:lab];
                 if (arr2.count == 0) {
                     lab.hidden = YES;
                 }
            }
            
            if (indexPath.row == 3 && appdelegate.currentEmployee.isManager == 0) {
                lab.hidden = YES;
            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    if (indexPath.section == 0) {
        EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        edit.employeeUuid = appdelegate.currentEmployee.uuid;
        [tempAppDelegate.rootNaviContor pushViewController:edit animated:NO];
    }
    else
    {
        if (indexPath.row == 0) {
            if (tempAppDelegate.currentEmployee.isManager == 1) {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"filter"];
                [UserEntity setFilter:dict];
            }
            else
            {
                NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"filter"];
                [UserEntity setFilter:dict];
            }
            MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
            [tempAppDelegate.rootNaviContor pushViewController:schedule animated:NO];
        }
        else if (indexPath.row == 1)
        {
            RequestViewController_phone *request = [RequestViewController_phone new];
            [tempAppDelegate.rootNaviContor pushViewController:request animated:NO];
        }
        else if (indexPath.row == 2)
        {
            AvailabilityViewController_iphone *avai = [AvailabilityViewController_iphone new];
            avai.employeeUuid = tempAppDelegate.currentEmployee.uuid;
            [tempAppDelegate.rootNaviContor pushViewController:avai animated:NO];
        }
        else if (indexPath.row == 3)
        {
            EmployeesViewController_iphone *empoyee = [EmployeesViewController_iphone new];
            [tempAppDelegate.rootNaviContor pushViewController:empoyee animated:NO];
        }
        if (tempAppDelegate.currentEmployee.isManager == 1) {
            
            if (indexPath.row == 4)
            {
                PositionsViewController_iphone *position = [PositionsViewController_iphone new];
                [tempAppDelegate.rootNaviContor pushViewController:position animated:NO];
            }
            else if (indexPath.row == 5)
            {
                LocationsViewController_iphone *location = [LocationsViewController_iphone new];
                [tempAppDelegate.rootNaviContor pushViewController:location animated:NO];
            }
            else if (indexPath.row == 6)
            {
                SettingViewController_iphone *setting = [SettingViewController_iphone new];
                [tempAppDelegate.rootNaviContor pushViewController:setting animated:NO];
            }
        }
        else
        {
            if (indexPath.row == 4)
            {
                SettingViewController_iphone *setting = [SettingViewController_iphone new];
                [tempAppDelegate.rootNaviContor pushViewController:setting animated:NO];
            }
        }
    }
}

@end
