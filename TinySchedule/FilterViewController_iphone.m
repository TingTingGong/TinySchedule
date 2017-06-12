//
//  FilterViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "FilterViewController_iphone.h"

@interface FilterViewController_iphone ()
{
    NSArray *arr_header;
    UITableViewCell *lastCell;
    
    NSDictionary *dict_temp;
}
@end

@implementation FilterViewController_iphone

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        lastCell = nil;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        arr_header = [NSArray arrayWithObjects:@" All Schedules",@" My Schedule",@" Employees",@" Positions",@" Locations", nil];
    }
    else
    {
        arr_header = [NSArray arrayWithObjects:@" My Schedule",@" Full Schedule",@" Open Shift",@" Position", nil];
        _tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, arr_header.count * 50);
    }
    
    dict_temp = [NSDictionary dictionary];
    
    _tableView.frame = CGRectMake(0, NavibarHeight, ScreenWidth, _tableView.frame.size.height);
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    // Do any additional setup after loading the view from its nib.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_header.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tintColor = AppMainColor;
    cell.textLabel.text = [arr_header objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 49, ScreenWidth-16, 1)];
    imageview.image = [UIImage imageNamed:@"line"];
    [cell.contentView addSubview:imageview];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 50)];
    imageView.highlightedImage = [UIImage imageNamed:@"filterSelect"];
    //imageView.image = [UIImage imageNamed:@"filterNormal"];
    [cell.contentView addSubview:imageView];

    NSDictionary *dict = [UserEntity getFilter];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 0) {
        if ((indexPath.row == 0 && [[dict objectForKey:@"filter"] isEqualToString:@"1"]) || (indexPath.row == 1 && [[dict objectForKey:@"filter"] isEqualToString:@"8"]) || (indexPath.row == 2 && [[dict objectForKey:@"filter"] isEqualToString:@"9"]) || (indexPath.row == 3 && [[dict objectForKey:@"filter"] isEqualToString:@"10"]) || (indexPath.row == 0 && [dict allKeys].count == 0)) {
            lastCell = cell;
            imageView.highlighted = YES;
            cell.textLabel.textColor = AppMainColor;
        }
    }
    else
    {
        if ((indexPath.row == 0 && [[dict objectForKey:@"filter"] isEqualToString:@"0"]) || (indexPath.row == 1 && [[dict objectForKey:@"filter"] isEqualToString:@"1"]) || (indexPath.row == 2 && ([[dict objectForKey:@"filter"] isEqualToString:@"2"] || [[dict objectForKey:@"filter"] isEqualToString:@"5"])) || (indexPath.row == 3 && ([[dict objectForKey:@"filter"] isEqualToString:@"3"] || [[dict objectForKey:@"filter"] isEqualToString:@"6"])) || (indexPath.row == 4 && ([[dict objectForKey:@"filter"] isEqualToString:@"4"] || [[dict objectForKey:@"filter"] isEqualToString:@"7"]))) {
            lastCell = cell;
            imageView.highlighted = YES;
            cell.textLabel.textColor = AppMainColor;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (lastCell != nil) {
        NSArray *arr_1 = lastCell.contentView.subviews;
        UIImageView *ima = [arr_1 objectAtIndex:1];
        ima.highlighted = NO;
        lastCell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *arr_2 = cell.contentView.subviews;
    UIImageView *ima_2 = [arr_2 objectAtIndex:1];
    ima_2.highlighted = YES;

    lastCell = cell;
    
    cell.textLabel.textColor = AppMainColor;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        if (indexPath.row != 0 && indexPath.row != 1) {
            FilterEmployeeViewController_iphone *filter = [FilterEmployeeViewController_iphone new];
            if (indexPath.row == 2) {
                filter.category = @"employee";
            }
            else if (indexPath.row == 3)
            {
                filter.category = @"position";
            }
            else
            {
                filter.category = @"location";
            }
            [self.navigationController pushViewController:filter animated:YES];
        }
        else
        {
            
            NSDictionary *dict;
            if (indexPath.row == 0) {
                dict = [NSDictionary dictionaryWithObject:@"0" forKey:@"filter"];
            }
            else if (indexPath.row == 1)
            {
                dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"filter"];
            }
            [UserEntity setFilter:dict];
        }
    }
    else
    {
        NSDictionary *dict;
        if (indexPath.row == 0) {
            dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"filter"];
        }
        else if (indexPath.row == 1)
        {
            dict = [NSDictionary dictionaryWithObject:@"8" forKey:@"filter"];
        }
        else if (indexPath.row == 2)
        {
            dict = [NSDictionary dictionaryWithObject:@"9" forKey:@"filter"];
        }
        else if (indexPath.row == 3)
        {
            dict = [NSDictionary dictionaryWithObject:@"10" forKey:@"filter"];
        }
        [UserEntity setFilter:dict];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
