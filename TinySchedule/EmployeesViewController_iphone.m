//
//  EmployeesViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "EmployeesViewController_iphone.h"

#define HeightForHeader 25
#define HeightForRow 56

@interface EmployeesViewController_iphone ()
{
    NSArray *arr_allJoinEmployees;
    NSArray *arr_noJoinEmployees;
    
    NSMutableDictionary *dict_joinEmployees;
    NSArray *arr_keys;
    
    NSTimer *myTimer;

}
@end

@implementation EmployeesViewController_iphone

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 0) {
        _addBtn.hidden = YES;
        _titleLabel.text = @"Coworkers";
    }
    
    [self setbeginRefreshing];
    
    [self initEmployees];
    
    //获取当前workplace的employee，第一次进入该页面，要获取数据一次，看看是否有new employee join，或者数据没有从另一台设备同步过来
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)initEmployees
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        arr_allJoinEmployees = [NSArray arrayWithArray:[DatabaseManager getAllJoinedEmployees]];
        arr_noJoinEmployees = [NSArray arrayWithArray:[DatabaseManager getNoJoinedEmployees]];
        dict_joinEmployees = [DatabaseManager getAllEmployeesByFullNameSorted:arr_allJoinEmployees];
    }
    else
    {
        dict_joinEmployees = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager getAllCoworkersByFullNameSorted]];
    }

    arr_keys = [[dict_joinEmployees allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    [_tableView reloadData];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addEmployee:(UIButton *)sender {
    EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
    [self.navigationController pushViewController:edit animated:YES];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        if (section != 0) {
            return HeightForHeader;
        }
        return 0;
    }
    else
    {
        return HeightForHeader;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForRow;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        return 1 + arr_keys.count;
    }
    else
    {
        return arr_keys.count;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        if (section == 0) {
            return 1;
        }
        else
        {
            if (arr_keys.count != 0) {
                NSString *key = [arr_keys objectAtIndex:section-1];
                NSMutableArray *arr= [dict_joinEmployees objectForKey:key];
                return arr.count;
            }
            return 0;
        }
    }
    else
    {
        if (arr_keys.count != 0) {
            NSString *key = [arr_keys objectAtIndex:section];
            NSMutableArray *arr= [dict_joinEmployees objectForKey:key];
            return arr.count;
        }
        return 0;
    }
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightForHeader)];
    headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, headerView.frame.size.width, headerView.frame.size.height)];
    NSString *title = @"";
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        if (arr_keys.count > section - 1) {
            NSString *key = [arr_keys objectAtIndex:section-1];
            title = key;
        }
    }
    else
    {
        if (arr_keys.count > section) {
            NSString *key = [arr_keys objectAtIndex:section];
            title = key;
        }
    }
    
    if (title != nil) {
        [titlelabel setAttributedText:SetAttributeText(title, SetColor(0, 0, 0, 0.3), SemiboldFontName, 14.0)];
    }
     [headerView addSubview:titlelabel];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"employeesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appdelegate.currentEmployee.isManager == 1 && indexPath.section == 0) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15, HeightForRow/2-36/2, 36, 36)];
        imageview.image = [UIImage imageNamed:@"newEmployee"];
        [cell.contentView addSubview:imageview];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 0, _tableView.frame.size.width - 75, HeightForRow)];
        label.text = @"New Employees";
        label.textColor = SetColor(0, 0, 0, 0.87);
        [cell.contentView addSubview:label];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(43, 10, 18, 18)];
        lab.backgroundColor = SetColor(248, 69, 70, 1.0);
        lab.layer.masksToBounds = YES;
        lab.layer.cornerRadius = 9;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:10.0];
        lab.text = [NSString stringWithFormat:@"%lu",(long)arr_noJoinEmployees.count];
        if (arr_noJoinEmployees.count == 0) {
            lab.hidden = YES;
        }
        else
        {
            lab.hidden = NO;
        }
        [cell.contentView addSubview:lab];
    }
    else
    {
        NSString *key = nil;
        if (appdelegate.currentEmployee.isManager == 1) {
            key = [arr_keys objectAtIndex:indexPath.section - 1];
        }
        else
        {
            key = [arr_keys objectAtIndex:indexPath.section];
        }
        NSMutableArray *arr= [dict_joinEmployees objectForKey:key];
        if (arr.count > indexPath.row) {
            
            Employees *employee = [arr objectAtIndex:indexPath.row];
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, HeightForRow/2-36/2, 36, 36)];
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
                lab.font = [UIFont systemFontOfSize:14.0];
                [imageview addSubview:lab];
            }
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 0, ScreenWidth-78, HeightForRow)];
            label.text = [NSString stringWithFormat:@"%@",employee.fullName];
            label.textColor = TextColorAlpha_87;
            label.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:label];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(68, HeightForRow-0.5, ScreenWidth-68, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            if(indexPath.row == arr.count-1)
            {
                line.hidden = YES;
            }
            if(indexPath.section == arr_keys.count && indexPath.row == arr.count-1)
            {
                line.hidden = NO;
                line.frame = CGRectMake(0, HeightForRow-0.5, ScreenWidth, 0.5);
            }
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        if (indexPath.section == 0) {
            NewEmployeesViewController_iphone *new = [[NewEmployeesViewController_iphone alloc]init];
            if (arr_noJoinEmployees.count != 0) {
                new.arr_newEmployees = [NSMutableArray arrayWithArray:arr_noJoinEmployees];
            }
            [self.navigationController pushViewController:new animated:YES];
        }
        else
        {
            NSString *key = [arr_keys objectAtIndex:indexPath.section-1];
            NSMutableArray *arr= [dict_joinEmployees objectForKey:key];
            Employees *employee = [arr objectAtIndex:indexPath.row];
            EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
            edit.employeeUuid = employee.uuid;
            [self.navigationController pushViewController:edit animated:YES];
        }
    }
    else
    {
//        NSString *key = [arr_keys objectAtIndex:indexPath.section];
//        NSMutableArray *arr= [dict_joinEmployees objectForKey:key];
//        Employees *employee = [arr objectAtIndex:indexPath.row];
//        EditEmployeeViewController_iphone *edit = [EditEmployeeViewController_iphone new];
//        edit.employeeUuid = employee.uuid;
//        [self.navigationController pushViewController:edit animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setbeginRefreshing
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
    
}
-(void) refreshView:(UIRefreshControl *)refresh
{
    if (_refreshControl.refreshing) {
        [self performSelector:@selector(refreshTableView:) withObject:refresh afterDelay:0];
    }
}
-(void)refreshTableView:(UIRefreshControl *)refresh{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/employee",api_workplace,appdelegate.currentWorkplace.uuid];
    [HttpRequestManager requestWithType:requestType_GET withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSArray *arr = (NSArray *)[DatabaseManager dictionaryWithJsondata:data];
        
        [refresh endRefreshing];
        
        if (response.statusCode == 200) {
            
            NSArray *arr_getAllLocalEmployee = [DatabaseManager getAllEmployees];
            NSString *employeeUuids = @"";
            
            for (NSDictionary *dict in arr) {
                
                Employees *employee = [DatabaseManager getEmployeeByUuid:[dict objectForKey:@"employeeId"]];
                if (employee == nil) {
                    employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employees" inManagedObjectContext:context];
                }
                employee.uuid = [dict objectForKey:@"employeeId"];
                employee.fullName = @"A Aaaaa";
                employee.isManager = [[dict objectForKey:@"isManager"] intValue];
                employee.isPermitted = [[dict objectForKey:@"isPermitted"] intValue];
                
                [context save:nil];
                
                employeeUuids = [NSString stringWithFormat:@"%@,%@",employeeUuids,[dict objectForKey:@"employeeId"]];
            }
            
            for (Employees *employee in arr_getAllLocalEmployee) {
                if (![employeeUuids containsString:employee.uuid]) {
                    [context deleteObject:employee];
                    [context save:nil];
                }
            }
            
            [self initEmployees];
        }
        
    } withFailureBlock:^(NSError *error){
        
    }];
}


@end
