//
//  RequestDetailViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/5.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "RequestDetailViewController_iphone.h"

@interface RequestDetailViewController_iphone ()
{
    NSArray *arr_disposeState;
}
@end

@implementation RequestDetailViewController_iphone
@synthesize uuid;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    if (ScreenWidth == 320) {
        _label_timeInterval.font = [UIFont systemFontOfSize:14.0];
        _label_type.font = [UIFont systemFontOfSize:14.0];
        _label_paidhours.font = [UIFont systemFontOfSize:14.0];
        _messageTextView.font = [UIFont systemFontOfSize:14.0];
        _messageTitleLabel.frame = CGRectMake(14, _messageTitleLabel.frame.origin.y, _messageTitleLabel.frame.size.width, _messageTitleLabel.frame.size.height);
        _l_line2.frame = CGRectMake(14, _l_line2.frame.origin.y, _l_line2.frame.size.width, 1);
        _l_line3.frame = CGRectMake(14, _l_line3.frame.origin.y, _l_line3.frame.size.width, 1);
        _l_line4.frame = CGRectMake(14, _l_line4.frame.origin.y, _l_line4.frame.size.width, 1);
    }
    else
    {
        _messageTextView.frame = CGRectMake(12, _messageTextView.frame.origin.y, _messageTextView.frame.size.width, _messageTextView.frame.size.height);
    }
    
    Requests *request = [DatabaseManager getRequestByUuid:uuid];
    Employees *employee = [DatabaseManager getEmployeeByUuid:request.employeeUuid];
    _image_portrait.layer.masksToBounds = YES;
    _image_portrait.layer.cornerRadius = 18.0;
    if (employee.headPortrait == nil) {
        _image_portrait.image = [UIImage imageNamed:@"defaultEmpoyee"];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _image_portrait.frame.size.width, _image_portrait.frame.size.height)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:employee.fullName]];
        [_image_portrait addSubview:lab];
    }
    else
    {
        _image_portrait.image = [UIImage imageWithData:employee.headPortrait];
    }
    _label_name.text = employee.fullName;
    UIColor *stateLabelTextColor;
    NSString *stateLabelText = nil;
    if ([request.waitType isEqualToString:@"0"]) {
        stateLabelText = @"Pending";
        stateLabelTextColor = SetColor(0, 0, 0, 0.54);
    }
    else if ([request.waitType isEqualToString:@"1"])
    {
        stateLabelText = @"Approved";
        stateLabelTextColor = SetColor(0, 195, 0, 1.0);
    }
    else
    {
        stateLabelText = @"Canceled";
        stateLabelTextColor = SetColor(250, 67, 63, 1.0);
    }
    _label_state.text = stateLabelText;
    _label_state.textColor = stateLabelTextColor;
    
    NSString *intervalLabelText = nil;
    NSString *intervalLabelText2 = nil;
    
    if (request.string_startTime == nil) {
        NSDictionary *dict1 = [StringManager getYearMonthDay:request.stamp_startDate];
        NSDictionary *dict2 = [StringManager getYearMonthDay:request.stamp_endDate];
        NSDate *date1 = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[request.stamp_startDate longLongValue]]];
        NSDate *date2 = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[request.stamp_endDate longLongValue]]];
        NSInteger re = [StringManager calcDaysFromBegin:date1 end:date2]+1;
        intervalLabelText = [NSString stringWithFormat:@"%@ %@ %@ - %@ %@ %@",[StringManager getEnglishMonth:[[dict1 objectForKey:@"month"] longValue]],[dict1 objectForKey:@"day"],[dict1 objectForKey:@"year"],[StringManager getEnglishMonth:[[dict2 objectForKey:@"month"] longValue]],[dict2 objectForKey:@"day"],[dict2 objectForKey:@"year"]];
        intervalLabelText2 = [NSString stringWithFormat:@"(%ldd)",(long)re];
    }
    else
    {
        NSDictionary *dict1 = [StringManager getYearMonthDay:request.stamp_startDate];
        float hour = [StringManager getIntervalHoursFromTowTime:request.string_startTime andTime2:request.string_endTime];
        intervalLabelText = [NSString stringWithFormat:@"%@ %@ %@, %@ - %@",[StringManager getEnglishMonth:[[dict1 objectForKey:@"month"] longValue]],[dict1 objectForKey:@"day"],[dict1 objectForKey:@"year"],request.string_startTime,request.string_endTime];
        intervalLabelText2 = [NSString stringWithFormat:@"(%.2fh)",hour];
    }
    
    CGSize size;
    if (ScreenWidth == 320) {
        size = [StringManager labelAutoCalculateRectWith:intervalLabelText FontSize:14.0 MaxSize:CGSizeMake(250, 20)];
        _label_timeInterval.frame = CGRectMake(_label_timeInterval.frame.origin.x-3, _label_timeInterval.frame.origin.y, size.width, 20);
    }
    else
    {
        size = [StringManager labelAutoCalculateRectWith:intervalLabelText FontSize:17.0 MaxSize:CGSizeMake(300, 20)];
        _label_timeInterval.frame = CGRectMake(_label_timeInterval.frame.origin.x, _label_timeInterval.frame.origin.y, size.width, 20);
    }
    
    _label_timeInterval.text = intervalLabelText;
    UILabel *label_timeInterval2 = [[UILabel alloc] initWithFrame:CGRectMake(size.width+20, _label_timeInterval.frame.origin.y, ScreenWidth-_label_timeInterval.frame.origin.x-16, 20)];
    label_timeInterval2.text = intervalLabelText2;
    label_timeInterval2.font = [UIFont systemFontOfSize:17.0];
    if (ScreenWidth == 320) {
        label_timeInterval2.font = [UIFont systemFontOfSize:14.0];
    }
    label_timeInterval2.textColor = SetColor(0, 0, 0, 0.3);
    [self.view addSubview:label_timeInterval2];
    
    if ([request.type isEqualToString:@"0"]) {
        _label_type.text = @"Unpaid";
    }
    else if ([request.type isEqualToString:@"1"])
    {
        _label_type.text = @"Paid (PTO)";
    }
    else if ([request.type isEqualToString:@"2"])
    {
        _label_type.text = @"Sick";
    }
    else
    {
        _label_type.text = @"Holiday";
    }
    
    _label_paidhours.text = [NSString stringWithFormat:@"%hd h",request.paidHours];

    NSDictionary *dict_state;
    if ([request.waitType isEqualToString:@"0"]) {
        dict_state = [StringManager getYearMonthDayTime:request.createDate];
    }
    else
    {
        dict_state = [StringManager getYearMonthDayTime:request.disposeDate];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",[[dict_state objectForKey:@"minute"] longValue]];
    if ([minute length] == 1) {
        minute = [NSString stringWithFormat:@"0%@",minute];
    }

    _messageTextView.text = request.message;
    if (request.message == nil) {
        _messageTextView.text = @"No Message";
    }
//    CGFloat fontCapHeight = _messageTextView.font.capHeight; // 文字大小所占的高度
//    CGFloat topMargin = 32; // 跟顶部的间距
//    _messageTextView.contentInset = UIEdgeInsetsMake(-_messageTextView.frame.size.height*0.5 + fontCapHeight + topMargin, 0, 0, 0);
    
    if (![request.type isEqualToString:@"1"]) {
        _paidHourTitleLabel.hidden = YES;
        _paidHourContentLabel.hidden = YES;
        _paidHourLine.hidden = YES;
        _messageTitleLabel.frame = CGRectMake(_messageTitleLabel.frame.origin.x, _paidHourTitleLabel.frame.origin.y, _messageTitleLabel.frame.size.width, _messageTitleLabel.frame.size.height);
        _messageTextView.frame = CGRectMake(_messageTextView.frame.origin.x, _paidHourContentLabel.frame.origin.y, _messageTextView.frame.size.width, _messageTextView.frame.size.height);
    }
    
    _employeeCancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _employeeCancelBtn.frame = CGRectMake(0, 1, ScreenWidth, 49);
    //246.69.69
    [_employeeCancelBtn setTitle:@"Cancel Request" forState:UIControlStateNormal];
    [_employeeCancelBtn setTitleColor:SetColor(246, 69, 69, 1.0) forState:UIControlStateNormal];
    _employeeCancelBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
    [_bottomView addSubview:_employeeCancelBtn];
    [_employeeCancelBtn addTarget:self action:@selector(cancelRequest:) forControlEvents:UIControlEventTouchUpInside];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([request.waitType isEqualToString:@"0"]) {
        //_label_state.text = @"Pending";
        if (appdelegate.currentEmployee.isManager == 0) {
            _cancelBtn.hidden = YES;
            _approveBtn.hidden = YES;
            _line1.hidden = YES;
            _line2.hidden = YES;
        }
        else
        {
            _employeeCancelBtn.hidden = YES;
        }
    }
    else
    {
        //1,2,3
        if (appdelegate.currentEmployee.isManager == 0) {
            
            _cancelBtn.hidden = YES;
            _approveBtn.hidden = YES;
            _line1.hidden = YES;
            _line2.hidden = YES;
            if ([request.waitType isEqualToString:@"2"] || [request.waitType isEqualToString:@"3"]) {
                
                _employeeCancelBtn.hidden = YES;
            }
        }
        else
        {
            _employeeCancelBtn.hidden = YES;
            if ([request.waitType isEqualToString:@"1"]) {
                _approveBtn.alpha = 0.5;
                _approveBtn.enabled = NO;
            }
            else if ([request.waitType isEqualToString:@"2"]) {
                _cancelBtn.alpha = 0.5;
                _cancelBtn.enabled = NO;
            }
        }
    }
    _deleteBtn.hidden = YES;
    
    arr_disposeState = [DatabaseManager getRequestAllDisposeState:uuid];
    
    if (_bgBlackView == nil) {
        
        _bgBlackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgBlackView.backgroundColor = SetColor(0, 0, 0, 0.1);
        [self.view addSubview:_bgBlackView];
        _bgBlackView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidebgBlackView:)];
        [_bgBlackView addGestureRecognizer:tap];
    }
    if (_bgWhiteView == nil) {
        _bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 252)];
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgWhiteView];
        if (arr_disposeState.count > 3) {
            _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 3*56+44+30);
        }
        if(_historyTableView == nil)
        {
            _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _bgWhiteView.frame.size.width, _bgWhiteView.frame.size.height)];
            _historyTableView.delegate = self;
            _historyTableView.dataSource = self;
            _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [_bgWhiteView addSubview:_historyTableView];
        }
    }

    // Do any additional setup after loading the view from its nib.
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)approveRequest:(UIButton *)sender {
    
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    
    Requests *request = [DatabaseManager getRequestByUuid:uuid];
    
    DDBDataModel *model = [DynamoDBManager getRequestDataModelByRequestUuid:uuid and:nil andState:@"1"];
    
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
                     
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                     request.disposeDate = model.modifyDate;
                     request.waitType = model.request_waitType;
                     [context save:nil];
                     
                     RequestAllDisposeState *dispose = [NSEntityDescription insertNewObjectForEntityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
                     dispose.parentUuid = request.parentUuid;
                     dispose.parentRequestUuid = request.uuid;
                     //同意只能是manager同意
                     dispose.sendRequestEmployeeUuid = appDelegate.currentEmployee.uuid;
                     dispose.disposeTime = request.disposeDate;
                     dispose.disposeState = request.waitType;
                     
                     [context save:nil];
                     
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     [self.navigationController popViewControllerAnimated:YES];
                 });
             }
         }
         return nil;
     }];
}

//employee取消自己的request，或者manager拒绝employee和自己的request
- (IBAction)cancelRequest:(UIButton *)sender {
    
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    
    Requests *request = [DatabaseManager getRequestByUuid:uuid];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DDBDataModel *model;
    if (appdelegate.currentEmployee.isManager == 0) {
        //employee取消自己的request
        model = [DynamoDBManager getRequestDataModelByRequestUuid:uuid and:nil andState:@"3"];
    }
    else
    {
        //manager取消自己的request或者denyemployee的request
        model = [DynamoDBManager getRequestDataModelByRequestUuid:uuid and:nil andState:@"2"];
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
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                     request.disposeDate = model.modifyDate;
                     request.waitType = model.request_waitType;
                     [context save:nil];
                     
                     RequestAllDisposeState *dispose = [NSEntityDescription insertNewObjectForEntityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
                     dispose.parentUuid = request.parentUuid;
                     dispose.parentRequestUuid = request.uuid;
                     if (appdelegate.currentEmployee.isManager == 0) {
                         dispose.sendRequestEmployeeUuid = request.employeeUuid;
                     }
                     else
                     {
                         dispose.sendRequestEmployeeUuid = appDelegate.currentEmployee.uuid;
                     }
                     dispose.disposeTime = request.disposeDate;
                     dispose.disposeState = request.waitType;
                     
                     [context save:nil];
                     
                     [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                     [self.navigationController popViewControllerAnimated:YES];
                      
                 });
             }
         }
         return nil;
     }];
}

- (IBAction)deleteRequest:(UIButton *)sender {
}


- (IBAction)showHistoryState:(UIButton *)sender {
    
    _bgBlackView.hidden = NO;
    [UIView animateWithDuration:AnimatedDuration animations:^{
        
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight - _bgWhiteView.frame.size.height, ScreenWidth, _bgWhiteView.frame.size.height);
        
    } completion:^(BOOL finished){
    }];
}

- (IBAction)employeeInfoBtn:(UIButton *)sender {
    
    Requests *request = [DatabaseManager getRequestByUuid:uuid];
    Employees *employee = [DatabaseManager getEmployeeByUuid:request.employeeUuid];
    EditEmployeeViewController_iphone *edit = [[EditEmployeeViewController_iphone alloc]init];
    edit.employeeUuid = employee.uuid;
    [self.navigationController pushViewController:edit animated:YES];
}

-(void)hidebgBlackView:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:AnimatedDuration animations:^{
        _bgWhiteView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _bgWhiteView.frame.size.height);
    } completion:^(BOOL finished){
        _bgBlackView.hidden = YES;
    }];
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"History";
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_disposeState.count;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in cell.imageView.subviews) {
        [view removeFromSuperview];
    }
    
    if (arr_disposeState.count - 1 >= indexPath.row) {
        
        RequestAllDisposeState *dispose = [arr_disposeState objectAtIndex:indexPath.row];
        Employees *employee = [DatabaseManager getEmployeeByUuid:dispose.sendRequestEmployeeUuid];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 56/2-36/2, 36, 36)];
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
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(68, 11, ScreenWidth-78, 16)];
        label.text = [NSString stringWithFormat:@"%@",employee.fullName];
        label.textColor = SetColor(0, 0, 0, 0.87);
        label.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:label];
        
        NSString *time = nil;
        if ([dispose.disposeState isEqualToString:@"0"]) {
            time = @"Created ";
        }
        else if ([dispose.disposeState isEqualToString:@"1"])
        {
            time = @"Approved";
        }
        else
        {
            time = @"Canceled";
        }
        NSDictionary *dict_state = [StringManager getYearMonthDayTime:dispose.disposeTime];
        NSString *minute = [NSString stringWithFormat:@"%ld",[[dict_state objectForKey:@"minute"] longValue]];
        if ([minute length] == 1) {
            minute = [NSString stringWithFormat:@"0%@",minute];
        }
        time = [NSString stringWithFormat:@"%@ %@ %@, %@ at %@:%@ %@",time,[StringManager getEnglishMonth:[[dict_state objectForKey:@"month"] longValue]],[dict_state objectForKey:@"day"],[dict_state objectForKey:@"year"],[dict_state objectForKey:@"hour"],minute,[dict_state objectForKey:@"end"]];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 29, ScreenWidth-68, 16)];
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.text = time;
        detailLabel.textColor = TextColorAlpha_54;
        [cell.contentView addSubview:detailLabel];
        
        if (indexPath.row == 0) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            line.backgroundColor = SetColor(0, 0, 0, 0.2);
            [cell.contentView addSubview:line];
        }
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 55.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    
    
    return cell;
}

@end
