//
//  AvailabilityViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "AvailabilityViewController_iphone.h"

@interface AvailabilityViewController_iphone ()
{
    NSMutableArray *arr_allmyAvailabilities;
}
@end

@implementation AvailabilityViewController_iphone
@synthesize employeeUuid;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self initData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

-(void) initData
{
    arr_allmyAvailabilities = [NSMutableArray arrayWithArray:[DatabaseManager getEmployeeAvailabilitiesByEmployeeUuid:employeeUuid]];
    if (arr_allmyAvailabilities.count == 0) {
        _doneBtn.hidden = YES;
    }
    else
    {
        _doneBtn.hidden = NO;
    }
    _tableView.editing = NO;
    [_tableView reloadData];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)disposeAvailability:(UIButton *)sender {

    if (_tableView.editing == YES) {
        [_tableView setEditing:NO animated:YES];
        [_doneBtn setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [_tableView setEditing:YES animated:YES];
        [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_allmyAvailabilities.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tintColor = AppMainColor;
    
    if (arr_allmyAvailabilities.count != 0) {

        Availability *availability = [arr_allmyAvailabilities objectAtIndex:indexPath.row];
        
        NSString *detailLabelText = @"";
        if ([availability.string_yearMonthDay2 isEqualToString:@"0"]) {
            detailLabelText = [NSString stringWithFormat:@"%@ - ongoing",availability.string_effectiveDate1];
        }
        else
        {
            detailLabelText = [NSString stringWithFormat:@"%@ - %@",availability.string_effectiveDate1,availability.string_effectiveDate2];
        }
        if ([availability.rotation isEqualToString:@"0"]) {
            detailLabelText = [NSString stringWithFormat:@"%@ (Every Week)",detailLabelText];
        }
        else if ([availability.rotation isEqualToString:@"1"])
        {
            detailLabelText = [NSString stringWithFormat:@"%@ (Every Other Week)",detailLabelText];
        }
        else if ([availability.rotation isEqualToString:@"2"])
        {
            detailLabelText = [NSString stringWithFormat:@"%@ (Every 3 Week)",detailLabelText];
        }
        else if ([availability.rotation isEqualToString:@"3"])
        {
            detailLabelText = [NSString stringWithFormat:@"%@ (Every 4 Week)",detailLabelText];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, ScreenWidth-32, 20)];
        titleLabel.textColor = TextColorAlpha_87;
        titleLabel.font = [UIFont systemFontOfSize:17.0];
        titleLabel.text = availability.title;
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 34, ScreenWidth-32-15, 16)];
        detailLabel.textColor = TextColorAlpha_54;
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.text = detailLabelText;
        
        if (ScreenWidth == 320) {
            detailLabel.font = [UIFont systemFontOfSize:12.0];
        }
        
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:detailLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        
        if (indexPath.row == arr_allmyAvailabilities.count-1) {
            line.frame = CGRectMake(0, line.frame.origin.y, ScreenWidth, 0.5);
        }
    }
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailabilityDetailViewController *detail = [AvailabilityDetailViewController new];
    
    Availability *avai = [arr_allmyAvailabilities objectAtIndex:indexPath.row];
    detail.uuid = avai.uuid;
    detail.employeeuuid = employeeUuid;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //1.将表中的cell删除
        
        //2.将本地的数组中数据删除
        
        //3.最后将服务器端的数据删除
        
        [_tableView setEditing:NO animated:YES];
        
        Availability *availability = [arr_allmyAvailabilities objectAtIndex:indexPath.row];
        
        NSString *message = [NSString stringWithFormat:@"Delete “%@”?",availability.title];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        alertController.view.tintColor = AppMainColor;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Availability" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            
            
            NSMutableDictionary *dict_configuration = [NSMutableDictionary dictionary];
            [dict_configuration setObject:availability.title forKey:Availability_Configuration_Title];
            [dict_configuration setObject:availability.string_effectiveDate1 forKey:Availability_Configuration_StringEffectiveDate1];
            [dict_configuration setObject:availability.string_effectiveDate2 forKey:Availability_Configuration_StringEffectiveDate2];
            [dict_configuration setObject:availability.string_yearMonthDay1 forKey:Availability_Configuration_YearMonthDay1];
            [dict_configuration setObject:availability.string_yearMonthDay2 forKey:Availability_Configuration_YearMonthDay2];
            [dict_configuration setObject:availability.rotation forKey:Availability_Configuration_Rotation];
            [dict_configuration setObject:availability.employeeUuid forKey:Availability_Configuration_EmployeeUuid];
            if (availability.notes != nil) {
                [dict_configuration setObject:availability.notes forKey:Availability_Configuration_Notes];
            }
            
            DDBDataModel *model = [DynamoDBManager getAvailableDataModel:availability.uuid andConfiguration:dict_configuration andSubAvailabilities:availability.subAvailabilities andNewParentUuid:nil];
            model.isDelete = [NSNumber numberWithInt:1];
            
            [[dynamoDBObjectMapper save:model] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                            
                            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            [arr_allmyAvailabilities removeObject:availability];
                            availability.isDelete = 1;
                            
                            NSManagedObjectContext *context = [appdelegate managedObjectContext];
                            [context save:nil];
                            [_tableView reloadData];
                        });
                        
                    }
                }
                return nil;
            }];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//选择你要对表进行处理的方式  默认是删除方式

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createAvailable:(UIButton *)sender {
    
    AvailabilityDetailViewController *create = [AvailabilityDetailViewController new];
    create.employeeuuid = employeeUuid;
    [self.navigationController pushViewController:create animated:YES];
}
@end
