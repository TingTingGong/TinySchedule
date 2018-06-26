//
//  TagEmployeeViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "TagEmployeeViewController_iphone.h"

@interface TagEmployeeViewController_iphone ()
{
    NSMutableDictionary *dict_allEmployee;
    NSArray *arr_keys;
    
    NSMutableArray *arr_selectEmployeeUuid;
}
@end

@implementation TagEmployeeViewController_iphone
@synthesize category;
@synthesize employees;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = CGRectMake(0, NavibarHeight+60, _tableView.frame.size.width, ScreenHeight-(NavibarHeight+60));
    
    if ([category isEqualToString:@"0"]) {
        arr_selectEmployeeUuid = [NSMutableArray arrayWithArray:[employees componentsSeparatedByString:@","]];
    }
    else if ([category isEqualToString:@"1"])
    {
        arr_selectEmployeeUuid = [NSMutableArray arrayWithArray:[employees componentsSeparatedByString:@","]];
    }
    else
    {
        arr_selectEmployeeUuid = [NSMutableArray arrayWithArray:[employees componentsSeparatedByString:@","]];
    }
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    [self setScrollrowView];
    
    dict_allEmployee = [DatabaseManager getAllEmployeesByFullNameSorted:[DatabaseManager getAllJoinedEmployees]];
    arr_keys = [[dict_allEmployee allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

-(void) setScrollrowView
{
    _scrollview.contentSize = CGSizeMake(50 * arr_selectEmployeeUuid.count, 0);
    
    for (UIView *view in _scrollview.subviews) {
        [view removeFromSuperview];
        for (UIView *v in view.subviews) {
            [v removeFromSuperview];
        }
    }
    
    if (arr_selectEmployeeUuid.count != 0) {
        for (int i = 0; i < arr_selectEmployeeUuid.count; i++) {
            Employees *employee = [DatabaseManager getEmployeeByUuid:[arr_selectEmployeeUuid objectAtIndex:i]];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i*50, 5, 50, 50)];
            [_scrollview addSubview:lab];
            if (employee.headPortrait != nil) {
                UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(16, 7, 36, 36)];
                ima.image = [UIImage imageWithData:employee.headPortrait];
                ima.layer.masksToBounds = YES;
                ima.layer.cornerRadius = 18;
                [lab addSubview: ima];
            }
            else
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 7, 36, 36)];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:employee.fullName]];
                label.layer.masksToBounds = YES;
                label.layer.cornerRadius = 18;
                label.backgroundColor = SetColor(35, 136, 251, 1.0);
                [lab addSubview:label];
            }
        }
    }
    else
    {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 200, 60)];
        lab.text = @"No Tag Employee";
        lab.font = [UIFont systemFontOfSize:15.0];
        [_scrollview addSubview:lab];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr_keys.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arr_keys.count > section) {
        NSString *key = [arr_keys objectAtIndex:section];
        NSMutableArray *arr= [dict_allEmployee objectForKey:key];
        return arr.count;
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, headerView.frame.size.width-32, headerView.frame.size.height)];
    NSString *title = @"";
    if (arr_keys.count > section) {
        NSString *key = [arr_keys objectAtIndex:section];
        title = key;
    }
    
    if (title != nil) {
        [titlelabel setAttributedText:SetAttributeText(title, SetColor(199, 199, 205, 1.0), SemiboldFontName, 14.0)];
    }
     [headerView addSubview:titlelabel];
     
     return headerView;
     }

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"employee";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (arr_keys.count != 0) {
        NSString *key = [arr_keys objectAtIndex:indexPath.section];
        NSMutableArray *arr= [dict_allEmployee objectForKey:key];
        
        if (arr.count > indexPath.row) {
            
            Employees *employee = [arr objectAtIndex:indexPath.row];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 36, 36)];
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
                [imageview addSubview:lab];
            }
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 10, _tableView.frame.size.width - 78, 40)];
            label.text = [NSString stringWithFormat:@"%@",employee.fullName];
            label.textColor = TextColorAlpha_87;
            [cell.contentView addSubview:label];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(68, 59.5, ScreenWidth-68, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
            
            UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-36, 20, 20, 20)];
            imageview2.image = [UIImage imageNamed:@"s_normal1"];
            imageview2.highlightedImage = [UIImage imageNamed:@"s_selected1"];
            [cell.contentView addSubview:imageview2];
            
            if ([arr_selectEmployeeUuid containsObject:employee.uuid]) {
                imageview2.highlighted = YES;
            }
            
            if(indexPath.row == arr.count-1)
            {
                line.hidden = YES;
            }
            if(indexPath.section == arr_keys.count-1 && indexPath.row == arr.count-1)
            {
                line.hidden = NO;
                line.frame = CGRectMake(0, 59.5, ScreenWidth, 0.5);
            }
        }
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [arr_keys objectAtIndex:indexPath.section];
    NSMutableArray *arr= [dict_allEmployee objectForKey:key];
    Employees *employee = [arr objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *arr_view = cell.contentView.subviews;
    UIImageView *imageview = [arr_view lastObject];
    if (imageview.highlighted == YES) {
        imageview.highlighted = NO;
        if ([arr_selectEmployeeUuid containsObject:employee.uuid]) {
            [arr_selectEmployeeUuid removeObject:employee.uuid];
        }
    }
    else
    {
        imageview.highlighted = YES;
        if (![arr_selectEmployeeUuid containsObject:employee.uuid]) {
            [arr_selectEmployeeUuid addObject:employee.uuid];
        }
    }
    [self setScrollrowView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(UIButton *)sender {
    
    if (arr_selectEmployeeUuid.count == 0) {
        
        [self.delegate getEmployees:nil];
    }
    else
    {
        [self.delegate getEmployees:[arr_selectEmployeeUuid componentsJoinedByString:@","]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
