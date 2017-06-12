//
//  RequestViewController_phone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "RequestViewController_phone.h"

@interface RequestViewController_phone ()
{
    NSDictionary *dict_request;
    BOOL isOpen;
    
    UIRefreshControl *refreshControl;
    
    NSArray *arrRequest1;
    NSArray *arrRequest2;
    NSArray *arrRequest3;
}
@end

@implementation RequestViewController_phone

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        isOpen = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self initData_request];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setbeginRefreshing];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createRequest:(UIButton *)sender {
    
    CreateRequestViewController_iphone *request = [CreateRequestViewController_iphone new];
    [self presentViewController:request animated:YES completion:nil];
}

-(void)initData_request
{
    dict_request = nil;
    arrRequest1 = nil;
    arrRequest2 = nil;
    arrRequest3 = nil;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        dict_request = [DatabaseManager getAllRequests];
    }
    else
    {
        dict_request = [DatabaseManager getAllMyRequests];
    }

    if ([dict_request objectForKey:@"0"] != nil) {
        
        arrRequest1 = [DatabaseManager sortedRequestByDisposeDate:[NSMutableArray arrayWithArray:[dict_request objectForKey:@"0"]]];
    }
    if ([dict_request objectForKey:@"1"] != nil) {
        
        arrRequest2 = [DatabaseManager sortedRequestByDisposeDate:[NSMutableArray arrayWithArray:[dict_request objectForKey:@"1"]]];
    }
    if ([dict_request objectForKey:@"2"] != nil) {
        
        arrRequest3 = [DatabaseManager sortedRequestByDisposeDate:[dict_request objectForKey:@"2"]];
    }
    
    for (id obj in arrRequest3) {
        if ([obj isKindOfClass:[Requests class]]) {
            
            Requests *request = obj;
            NSLog(@"%@",request.disposeDate);
        }
        else
        {
            Drop *drop = obj;
            NSLog(@"%@",drop.modifyDate);
        }
    }

    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 0;
}

//-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
//    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 200, 16)];
//    headerLabel.textColor = AppMainColor;
//    headerLabel.text = @"Load Pass Requests...";
//    headerLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [view addSubview:headerLabel];
//    
//    return view;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {

        if (arrRequest1.count > 3)
        {
            if (isOpen == NO) {
                return 4;
            }
            return arrRequest1.count+1;
        }
        return arrRequest1.count;
    }
    else if (section == 1)
    {
        return arrRequest2.count;
    }
    else
    {
        return arrRequest3.count;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (arrRequest1.count > 3)
        {
            if (isOpen == NO) {
                if (indexPath.row == 3) {
                    return 32;
                }
                return 60;
            }
            else
            {
                if (indexPath.row == arrRequest1.count) {
                    return 32;
                }
                return 60;
            }
        }
        else
        {
            return 60;
        }
    }
    return 60;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
    view.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 17, 200, 16)];
    headerLabel.textColor = SetColor(21, 27, 43, 0.5);
    headerLabel.font = [UIFont fontWithName:SemiboldFontName size:12.0];
    
    UILabel *numlabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width-50, 17, 40, 16)];
    numlabel.textAlignment = NSTextAlignmentRight;
    numlabel.textColor = TextColorAlpha_54;
    numlabel.font = [UIFont fontWithName:SemiboldFontName size:14.0];
    
    if (section == 0) {
        headerLabel.text = @"Needing Your Action";
        numlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)arrRequest1.count];
    }
    else if (section == 1)
    {
        headerLabel.text = @"Awaiting Action From Others";
        numlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)arrRequest2.count];
    }
    else
    {
        headerLabel.text = @"Other Requests";
        numlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)arrRequest3.count];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, _tableView.frame.size.width, 0.5)];
    line.backgroundColor = SetColor(0, 0, 0, 0.1);
    
    [view addSubview:headerLabel];
    [view addSubview:numlabel];
    [view addSubview:line];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identity = @"requestcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 200, 20)];
    textlabel.font = [UIFont fontWithName:SemiboldFontName size:17.0];
    textlabel.textColor = TextColorAlpha_87;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 34, ScreenWidth-(10+16)-60, 16)];
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.textColor = TextColorAlpha_54;
    
    [cell.contentView addSubview:textlabel];
    [cell.contentView addSubview:detailLabel];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width-59, 10, 49, 18)];
    typeLabel.font = [UIFont systemFontOfSize:12.0];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.backgroundColor = SetColor(0, 121, 255, 1.0);
    typeLabel.layer.masksToBounds = YES;
    typeLabel.layer.cornerRadius = 4.0;
    [cell.contentView addSubview:typeLabel];
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.frame.size.width-100, 32, 90, 20)];
    stateLabel.text = @"Pending";
    stateLabel.textColor = TextColorAlpha_54;
    stateLabel.font = [UIFont systemFontOfSize:12.0];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:stateLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 59.5, _tableView.frame.size.width-16, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [cell.contentView addSubview:line];
    
    if (indexPath.section == 0 && arrRequest1.count > 3 && ((isOpen == YES && indexPath.row == arrRequest1.count) || (isOpen == NO && indexPath.row == 3))) {
        
        typeLabel.backgroundColor = [UIColor clearColor];
        stateLabel.text = @"";
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectBtn.frame = CGRectMake(0, 0, ScreenWidth-20, 32);
        if (isOpen == NO) {
            [selectBtn setTitle:@"See All" forState:UIControlStateNormal];
        }
        else
        {
            [selectBtn setTitle:@"Pack up" forState:UIControlStateNormal];
        }
        selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [selectBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:selectBtn];
        [selectBtn addTarget:self action:@selector(showAllData:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        Requests *request = nil;
        Drop *drop = nil;
        if (indexPath.section == 0) {
            
            if ([[arrRequest1 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest1 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest1 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest1 objectAtIndex:indexPath.row];
            }
        }
        else if (indexPath.section == 1) {
            
            if ([[arrRequest2 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest2 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest2 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest2 objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if ([[arrRequest3 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest3 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest3 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest3 objectAtIndex:indexPath.row];
            }
        }
        if (request != nil) {
            
            Employees *employee = [DatabaseManager getEmployeeByUuid:request.employeeUuid];
            textlabel.text = employee.fullName;
            NSDictionary *dict = [StringManager getYearMonthDay:request.stamp_startDate];
            NSDictionary *dict2 = [StringManager getYearMonthDay:request.stamp_endDate];
            if (request.string_startTime == nil) {
                
                detailLabel.text = [NSString stringWithFormat:@"%@ %lu, %@ - %@ %lu, %@",[StringManager getEnglishMonth:[[dict objectForKey:@"month"] longValue]],[[dict objectForKey:@"day"] longValue],[dict objectForKey:@"year"],[StringManager getEnglishMonth:[[dict2 objectForKey:@"month"] longValue]],[[dict2 objectForKey:@"day"] longValue],[dict2 objectForKey:@"year"]];
            }
            else
            {
                detailLabel.text = [NSString stringWithFormat:@"%@ %@, %@ - %@",[StringManager getEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"],request.string_startTime,request.string_endTime];
            }
            
            
            if ([request.type isEqualToString:@"0"]) {
                typeLabel.text = @"Unpaid";
            }
            else if ([request.type isEqualToString:@"1"])
            {
                typeLabel.frame = CGRectMake(_tableView.frame.size.width-44, typeLabel.frame.origin.y, 34, 20);
                typeLabel.text = @"PTO";
            }
            else if ([request.type isEqualToString:@"2"])
            {
                typeLabel.frame = CGRectMake(_tableView.frame.size.width-43, typeLabel.frame.origin.y, 33, 20);
                typeLabel.backgroundColor = SetColor(222, 29, 177, 1.0);
                typeLabel.text = @"Sick";
            }
            else
            {
                typeLabel.frame = CGRectMake(_tableView.frame.size.width-63, typeLabel.frame.origin.y, 53, 20);
                typeLabel.text = @"Holiday";
            }
            if ([request.waitType isEqualToString:@"1"]) {
                stateLabel.text = @"Accepted";
                stateLabel.textColor = SetColor(0, 195, 0, 1.0);
            }
            else if ([request.waitType isEqualToString:@"2"])
            {
                stateLabel.text = @"Canceled";
                stateLabel.textColor = SetColor(250, 67, 63, 1.0);
            }
            else if ([request.waitType isEqualToString:@"3"])
            {
                stateLabel.text = @"Canceled";
                stateLabel.textColor = SetColor(250, 67, 63, 1.0);
            }
        }
        else if (drop != nil)
        {
            Employees *employee = [DatabaseManager getEmployeeByUuid:drop.oriShiftEmployeeUuid];
            Shifts *shift = [DatabaseManager getShiftByUuid:drop.parentShiftUuid];
            textlabel.text = employee.fullName;
            detailLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@",shift.string_week,shift.string_month,shift.string_day,shift.string_time];
            
            typeLabel.backgroundColor = SetColor(255, 184, 18, 1.0);
            typeLabel.frame = CGRectMake(_tableView.frame.size.width-51, typeLabel.frame.origin.y, 41, 18);
            if (drop.isDrop == 0) {
                typeLabel.text = @"Drop";
            }
            else
            {
                typeLabel.text = @"Swap";
                if (drop.swap_acceptShiftUuid != nil && drop.swapShiftUuid2 != nil) {
                    Shifts *shift2 = [DatabaseManager getShiftByUuid:drop.swapShiftUuid2];
                    detailLabel.text = [NSString stringWithFormat:@"%@, %@ %@, %@",shift2.string_week,shift2.string_month,shift2.string_day,shift2.string_time];
                }
            }
            if ([drop.state isEqualToString:@"1"]) {
                stateLabel.text = @"Accepted";
                stateLabel.textColor = SetColor(0, 195, 0, 1.0);
            }
            else if ([drop.state isEqualToString:@"2"] || [drop.state isEqualToString:@"3"])
            {
                stateLabel.text = @"Canceled";
                stateLabel.textColor = SetColor(250, 67, 63, 1.0);
            }
        }
    }

    return cell;
}

-(void) showAllData:(UIButton *)sender
{
    if (isOpen == YES) {
        isOpen = NO;
        [sender setTitle:@"Sell All" forState:UIControlStateNormal];
    }
    else
    {
        isOpen = YES;
        [sender setTitle:@"Pack Up" forState:UIControlStateNormal];
    }
    [self initData_request];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && arrRequest1.count > 3 && ((isOpen == YES && indexPath.row == arrRequest1.count) || (isOpen == NO && indexPath.row == 3))) {
    }
    else
    {
        Requests *request = nil;
        Drop *drop = nil;
        if (indexPath.section == 0) {
            
            if ([[arrRequest1 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest1 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest1 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest1 objectAtIndex:indexPath.row];
            }
        }
        else if (indexPath.section == 1) {
            
            if ([[arrRequest2 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest2 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest2 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest2 objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if ([[arrRequest3 objectAtIndex:indexPath.row] isKindOfClass:[Requests class]]) {
                request = [arrRequest3 objectAtIndex:indexPath.row];
            }
            else if ([[arrRequest3 objectAtIndex:indexPath.row] isKindOfClass:[Drop class]])
            {
                drop = [arrRequest3 objectAtIndex:indexPath.row];
            }
        }
        
        if (request != nil) {
            RequestDetailViewController_iphone *detail = [RequestDetailViewController_iphone new];
            detail.uuid = request.uuid;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if (drop != nil)
        {
            if (drop.isDrop == 0) {
                DropViewController_iphone *dv = [DropViewController_iphone new];
                dv.category = @"0";
                dv.uuid = drop.parentShiftUuid;
                dv.dropuuid = drop.uuid;
                dv.isShowShiftDetail = YES;
                [self.navigationController pushViewController:dv animated:YES];
            }
            else
            {
                SwapViewController_iphone *sv = [SwapViewController_iphone new];
                sv.uuid = drop.parentShiftUuid;
                sv.swapuuid = drop.uuid;
                sv.isShowShiftDetail = YES;
                [self.navigationController pushViewController:sv animated:YES];
            }
        }
    }
}

-(void) seeAllRequest
{
    if (isOpen == YES) {
        isOpen = NO;
    }
    else
    {
        isOpen = YES;
    }
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setbeginRefreshing
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
    
}
-(void) refreshView:(UIRefreshControl *)refresh
{
    if (refreshControl.refreshing) {
        [self performSelector:@selector(refreshTableView:) withObject:refresh afterDelay:0];
    }
}
-(void)refreshTableView:(UIRefreshControl *)refresh{
    
    __block BOOL isTake = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    //同步数据表
    queryExpression.scanIndexForward = 0;
    queryExpression.indexName = @"CurrentWorkPlaceAllData-Index";
    queryExpression.keyConditionExpression = [NSString stringWithFormat:@"parentUuid = :PUUID"];
    queryExpression.expressionAttributeValues = @{@":PUUID" : appDelegate.currentWorkplace.uuid};
    [[dynamoDBObjectMapper query:[DDBDataModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [refresh endRefreshing];
            });
        }
        else
        {
            AWSDynamoDBPaginatedOutput *output = task.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *arr = output.items;
                
                isTake = [DynamoDBManager dynamodbDataSaveToLocal:arr];
                
                [self initData_request];
                [refresh endRefreshing];
                if (isTake == NO) {
                    KnowledgeShiftViewController_iphone *know = [KnowledgeShiftViewController_iphone new];
                    [self presentViewController:know animated:YES completion:nil];
                }
            });
        }
        return nil;
    }];
}


@end
