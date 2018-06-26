//
//  NewEmployeesViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/8.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "NewEmployeesViewController_iphone.h"

#define HeightForRow 56

@interface NewEmployeesViewController_iphone ()

@end

@implementation NewEmployeesViewController_iphone
@synthesize arr_newEmployees;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@ (%lu)",_titleLabel.text,(unsigned long)arr_newEmployees.count];
    
    float height = arr_newEmployees.count * HeightForRow;
    _tableView.frame = CGRectMake(0, NavibarHeight, self.view.frame.size.width, height);
    if (height > ScreenHeight - NavibarHeight) {
        _tableView.frame = CGRectMake(0, NavibarHeight, self.view.frame.size.width, ScreenHeight - NavibarHeight);
    }
    
    if (arr_newEmployees.count == 0) {
        UILabel *lab_none = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 20)];
        lab_none.textAlignment = NSTextAlignmentCenter;
        lab_none.font = [UIFont fontWithName:RegularFontName size:17.0];
        lab_none.textColor = TextColorAlpha_54;
        lab_none.text = @"Nobody is trying to join this workplace.";
        [self.view addSubview:lab_none];
    }

    // Do any additional setup after loading the view from its nib.
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_newEmployees.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightForRow;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"new";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (arr_newEmployees.count != 0) {
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(68, HeightForRow-0.5, ScreenWidth-15, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        
        Employees *employee = [arr_newEmployees objectAtIndex:indexPath.row];
        
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
            [imageview addSubview:lab];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 0, _tableView.frame.size.width - 78, HeightForRow)];
        label.text = [NSString stringWithFormat:@"%@",employee.fullName];
        label.textColor = TextColorAlpha_87;
        label.font = [UIFont fontWithName:RegularFontName size:17.0];
        [cell.contentView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth - 85, HeightForRow/2-22/2, 68, 22);
        btn.tag = indexPath.row;
        [btn setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"accepted"] forState:UIControlStateSelected];
        
        if (employee.isPermitted == 0) {
            btn.selected = NO;
        }
        else{
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(accepteEmployee:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        if(indexPath.row == arr_newEmployees.count-1)
        {
            line.frame = CGRectMake(0, line.frame.origin.y, ScreenWidth, 0.5);
        }
        
    }
    return cell;
}

-(void)toAddEmployee
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"add employee" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)accepteEmployee:(UIButton *)sender
{
    Employees *employee = [arr_newEmployees objectAtIndex:sender.tag];
    NSString *message = [NSString stringWithFormat:@"Accept %@ to join this workplace?",employee.fullName];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        Employees *selectEmployee = [arr_newEmployees objectAtIndex:sender.tag];
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        NSString *urlstring = [NSString stringWithFormat:@"%@/%@/employee/%@",api_workplace,appdelegate.currentWorkplace.uuid,selectEmployee.uuid];
        
        [HttpRequestManager requestWithType:requestType_POST withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data , NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
            NSLog(@"%@",dict);
            
            if (response.statusCode == 200) {
                
                [arr_newEmployees removeObject:selectEmployee];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                _titleLabel.text = [NSString stringWithFormat:@"New Employees(%lu)",(unsigned long)arr_newEmployees.count];
                
                selectEmployee.isPermitted = 1;
                [context save:nil];
            }
            
        } withFailureBlock:^(NSError *error){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Decline";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *arr_subviews = cell.contentView.subviews;
    UIButton *btn = [arr_subviews lastObject];
    
    if (btn.selected == NO) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            Employees *selectEmployee = [arr_newEmployees objectAtIndex:indexPath.row];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper load:[DDBEmployeesInfoModel class] hashKey:selectEmployee.uuid rangeKey:selectEmployee.email] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
                if (task.error) {
                    
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        DDBEmployeesInfoModel *model = task.result;
                        
                        if ([model.parentUuid isEqualToString:appDelegate.currentWorkplace.uuid]) {
                            DDBEmployeesInfoModel *employeeModel = [[DDBEmployeesInfoModel alloc]init];
                            employeeModel.uuid = selectEmployee.uuid;
                            employeeModel.email = selectEmployee.email;
                            employeeModel.isManager = [NSNumber numberWithInt:0];
                            employeeModel.isDelete = [NSNumber numberWithInt:0];
                            employeeModel.isJoinPlace = [NSNumber numberWithInt:0];
                            employeeModel.isAcceptJoined = [NSNumber numberWithInt:2];
                            employeeModel.fullname = selectEmployee.fullName;
                            employeeModel.password = selectEmployee.password;
                            employeeModel.phone = selectEmployee.phone;
                            employeeModel.maxHoursPerWeek = [NSNumber numberWithShort:selectEmployee.maxHoursPerWeek];
                            if(selectEmployee.headPortrait != nil)
                            {
                                employeeModel.portrait = [StringManager dataTransferString:selectEmployee.headPortrait];
                            }
                            
                            [[dynamoDBObjectMapper save:employeeModel]
                             continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
                                 if (task.error) {
                                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                     NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                     [alertController addAction:okAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                 }
                                 else {
                                     if ([employeeModel isKindOfClass:[DDBEmployeesInfoModel class]]) {
                                         
                                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                         
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             [arr_newEmployees removeObject:selectEmployee];
                                             [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                             [context deleteObject:selectEmployee];
                                             _titleLabel.text = [NSString stringWithFormat:@"New Employees(%lu)",(unsigned long)arr_newEmployees.count];
                                         });
                                     }
                                 }
                                 return nil;
                             }];
                        }
                        else
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            [arr_newEmployees removeObject:selectEmployee];
                            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            [context deleteObject:selectEmployee];
                            _titleLabel.text = [NSString stringWithFormat:@"New Employees(%lu)",(unsigned long)arr_newEmployees.count];
                        }
                    });
                }
                return nil;
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
