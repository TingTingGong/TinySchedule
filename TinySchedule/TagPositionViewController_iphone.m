//
//  TagPositionViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/16.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "TagPositionViewController_iphone.h"

@interface TagPositionViewController_iphone ()
{
    NSMutableArray *arr_allPositons;
}
@end

@implementation TagPositionViewController_iphone
@synthesize employeeuuid;
@synthesize arr_selectPositionuuid;
@synthesize notModifyPrifileViewPassArray;

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    arr_allPositons = [NSMutableArray arrayWithArray:[DatabaseManager getAllPositions]];
    

    if (employeeuuid != nil && notModifyPrifileViewPassArray == NO) {
        NSArray *arr_employeeposiontion = [DatabaseManager getEmployeePositions:employeeuuid];
        if (arr_employeeposiontion.count > 0) {
            Positions *recentPosition = [arr_employeeposiontion objectAtIndex:0];
            NSString *recentPositionuuid = recentPosition.uuid;
            
            if (![arr_selectPositionuuid containsObject:recentPositionuuid]) {
                [arr_selectPositionuuid addObject:recentPositionuuid];
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
    
    arr_allPositons = [NSMutableArray arrayWithArray:[DatabaseManager getAllPositions]];
    
    _line.frame = CGRectMake(0, 63.5, ScreenWidth, 0.5);
    _line.backgroundColor = SepearateLineColor;
    
    // Do any additional setup after loading the view from its nib.
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return arr_allPositons.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    return 56;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.tintColor = AppMainColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"positionCell";
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 18, ScreenWidth - 80, 20)];
    [cell.contentView addSubview:label];
    
    if (indexPath.section == 0) {
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(18, 20, 20, 20)];
        imageview.image = [UIImage imageNamed:@"s_add_item"];
        [cell.contentView addSubview:imageview];
        
        label.frame = CGRectMake(50, 20, ScreenWidth - 80, 20);
        label.text = @"New Position";
        label.textColor = AppMainColor;
        label.font = [UIFont fontWithName:RegularFontName size:17.0];
        line.frame = CGRectMake(16, 59.5, ScreenWidth-16, 0.5);
    }
    else
    {
        if (arr_allPositons.count != 0) {
            
            Positions *position = [arr_allPositons objectAtIndex:indexPath.row];
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(23, 23, 10, 10)];
            imageview.backgroundColor = SetColor(157, 167, 160, 1.0);
            imageview.layer.cornerRadius = 10/2.0;
            imageview.layer.masksToBounds = YES;
            imageview.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithShort:position.color]];
            [cell.contentView addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, ScreenWidth - 70, 56)];
            label.text = position.name;
            label.font = [UIFont fontWithName:LightFontName size:17.0];
            label.textColor = TextColorAlpha_87;
            [cell.contentView addSubview:label];
            
            if ([arr_selectPositionuuid containsObject:position.uuid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            if (indexPath.row == arr_allPositons.count - 1) {
                line.frame = CGRectMake(0, line.frame.origin.y, ScreenWidth, 0.5);
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        PositionDetailViewController_iphone *position = [PositionDetailViewController_iphone new];
        position.isEmployeeSeePositionDetail = NO;
        position.isCreatePosition = YES;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:position];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        Positions *position = [arr_allPositons objectAtIndex:indexPath.row];
        if (arr_selectPositionuuid.count == 0) {
            arr_selectPositionuuid = [NSMutableArray array];
        }
        if(![arr_selectPositionuuid containsObject:position.uuid])
        {
            [arr_selectPositionuuid addObject:position.uuid];
        }
        [self.delegate getTagPositionUuid:arr_selectPositionuuid];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self.delegate getTagPositionUuid:arr_selectPositionuuid];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
