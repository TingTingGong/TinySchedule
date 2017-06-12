//
//  FilterEmployeeViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "FilterEmployeeViewController_iphone.h"

@interface FilterEmployeeViewController_iphone ()
{
    NSArray *arr_allJoinEmployees;
    NSArray *arr_allPositions;
    NSArray *arr_allLocations;
    BOOL isIncludeAll;
    
    NSDictionary *dict_temp;
}
@end

@implementation FilterEmployeeViewController_iphone
@synthesize category;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isIncludeAll = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    arr_allJoinEmployees = [NSArray arrayWithArray:[DatabaseManager getAllJoinedEmployees]];
    arr_allPositions = [NSArray arrayWithArray:[DatabaseManager getAllPositions]];
    arr_allLocations = [NSArray arrayWithArray:[DatabaseManager getAllLocations]];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    _line2.frame = CGRectMake(0, _line2.frame.origin.y, ScreenWidth, 0.5);
    _line2.backgroundColor = SepearateLineColor;
    
    _line3.frame = CGRectMake(0, _line3.frame.origin.y, ScreenWidth, 0.5);
    _line3.backgroundColor = SepearateLineColor;
    // Do any additional setup after loading the view from its nib.
}

-(void)initView
{
    float interVal = (ScreenWidth-80*2 - 60)/2;
    _excludeBtn.frame = CGRectMake(interVal, 0, 80, 48);
    _includeBtn.frame = CGRectMake(interVal+140, 0, 80, 48);
    _excludeImage.frame = CGRectMake(_excludeBtn.frame.origin.x, 48, _excludeBtn.frame.size.width, 2);
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44+50, ScreenWidth, ScreenHeight - (64+44+50))];
        if ([category isEqualToString:@"employee"]) {
            
            _label.text = @"Employees";
        }
        else if([category isEqualToString:@"position"])
        {
            _label.text = @"Positions";
        }
        else if([category isEqualToString:@"location"])
        {
            _label.text = @"Locations";
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([category isEqualToString:@"employee"]) {
        return arr_allJoinEmployees.count+1;
    }
    else if([category isEqualToString:@"position"])
    {
        return arr_allPositions.count+1;
    }
    else if([category isEqualToString:@"location"])
    {
        return arr_allLocations.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = SetColor(0, 0 ,0, 0.3);
    cell.textLabel.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    
    if ([category isEqualToString:@"employee"]) {
        if (arr_allJoinEmployees.count != 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Open Shift";
                cell.textLabel.textColor = AppMainColor;
            }
            else
            {
                Employees *employee = [arr_allJoinEmployees objectAtIndex:indexPath.row-1];
                cell.textLabel.text = employee.fullName;
            }
            
        }
    }
    else if([category isEqualToString:@"position"])
    {
        if (arr_allPositions.count != 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Unassigned";
            }
            else
            {
                Positions *position = [arr_allPositions objectAtIndex:indexPath.row-1];
                cell.textLabel.text = position.name;
            }
        }
        else
        {
            cell.textLabel.text = @"Unassigned";
        }
    }
    else
    {
        if (arr_allLocations.count != 0) {
            Locations *location = [arr_allLocations objectAtIndex:indexPath.row];
            cell.textLabel.text = location.name;
        }
    }
    
    cell.textLabel.textColor = [UIColor grayColor];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 36, 15, 20, 20)];
    imageview.image = [UIImage imageNamed:@"s_normal1"];
    imageview.highlightedImage = [UIImage imageNamed:@"s_selected1"];
    [cell.contentView addSubview:imageview];
    if (isIncludeAll == YES) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        imageview.highlighted = YES;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)excludeAll:(UIButton *)sender {
    [_excludeBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
    [_includeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _excludeImage.frame = CGRectMake(_excludeBtn.frame.origin.x, 48, _excludeBtn.frame.size.width, 2);
    }];
    if (isIncludeAll == YES) {
        dict_temp = nil;
        [_tableView reloadData];
    }
    isIncludeAll = NO;
}

- (IBAction)includeAll:(id)sender {
    [_includeBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
    [_excludeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _excludeImage.frame = CGRectMake(_includeBtn.frame.origin.x, 48, _excludeBtn.frame.size.width, 2);
    }];
    if (isIncludeAll == NO) {
        
        if ([category isEqualToString:@"employee"]) {
            dict_temp = [NSDictionary dictionaryWithObject:@"5" forKey:@"filter"];
        }
        else if ([category isEqualToString:@"position"])
        {
            dict_temp = [NSDictionary dictionaryWithObject:@"6" forKey:@"filter"];
        }
        else if ([category isEqualToString:@"location"])
        {
            dict_temp = [NSDictionary dictionaryWithObject:@"7" forKey:@"filter"];
        }
        
        [_tableView reloadData];
    }
    isIncludeAll = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isIncludeAll == YES) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageview = (UIImageView *)cell.accessoryView;
        imageview.highlighted = YES;
    }
    else
    {
        if ([category isEqualToString:@"employee"]) {
            if (indexPath.row == 0) {
                dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"filter",OpenShiftEmployeeUuid,@"employeeUuid", nil];
            }
            else
            {
                Employees *employee = [arr_allJoinEmployees objectAtIndex:indexPath.row-1];
                dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"filter",employee.uuid,@"employeeUuid", nil];
            }
        }
        else if([category isEqualToString:@"position"])
        {
            if (indexPath.row == 0) {
                dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"filter",UnassignedPositionUuid,@"positionUuid", nil];
            }
            else
            {
                Positions *position = [arr_allPositions objectAtIndex:indexPath.row-1];
                dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"filter",position.uuid,@"positionUuid", nil];
            }
        }
        else if([category isEqualToString:@"location"])
        {
            Locations *location = [arr_allLocations objectAtIndex:indexPath.row];
            dict_temp = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"filter",location.uuid,@"locationUuid", nil];
        }
    }
    
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismiss:(UIButton *)sender {
    if (dict_temp != nil) {
        [UserEntity setFilter:dict_temp];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
