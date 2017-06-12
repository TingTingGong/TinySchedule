//
//  LocationDetailViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LocationDetailViewController_iphone.h"
#define rowHeight1 44
#define mapViewHeight 128
#define intervalHeight 10
#define rowHeight3 56

#define createLocation @"Create Location"

@interface LocationDetailViewController_iphone ()
{
    NSString *name;
    NSString *address;
    double selectLatitude;
    double selectLongitude;
    
    NSString *oriEmployees;
    NSString *employees;
    
    NSString *newLocationuuid;
}
@end

@implementation LocationDetailViewController_iphone
@synthesize uuid;
@synthesize isCreateLocation;
@synthesize isEmployeeSeeDetail;

-(void) getEmployees:(NSString *)myEmployees
{
    employees = myEmployees;
    [_tableView reloadData];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectLatitude = 0;
        selectLongitude = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (isEmployeeSeeDetail == YES) {
        _saveBtn.hidden = YES;
        _deleteBtn.hidden = YES;
    }
    if (appdelegate.currentEmployee.isManager == 1 && isCreateLocation == YES) {
        _saveBtn.hidden = NO;
        _deleteBtn.hidden = YES;
        _titleLabel.text = createLocation;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (isEmployeeSeeDetail == YES) {
        return NO;
    }
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([StringManager isEmpty:textField.text] && [string isEqualToString:@" "]) {
        return NO;
    }

    if (isEmployeeSeeDetail == YES) {
        return NO;
    }
    
    name = [_textField.text stringByAppendingString:string];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    Locations *location = [DatabaseManager getLocationByUuid:uuid];
    if (location != nil) {
        address = location.address;
    }
    
    _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, ScreenHeight-NavibarHeight-50);
    
    newLocationuuid = [StringManager getItemID];
    
    _deleteBtn.layer.borderWidth = 0.5;
    _deleteBtn.layer.borderColor = [SepearateLineColor CGColor];
    
    if (uuid == nil) {

        [_backBtn setImage:[UIImage imageNamed:@"back_dark"] forState:UIControlStateNormal];
    }
    else
    {
        Locations *location = [DatabaseManager getLocationByUuid:uuid];
        name = location.name;
        address = location.address;
        selectLatitude = location.latitude;
        selectLongitude = location.longitude;
        employees = location.employees;
        oriEmployees = location.employees;
        [_backBtn setImage:[UIImage imageNamed:@"back2_dark"] forState:UIControlStateNormal];
    }
    
    [_tableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    else
    {
        if (uuid == nil && [[employees componentsSeparatedByString:@","] count] == 0) {
            return 1;
        }
        else
        {
            NSArray *arr = [employees componentsSeparatedByString:@","];
            return arr.count+1;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return rowHeight1;
    }
    else if (indexPath.section == 1)
    {
        CGSize size = CGSizeMake(ScreenWidth-156, 44);
        if (address != nil) {
            size = [StringManager labelAutoCalculateRectWith:address FontSize:17.0 MaxSize:CGSizeMake(ScreenWidth-156, 80)];
        }
        return intervalHeight+size.height+intervalHeight+mapViewHeight+intervalHeight;
    }
    else
    {
        if (indexPath.row == 0) {
            return rowHeight1;
        }
        return rowHeight3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    if (indexPath.section == 0) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        imageview.image = [UIImage imageNamed:@"name"];
        [cell.contentView addSubview:imageview];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 85, 16)];
        [lab setAttributedText: SetAttributeText(@"NAME", TextColorAlpha_87, SemiboldFontName, 14.0)];
         [cell.contentView addSubview:lab];
         
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-116, 50)];
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = TextColorAlpha_54;
        _textField.text = name;
        [cell.contentView addSubview:_textField];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, 43, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    else if (indexPath.section == 1)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        imageview.image = [UIImage imageNamed:@"s_location_dark"];
        [cell.contentView addSubview:imageview];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 85, 16)];
        [lab setAttributedText: SetAttributeText(@"LOCATION", TextColorAlpha_87, SemiboldFontName, 14.0)];
         [cell.contentView addSubview:lab];
         
         CGSize size = CGSizeMake(ScreenWidth-156, 44);
         if (address != nil) {
             size = [StringManager labelAutoCalculateRectWith:address FontSize:17.0 MaxSize:CGSizeMake(ScreenWidth-156, 80)];
         }
        
         _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, intervalHeight, ScreenWidth-156, size.height)];
         _addressLabel.textAlignment = NSTextAlignmentRight;
         _addressLabel.textColor = SetColor(0, 0, 0, 0.54);
         _addressLabel.numberOfLines = 0;
         _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
         _addressLabel.text = address;
         
         [cell.contentView addSubview:_addressLabel];
        
        GMSMapView *mapView_ = [[GMSMapView alloc]initWithFrame:CGRectMake(16, intervalHeight+size.height+10, ScreenWidth-32, mapViewHeight)];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:selectLatitude longitude:selectLongitude zoom:15];
        mapView_ = [GMSMapView mapWithFrame:mapView_.frame camera:camera];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(selectLatitude, selectLatitude);
        marker.title = name;
        marker.snippet = address;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.flat = YES;
        marker.map = mapView_;
        
        [cell.contentView addSubview:mapView_];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, mapView_.frame.origin.y+mapViewHeight+9.5, ScreenWidth-16, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
    }
    else
    {
        if (indexPath.row == 0)
        {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
            imageview.image = [UIImage imageNamed:@"s_who_dark"];
            [cell.contentView addSubview:imageview];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 100, 16)];
            [lab setAttributedText: SetAttributeText(@"EMPLOYEES", TextColorAlpha_87, SemiboldFontName, 14.0)];
             [cell.contentView addSubview:lab];
             
             UIButton *btn_tag = [UIButton buttonWithType:UIButtonTypeCustom];
             btn_tag.frame = CGRectMake(ScreenWidth-180, 0, 175, rowHeight1);
             [btn_tag setImage:[UIImage imageNamed:@"addAvailable"] forState:UIControlStateNormal];
             [btn_tag setTitle:@"  Tag Employees" forState:UIControlStateNormal];
             [btn_tag setTitleColor:TextColorAlpha_54 forState:UIControlStateNormal];
             [cell.contentView addSubview:btn_tag];
             [btn_tag addTarget:self action:@selector(tagEmployee) forControlEvents:UIControlEventTouchUpInside];

             if (isEmployeeSeeDetail == YES) {
                 btn_tag.hidden = YES;
             }
             
             UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, rowHeight1-1, ScreenWidth, 0.5)];
             line.backgroundColor = SepearateLineColor;
             [cell.contentView addSubview:line];
        }
        else
        {
            if (uuid != nil || employees != nil) {
                
                UIButton *cellImageview = [UIButton buttonWithType:UIButtonTypeCustom];
                cellImageview.tag = indexPath.row;
                cellImageview.frame = CGRectMake(0, 0, 56, 56);
                [cellImageview setImage:[UIImage imageNamed:@"-_tag"] forState:UIControlStateNormal];
                [cellImageview addTarget:self action:@selector(subEmployee:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cellImageview];
                
                NSArray *arr = [employees componentsSeparatedByString:@","];
                Employees *employee = [DatabaseManager getEmployeeByUuid:[arr objectAtIndex:indexPath.row-1]];
                UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(50, 10, 36, 36)];
                ima.layer.masksToBounds = YES;
                ima.layer.cornerRadius = 18.0;
                [cell.contentView addSubview:ima];
                if (employee.headPortrait == nil) {
                    ima.image = [UIImage imageNamed:@"defaultEmpoyee"];
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ima.frame.size.width, ima.frame.size.height)];
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.textColor = [UIColor whiteColor];
                    lab.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:employee.fullName]];
                    [ima addSubview:lab];
                }
                else
                {
                    ima.image = [UIImage imageWithData:employee.headPortrait];
                }
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-110, rowHeight3)];
                lab.text = employee.fullName;
                lab.textColor = SetColor(0, 0, 0, 0.54);
                [cell.contentView addSubview:lab];
                
                if (isEmployeeSeeDetail == YES) {
                    cellImageview.hidden = YES;
                    ima.frame = CGRectMake(16, ima.frame.origin.y, ima.frame.size.width, ima.frame.size.height);
                    lab.frame = CGRectMake(68, lab.frame.origin.y, lab.frame.size.width, lab.frame.size.height);
                }
                
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(50, rowHeight3-1, ScreenWidth-50, 0.5)];
                line.backgroundColor = SepearateLineColor;
                [cell.contentView addSubview:line];
                
                if(indexPath.row == arr.count)
                {
                    line.frame = CGRectMake(0, rowHeight3-1, ScreenWidth, 0.5);
                }
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelgate.currentEmployee.isManager == 1) {
        if (indexPath.section == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        else if (indexPath.section == 1) {
            if(isCreateLocation == YES || isEmployeeSeeDetail == NO)
            {
                GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
                acController.delegate = self;
                [[UINavigationBar appearance] setBarTintColor:AppMainColor];
                [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                [self presentViewController:acController animated:YES completion:nil];
            }
        }
        else if (indexPath.section == 2)
        {
            if (indexPath.row == 0) {
                if(isCreateLocation == YES || isEmployeeSeeDetail == NO)
                {
                    [self tagEmployee];
                }
            }
            else
            {
                NSArray *arr = [employees componentsSeparatedByString:@","];
                Employees *employee = [DatabaseManager getEmployeeByUuid:[arr objectAtIndex:indexPath.row-1]];
                EditEmployeeViewController_iphone *edit = [[EditEmployeeViewController_iphone alloc] init];
                edit.employeeUuid = employee.uuid;
                [self.navigationController pushViewController:edit animated:YES];
            }
        }
    }
}

-(void) tagEmployee
{
    AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelgate.currentEmployee.isManager == 1) {
        TagEmployeeViewController_iphone *tag = [TagEmployeeViewController_iphone new];
        tag.employees = employees;
        tag.category = @"1";
        tag.delegate = self;
        [self.navigationController pushViewController:tag animated:YES];
    }
}

-(void) subEmployee:(UIButton *)sender
{
    AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelgate.currentEmployee.isManager == 1) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[employees componentsSeparatedByString:@","]];
        NSString *removeemployee = [arr objectAtIndex:sender.tag-1];
        [arr removeObject:removeemployee];
        if (arr.count == 0) {
            employees = nil;
        }
        else
        {
            employees = [arr componentsJoinedByString:@","];
        }
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    
    CLLocationCoordinate2D mycoordinate = place.coordinate;
    
    address = place.formattedAddress;
    selectLatitude = mycoordinate.latitude;
    selectLongitude = mycoordinate.longitude;
    [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", (long)(long)[error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    name = textField.text;
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    name = textField.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textField resignFirstResponder];
}


- (IBAction)back:(UIButton *)sender {
    if (uuid == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)save:(UIButton *)sender {
    
    [_textField resignFirstResponder];
    
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([name length] == 0 || name == nil || [address length] == 0 || address == nil) {
        
        NSString *message = @"";
        
        if([name length] == 0 || name == nil)
        {
            message = [NSString stringWithFormat:@"'Name' looks empty!"];
        }
        else if ([address length] == 0 || address == nil)
        {
            message = [NSString stringWithFormat:@"'Address' looks empty!"];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        NSString *urlstring = [NSString stringWithFormat:@"%@",api_location];
        NSString *requesttype = @"";
        NSDictionary *params = nil;
        
        if (uuid == nil) {
            requesttype = requestType_POST;
            params = @{@"name":name,@"address":address,@"latutide":[NSString stringWithFormat:@"%lf",selectLatitude],@"longitude":[NSString stringWithFormat:@"%lf",selectLongitude],@"workplaceId":appdelegate.currentWorkplace.uuid};
        }
        else
        {
            requesttype = requestType_PUT;
            urlstring = [NSString stringWithFormat:@"%@/%@",api_location,uuid];
            params = @{@"name":name,@"address":address,@"latutide":[NSString stringWithFormat:@"%lf",selectLatitude],@"longitude":[NSString stringWithFormat:@"%lf",selectLongitude]};
        }
        
        [HttpRequestManager requestWithType:requesttype withUrlString:urlstring withParaments:params withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
            
            if (response.statusCode == 200) {
                
                if (uuid == nil) {
                    Locations *location = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:context];
                    location.uuid = [dict objectForKey:@"id"];
                    location.name = name;
                    location.address = address;
                    location.latitude = selectLatitude;
                    location.longitude = selectLongitude;
                    //location.employees = model.location_employees;
                    
                    [context save:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    Locations *location = [DatabaseManager getLocationByUuid:uuid];
                    location.name = name;
                    location.address = address;
                    location.latitude = selectLatitude;
                    location.longitude = selectLongitude;
                    //location.employees = model.location_employees;
                    
                    [context save:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
        } withFailureBlock:^(NSError *error){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
}

- (IBAction)deleteLocation:(UIButton *)sender {
    
    Locations *location = [DatabaseManager getLocationByUuid:uuid];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@",api_location,location.uuid];
    
    [HttpRequestManager requestWithType:requestType_DELETE withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        
        if (response.statusCode == 200) {
            
            [context deleteObject:location];
            [context save:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withFailureBlock:^(NSError *error){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
//
//    NSDictionary *dict_shift = [DatabaseManager getShiftsByLocationUuid:uuid];
//    if([dict_shift allKeys].count == 0)
//    {
//        NSString *message = [NSString stringWithFormat:@"Delete “%@”?",location.name];
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//        alertController.view.tintColor = AppMainColor;
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Location" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
//            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            
//            AppDelegate *appdelgate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if (appdelgate.currentEmployee.isManager == 1) {
//                
//                NSManagedObjectContext *context = [appDelegate managedObjectContext];
//                
//                [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
//                
//                DDBDataModel *model = [[DDBDataModel alloc]init];
//                model.createDate = location.createDate;
//                model.modifyDate = location.modifyDate;;
//                model.uuid = location.uuid;
//                model.managerUuid = location.managerUuid;
//                model.parentUuid = location.parentUuid;
//                model.tableIdentityID = @"Locations";
//                model.isDelete = [NSNumber numberWithInt:1];
//                model.location_name = location.name;
//                if (location.address != nil || ![location.address isEqualToString:@""]) {
//                    model.location_addr = location.address;
//                }
//                model.location_latitude = location.latitude;
//                model.location_longitude = location.longitude;
//                if (location.employees != nil) {
//                    model.location_employees = location.employees;
//                }
//                
//                AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//                [[dynamoDBObjectMapper save:model]
//                 continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task) {
//                     if (task.error) {
//                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
//                         NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
//                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
//                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//                         [alertController addAction:cancelAction];
//                         [self presentViewController:alertController animated:YES completion:nil];
//                     }
//                     else {
//                         if ([model isKindOfClass:[DDBDataModel class]]) {
//                             
//                             dispatch_async(dispatch_get_main_queue(), ^{
//                                 
//                                 location.isDelete = 1;
//                                 
//                                 [context save:nil];
//                                 [KLoadingView hideKLoadingViewForView:self.view animated:YES];
//                                 [self.navigationController popViewControllerAnimated:YES];
//                             });
//                         }
//                     }
//                     return nil;
//                 }];
//            }
//            
//        }];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Because this location is irreversible and can cause data loss,please first remove all shifts from this location." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
}

@end
