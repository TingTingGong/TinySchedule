//
//  CreateWorkplaceViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "CreateWorkplaceViewController_iphone.h"

#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

@interface CreateWorkplaceViewController_iphone ()
{
    NSArray *arr_title;
    
    UITextField *nameField;
    UILabel *typeLabel;
    UILabel *addressLabel;
    
    GMSMapView *mapView_;
    
    UIPickerView *typePicker;
    NSArray *arr_type;
    
    NSString *name;
    NSString *address;
    NSString *type;
    
    double selectLatitude;
    double selectLongitude;
    
    NSString *myuuid;
    NSString *myLocationuuid;
    NSString *mysettinguuid;
}
@end

@implementation CreateWorkplaceViewController_iphone

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        name = @"";
        address = @"";
        type = @"";
        selectLatitude = -33.86;
        selectLongitude = 151.20;
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    typePicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, 20, 200, 44)];
    [_titleLabel setAttributedText:SetAttributeText(@"Create Workplace", SetColor(0, 0, 0, 0.87), SemiboldFontName, 17.0)];
     _titleLabel.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:_titleLabel];
     
     _saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     _saveBtn.frame = CGRectMake(ScreenWidth-65, 20, 56, 44);
     [_saveBtn setTitle:@"Save" forState:UIControlStateNormal];
     [_saveBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
     [_saveBtn.titleLabel setAttributedText:SetAttributeText(@"Save", AppMainColor, SemiboldFontName, 17.0)];
      [self.view addSubview:_saveBtn];
      [_saveBtn addTarget:self action:@selector(saveWorkplace) forControlEvents:UIControlEventTouchUpInside];

    
    myuuid = [StringManager getItemID];
    myLocationuuid = [StringManager getItemID];
    mysettinguuid = [StringManager getItemID];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"name",@"imageName",@"NAME",@"title", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"type_dark",@"imageName",@"TYPE",@"title", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"s_location_dark",@"imageName",@"ADDRESS",@"title", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"imageName", nil];
    arr_title = [NSArray arrayWithObjects:dict1,dict2,dict3,dict4, nil];
    
    arr_type = [NSArray arrayWithObjects:WorkPlaceType_1,WorkPlaceType_2,WorkPlaceType_3,WorkPlaceType_4,WorkPlaceType_5,WorkPlaceType_6,WorkPlaceType_7, nil];
    [self initTypePicker];
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_title.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 82;
    }
    else if (indexPath.row == 3)
    {
        return 139;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row != 3) {
        
        NSDictionary *dict = [arr_title objectAtIndex:indexPath.row];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        imageview.image = [UIImage imageNamed:[dict objectForKey:@"imageName"]];
        [cell.contentView addSubview:imageview];
        UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 100, 16)];
        if([dict objectForKey:@"title"] != nil)
        {
            [lab_title setAttributedText:SetAttributeText([dict objectForKey:@"title"], SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
        }
        
        [cell.contentView addSubview:lab_title];
        
        if (indexPath.row == 0) {
            
            nameField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-116, 44)];
            nameField.delegate = self;
            [nameField becomeFirstResponder];
            nameField.tintColor = AppMainColor;
            nameField.textColor = SetColor(0, 0, 0, 0.54);
            nameField.placeholder = @"Numbers,letters,or underscores";
            nameField.textAlignment = NSTextAlignmentRight;
            nameField.returnKeyType = UIReturnKeyDone;
            nameField.text = name;
            nameField.font = [UIFont systemFontOfSize:15.0];
            [cell.contentView addSubview:nameField];
        }
        else if (indexPath.row == 1)
        {
            typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-116, 44)];
            typeLabel.textAlignment = NSTextAlignmentRight;
            if(type != nil)
            {
                [typeLabel setAttributedText:SetAttributeText(type, SetColor(0, 0, 0, 0.54), RegularFontName, 14.0)];
            }
             typeLabel.textColor = SetColor(0, 0, 0, 0.54);
            typeLabel.font = [UIFont systemFontOfSize:15.0];
            [cell.contentView addSubview:typeLabel];
        }
        else
        {
            addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 10, ScreenWidth-156, 72)];
            addressLabel.textAlignment = NSTextAlignmentRight;
            addressLabel.textColor = SetColor(0, 0, 0, 0.54);
            addressLabel.numberOfLines = 0;
            addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
            addressLabel.text = address;
            addressLabel.font = [UIFont systemFontOfSize:15.0];
            
            CGSize size =CGSizeMake(ScreenWidth-156,72);
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0],NSFontAttributeName,nil];
            CGSize  actualsize =[address boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
            addressLabel.frame =CGRectMake(140,10, ScreenWidth-156, actualsize.height);
            
            [cell.contentView addSubview:addressLabel];
        }
         if(indexPath.row == 0 || indexPath.row == 1)
         {
             UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(16, 43.5, ScreenWidth-16, 0.5)];
             line.backgroundColor = SetColor(0, 0, 0, 0.1);
             [cell.contentView addSubview:line];
         }
    }
    else
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:selectLatitude longitude:selectLongitude zoom:15];
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(15, 0, ScreenWidth-30, 129) camera:camera];
        mapView_.myLocationEnabled = YES;
        [cell.contentView addSubview:mapView_];
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(selectLatitude, selectLatitude);
        marker.title = name;
        marker.snippet = address;
        marker.map = mapView_;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 138.5, ScreenWidth, 0.5)];
        line.backgroundColor = SetColor(0, 0, 0, 0.1);
        [cell.contentView addSubview:line];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        [nameField resignFirstResponder];
        
        [UIView animateWithDuration:AnimatedDuration animations:^{
            typePicker.frame = CGRectMake(0, ScreenHeight-200, ScreenWidth, 200);
        } completion:^(BOOL finished){
        }];
    }
    else if (indexPath.row == 2)
    {
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        [[UINavigationBar appearance] setBarTintColor:AppMainColor];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [self presentViewController:acController animated:YES completion:nil];
    }
}

-(void)initTypePicker
{
    typePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200)];
    typePicker.delegate = self;
    typePicker.dataSource = self;
    [typePicker selectedRowInComponent:0];
    [self.view addSubview:typePicker];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arr_type.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [arr_type objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [UIView animateWithDuration:AnimatedDuration animations:^{
        typeLabel.text = [arr_type objectAtIndex:row];
        type = [arr_type objectAtIndex:row];
        typePicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    } completion:^(BOOL finished){
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    CLLocationCoordinate2D mycoordinate = place.coordinate;
    
    address = place.formattedAddress;
    selectLatitude = mycoordinate.latitude;
    selectLongitude = mycoordinate.longitude;
    [_tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", (long)[error code]);
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
    if([StringManager includeChinese:textField.text] == YES || [textField.text containsString:@" "])
    {
        textField.text = @"";
    }
    else
    {
        name = textField.text;
        textField.textColor = [UIColor blackColor];
        textField.alpha = 0.54;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [nameField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)saveWorkplace {
    
    NSString *str = [nameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([nameField.text isEqualToString:@""] || [nameField.text length] == 0 || [StringManager isEmpty:nameField.text] == YES || [str length] == 0) {
        [nameField shake];
    }
    else if ([typeLabel.text isEqualToString:@""] || typeLabel.text == nil || [addressLabel.text isEqualToString:@""] || [addressLabel.text length] == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Make sure you have filled out all the blanks." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [nameField resignFirstResponder];
        [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
        
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSInteger typeindex = [arr_type indexOfObject:type];
        NSNumber *typenumber = [NSNumber numberWithInteger:typeindex+1];
        NSString *latitudestring = [NSString stringWithFormat:@"%lf",selectLatitude];
        NSString *longitudestring = [NSString stringWithFormat:@"%lf",selectLongitude];
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        [HttpRequestManager requestWithType:requestType_POST withUrlString:api_workplace withParaments:@{@"EmployeeId":appdelegate.currentEmployee.uuid,@"name":name,@"type":typenumber,@"address":address,@"latitude":latitudestring,@"longitude":longitudestring} withSuccessBlock:^(NSData *data, NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];

            if (response.statusCode == 200) {
                
                //会返回id，以后要把id也保存,还会返回isManager,isPermitted，更新currentEmployee着两个字段
                CurrentWorkPlace *addPlace = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentWorkPlace" inManagedObjectContext:context];
                addPlace.uuid = [dict objectForKey:@"id"];
                addPlace.name = name;
                addPlace.address = address;
                addPlace.type = typeindex;
                addPlace.latitude = latitudestring;
                addPlace.longitude = longitudestring;
                addPlace.isCreator = 1;
                addPlace.isPermitted = 1;
                
                appdelegate.currentWorkplace = addPlace;
                
                WorkPlaces *workplace = [NSEntityDescription insertNewObjectForEntityForName:@"WorkPlaces" inManagedObjectContext:context];
                workplace.uuid = addPlace.uuid;
                workplace.name = addPlace.name;
                workplace.address = addPlace.address;
                workplace.type = addPlace.type;
                workplace.latitude = addPlace.latitude;
                workplace.longitude = addPlace.longitude;
                workplace.isCreator = 1;
                workplace.isPermitted = 1;
                
                [context save:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSidebarMenu object:self userInfo:nil];
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
            else
            {
                
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
                 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string lowercaseString]];
        return NO;
    }
    
    if (!([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1) && ![string isEqualToString:@""]){
        return NO;
    }

    return YES;
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
