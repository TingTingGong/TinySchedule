//
//  DropViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/30.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "DropViewController_iphone.h"

@interface DropViewController_iphone ()
{
    Shifts *passshift;
    Drop *passdrop;
    NSMutableArray *arr_employeesUUid;
    NSMutableArray *arr_selectEmployeesUUid;
}
@end

@implementation DropViewController_iphone
@synthesize category;
@synthesize uuid;
@synthesize dropuuid;
@synthesize isShowShiftDetail;

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    arr_selectEmployeesUUid = [NSMutableArray array];
    
    _portraitView.frame = CGRectMake(ScreenWidth/2-30, 72, 56, 56);
    _portraitView.layer.masksToBounds = YES;
    _portraitView.layer.cornerRadius = _portraitView.frame.size.width/2;
    
    passshift = [DatabaseManager getShiftByUuid:uuid];
    passdrop = [DatabaseManager getDropByUuid:dropuuid];

    
    Employees *employee = [DatabaseManager getEmployeeByUuid:passshift.employeeUuid];
    Locations *location = [DatabaseManager getLocationByUuid:passshift.locationUuid];
    Positions *position = [DatabaseManager getPositionByUuid:passshift.positionUuid];
    
    if (passdrop.drop_accepteEmployeeUuid != nil && passdrop.oriShiftEmployeeUuid != nil) {
        employee = [DatabaseManager getEmployeeByUuid:passdrop.oriShiftEmployeeUuid];
    }
    if (employee.headPortrait == nil) {
        _portraitView.backgroundColor = SetColor(38, 139, 249, 1.0);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _portraitView.frame.size.width, _portraitView.frame.size.height)];
        if (employee != nil) {
            lab.text = [StringManager getManyFirstLetterFromString:employee.fullName];
        }
        else
        {
            lab.text = [StringManager getManyFirstLetterFromString:passshift.employeeName];
        }
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        [_portraitView addSubview:lab];
        
        if ([category isEqualToString:@"1"]) {
            lab.hidden = YES;
        }
    }
    else
    {
        _portraitView.image = [UIImage imageWithData:employee.headPortrait];
    }
    _nameLabel.text = employee.fullName;
    _shiftTimeLabel.text = [NSString stringWithFormat:@"%@, %@ %@  %@",passshift.string_week,passshift.string_month,passshift.string_day,passshift.string_time];
    if (position != nil) {
        _addressLabel.text = [NSString stringWithFormat:@"at %@ as %@",location.name,position.name];
    }
    else
    {
        _addressLabel.text = [NSString stringWithFormat:@"at %@",location.name];
    }
    
    if (passdrop == nil) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, _stateLabel.frame.origin.y, ScreenWidth, _stateLabel.frame.size.height)];
        lab.text = @"New";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12.0];
        lab.textColor = SetColor(200, 200, 200, 1.0);
        [_shiftView addSubview:lab];
        _stateLabel.hidden = YES;
        _stateTimeLabel.hidden = YES;
    }
    else
    {
        _sendBtn.hidden = YES;
        if ([passdrop.state intValue] == 0) {
            _stateLabel.text = @"Pending";
            _stateLabel.textColor = SetColor(255, 103, 1, 1.0);
            _stateTimeLabel.text = @"Created";
        }
        else if ([passdrop.state intValue] == 1) {
            _stateLabel.text = @"Accpeted";
            _stateLabel.textColor = AppMainColor;
        }
        else if ([passdrop.state intValue] == 2) {
            _stateLabel.text = @"Decline";
            _stateLabel.textColor = SetColor(250, 67, 63, 1.0);
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = [StringManager getYearMonthDay:passdrop.createDate];
        if (passdrop.message != nil) {
            _textView.text = passdrop.message;
        }
        _stateTimeLabel.text = [NSString stringWithFormat:@"%@ in %@, %@ %@",_stateTimeLabel.text,[dict objectForKey:@"week"],[StringManager getEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"]];
    }
    if ([category isEqualToString:@"0"]) {
        _titleLabel.text = @"Drop";
    }
    else if ([category isEqualToString:@"1"])
    {
        _titleLabel.text = @"Offer/Assign";
        _portraitView.backgroundColor = [UIColor clearColor];
        _portraitView.image = [UIImage imageNamed:@"assignOpen"];
        _nameLabel.text = @"Open Shift";
    }
    else if ([category isEqualToString:@"2"])
    {
        _titleLabel.text = @"Find Replaces";
    }
    
    if (appdelegate.currentEmployee.isManager == 1 || [passshift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
        _tableHeaderLabel.text = @"  Potential Takers";
    }
    else
    {
        _tableHeaderLabel.text = @"  Potential Takers";
    }
    
    if (_selectAllBtn == nil) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _selectAllBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
        [_selectAllBtn setTitle:@"Select All" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_selectAllBtn];
        [_selectAllBtn addTarget:self action:@selector(selectAllEmployee) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_selectNoneBtn == nil) {
        _selectNoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _selectNoneBtn.frame = CGRectMake(ScreenWidth/2, 1, ScreenWidth/2, 49);
        [_selectNoneBtn setTitle:@"Select None" forState:UIControlStateNormal];
        [_selectNoneBtn setTitleColor:SetColor(255, 103, 1, 1) forState:UIControlStateNormal];
        _selectNoneBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview: _selectNoneBtn];
        [_selectNoneBtn addTarget:self action:@selector(selectNoneEmployee) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_acceptBtn == nil) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _acceptBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
        [_acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
        [_acceptBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_acceptBtn];
        [_acceptBtn addTarget:self action:@selector(acceptedDrop) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_declineBtn == nil) {
        _declineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _declineBtn.frame = CGRectMake(ScreenWidth/2, 1, ScreenWidth/2, 49);
        [_declineBtn setTitle:@"Decline" forState:UIControlStateNormal];
        [_declineBtn setTitleColor:SetColor(250, 67, 63, 1.0) forState:UIControlStateNormal];
        _declineBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_declineBtn];
        [_declineBtn addTarget:self action:@selector(declineDrop) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_cancelRequestBtn == nil) {
        _cancelRequestBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelRequestBtn.frame = CGRectMake(0, 1, ScreenWidth, 49);
        [_cancelRequestBtn setTitle:@"Cancel Request" forState:UIControlStateNormal];
        [_cancelRequestBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        _cancelRequestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_bottomView addSubview:_cancelRequestBtn];
        [_cancelRequestBtn addTarget:self action:@selector(cancelMyRequest) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(isShowShiftDetail == NO)
    {
        _showShiftDetailBtn.hidden = YES;
    }
    
    //该shift还没drop,仅仅是发起人
    if (passdrop == nil) {
        
        _acceptBtn.hidden = YES;
        _declineBtn.hidden = YES;
        _cancelRequestBtn.hidden = YES;
        
        //发起人，去获取所有相关的employee
        arr_employeesUUid = [DatabaseManager getFreeEmployeeByShiftUuid:uuid];
    }
    //该shift已经drop,前面先按pending状态去显示，最后一并处理是否是pending以外的状态
    else
    {
        _sendBtn.hidden = YES;
        _textView.userInteractionEnabled = NO;
        
        arr_employeesUUid = [NSMutableArray arrayWithArray:[passdrop.dropUuids componentsSeparatedByString:@","]];
        //已经drop的employee，如果有已经删除的，那么不显示
        NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:arr_employeesUUid];
        for (NSString *employeeuuid in arr_temp) {
            Employees *employe = [DatabaseManager getEmployeeByUuid:employeeuuid];
            if (employe == nil) {
                [arr_employeesUUid removeObject:employeeuuid];
            }
        }

        //已经drop的shift，发起人只能cancel
        if ([passshift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
            
            _selectAllBtn.hidden = YES;
            _selectNoneBtn.hidden = YES;
            _acceptBtn.hidden = YES;
            _declineBtn.hidden = YES;
            _line.hidden = YES;
        }
        else
        {
            //manager
            if (appdelegate.currentEmployee.isManager == 1) {
                
                if (passdrop.isManagerAccepted == 1) {
                    
                    //manager已经accepted后,drop的employee中不包含manager时，只能做cancel操作
                    if (![passdrop.dropUuids containsString:appdelegate.currentEmployee.uuid]) {
                        _selectAllBtn.hidden = YES;
                        _selectNoneBtn.hidden = YES;
                        _acceptBtn.hidden = YES;
                        _declineBtn.hidden = YES;
                        _line.hidden = YES;
                    }
                    else
                    {
                        _selectAllBtn.hidden = YES;
                        _selectNoneBtn.hidden = YES;
                        _cancelRequestBtn.hidden = YES;
                    }
                }
                else
                {
                    _cancelRequestBtn.hidden = YES;
                    _selectAllBtn.hidden = YES;
                    _selectNoneBtn.hidden = YES;
                }
            }
            //被发起人
            else
            {
                _selectAllBtn.hidden = YES;
                _selectNoneBtn.hidden = YES;
                _cancelRequestBtn.hidden = YES;
                if ([passdrop.declineDropUuids containsString:appdelegate.currentEmployee.uuid]) {
                    _line.hidden = YES;
                    _line1.hidden = YES;
                    _acceptBtn.hidden = YES;
                    _declineBtn.hidden = YES;
                }
            }
        }
    }
    
    if (passdrop != nil && ![passdrop.state isEqualToString:@"0"]) {
        _selectAllBtn.hidden = YES;
        _selectNoneBtn.hidden = YES;
        _cancelRequestBtn.hidden = YES;
        _acceptBtn.hidden = YES;
        _declineBtn.hidden = YES;
        _line.hidden = YES;
        _line1.hidden = YES;
    }
    _tableView.frame = CGRectMake(0, 344, self.view.frame.size.width, ScreenHeight-50-344);
    
    // Do any additional setup after loading the view from its nib.
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

-(void) textViewDidBeginEditing:(UITextView *)textView
{
    if (ScreenWidth < 375) {
        [UIView animateWithDuration:AnimatedDuration animations:^{
            self.view.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
        }];
    }
    if ([textView.text isEqualToString:@"Message"]) {
        _textView.text = @"";
    }
}
-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
    }
    CGSize size = [StringManager labelAutoCalculateRectWith:textView.text FontSize:14.0 MaxSize:CGSizeMake(ScreenWidth-24, 51)];
    if (size.height >= 51) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    if (ScreenWidth < 375) {
        [UIView animateWithDuration:AnimatedDuration animations:^{
            [_textView resignFirstResponder];
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished){
        }];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_employeesUUid.count;
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    Employees *employee = [DatabaseManager getEmployeeByUuid:[arr_employeesUUid objectAtIndex:indexPath.row]];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 40, 40)];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 20.0;
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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 10, _tableView.frame.size.width - 75, 40)];
    label.text = [NSString stringWithFormat:@"%@",employee.fullName];
    [cell.contentView addSubview:label];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //新创建的drop或还没有被manager accpted的drop，需要进行多选
    if (passdrop == nil || (appdelegate.currentEmployee.isManager == 1 && passdrop != nil && passdrop.isManagerAccepted == 0 && [passdrop.state isEqualToString:@"0"])) {
        UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
        imageview2.image = [UIImage imageNamed:@"s_normal1"];
        imageview2.highlightedImage = [UIImage imageNamed:@"s_selected1"];
        [cell.contentView addSubview:imageview2];
        
        if ([arr_selectEmployeesUUid containsObject:employee.uuid]) {
            imageview2.highlighted = YES;
        }
    }
    else
    {
        UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
        [cell.contentView addSubview:imageview2];
        
        if (passdrop.declineDropUuids != nil && [passdrop.declineDropUuids containsString:employee.uuid]) {
            imageview2.image = [UIImage imageNamed:@"decline"];
        }
        if (passdrop.drop_accepteEmployeeUuid != nil && [passdrop.drop_accepteEmployeeUuid isEqualToString:employee.uuid]) {
            imageview2.image = [UIImage imageNamed:@"s_selected1"];
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (passdrop == nil || (appdelegate.currentEmployee.isManager == 1 && passdrop != nil && passdrop.isManagerAccepted == 0 && [passdrop.state isEqualToString:@"0"])) {
        Employees *employee = [DatabaseManager getEmployeeByUuid:[arr_employeesUUid objectAtIndex:indexPath.row]];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *arr_view = cell.contentView.subviews;
        UIImageView *imageview = [arr_view lastObject];
        if (imageview.highlighted == YES) {
            imageview.highlighted = NO;
            if ([arr_selectEmployeesUUid containsObject:employee.uuid]) {
                [arr_selectEmployeesUUid removeObject:employee.uuid];
            }
        }
        else
        {
            imageview.highlighted = YES;
            if (![arr_selectEmployeesUUid containsObject:employee.uuid]) {
                [arr_selectEmployeesUUid addObject:employee.uuid];
            }
        }
    }
    else
    {
    }
}

-(void) selectAllEmployee
{
    arr_selectEmployeesUUid = nil;
    arr_selectEmployeesUUid = [NSMutableArray arrayWithArray:arr_employeesUUid];
    [_tableView reloadData];
}

-(void) selectNoneEmployee
{
    arr_selectEmployeesUUid = nil;
    arr_selectEmployeesUUid = [NSMutableArray array];
    [_tableView reloadData];
}

//manager同意该请求(同步drop)，或employee接受该请求(同步shift和drop)
-(void) acceptedDrop
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (passdrop.isManagerAccepted == 0 && appdelegate.currentEmployee.isManager == 1) {
        if (arr_selectEmployeesUUid.count == 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must select one employee at least!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passdrop.uuid rangeKey:passdrop.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                        
                        DDBDataModel *model = task.result;
                        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        NSManagedObjectContext *context = [appdelegate managedObjectContext];
                        
                        if ([model.tableIdentityID isEqualToString:@"Drop"]) {
                            passdrop.modifyDate = model.modifyDate;
                            passdrop.declineDropUuids = model.drop_delcineDropUuids;
                            passdrop.dropUuids = model.drop_dropUuids;
                            passdrop.drop_accepteEmployeeUuid = model.drop_dropAccptedEmploueeUuid;
                            passdrop.isDelete = [model.isDelete shortValue];
                            passdrop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                            passdrop.state = model.drop_state;
                            [context save:nil];
                            
                            if (passdrop.isDelete == 0) {
                                if ([passdrop.state isEqualToString:@"0"]) {
                                    DDBDataModel *model = [DynamoDBManager getDropDataModelByDropUuid:passdrop.uuid andOriShiftUuid:uuid];
                                    model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
                                    model.drop_state = @"0";
                                    if (_textView.text != nil) {
                                        model.drop_messsage = _textView.text;
                                    }
                                    model.drop_dropUuids = [arr_selectEmployeesUUid componentsJoinedByString:@","];
                                    
                                    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
                                    [[dynamoDBObjectMapper save:model]
                                     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                                                     
                                                     NSManagedObjectContext *context = [appdelegate managedObjectContext];
                                                     
                                                     passdrop.modifyDate = model.modifyDate;
                                                     passdrop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                                                     passdrop.message = model.drop_messsage;
                                                     passdrop.dropUuids = model.drop_dropUuids;
                                                     
                                                     [context save:nil];
                                                     
                                                     
                                                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 });
                                             }
                                         }
                                         return nil;
                                     }];
                                }
                                else if([passdrop.state isEqualToString:@"1"] && passdrop.isManagerAccepted == 1)
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been Accepted us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else if([passdrop.state isEqualToString:@"2"] && passdrop.isManagerAccepted == 1)
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been declined us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            }
                            else
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                        else
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }
                return nil;
            }];
        }
    }
    else
    {
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passdrop.uuid rangeKey:passdrop.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                    
                    DDBDataModel *model = task.result;
                    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [appdelegate managedObjectContext];
                    
                    if ([model.tableIdentityID isEqualToString:@"Drop"]) {
                        passdrop.modifyDate = model.modifyDate;
                        passdrop.declineDropUuids = model.drop_delcineDropUuids;
                        passdrop.dropUuids = model.drop_dropUuids;
                        passdrop.drop_accepteEmployeeUuid = model.drop_dropAccptedEmploueeUuid;
                        passdrop.isDelete = [model.isDelete shortValue];
                        passdrop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                        passdrop.state = model.drop_state;
                        [context save:nil];
                        
                        if (passdrop.isDelete == 0) {
                            if ([passdrop.state isEqualToString:@"0"] && passdrop.isManagerAccepted == 1) {
                                //同步两条数据，shift和drop
                                NSMutableArray *arr_request = [DynamoDBManager getShiftWriteRequestByShiftuuid:uuid andDropWriteRequestByDropUuid:passdrop.uuid];
                                AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
                                AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
                                batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_request};
                                batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
                                [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
                                    if (task.error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                            NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                            [alertController addAction:okAction];
                                            [self presentViewController:alertController animated:YES completion:nil];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        });
                                    }
                                    else
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            AWSDynamoDBBatchWriteItemOutput *batchWriteItemOutput = task.result;
                                            NSArray *consumedCapacity = batchWriteItemOutput.consumedCapacity;
                                            NSLog(@"%lu",(unsigned long)consumedCapacity.count);
                                            
                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                            NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                            
                                            AWSDynamoDBWriteRequest *writeRequest2 = [arr_request objectAtIndex:1];
                                            NSDictionary *dict = writeRequest2.putRequest.item;
                                            AWSDynamoDBAttributeValue *modifyDate = [dict objectForKey:@"modifyDate"];
                                            passdrop.modifyDate = modifyDate.S;
                                            AWSDynamoDBAttributeValue *drop_state = [dict objectForKey:@"drop_state"];
                                            passdrop.state = drop_state.S;
                                            AWSDynamoDBAttributeValue *drop_dropAccptedEmploueeUuid = [dict objectForKey:@"drop_dropAccptedEmploueeUuid"];
                                            
                                            passdrop.modifyDate = modifyDate.S;
                                            passdrop.drop_accepteEmployeeUuid = drop_dropAccptedEmploueeUuid.S;
                                            [context save:nil];
                                            
                                            passshift.isTake = 1;
                                            passshift.modifyDate = modifyDate.S;
                                            passshift.employeeUuid = appdelegate.currentEmployee.uuid;
                                            Employees *employee = [DatabaseManager getEmployeeByUuid:appDelegate.currentEmployee.uuid];
                                            passshift.employeeName = employee.fullName;
                                            [context save:nil];

                                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    }
                                    return nil;
                                }];
                            }
                            else if([passdrop.state isEqualToString:@"1"] && passdrop.isManagerAccepted == 1)
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been Accepted us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else if([passdrop.state isEqualToString:@"2"] && passdrop.isManagerAccepted == 1)
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];

                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been declined us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                [alertController addAction:okAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                        else
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    else
                    {
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
            return nil;
        }];
    }
}

//manager cancel request or employee decline request

-(void) declineDrop
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1 && passdrop.isManagerAccepted == 0) {
        [self cancelMyRequest];
    }
    else
    {
        //decline之前，最好先去服务器查询该条数据是否已经被cancel或者accpted
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passdrop.uuid rangeKey:passdrop.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                    
                    DDBDataModel *model = task.result;
                    NSManagedObjectContext *context = [appdelegate managedObjectContext];
                    
                    if ([model.tableIdentityID isEqualToString:@"Drop"]) {
                        passdrop.modifyDate = model.modifyDate;
                        passdrop.declineDropUuids = model.drop_delcineDropUuids;
                        passdrop.drop_accepteEmployeeUuid = model.drop_dropAccptedEmploueeUuid;
                        passdrop.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
                        passdrop.isDelete = [model.isDelete shortValue];
                        passdrop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                        passdrop.message = model.drop_messsage;
                        passdrop.state = model.drop_state;
                        [context save:nil];
                        
                        if ([passdrop.state intValue] == 0) {
                            [self employeeDeclineDrop];
                        }
                        else if([passdrop.state intValue] == 1)
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else if ([passdrop.state intValue] == 2)
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been canceled!" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    else
                    {
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
            return nil;
        }];
    }
}


-(void) cancelMyRequest
{
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DDBDataModel *model = [DynamoDBManager getDropDataModelByDropUuid:passdrop.uuid andOriShiftUuid:uuid];
    model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
    model.drop_state = @"2";
    if (_textView.text != nil) {
        model.drop_messsage = _textView.text;
    }
    model.drop_dropUuids = passdrop.dropUuids;
    if (passdrop.declineDropUuids != nil) {
        model.drop_delcineDropUuids = passdrop.declineDropUuids;
    }
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper save:model]
     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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

                     NSManagedObjectContext *context = [appdelegate managedObjectContext];

                     passdrop.modifyDate = model.modifyDate;
                     passdrop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                     passdrop.message = model.drop_messsage;
                     passdrop.state = model.drop_state;
                     [context save:nil];
                     
                     
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     [self.navigationController popViewControllerAnimated:YES];
                 });
                 
             }
         }
         return nil;
     }];
}

-(void) employeeDeclineDrop
{

    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DDBDataModel *model = [DynamoDBManager getDropDataModelByDropUuid:passdrop.uuid andOriShiftUuid:uuid];
    model.drop_dropUuids = passdrop.dropUuids;
    if (passdrop.declineDropUuids == nil) {
        model.drop_delcineDropUuids = appdelegate.currentEmployee.uuid;
    }
    else
    {
        model.drop_delcineDropUuids = [NSString stringWithFormat:@"%@,%@",passdrop.declineDropUuids,appdelegate.currentEmployee.uuid];
    }
    if (passdrop.drop_accepteEmployeeUuid != nil) {
        model.drop_dropAccptedEmploueeUuid = passdrop.drop_accepteEmployeeUuid;
    }
    model.drop_dropUuids = passdrop.dropUuids;
    model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
    if (passdrop.message != nil) {
        model.drop_messsage = passdrop.message;
    }
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[model.drop_dropUuids componentsSeparatedByString:@","]];
    NSMutableArray *arr2 = [NSMutableArray arrayWithArray:[model.drop_delcineDropUuids componentsSeparatedByString:@","]];
    
    if (arr1.count == arr2.count) {
        model.drop_state = @"2";
    }
    else
    {
        if (model.drop_dropAccptedEmploueeUuid == nil) {
            model.drop_state = @"0";
        }
        else
        {
            model.drop_state = @"1";
        }
    }

    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper save:model]
     continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                     
                     NSManagedObjectContext *context = [appdelegate managedObjectContext];
                     
                     passdrop.modifyDate = model.modifyDate;
                     passdrop.state = model.drop_state;
                     passdrop.dropUuids = model.drop_dropUuids;
                     passdrop.declineDropUuids = model.drop_delcineDropUuids;
                     [context save:nil];
                     
                     
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 });
                 
             }
         }
         return nil;
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)send:(UIButton *)sender {
    
    if (arr_selectEmployeesUUid.count == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must select one employee at least!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        if ([category isEqualToString:@"1"]) {
            Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
            int needNumber = shift.needEmployeesNumber - shift.haveTakedEmployeesNumber;
            if (arr_selectEmployeesUUid.count > needNumber) {
                
                NSString *message = [NSString stringWithFormat:@"You can only assign %d employees",needNumber];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                NSMutableArray *arr_writeRequest = [NSMutableArray array];
                NSString *date = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
                
                AWSDynamoDBWriteRequest *writeRequest_1 = [AWSDynamoDBWriteRequest new];
                writeRequest_1.putRequest = [AWSDynamoDBPutRequest new];
                
                AWSDynamoDBAttributeValue *createdate_1 = [AWSDynamoDBAttributeValue new];
                createdate_1.S = shift.createDate;
                AWSDynamoDBAttributeValue *modifyDate_1 = [AWSDynamoDBAttributeValue new];
                modifyDate_1.S = date;
                AWSDynamoDBAttributeValue *haskKeyValue_1 = [AWSDynamoDBAttributeValue new];
                haskKeyValue_1.S = shift.uuid;
                AWSDynamoDBAttributeValue *rangeKeyValue_1 = [AWSDynamoDBAttributeValue new];
                rangeKeyValue_1.S = shift.parentUuid;
                AWSDynamoDBAttributeValue *manageruuid_1 = [AWSDynamoDBAttributeValue new];
                manageruuid_1.S = shift.managerUuid;
                AWSDynamoDBAttributeValue *isdelete_1 = [AWSDynamoDBAttributeValue new];
                isdelete_1.N = [NSString stringWithFormat:@"%hd",shift.isDelete];
                AWSDynamoDBAttributeValue *tablename_1 = [AWSDynamoDBAttributeValue new];
                tablename_1.S = @"Shifts";
                
                AWSDynamoDBAttributeValue *employeeuuid_1 = [AWSDynamoDBAttributeValue new];
                employeeuuid_1.S = shift.employeeUuid;
                AWSDynamoDBAttributeValue *employeename_1 = [AWSDynamoDBAttributeValue new];
                employeename_1.S = OpenShiftEmployeeName;
                AWSDynamoDBAttributeValue *locationuuid_1 = [AWSDynamoDBAttributeValue new];
                locationuuid_1.S = shift.locationUuid;
                AWSDynamoDBAttributeValue *positionuuid_1 = [AWSDynamoDBAttributeValue new];
                if (shift.positionUuid != nil) {
                    positionuuid_1.S = shift.positionUuid;
                }
                AWSDynamoDBAttributeValue *startdate_1 = [AWSDynamoDBAttributeValue new];
                startdate_1.S = shift.startDate;
                AWSDynamoDBAttributeValue *starttime_1 = [AWSDynamoDBAttributeValue new];
                starttime_1.S = shift.startTime;
                AWSDynamoDBAttributeValue *endtime_1 = [AWSDynamoDBAttributeValue new];
                endtime_1.S = shift.endTime;
                AWSDynamoDBAttributeValue *totalhours_1 = [AWSDynamoDBAttributeValue new];
                totalhours_1.S = shift.totalHours;
                AWSDynamoDBAttributeValue *unbreak_1 = [AWSDynamoDBAttributeValue new];
                unbreak_1.S = shift.unpaidBreak;
                AWSDynamoDBAttributeValue *openshiftemployees_1 = [AWSDynamoDBAttributeValue new];
                if (shift.openShift_employees != nil) {
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[shift.openShift_employees componentsSeparatedByString:@","]];
                    for (NSString *e_uuid in arr_selectEmployeesUUid) {
                        [arr addObject:e_uuid];
                    }
                    openshiftemployees_1.S = [arr componentsJoinedByString:@","];
                }
                else
                {
                    openshiftemployees_1.S = [arr_selectEmployeesUUid componentsJoinedByString:@","];
                }
                AWSDynamoDBAttributeValue *needemployeenumber_1 = [AWSDynamoDBAttributeValue new];
                needemployeenumber_1.N = [NSString stringWithFormat:@"%hd",shift.needEmployeesNumber];
                AWSDynamoDBAttributeValue *shiftnotes_1 = [AWSDynamoDBAttributeValue new];
                if (shift.notes != nil && ![shift.notes isEqualToString:@""]) {
                    shiftnotes_1.S = shift.notes;
                }
                AWSDynamoDBAttributeValue *str_year_1 = [AWSDynamoDBAttributeValue new];
                str_year_1.S = shift.string_year;
                AWSDynamoDBAttributeValue *str_month_1 = [AWSDynamoDBAttributeValue new];
                str_month_1.S = shift.string_month;
                AWSDynamoDBAttributeValue *str_day_1 = [AWSDynamoDBAttributeValue new];
                str_day_1.S = shift.string_day;
                AWSDynamoDBAttributeValue *str_week_1 = [AWSDynamoDBAttributeValue new];
                str_week_1.S = shift.string_week;
                AWSDynamoDBAttributeValue *str_time_1 = [AWSDynamoDBAttributeValue new];
                str_time_1.S = shift.string_time;
                AWSDynamoDBAttributeValue *takestate_1 = [AWSDynamoDBAttributeValue new];
                takestate_1.N = [NSString stringWithFormat:@"%hd",shift.takeState];
                AWSDynamoDBAttributeValue *havetakeemployeenumber_1 = [AWSDynamoDBAttributeValue new];
                int re = shift.haveTakedEmployeesNumber + (int)arr_selectEmployeesUUid.count;
                havetakeemployeenumber_1.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:re]];
                
                if ([needemployeenumber_1.N intValue] == [havetakeemployeenumber_1.N intValue]) {
                    isdelete_1.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
                }
                
                if (shift.positionUuid == nil && [shift.notes length] == 0) {
                    
                    writeRequest_1.putRequest.item = @{@"createDate": createdate_1,@"modifyDate" : modifyDate_1,@"uuid": haskKeyValue_1,@"managerUuid": manageruuid_1,@"parentUuid": rangeKeyValue_1,@"isDelete": isdelete_1,@"tableIdentityID": tablename_1,@"shift_employeeUuid": employeeuuid_1,@"shift_employeeName":employeename_1,@"shift_locationUuid": locationuuid_1,@"shift_startDate": startdate_1,@"shift_startTime": starttime_1,@"shift_endTime": endtime_1,@"shift_totalHours": totalhours_1,@"shift_unPaidBreak": unbreak_1,@"shift_employeesNumbers": needemployeenumber_1,@"shift_strYear": str_year_1,@"shift_strMonth": str_month_1,@"shift_strDay": str_day_1,@"shift_strWeek": str_week_1,@"shift_strTime": str_time_1,@"shift_takedState": takestate_1,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber_1};
                }
                else if (shift.positionUuid == nil && [shift.notes length] > 0)
                {
                    writeRequest_1.putRequest.item = @{@"createDate": createdate_1,@"modifyDate" : modifyDate_1,@"uuid": haskKeyValue_1,@"managerUuid": manageruuid_1,@"parentUuid": rangeKeyValue_1,@"isDelete": isdelete_1,@"tableIdentityID": tablename_1,@"shift_employeeUuid": employeeuuid_1,@"shift_employeeName":employeename_1,@"shift_locationUuid": locationuuid_1,@"shift_startDate": startdate_1,@"shift_startTime": starttime_1,@"shift_endTime": endtime_1,@"shift_totalHours": totalhours_1,@"shift_unPaidBreak": unbreak_1,@"shift_employeesNumbers": needemployeenumber_1,@"shift_strYear": str_year_1,@"shift_strMonth": str_month_1,@"shift_strDay": str_day_1,@"shift_strWeek": str_week_1,@"shift_strTime": str_time_1,@"shift_takedState": takestate_1,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber_1,@"shift_notes": shiftnotes_1};
                }
                else if (shift.positionUuid != nil && [shift.notes length] == 0)
                {
                    writeRequest_1.putRequest.item = @{@"createDate": createdate_1,@"modifyDate" : modifyDate_1,@"uuid": haskKeyValue_1,@"managerUuid": manageruuid_1,@"parentUuid": rangeKeyValue_1,@"isDelete": isdelete_1,@"tableIdentityID": tablename_1,@"shift_employeeUuid": employeeuuid_1,@"shift_employeeName":employeename_1,@"shift_locationUuid": locationuuid_1,@"shift_startDate": startdate_1,@"shift_startTime": starttime_1,@"shift_endTime": endtime_1,@"shift_totalHours": totalhours_1,@"shift_unPaidBreak": unbreak_1,@"shift_employeesNumbers": needemployeenumber_1,@"shift_strYear": str_year_1,@"shift_strMonth": str_month_1,@"shift_strDay": str_day_1,@"shift_strWeek": str_week_1,@"shift_strTime": str_time_1,@"shift_takedState": takestate_1,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber_1,@"shift_positionUuid": positionuuid_1};
                }
                else
                {
                    writeRequest_1.putRequest.item = @{@"createDate": createdate_1,@"modifyDate" : modifyDate_1,@"uuid": haskKeyValue_1,@"managerUuid": manageruuid_1,@"parentUuid": rangeKeyValue_1,@"isDelete": isdelete_1,@"tableIdentityID": tablename_1,@"isDelete": isdelete_1,@"shift_employeeUuid": employeeuuid_1,@"shift_employeeName":employeename_1,@"shift_locationUuid": locationuuid_1,@"shift_startDate": startdate_1,@"shift_startTime": starttime_1,@"shift_endTime": endtime_1,@"shift_totalHours": totalhours_1,@"shift_unPaidBreak": unbreak_1,@"shift_employeesNumbers": needemployeenumber_1,@"shift_strYear": str_year_1,@"shift_strMonth": str_month_1,@"shift_strDay": str_day_1,@"shift_strWeek": str_week_1,@"shift_strTime": str_time_1,@"shift_takedState": takestate_1,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber_1,@"shift_positionUuid": positionuuid_1,@"shift_notes": shiftnotes_1};
                }
                
                [arr_writeRequest addObject:writeRequest_1];
                
                NSMutableArray *arr_itemuuid = [NSMutableArray array];
                
                for (NSString *employeeUuid in arr_selectEmployeesUUid) {
                    
                    AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
                    writeRequest.putRequest = [AWSDynamoDBPutRequest new];
                    
                    AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
                    createdate.S = date;
                    AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
                    modifyDate.S = date;
                    AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
                    haskKeyValue.S = [StringManager getItemID];
                    [arr_itemuuid addObject:haskKeyValue.S];
                    AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
                    rangeKeyValue.S = shift.parentUuid;
                    AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
                    manageruuid.S = shift.managerUuid;
                    AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
                    isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
                    AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
                    tablename.S = @"Shifts";
                    
                    AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
                    employeeuuid.S = employeeUuid;
                    AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
                    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
                    employeename.S = employee.fullName;
                    if (employeeUuid == nil || [employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                        employeename.S = OpenShiftEmployeeName;
                    }
                    AWSDynamoDBAttributeValue *locationuuid = [AWSDynamoDBAttributeValue new];
                    locationuuid.S = shift.locationUuid;
                    AWSDynamoDBAttributeValue *positionuuid = [AWSDynamoDBAttributeValue new];
                    if (shift.positionUuid != nil) {
                        positionuuid.S = shift.positionUuid;
                    }
                    AWSDynamoDBAttributeValue *startdate = [AWSDynamoDBAttributeValue new];
                    startdate.S = shift.startDate;
                    AWSDynamoDBAttributeValue *starttime = [AWSDynamoDBAttributeValue new];
                    starttime.S = shift.startTime;
                    AWSDynamoDBAttributeValue *endtime = [AWSDynamoDBAttributeValue new];
                    endtime.S = shift.endTime;
                    AWSDynamoDBAttributeValue *totalhours = [AWSDynamoDBAttributeValue new];
                    totalhours.S = shift.totalHours;
                    AWSDynamoDBAttributeValue *unbreak = [AWSDynamoDBAttributeValue new];
                    unbreak.S = shift.unpaidBreak;
                    AWSDynamoDBAttributeValue *needemployeenumber = [AWSDynamoDBAttributeValue new];
                    needemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
                    AWSDynamoDBAttributeValue *shiftnotes = [AWSDynamoDBAttributeValue new];
                    if (shift.notes != nil) {
                        shiftnotes.S = shift.notes;
                    }
                    AWSDynamoDBAttributeValue *str_year = [AWSDynamoDBAttributeValue new];
                    str_year.S = shift.string_year;
                    AWSDynamoDBAttributeValue *str_month = [AWSDynamoDBAttributeValue new];
                    str_month.S = shift.string_month;
                    AWSDynamoDBAttributeValue *str_day = [AWSDynamoDBAttributeValue new];
                    str_day.S = shift.string_day;
                    AWSDynamoDBAttributeValue *str_week = [AWSDynamoDBAttributeValue new];
                    str_week.S = shift.string_week;
                    AWSDynamoDBAttributeValue *str_time = [AWSDynamoDBAttributeValue new];
                    str_time.S = shift.string_time;
                    AWSDynamoDBAttributeValue *istake = [AWSDynamoDBAttributeValue new];
                    istake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
                    AWSDynamoDBAttributeValue *takestate = [AWSDynamoDBAttributeValue new];
                    takestate.N = [NSString stringWithFormat:@"%hd",shift.takeState];
                    AWSDynamoDBAttributeValue *havetakeemployeenumber = [AWSDynamoDBAttributeValue new];
                    havetakeemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
                    
                    if (shift.positionUuid == nil && [shift.notes length] == 0) {
                        
                        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_employeeName":employeename};
                    }
                    else if (shift.positionUuid == nil && shift.notes != nil)
                    {
                        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
                    }
                    else if (shift.positionUuid != nil && shift.notes == nil)
                    {
                        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_employeeName":employeename};
                    }
                    else
                    {
                        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"isDelete": isdelete,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
                    }
                    
                    [arr_writeRequest addObject:writeRequest];
                }
                AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
                AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
                batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_writeRequest};
                batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
                [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
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
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSManagedObjectContext *context = [appdelegate managedObjectContext];
                            
                            shift.modifyDate = date;
                            if (shift.openShift_employees != nil) {
                                NSMutableArray *arr = [NSMutableArray arrayWithArray:[shift.openShift_employees componentsSeparatedByString:@","]];
                                for (NSString *e_uuid in arr_selectEmployeesUUid) {
                                    [arr addObject:e_uuid];
                                }
                                shift.openShift_employees = [arr componentsJoinedByString:@","];
                            }
                            else
                            {
                                shift.openShift_employees = [arr_selectEmployeesUUid componentsJoinedByString:@","];
                            }
                            int re = shift.haveTakedEmployeesNumber + (int)arr_selectEmployeesUUid.count;
                            shift.haveTakedEmployeesNumber = re;
                            
                            [context save:nil];
                            
                            for (int i = 0 ;i < arr_itemuuid.count; i++) {
                                NSString *itemuuid = [arr_itemuuid objectAtIndex:i];
                                Shifts *_shift = [NSEntityDescription insertNewObjectForEntityForName:@"Shifts" inManagedObjectContext:context];
                                _shift.createDate = date;
                                _shift.modifyDate = date;
                                _shift.uuid = itemuuid;
                                _shift.managerUuid = shift.managerUuid;
                                _shift.parentUuid = shift.parentUuid;
                                _shift.isDelete = 0;
                                _shift.employeeUuid = [arr_selectEmployeesUUid objectAtIndex:i];
                                Employees *employee = [DatabaseManager getEmployeeByUuid:_shift.employeeUuid];
                                _shift.employeeName = employee.fullName;
                                _shift.positionUuid = shift.positionUuid;
                                _shift.locationUuid = shift.locationUuid;
                                _shift.startDate = shift.startDate;
                                _shift.startTime = shift.startTime;
                                _shift.endTime = shift.endTime;
                                _shift.totalHours = shift.totalHours;
                                _shift.unpaidBreak = shift.unpaidBreak;
                                _shift.needEmployeesNumber = 0;
                                _shift.notes = shift.notes;
                                _shift.string_year = shift.string_year;
                                _shift.string_month = shift.string_month;
                                _shift.string_day = shift.string_day;
                                _shift.string_week = shift.string_week;
                                _shift.string_time = shift.string_time;
                                _shift.isTake = 0;
                                _shift.haveTakedEmployeesNumber = 0;
                                _shift.takeState = shift.takeState;
                                _shift.haveTakedEmployeesNumber = 0;
                                [context save:nil];
                            }
                            
                            if (shift.haveTakedEmployeesNumber == shift.needEmployeesNumber) {
                                shift.isDelete = 1;
                                [context deleteObject:shift];
                                [context save:nil];
                            }
                            
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }
                    return nil;
                }];
            }
        }
        else
        {
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            DDBDataModel *model = [DynamoDBManager getDropDataModelByDropUuid:nil andOriShiftUuid:uuid];
            if (appdelegate.currentEmployee.isManager == 0) {
                model.drop_isManagerAccepted = [NSNumber numberWithInt:0];
            }
            else
            {
                model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
            }
            model.drop_state = @"0";
            if (_textView.text != nil) {
                model.drop_messsage = _textView.text;
            }
            model.drop_dropUuids = [arr_selectEmployeesUUid componentsJoinedByString:@","];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper save:model]
             continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                             
                             NSManagedObjectContext *context = [appdelegate managedObjectContext];
                             
                             Drop *drop = [NSEntityDescription insertNewObjectForEntityForName:@"Drop" inManagedObjectContext:context];
                             drop.createDate = model.createDate;
                             drop.modifyDate = model.modifyDate;
                             drop.uuid = model.uuid;
                             drop.managerUuid = model.managerUuid;
                             drop.parentUuid = model.parentUuid;
                             drop.isDelete = [model.isDelete shortValue];
                             drop.parentShiftUuid = model.drop_parentShidtUuid;
                             drop.oriShiftEmployeeUuid = model.drop_oriShiftEmployeeUuid;
                             drop.isDrop = [model.drop_isDrop shortValue];
                             drop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                             drop.message = model.drop_messsage;
                             drop.state = model.drop_state;
                             drop.dropUuids = model.drop_dropUuids;
                             
                             [context save:nil];
                             
                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                             [self.navigationController popViewControllerAnimated:YES];
                         });
                     }
                 }
                 return nil;
             }];
        }
    }
}


- (IBAction)seeShiftDetail:(UIButton *)sender {
    ShiftDetailViewController_iphone *detail = [ShiftDetailViewController_iphone new];
    detail.uuid = uuid;
    detail.notEditShift = YES;
    [self.navigationController pushViewController:detail animated:YES];
}
@end
