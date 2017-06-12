//
//  LocationListViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/11.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LocationListViewController_iphone.h"

@interface LocationListViewController_iphone ()
{
    NSMutableArray *arr_locations;
}
@end

@implementation LocationListViewController_iphone
@synthesize locationUuid;
@synthesize employeeuuid;
@synthesize arr_selectLocationuuid;
@synthesize notModifyPrifileViewPassArray;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    arr_locations = [NSMutableArray arrayWithArray:[DatabaseManager getAllLocations]];
    if (employeeuuid != nil && notModifyPrifileViewPassArray == NO) {
        NSArray *arr_employeelocation = [DatabaseManager getEmployeeLocations:employeeuuid];
        if (arr_employeelocation.count > 0) {
            Locations *recentLocation = [arr_employeelocation objectAtIndex:0];
            NSString *recentLocationuuid = recentLocation.uuid;
//            if (arr_employeelocation.count >= 2) {
//                for (int i = 1; i < arr_employeelocation.count; i++) {
//                    Locations *locamax = [arr_employeelocation objectAtIndex:i];
//                    if ([locamax.createDate longLongValue] > [recentLocation.createDate longLongValue]) {
//                        recentLocationuuid = locamax.uuid;
//                    }
//                }
//            }
            if (![arr_selectLocationuuid containsObject:recentLocationuuid]) {
                [arr_selectLocationuuid addObject:recentLocationuuid];
            }
        }
    }
    [_tableView reloadData];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    notModifyPrifileViewPassArray = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, ScreenHeight-NavibarHeight);
    
    arr_locations = [NSMutableArray arrayWithArray:[DatabaseManager getAllLocations]];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    // Do any additional setup after loading the view from its nib.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return arr_locations.count;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 56;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.tintColor = AppMainColor;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, 55.5, ScreenWidth-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16, 18, ScreenWidth - 45, 20)];
    [cell.contentView addSubview:label];
    
    if (indexPath.section == 0) {
    
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 20, 20)];
        imageview.image = [UIImage imageNamed:@"s_add_item"];
        [cell.contentView addSubview:imageview];
        
        label.frame = CGRectMake(50, 20, ScreenWidth - 80, 20);
        label.text = @"New Location";
        label.textColor = AppMainColor;
        label.font = [UIFont fontWithName:RegularFontName size:17.0];
        line.frame = CGRectMake(16, 59.5, ScreenWidth-16, 0.5);
    }
    else
    {
        if (arr_locations.count != 0) {
            Locations *location = [arr_locations objectAtIndex:indexPath.row];
            label.text = location.name;
            label.font = [UIFont fontWithName:LightFontName size:17.0];
            label.textColor = TextColorAlpha_87;
            
            if (arr_selectLocationuuid.count > 0 && [arr_selectLocationuuid containsObject:location.uuid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            if (indexPath.row == arr_locations.count - 1) {
                line.frame = CGRectMake(0, line.frame.origin.y, ScreenWidth, 0.5);
            }
        }
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LocationDetailViewController_iphone *location = [LocationDetailViewController_iphone new];
        location.isEmployeeSeeDetail = NO;
        location.isCreateLocation = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:location];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        Locations *location = [arr_locations objectAtIndex:indexPath.row];
        if (![arr_selectLocationuuid containsObject:location.uuid]) {
            if (arr_selectLocationuuid == nil) {
                arr_selectLocationuuid = [NSMutableArray array];
            }
            [arr_selectLocationuuid addObject:location.uuid];
        }
        [self.delegate getlocationUuid:arr_selectLocationuuid];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.delegate getlocationUuid:arr_selectLocationuuid];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
