 //
//  SwapViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/30.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SwapViewController_iphone.h"

@interface SwapViewController_iphone ()
{
    Shifts *passshift;
    Drop *passSwap;
    NSMutableArray *arr_shiftsUuid;
    NSMutableArray *arr_selectShiftsUuid;
    
    Shifts *accpteShift;

}
@end

@implementation SwapViewController_iphone
@synthesize uuid;
@synthesize swapuuid;
@synthesize isShowShiftDetail;

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    arr_selectShiftsUuid = [NSMutableArray array];
    
    _portraitView.frame = CGRectMake(ScreenWidth/2-30, 74, 56, 56);
    _portraitView.layer.masksToBounds = YES;
    _portraitView.layer.cornerRadius = _portraitView.frame.size.width/2;
    
    passshift = [DatabaseManager getShiftByUuid:uuid];
    passSwap = [DatabaseManager getSwapByUuid:swapuuid];
    
    accpteShift = [DatabaseManager getShiftByUuid:passSwap.swap_acceptShiftUuid];
    
    Employees *employee = [DatabaseManager getEmployeeByUuid:passshift.employeeUuid];
    Locations *location = [DatabaseManager getLocationByUuid:passshift.locationUuid];
    Positions *position = [DatabaseManager getPositionByUuid:passshift.positionUuid];
    
    if (passSwap.swap_acceptShiftUuid != nil && passSwap.swapShiftUuid1 != nil && passSwap.swapShiftUuid2 != nil) {
        Shifts *shift1 = [DatabaseManager getShiftByUuid:passSwap.swapShiftUuid1];
        employee = [DatabaseManager getEmployeeByUuid:shift1.employeeUuid];
        
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
        
    }
    else
    {
        _portraitView.image = [UIImage imageWithData:employee.headPortrait];
    }
    
    Employees *oriemployee = [DatabaseManager getEmployeeByUuid:passSwap.oriShiftEmployeeUuid];
    _nameLabel.text = oriemployee.fullName;
    if (oriemployee != nil) {
        _nameLabel.text = oriemployee.fullName;
    }
    
    _shiftTimeLabel.text = [NSString stringWithFormat:@"%@, %@ %@  %@",passshift.string_week,passshift.string_month,passshift.string_day,passshift.string_time];
    if (position != nil) {
        _addressLabel.text = [NSString stringWithFormat:@"at %@ as %@",location.name,position.name];
    }
    else
    {
        _addressLabel.text = [NSString stringWithFormat:@"at %@",location.name];
    }
    
    if ([passSwap.state isEqualToString:@"1"]) {
        Shifts *oripositionshift = [DatabaseManager getShiftByUuid:passSwap.swapShiftUuid1];
        Positions *oriposition = [DatabaseManager getPositionByUuid:oripositionshift.positionUuid];
        if (oriposition != nil) {
            _addressLabel.text = [NSString stringWithFormat:@"at %@ as %@",location.name,oriposition.name];
        }
        else
        {
            _addressLabel.text = [NSString stringWithFormat:@"at %@",location.name];
        }
    }
    
    if(isShowShiftDetail == NO)
    {
        _showShiftDtailBtn.hidden = YES;
    }
    
    if (passSwap == nil) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, _stateLabel.frame.origin.y, ScreenWidth, _stateLabel.frame.size.height)];
        lab.text = @"New";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12.0];
        lab.textColor = SetColor(200, 200, 200, 1.0);
        [_shiftView addSubview:lab];
        _stateLabel.hidden = YES;
    }
    else
    {
        _sendBtn.hidden = YES;
        if ([passSwap.state intValue] == 0) {
            _stateLabel.text = @"Pending";
            _stateLabel.textColor = [UIColor orangeColor];
        }
        else if ([passSwap.state intValue] == 1) {
            _stateLabel.text = @"Accpeted";
            _stateLabel.textColor = AppMainColor;
        }
        else if ([passSwap.state intValue] == 2) {
            _stateLabel.text = @"Decline";
            _stateLabel.textColor = [UIColor redColor];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict = [StringManager getYearMonthDay:passSwap.createDate];
        if (passSwap.message != nil) {
            _textView.text = passSwap.message;
        }
    }

    
    if (_selectAllBtn == nil) {
        _selectAllBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _selectAllBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
        [_selectAllBtn setTitle:@"Select All" forState:UIControlStateNormal];
        [_selectAllBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        _selectAllBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_selectAllBtn];
        [_selectAllBtn addTarget:self action:@selector(selectAllShifts) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_selectNoneBtn == nil) {
        _selectNoneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _selectNoneBtn.frame = CGRectMake(ScreenWidth/2, 1, ScreenWidth/2, 49);
        [_selectNoneBtn setTitle:@"Select None" forState:UIControlStateNormal];
        _selectNoneBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_selectNoneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_bottomView addSubview: _selectNoneBtn];
        [_selectNoneBtn addTarget:self action:@selector(selectNoneShifts) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_acceptBtn == nil) {
        _acceptBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _acceptBtn.frame = CGRectMake(0, 1, ScreenWidth/2, 49);
        [_acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
        [_acceptBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        _acceptBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_bottomView addSubview:_acceptBtn];
        [_acceptBtn addTarget:self action:@selector(acceptedSwap) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_declineBtn == nil) {
        _declineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _declineBtn.frame = CGRectMake(ScreenWidth/2, 1, ScreenWidth/2, 49);
        [_declineBtn setTitle:@"Decline" forState:UIControlStateNormal];
        _declineBtn.titleLabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
        [_declineBtn setTitleColor:SetColor(250, 67, 63, 1.0) forState:UIControlStateNormal];
        [_bottomView addSubview:_declineBtn];
        [_declineBtn addTarget:self action:@selector(declineSwap) forControlEvents:UIControlEventTouchUpInside];
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
    
    //该shift还没swap,仅仅是发起人
    if (passSwap == nil) {
        
        _acceptBtn.hidden = YES;
        _declineBtn.hidden = YES;
        _cancelRequestBtn.hidden = YES;
        
        //发起人，去获取所有相关的shift
        arr_shiftsUuid = [DatabaseManager getFreeShiftsUuidByShiftUuid:uuid];
    
    }
    //该shift已经swap
    else
    {
        _sendBtn.hidden = YES;
        _textView.userInteractionEnabled = NO;
        
        arr_shiftsUuid = [NSMutableArray array];
        
        for (NSString *shfituuid in [passSwap.dropUuids componentsSeparatedByString:@","]) {

            Shifts *shfit = [DatabaseManager getShiftByUuid:shfituuid];
            Employees *employee = [DatabaseManager getEmployeeByUuid:shfit.employeeUuid];
            if (employee != nil && shfit != nil) {

                if ([passSwap.state isEqualToString:@"1"]) {
                    if (passSwap.swap_acceptShiftUuid != nil && passSwap.swapShiftUuid1 != nil && passSwap.swapShiftUuid2 != nil) {
                        Shifts *s_swap = [DatabaseManager getShiftByUuid:passSwap.swapShiftUuid1];
                        if (s_swap != nil) {
                            [arr_shiftsUuid addObject:shfit.uuid];
                        }
                    }
                }
                else
                {
                    [arr_shiftsUuid addObject:shfit.uuid];
                }
            }
        }
        
        //已经swap的shift，发起人只能cancel
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
                
                if (passSwap.isManagerAccepted == 1) {
                    
                    //manager已经accepted后，,如果swap的所有shift包含自己的shift，则选择一个自己的shift进行交换，否则只能做cancel操作
                    bool existMe = NO;
                    for (NSString *shiftuuid in arr_shiftsUuid) {
                        Shifts *shift = [DatabaseManager getShiftByUuid:shiftuuid];
                        Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
                        if ([employee.uuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                            existMe = YES;
                            break;
                        }
                    }
                    if (existMe == YES) {
                        _selectAllBtn.hidden = YES;
                        _selectNoneBtn.hidden = YES;
                        _cancelRequestBtn.hidden = YES;
                    }
                    else
                    {
                        _selectAllBtn.hidden = YES;
                        _selectNoneBtn.hidden = YES;
                        _acceptBtn.hidden = YES;
                        _declineBtn.hidden = YES;
                        _line.hidden = YES;
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
                NSArray *arr_decline = [passSwap.declineDropUuids componentsSeparatedByString:@","];
                for (NSString *shiftuuid in arr_decline) {
                    Shifts *shift = [DatabaseManager getShiftByUuid:shiftuuid];;
                    if ([shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        _line.hidden = YES;
                        _line2.hidden = YES;
                        _acceptBtn.hidden = YES;
                        _declineBtn.hidden = YES;
                        break;
                    }
                }
            }
        }
    }
    
    if (passSwap != nil && ![passSwap.state isEqualToString:@"0"]) {
        _selectAllBtn.hidden = YES;
        _selectNoneBtn.hidden = YES;
        _cancelRequestBtn.hidden = YES;
        _acceptBtn.hidden = YES;
        _declineBtn.hidden = YES;
        _line.hidden = YES;
        _line2.hidden = YES;
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
//    if ([textView.text length] > 50 && ![text isEqualToString:@""]) {
//        return NO;
//    }
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
    return arr_shiftsUuid.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, ScreenWidth-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, ScreenWidth-60, 20)];
    textLabel.font = [UIFont systemFontOfSize:17.0];
    textLabel.textColor = SetColor(3, 3, 3, 1.0);
    [cell.contentView addSubview:textLabel];
    
    if (ScreenWidth == 320) {
        textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 34, textLabel.frame.size.width, 16)];
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.textColor = TextColorAlpha_54;
    [cell.contentView addSubview:detailLabel];
    
    Shifts *shift = [DatabaseManager getShiftByUuid:[arr_shiftsUuid objectAtIndex:indexPath.row]];
    Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
    Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
    
    textLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@",shift.string_week,shift.string_month,shift.string_day,shift.string_time];

    if (position != nil) {
        detailLabel.text = [NSString stringWithFormat:@"%@ as %@",employee.fullName,position.name];
    }
    else
    {
        detailLabel.text = employee.fullName;
    }
    
    if (ScreenWidth == 320) {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    if (passSwap.swap_acceptShiftUuid != nil && passSwap.swapShiftUuid1 != nil && passSwap.swapShiftUuid2 != nil && [shift.uuid isEqualToString:passSwap.swap_acceptShiftUuid]) {
        
        Shifts *shift1 = [DatabaseManager getShiftByUuid:passSwap.swapShiftUuid1];
        textLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@",shift1.string_week,shift1.string_month,shift1.string_day,shift1.string_time];
    }
    
 
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //新创建的swap或还没有被manager accepted的swap，需要进行任意多选
    if (passSwap == nil || (appdelegate.currentEmployee.isManager == 1 && passSwap != nil && passSwap.isManagerAccepted  == 0 && [passSwap.state isEqualToString:@"0"])) {
        
        UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
        imageview2.image = [UIImage imageNamed:@"s_normal1"];
        imageview2.highlightedImage = [UIImage imageNamed:@"s_selected1"];
        [cell.contentView addSubview:imageview2];
        if ([arr_selectShiftsUuid containsObject:shift.uuid]) {
            imageview2.highlighted = YES;
        }
    }
    else
    {
        //被发起者还没有对swap进行操作并且swap当前状态为“0”，则可以进行单选去accpted
        //manager和发起者，只能显示decline的shift或accpted的shift
        if (passSwap != nil && passSwap.isManagerAccepted == 1 && [passSwap.state isEqualToString:@"0"] && [shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
            
            UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
            imageview2.image = [UIImage imageNamed:@"s_normal1"];
            imageview2.highlightedImage = [UIImage imageNamed:@"s_selected1"];
            [cell.contentView addSubview:imageview2];
            
            if (![passSwap.declineDropUuids containsString:shift.uuid]) {

                if (accpteShift != nil && [accpteShift.uuid isEqualToString:shift.uuid]) {
                    imageview2.highlighted = YES;
                }
            }
            else
            {
                imageview2.image = [UIImage imageNamed:@"decline"];
            }
        }
        else
        {
            UIImageView *imageview2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-40, 20, 20, 20)];
            [cell.contentView addSubview:imageview2];
            if (passSwap.declineDropUuids != nil && [passSwap.declineDropUuids containsString:shift.uuid]) {
                imageview2.image = [UIImage imageNamed:@"decline"];
            }
            else if (passSwap.swap_acceptShiftUuid != nil && accpteShift != nil && [shift.uuid isEqualToString:accpteShift.uuid]) {
                imageview2.image = [UIImage imageNamed:@"s_selected1"];
            }
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (passSwap == nil || (appdelegate.currentEmployee.isManager == 1 && passSwap != nil && passSwap.isManagerAccepted  == 0 && [passSwap.state isEqualToString:@"0"])) {
        
        Shifts *shift = [DatabaseManager getShiftByUuid:[arr_shiftsUuid objectAtIndex:indexPath.row]];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *arr_view = cell.contentView.subviews;
        UIImageView *imageview = [arr_view lastObject];
        if (imageview.highlighted == YES) {
            imageview.highlighted = NO;
            if ([arr_selectShiftsUuid containsObject:shift.uuid]) {
                [arr_selectShiftsUuid removeObject:shift.uuid];
            }
        }
        else
        {
            imageview.highlighted = YES;
            if (![arr_selectShiftsUuid containsObject:shift.uuid]) {
                if (arr_selectShiftsUuid == nil) {
                    arr_selectShiftsUuid = [NSMutableArray array];
                }
                [arr_selectShiftsUuid addObject:shift.uuid];
            }
        }
        [_tableView reloadData];
    }
    else
    {
        Shifts *shift = [DatabaseManager getShiftByUuid:[arr_shiftsUuid objectAtIndex:indexPath.row]];
        if (passSwap != nil && passSwap.isManagerAccepted == 1 && [passSwap.state isEqualToString:@"0"] && [shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]){
            if (![passSwap.declineDropUuids containsString:shift.uuid]) {
                //被发起者选择一个shift交换
                Shifts *shift = [DatabaseManager getShiftByUuid:[arr_shiftsUuid objectAtIndex:indexPath.row]];
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                NSArray *arr_view = cell.contentView.subviews;
                UIImageView *imageview = [arr_view lastObject];
                if (imageview.highlighted == YES) {

                }
                else
                {
                    imageview.highlighted = YES;
                    accpteShift = shift;
                    [_tableView reloadData];
                }
            }
        }
    }
}

-(void) selectAllShifts
{
    arr_selectShiftsUuid = nil;
    arr_selectShiftsUuid = [NSMutableArray arrayWithArray:arr_shiftsUuid];
    [_tableView reloadData];
}

-(void) selectNoneShifts
{
    arr_selectShiftsUuid = nil;
    [_tableView reloadData];
}


-(void) acceptedSwap
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (passSwap.isManagerAccepted == 0 && appdelegate.currentEmployee.isManager == 1) {
        if (arr_selectShiftsUuid.count == 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must select one employee at least!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passSwap.uuid rangeKey:passSwap.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                            passSwap.modifyDate = model.modifyDate;
                            passSwap.declineDropUuids = model.drop_delcineDropUuids;
                            passSwap.dropUuids = model.drop_dropUuids;
                            passSwap.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
                            passSwap.isDelete = [model.isDelete shortValue];
                            passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                            passSwap.state = model.drop_state;
                            [context save:nil];
                            
                            if (passSwap.isDelete == 0) {
                                if ([passSwap.state isEqualToString:@"0"]) {
                                    
                                    [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passSwap.uuid rangeKey:passSwap.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
                                        if (task.error) {
                                            
                                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                            NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                            [alertController addAction:okAction];
                                            [self presentViewController:alertController animated:YES completion:nil];
                                        }
                                        else {
                                            
                                            DDBDataModel *model = [DynamoDBManager getSwapDataModelBySwapUuid:passSwap.uuid andOriShiftUuid:uuid];
                                            model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
                                            model.drop_state = @"0";
                                            if (_textView.text != nil) {
                                                model.drop_messsage = _textView.text;
                                            }
                                            model.drop_dropUuids = [arr_selectShiftsUuid componentsJoinedByString:@","];
                                            
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
                                                             
                                                             passSwap.modifyDate = model.modifyDate;
                                                             passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                                                             passSwap.message = model.drop_messsage;
                                                             passSwap.dropUuids = model.drop_dropUuids;
                                                             
                                                             [context save:nil];
                                                             
                                                             NSString *string = passSwap.dropUuids;
                                                             NSArray *arr = [NSArray arrayWithArray:[string componentsSeparatedByString:@","]];
                                                             
                                                             NSMutableArray *arr_employeeuuid = [NSMutableArray array];
                                                             for (NSString *shiftid in arr) {
                                                                 
                                                                 Shifts *shfit = [DatabaseManager getShiftByUuid:shiftid];
                                                                 Employees *employee = [DatabaseManager getEmployeeByUuid:shfit.employeeUuid];
                                                                 if (employee != nil && ![arr_employeeuuid containsObject:employee.uuid]) {
                                                                     [arr_employeeuuid addObject:employee.uuid];
                                                                 }
                                                             }
                                                             
                                                             
                                                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                             
                                                         });
                                                     }
                                                 }
                                                 return nil;
                                             }];
                                        }
                                        return nil;
                                    }];
                                }
                                else if([passSwap.state isEqualToString:@"1"])
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been Accepted us to the others." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else if([passSwap.state isEqualToString:@"2"])
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been declined." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else if([passSwap.state isEqualToString:@"3"])
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been canceled." preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted!" preferredStyle:UIAlertControllerStyleAlert];
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
        if (accpteShift == nil) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must select one shift!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passSwap.uuid rangeKey:passSwap.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                            passSwap.modifyDate = model.modifyDate;
                            passSwap.declineDropUuids = model.drop_delcineDropUuids;
                            passSwap.dropUuids = model.drop_dropUuids;
                            passSwap.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
                            passSwap.isDelete = [model.isDelete shortValue];
                            passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                            passSwap.state = model.drop_state;
                            [context save:nil];
                            
                            if (passSwap.isDelete == 0) {
                                if ([passSwap.state isEqualToString:@"0"] && passSwap.isManagerAccepted == 1) {
                                    //同步三条数据，两条shift和一条drop
                                    NSMutableArray *arr_request = [DynamoDBManager getShiftWriteRequestByOriShiftuuid:uuid andMyShiftUuid:accpteShift.uuid andSwapWriteRequestBySwappUuid:passSwap.uuid];
                                    
                                    AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
                                    AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
                                    batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_request};
                                    batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
                                    [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
                                        if (task.error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                                NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                                [alert addAction:okAction];
                                                [self presentViewController:alert animated:YES completion:nil];
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
                                                
                                                AWSDynamoDBWriteRequest *writeRequest = [arr_request objectAtIndex:0];
                                                NSDictionary *dict = writeRequest.putRequest.item;
                                                AWSDynamoDBAttributeValue *modifyDate = [dict objectForKey:@"modifyDate"];
                                                
                                                NSString *ori_startDate = @"";
                                                NSString *ori_starttime = @"";
                                                NSString *ori_endtime = @"";
                                                NSString *ori_totalhours = @"";
                                                NSString *ori_unbreak = @"";
                                                NSString *ori_notes = @"";
                                                NSString *ori_str_year = @"";
                                                NSString *ori_str_month = @"";
                                                NSString *ori_str_day = @"";
                                                NSString *ori_str_week = @"";
                                                NSString *ori_time = @"";
                                                int16_t ori_isTake = 1;
                                                int16_t ori_takestate = 0;
        
                                                //原始shift，accpte shift  swap
                                                Shifts *oriShift = [DatabaseManager getShiftByUuid:uuid];
                                                ori_startDate = oriShift.startDate;
                                                ori_starttime = oriShift.startTime;
                                                ori_endtime = oriShift.endTime;
                                                ori_totalhours = oriShift.totalHours;
                                                ori_unbreak = oriShift.unpaidBreak;
                                                ori_notes = oriShift.notes;
                                                ori_str_year = oriShift.string_year;
                                                ori_str_month = oriShift.string_month;
                                                ori_str_day = oriShift.string_day;
                                                ori_str_week = oriShift.string_week;
                                                ori_time = oriShift.string_time;
                                                ori_isTake = oriShift.isTake;
                                                ori_takestate = oriShift.takeState;
                                                
                                                oriShift.modifyDate = modifyDate.S;
                                                oriShift.startDate = accpteShift.startDate;
                                                oriShift.startTime = accpteShift.startTime;
                                                oriShift.endTime = accpteShift.endTime;
                                                oriShift.totalHours = accpteShift.totalHours;
                                                oriShift.unpaidBreak = accpteShift.unpaidBreak;
                                                oriShift.notes = accpteShift.notes;
                                                oriShift.string_year = accpteShift.string_year;
                                                oriShift.string_month = accpteShift.string_month;
                                                oriShift.string_day = accpteShift.string_day;
                                                oriShift.string_week = accpteShift.string_week;
                                                oriShift.string_time = accpteShift.string_time;
                                                oriShift.isTake = 1;
                                                oriShift.takeState = accpteShift.takeState;
                                                [context save:nil];
                                                
                                                accpteShift.modifyDate = modifyDate.S;
                                                accpteShift.startDate = ori_startDate;
                                                accpteShift.startTime = ori_starttime;
                                                accpteShift.endTime = ori_endtime;
                                                accpteShift.totalHours = ori_totalhours;
                                                accpteShift.unpaidBreak = ori_unbreak;
                                                accpteShift.notes = ori_notes;
                                                accpteShift.string_year = ori_str_year;
                                                accpteShift.string_month = ori_str_month;
                                                accpteShift.string_day = ori_str_day;
                                                accpteShift.string_week = ori_str_week;
                                                accpteShift.string_time = ori_time;
                                                accpteShift.isTake = 1;
                                                accpteShift.takeState = ori_takestate;
                                                [context save:nil];
                                                
                                                passSwap.parentShiftUuid = 
                                                passSwap.swapShiftUuid1 = oriShift.uuid;
                                                passSwap.swapShiftUuid2 = accpteShift.uuid;
                                                passSwap.modifyDate = modifyDate.S;
                                                passSwap.state = @"1";
                                                passSwap.swap_acceptShiftUuid = accpteShift.uuid;
                                                [context save:nil];
                                                
                                                
                                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                                [self.navigationController popViewControllerAnimated:YES];
                                            });
                                        }
                                        return nil;
                                    }];
                                }
                                else if([passSwap.state isEqualToString:@"1"] && passSwap.isManagerAccepted == 1)
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been Accepted us to the others" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else if([passSwap.state isEqualToString:@"2"] && passSwap.isManagerAccepted == 1)
                                {
                                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been declined" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                                    [alertController addAction:okAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else
                            {
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted!" preferredStyle:UIAlertControllerStyleAlert];
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
}

-(void) declineSwap
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1 && passSwap.isManagerAccepted == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to cancel the request?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self cancelMyRequest];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self employeeDeclineSwap];
    }
}

-(void) employeeDeclineSwap
{
    
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passSwap.uuid rangeKey:passSwap.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                    passSwap.modifyDate = model.modifyDate;
                    passSwap.declineDropUuids = model.drop_delcineDropUuids;
                    passSwap.dropUuids = model.drop_dropUuids;
                    passSwap.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
                    passSwap.isDelete = [model.isDelete shortValue];
                    passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                    passSwap.state = model.drop_state;
                    [context save:nil];
                    
                    if (passSwap.isDelete == 0) {
                        if ([passSwap.state isEqualToString:@"0"] && passSwap.isManagerAccepted == 1) {
                            
                            [[dynamoDBObjectMapper load:[DDBDataModel class] hashKey:passSwap.uuid rangeKey:passSwap.parentUuid] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
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
                                            passSwap.modifyDate = model.modifyDate;
                                            passSwap.declineDropUuids = model.drop_delcineDropUuids;
                                            passSwap.dropUuids = model.drop_dropUuids;
                                            passSwap.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
                                            passSwap.isDelete = [model.isDelete shortValue];
                                            passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                                            passSwap.state = model.drop_state;
                                            passSwap.declineDropUuids = model.drop_delcineDropUuids;
                                            [context save:nil];
                                            
                                            DDBDataModel *model = [DynamoDBManager getSwapDataModelBySwapUuid:passSwap.uuid andOriShiftUuid:uuid];
                                            
                                            //employee decline request
                                            model.drop_dropUuids = passSwap.dropUuids;
                                            model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
                                            if (_textView.text != nil) {
                                                model.drop_messsage = _textView.text;
                                            }
                                            if (passSwap.swap_acceptShiftUuid != nil) {
                                                model.drop_swapAcceptedShiftUuid = passSwap.swap_acceptShiftUuid;
                                            }
                                            
                                            NSArray *arr_shiftuuid = [passSwap.dropUuids componentsSeparatedByString:@","];
                                            NSMutableArray *arr_declineshiftuuid = [NSMutableArray arrayWithArray:[passSwap.declineDropUuids componentsSeparatedByString:@"," ]];
                                            
                                            NSMutableArray *arr_myShiftuuid = [NSMutableArray array];
                                            
                                            for (NSString *suuid in arr_shiftuuid) {
                                                Shifts *shfit = [DatabaseManager getShiftByUuid:suuid];
                                                if ([shfit.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                                                    [arr_myShiftuuid addObject:suuid];
                                                }
                                            }
                                            
                                            for (NSString *suuid in arr_myShiftuuid) {
                                                [arr_declineshiftuuid addObject:suuid];
                                            }
                                            
                                            model.drop_delcineDropUuids = [arr_declineshiftuuid componentsJoinedByString:@","];
                                            
                                            NSMutableArray *arr1 = [NSMutableArray arrayWithArray:[model.drop_dropUuids componentsSeparatedByString:@","]];
                                            NSMutableArray *arr2 = [NSMutableArray arrayWithArray:[model.drop_delcineDropUuids componentsSeparatedByString:@","]];
                                            
                                            if (arr1.count == arr2.count) {
                                                model.drop_state = @"2";
                                            }
                                            else
                                            {
                                                if (passSwap.swap_acceptShiftUuid != nil) {
                                                    model.drop_state = @"1";
                                                    model.drop_swapAcceptedShiftUuid = passSwap.swap_acceptShiftUuid;
                                                }
                                                else
                                                {
                                                    model.drop_state = @"0";
                                                }
                                            }
                                            
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
                                                             
                                                             passSwap.modifyDate = model.modifyDate;
                                                             passSwap.state = model.drop_state;
                                                             passSwap.dropUuids = model.drop_dropUuids;
                                                             passSwap.declineDropUuids = model.drop_delcineDropUuids;
                                                             [context save:nil];
                                                             
                                                             
                                                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         });
                                                         
                                                     }
                                                 }
                                                 return nil;
                                             }];
                                            
                                        }
                                        else
                                        {
                                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                        }
                                    });
                                }
                                return nil;
                            }];
                        }
                        else if([passSwap.state isEqualToString:@"1"] && passSwap.isManagerAccepted == 1)
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been Accepted us to the others." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else if([passSwap.state isEqualToString:@"2"] && passSwap.isManagerAccepted == 1)
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been declined." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else if([passSwap.state isEqualToString:@"3"] && passSwap.isManagerAccepted == 1)
                        {
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Swap has already been canceled." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:okAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Drop has already been deleted!" preferredStyle:UIAlertControllerStyleAlert];
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

-(void) cancelMyRequest
{
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DDBDataModel *model = [DynamoDBManager getSwapDataModelBySwapUuid:passSwap.uuid andOriShiftUuid:uuid];
    
    model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
    model.drop_state = @"2";
    if (_textView.text != nil) {
        model.drop_messsage = _textView.text;
    }
    model.drop_dropUuids = passSwap.dropUuids;
    if (passSwap.declineDropUuids != nil) {
        model.drop_delcineDropUuids = passSwap.declineDropUuids;
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
                     
                     passSwap.modifyDate = model.modifyDate;
                     passSwap.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
                     passSwap.message = model.drop_messsage;
                     passSwap.state = model.drop_state;
                     
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
    
    if (arr_selectShiftsUuid.count == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must select one shift at least!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        DDBDataModel *model = [DynamoDBManager getSwapDataModelBySwapUuid:nil andOriShiftUuid:uuid];
        if (appdelegate.currentEmployee.isManager == 0) {
            model.drop_isManagerAccepted = [NSNumber numberWithInt:0];
        }
        else
        {
            model.drop_isManagerAccepted = [NSNumber numberWithInt:1];
        }
        if (_textView.text != nil) {
            model.drop_messsage = _textView.text;
        }
        model.drop_dropUuids = [arr_selectShiftsUuid componentsJoinedByString:@","];
        
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


- (IBAction)seeShiftDetail:(UIButton *)sender {
    ShiftDetailViewController_iphone *detail = [ShiftDetailViewController_iphone new];
    detail.uuid = uuid;
    detail.notEditShift = YES;
    if ([passSwap.state isEqualToString:@"1"]) {
        Shifts *oripositionshift = [DatabaseManager getShiftByUuid:passSwap.swapShiftUuid1];
        Positions *oriposition = [DatabaseManager getPositionByUuid:oripositionshift.positionUuid];
        detail.swapOriPositionuuid = oriposition.uuid;
        if (oriposition == nil) {
            detail.swapOriPositionuuid = @"111111";
        }
    }
    [self.navigationController pushViewController:detail animated:YES];
}
@end
