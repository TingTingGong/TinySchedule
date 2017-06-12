//
//  EditEmployeeViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/28.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "EditEmployeeViewController_iphone.h"

#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_CHARECTERS2 @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define EditString @"Edit"
#define SaveString @"Save"

@interface EditEmployeeViewController_iphone ()
{
    UITextField *field1;
    UITextField *field2;
    UITextField *field3;
    UITextField *field4;
    
    UILabel *line_y;
    
    NSMutableArray *arr_locationUuid;
    NSMutableArray *arr_positionUuid;
    NSArray *arr_oriPostionUuid;
    NSArray *arr_oriLocationUuid;
    NSString *modifyEmployee_name1;
    NSString *modifyEmployee_name2;
    NSString *modifyEmployee_phone;
    NSString *modifyEmployee_email;
    NSData *modifyEmployeeImageData;
    NSData *employeeImageData;
    
    BOOL notrefreshLocationUuid;
    
    RMPhoneFormat *phoneFormat;
    NSMutableCharacterSet *phoneChars;
    
    BOOL isManager;
    BOOL isEdit;

}
@end

@implementation EditEmployeeViewController_iphone

@synthesize employeeUuid;
@synthesize defaultLocationuuid;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isEdit = NO;
    }
    return self;
}

-(void) getTagPositionUuid:(NSMutableArray *) arr_position_uuid
{
    notrefreshLocationUuid = YES;
    arr_positionUuid = nil;
    arr_positionUuid = [NSMutableArray arrayWithArray:arr_position_uuid];
    [_tableView reloadData];
}

-(void) getlocationUuid:(NSMutableArray *) arr_location_uuid
{
    notrefreshLocationUuid = YES;
    arr_locationUuid = nil;
    arr_locationUuid = [NSMutableArray arrayWithArray:arr_location_uuid];
    [_tableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];

    //从profile界面进入该页面，需要获取employee在当前数据的location和position,从其他页面进入该页面，就不需要，其他页面会传入对应的数组过来
    if (notrefreshLocationUuid == NO && employeeUuid != nil) {
        arr_locationUuid = [DatabaseManager getEmployeeLocationUuids:employeeUuid];
        arr_positionUuid = [DatabaseManager getEmployeePositionUuids:employeeUuid];
        arr_oriLocationUuid = [NSMutableArray arrayWithArray:arr_locationUuid];
        arr_oriPostionUuid = [NSMutableArray arrayWithArray:arr_positionUuid];
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.allowsSelection = YES;
    
    isEdit = NO;
    
    if (line_y == nil) {
        line_y = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 1, 1, 49)];
        line_y.backgroundColor = SepearateLineColor;
        [_bottomView addSubview:line_y];
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        isManager = YES;
    }
    else
    {
        isManager = NO;
    }
    
    if (isManager == NO) {
        if (![appdelegate.currentEmployee.uuid isEqualToString:employeeUuid]) {
            _saveBtn.hidden = YES;
        }
        _bottomView.hidden = YES;
        _tableView.frame = CGRectMake(0, NavibarHeight, _tableView.frame.size.width, ScreenHeight-NavibarHeight);
    }
    else
    {
        [_saveBtn setTitle:EditString forState:UIControlStateNormal];
        _deleteBtn.hidden = YES;
    }
    

    phoneFormat = [[RMPhoneFormat alloc] init];
    phoneChars = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [phoneChars addCharactersInString:@"+*#,"];
    
    if (notrefreshLocationUuid == NO) {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
        if (appdelegate.currentEmployee.isManager == 0) {
            self.bottomView.hidden = YES;
        }
        else
        {
            self.bottomView.hidden = NO;
        }
        NSRange range = [employee.fullName rangeOfString:@" "];
        NSString *s1 = [employee.fullName substringWithRange:NSMakeRange(0, range.location)];
        NSString *s2 = [employee.fullName substringFromIndex:range.location+1];
        modifyEmployee_name1 = [NSString stringWithFormat:@"%@",s1];
        modifyEmployee_name2 = [NSString stringWithFormat:@"%@",s2];
        
        modifyEmployee_email = employee.email;
        modifyEmployee_phone = employee.phone;
        if (employee.headPortrait == nil) {
            modifyEmployeeImageData = nil;
        }
        else
        {
            modifyEmployeeImageData = employee.headPortrait;
        }
    }
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 120;
    }
    else if (indexPath.section == 1)
    {
        if (arr_positionUuid.count != 0) {
            if (isEdit == NO || isManager == 0) {
                return arr_positionUuid.count * 44;
            }
            return (arr_positionUuid.count+1) * 44;
        }
    }
    else if (indexPath.section == 2)
    {
        if (arr_locationUuid.count != 0) {
            if (isEdit == NO || isManager == 0) {
                return arr_locationUuid.count * 44;
            }
            return (arr_locationUuid.count+1) * 44;
        }
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

    Employees *editEmployee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 88, 88)];
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 44;
            imageview.userInteractionEnabled = YES;
            [cell.contentView addSubview:imageview];
            
            if (modifyEmployeeImageData != nil) {
                imageview.image = [UIImage imageWithData:modifyEmployeeImageData];
            }
            else
            {
                imageview.image = [UIImage imageNamed:@"defaultEmpoyee2"];
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = [UIColor whiteColor];
                lab.text = [NSString stringWithFormat:@"%@",[StringManager getManyFirstLetterFromString:editEmployee.fullName]];
                lab.font = [UIFont fontWithName:SemiboldFontName size:36.0];
                [imageview addSubview:lab];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadPortrait:)];
            [imageview addGestureRecognizer:tap];
            
            field1 = [[UITextField alloc]initWithFrame:CGRectMake(120, 16, ScreenWidth - 136, 44)];
            field1.delegate = self;
            field1.placeholder = @"First Name";
            field1.text = modifyEmployee_name1;
            
            field1.textAlignment = NSTextAlignmentRight;
            field1.textColor = TextColorAlpha_54;
            field1.font = [UIFont fontWithName:RegularFontName size:17.0];
            [field1 setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [cell.contentView addSubview:field1];
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(120, 16+44, ScreenWidth - 120, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];

            field2 = [[UITextField alloc]initWithFrame:CGRectMake(120, 16+44+1, ScreenWidth - 136, 48)];
            field2.delegate = self;
            field2.placeholder = @"Last Name";
            field2.text = modifyEmployee_name2;
            field2.textColor = TextColorAlpha_54;
            field2.textAlignment = NSTextAlignmentRight;
            field2.font = [UIFont fontWithName:RegularFontName size:17.0];
            [field2 setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [cell.contentView addSubview:field2];
            
            UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(120, 16+44+1+44, ScreenWidth - 120, 0.5)];
            line2.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line2];
        }
        else if (indexPath.row == 1)
        {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, (44-24)/2, 24, 24)];
            imageview.image = [UIImage imageNamed:@"p_phone"];
            [cell.contentView addSubview:imageview];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
            [lab setAttributedText:SetAttributeText(@"PHONE", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
            [cell.contentView addSubview:lab];
            
            field3 = [[UITextField alloc]initWithFrame:CGRectMake(120, 12, ScreenWidth - 136, 20)];
            field3.delegate = self;
            field3.placeholder = @"Phone Number";
            field3.text = modifyEmployee_phone;
            field3.textAlignment = NSTextAlignmentRight;
            field3.textColor = TextColorAlpha_54;
            field3.keyboardType = UIKeyboardTypePhonePad;
            field3.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:field3];
            
            if (isEdit == NO) {
                field3.enabled = NO;
            }
            else
            {
                field3.enabled = YES;
            }
             
             UIToolbar * topKeyboardView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 30)];
             [topKeyboardView setBarStyle:UIBarStyleDefault];
             UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
             UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Done",nil,nil) style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
             NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
             [topKeyboardView setItems:buttonsArray];
             
             if (ScreenWidth == 414) {
                 topKeyboardView.frame = CGRectMake(0, 0, ScreenWidth, 42);
             }
             [field3 setInputAccessoryView:topKeyboardView];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, ScreenWidth - 20, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 2)
        {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, (44-24)/2, 24, 24)];
            imageview.image = [UIImage imageNamed:@"p_email"];
            [cell.contentView addSubview:imageview];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
            [lab setAttributedText:SetAttributeText(@"EMAIL", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
            [cell.contentView addSubview:lab];
            
            field4 = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, ScreenWidth - 136, 44)];
            field4.delegate = self;
            field4.placeholder = @"name@example.com";
            field4.text = editEmployee.email;
            field4.textAlignment = NSTextAlignmentRight;
            field4.textColor = TextColorAlpha_54;
            field4.keyboardType = UIKeyboardTypeEmailAddress;
            field4.autocapitalizationType = UITextAutocapitalizationTypeNone;
            field4.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:field4];
            
            if (isEdit == NO) {
                field4.enabled = NO;
            }
            else
            {
                field4.enabled = YES;
            }
             
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, ScreenWidth - 20, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
        else if (indexPath.row == 3)
        {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, (44-24)/2, 24, 24)];
            imageview.image = [UIImage imageNamed:@"p_employee"];
            [cell.contentView addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
            label.text = @"ROLE";
            [label setAttributedText:SetAttributeText(@"ROLE", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
            [cell.contentView addSubview:label];
            
//            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 114, 0, 80, 44)];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 96, 0, 80, 44)];
             lab.textAlignment = NSTextAlignmentRight;
            lab.textColor = TextColorAlpha_54;
            if (editEmployee.isManager == 1) {
                lab.text = @"Manager";
            }
            else
            {
                lab.text = @"Employee";
            }
            
            [cell.contentView addSubview:lab];
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, 43, ScreenWidth - 20, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
    }
    else if (indexPath.section == 1)
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        ima.image = [UIImage imageNamed:@"p_position"];
        [cell.contentView addSubview:ima];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 44)];
        [lab setAttributedText:SetAttributeText(@"POSITIONS", SetColor(0, 0, 0, 0.87), SemiboldFontName, 14.0)];
        [cell.contentView addSubview:lab];
        
        
        int i = 0;
        if (arr_positionUuid.count == 0 && isEdit == NO) {
            UILabel *lab_detail = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, ScreenWidth-106, 44)];
            lab_detail.textAlignment = NSTextAlignmentRight;
            lab_detail.text = @"None";
            lab_detail.textColor = SetColor(0, 0, 0, 0.3);
            lab_detail.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab_detail];
        }
        if (isEdit == YES && isManager == 1) {
            UIButton *btn_addtag = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_addtag.frame = CGRectMake(160, arr_positionUuid.count*44, 44, 44);
            [btn_addtag setImage:[UIImage imageNamed:@"+_tag"] forState:UIControlStateNormal];
            btn_addtag.tag = i;
            [cell.contentView addSubview:btn_addtag];
            [btn_addtag addTarget:self action:@selector(addPosition) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lab_tagp = [[UILabel alloc]initWithFrame:CGRectMake(190, arr_positionUuid.count*44, ScreenWidth - 206, 44)];
            lab_tagp.textColor = TextColorAlpha_54;
            lab_tagp.textAlignment = NSTextAlignmentRight;
            lab_tagp.text = @"Tag Position";
            lab_tagp.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab_tagp];
        }
        for (NSString *uuid in arr_positionUuid) {
            
            Positions *position = [DatabaseManager getPositionByUuid:uuid];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(160, i*44, 44, 44);
            [btn setImage:[UIImage imageNamed:@"-_tag"] forState:UIControlStateNormal];
            btn.tag = i;
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(subPosition:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isEdit == NO || isManager == 0) {
                btn.hidden = YES;
            }
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(190, i*44, ScreenWidth - 206, 44)];
            lab.textColor = TextColorAlpha_54;
            lab.textAlignment = NSTextAlignmentRight;
            lab.text = position.name;
            lab.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab];
            
            i++;
        }
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, ScreenWidth - 20, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        float height = 44;
        if(isEdit == YES && isManager == 1)
        {
            height += arr_positionUuid.count*44;
        }
        else
        {
            height += arr_positionUuid.count*44-44;
        }
        if (arr_positionUuid.count == 0) {
            height = 44;
        }
        line.frame = CGRectMake(20, height-1, ScreenWidth - 20, 0.5);
    }
    else if(indexPath.section == 2)
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 25, 25)];
        ima.image = [UIImage imageNamed:@"p_location"];
        [cell.contentView addSubview:ima];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 50)];
        [lab setAttributedText:SetAttributeText(@"LOCATIONS", TextColorAlpha_87, SemiboldFontName, 14.0)];
        [cell.contentView addSubview:lab];
        
        int i = 0;
        if (arr_locationUuid.count == 0 && isEdit == NO) {
            UILabel *lab_detail = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, ScreenWidth-106, 44)];
            lab_detail.textAlignment = NSTextAlignmentRight;
            lab_detail.text = @"None";
            lab_detail.textColor = SetColor(0, 0, 0, 0.3);
            lab_detail.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab_detail];
        }
        if (isEdit == YES && isManager == 1) {
            UIButton *btn_addtag = [UIButton buttonWithType:UIButtonTypeCustom];
            btn_addtag.frame = CGRectMake(160, arr_locationUuid.count*44, 44, 44);
            [btn_addtag setImage:[UIImage imageNamed:@"+_tag"] forState:UIControlStateNormal];
            btn_addtag.tag = i;
            [cell.contentView addSubview:btn_addtag];
            [btn_addtag addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lab_tagl = [[UILabel alloc]initWithFrame:CGRectMake(190, arr_locationUuid.count*44, ScreenWidth - 206, 44)];
            lab_tagl.textColor = TextColorAlpha_54;
            lab_tagl.textAlignment = NSTextAlignmentRight;
            lab_tagl.text = @"Tag Location";
            lab_tagl.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab_tagl];
        }
        for (NSString *uuid in arr_locationUuid) {
            
            Locations *location = [DatabaseManager getLocationByUuid:uuid];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(160, i*44, 44, 44);
            [btn setImage:[UIImage imageNamed:@"-_tag"] forState:UIControlStateNormal];
            btn.tag = i;
            [cell.contentView addSubview:btn];
            [btn addTarget:self action:@selector(subLocation:) forControlEvents:UIControlEventTouchUpInside];
            
            if (isEdit == NO || isManager == 0) {
                btn.hidden = YES;
            }
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(190, i*44, ScreenWidth - 206, 44)];
            lab.textColor = TextColorAlpha_54;
            lab.textAlignment = NSTextAlignmentRight;
            lab.text = location.name;
            lab.font = [UIFont fontWithName:RegularFontName size:17.0];
            [cell.contentView addSubview:lab];
            
            i++;
        }

        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(20, cell.frame.size.height-1, ScreenWidth - 20, 0.5)];
        line.backgroundColor = SepearateLineColor;
        [cell.contentView addSubview:line];
        float height = 44;
        if(isEdit == YES && isManager == 1)
        {
            height += arr_locationUuid.count*44;
        }
        else
        {
            height += arr_locationUuid.count*44-44;
        }
        line.frame = CGRectMake(20, height-1, ScreenWidth - 20, 0.5);
    }
    return cell;
}
         
-(void)dismissKeyBoard
{
    [self setAllFieldResignFirstResponse];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1 && isEdit == NO) {
        [self clickPhoneshowAlert];
    }
    else if (indexPath.section == 0 && indexPath.row == 2 && isEdit == NO)
    {
        [self clickEmailShowAlert];
    }
}

-(void) clickPhoneshowAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Place Phone Call",@"Send Text Message"/*,@"Send Email",@"Add Contact to Address Book"*/, nil];
    for (int i = 0; i < arr.count; i++) {
        
        UIAlertAction *otherButton = [UIAlertAction actionWithTitle:[arr objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self alertHandle:i+100];
        }];
        [alertController addAction:otherButton];
        alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void) clickEmailShowAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelButton];
    
    UIAlertAction *otherButton = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self alertHandle:102];
    }];
    [alertController addAction:otherButton];
    alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) subPosition:(UIButton *)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        [arr_positionUuid removeObject:[arr_positionUuid objectAtIndex:sender.tag]];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void) addPosition
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        TagPositionViewController_iphone *tagP = [TagPositionViewController_iphone new];
        tagP.delegate = self;
        tagP.notModifyPrifileViewPassArray = YES;
        tagP.arr_selectPositionuuid = arr_positionUuid;
        tagP.employeeuuid = employeeUuid;
        [self presentViewController:tagP animated:YES completion:nil];
    }
}

-(void) subLocation:(UIButton *)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        [arr_locationUuid removeObject:[arr_locationUuid objectAtIndex:sender.tag]];
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void) addLocation
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1) {
        LocationListViewController_iphone *locationV = [LocationListViewController_iphone new];
        locationV.delegate = self;
        locationV.notModifyPrifileViewPassArray = YES;
        locationV.arr_selectLocationuuid = arr_locationUuid;
        locationV.employeeuuid = employeeUuid;
        [self presentViewController:locationV animated:YES completion:nil];
    } 
}

-(void)changeHeadPortrait:(UITapGestureRecognizer *)tap
{
    AppDelegate *appdeleagte = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (([appdeleagte.currentEmployee.uuid isEqualToString:employeeUuid] || isManager == 1) && isEdit == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelButton];
        
        NSArray *arr = [NSArray arrayWithObjects:InternationalL(@"takePhoto"),InternationalL(@"photoLibrary"), nil];
        for (int i = 0; i < arr.count; i++) {
            
            UIAlertAction *otherButton = [UIAlertAction actionWithTitle:[arr objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self alertHandle:i];
            }];
            [alertController addAction:otherButton];
            alertController.view.tintColor = SetColor(0 ,195, 0,1.0);
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void) alertHandle:(NSInteger) index
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    if(index == 0)
    {
        [self snapImage];
    }
    else if(index == 1)
    {
        [self pickImage];
    }
    else if (index == 2)
    {
        [self deleteEmployeeAllData:YES];
    }
    else if (index == 3)
    {
        [self deleteEmployeeAllData:NO];
    }
    else if (index == 100)
    {
        [appdelegate callPhoneNumber:employee.phone];
    }
    else if(index == 101)
    {
        NSArray *arr_phone = [NSArray arrayWithObjects:employee.phone, nil];
        [appdelegate showMessageView:arr_phone title:nil body:nil];
    }
    else if (index == 102)
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            if ([mailClass canSendMail])
            {
                NSArray *arr_email = [NSArray arrayWithObjects:employee.email, nil];
                [appdelegate sendEmail:self andToEmail:arr_email];
                [appdelegate.rootController_iphone presentViewController:appdelegate.appMailController2 animated:YES completion:^{
                }];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Email is not configured." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
    else if (index == 103)
    {
        CNMutableContact *contact = [[CNMutableContact alloc]init];
        [self setupContact:contact andEmployee:employee];
        
        CNSaveRequest * saveRequest = [[CNSaveRequest alloc] init];
        [saveRequest addContact:contact toContainerWithIdentifier:nil];
        CNContactStore * store = [[CNContactStore alloc]init];
        if ([store executeSaveRequest:saveRequest error:nil] == YES) {
            
            NSLog(@"bbb");
        }
        
//        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) return;
//             CNContactStore *store = [[CNContactStore alloc] init];
//             [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                if (granted)
//                {
//                    appdelegate.contactPeoplePickerVc.delegate = self;
//                    appdelegate.contactPeoplePickerVc.predicateForSelectionOfProperty = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(key == 'emailAddresses') AND (value LIKE '%@')",employee.email]];
//                    appdelegate.contactPeoplePickerVc.predicateForSelectionOfContact = [NSPredicate predicateWithFormat:@"emailAddresses.@count == 1"];
//                    [self presentViewController:appdelegate.contactPeoplePickerVc  animated:YES completion:nil];
//                }
//            }];
    }
}
- (void)setupContact:(CNMutableContact *)contact andEmployee:(Employees *) employee{

    if (employee.headPortrait != nil) {
        contact.imageData = UIImagePNGRepresentation([UIImage imageWithData:employee.headPortrait]);
    }
    NSRange range = [employee.fullName rangeOfString:@" "];
    NSString *s1 = [employee.fullName substringWithRange:NSMakeRange(0, range.location)];
    NSString *s2 = [employee.fullName substringFromIndex:range.location+1];
    contact.givenName = [NSString stringWithFormat:@"%@",s2];
    contact.familyName = [NSString stringWithFormat:@"%@",s1];
    
    //CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:employee.email];
    CNLabeledValue *workEmail =[CNLabeledValue labeledValueWithLabel:CNLabelWork value:employee.email];
    contact.emailAddresses = @[/*homeEmail,*/workEmail];

    CNLabeledValue *mianPhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMain value:[CNPhoneNumber phoneNumberWithStringValue:employee.phone]];
    //CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberHomeFax value:[CNPhoneNumber phoneNumberWithStringValue:employee.phone]];
    contact.phoneNumbers = @[mianPhone/*, homePhone*/];

//     //设置联系人地址
//     CNMutablePostalAddress * homeAdress = [[CNMutablePostalAddress alloc]init];
//     homeAdress.street = @"大雁塔";
//     homeAdress.city = @"西安";
//     homeAdress.state = @"中国";
//     homeAdress.postalCode = @"xxxxx";
//     contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAdress]];
//
//     //设置联系人生日
//     NSDateComponents * birthday = [[NSDateComponents  alloc] init];
//     birthday.day=7;
//     birthday.month=9;
//     birthday.year=1998;
//     contact.birthday=birthday;
 }

#pragma mark -
#pragma mark email
- (void)mailComposeController: (MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"发送失败!");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark Address Book
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    ipc.delegate=self;
    ipc.allowsEditing=YES;
    if ([ipc.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [ipc.navigationBar setBarTintColor:[UIColor whiteColor]];
        [ipc.navigationBar setTranslucent:NO];
        [ipc.navigationBar setTintColor:[UIColor blackColor]];
    }else{
        [ipc.navigationBar setBackgroundColor:[UIColor whiteColor]];
    }
    ipc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont fontWithName:SemiboldFontName size:17]};
    [self presentViewController:ipc animated:YES completion:^{}];
}
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate=self;
    ipc.allowsEditing=YES;
    
    if ([ipc.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [ipc.navigationBar setBarTintColor:[UIColor whiteColor]];
        [ipc.navigationBar setTranslucent:NO];
        [ipc.navigationBar setTintColor:[UIColor blackColor]];
    }else{
        [ipc.navigationBar setBackgroundColor:[UIColor whiteColor]];
    }
    ipc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont fontWithName:SemiboldFontName size:17]};
    [self presentViewController:ipc animated:YES completion:^{}];
}
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    //UIImagePickerControllerOriginalImage   UIImagePickerControllerEditedImage
    UIImage *img=[info objectForKey:@"UIImagePickerControllerEditedImage"];
//    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
//        UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
//    }
    UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    [self saveImage:newImg];
    [self dismissViewControllerAnimated:YES completion:^{
        //headrImage.image=img;

    }];
    
}

- (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

- (void)saveImage:(UIImage *)tempImage{
    
    NSData* imageData;
    
    if (UIImagePNGRepresentation(tempImage)) {

        imageData = UIImagePNGRepresentation(tempImage);
    }
    else {
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    if (employeeUuid == nil) {
        employeeImageData = imageData;
    }
    else
    {
        modifyEmployeeImageData = imageData;
    }
    [_tableView reloadData];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
    [field4 resignFirstResponder];
    return YES;
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
    [field4 resignFirstResponder];
}
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if(([textField isEqual:field4] && employeeUuid != nil) || isEdit == NO)
    {
        return NO;
    }
    return YES;
}
         
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:field1]) {
        if([field1.text length] == 0 || [StringManager isEmpty:field1.text] == YES || [StringManager includeChinese:field1.text] || [field1.text containsString:@" "])
        {
            field1.text = @"";
        }
        modifyEmployee_name1 = field1.text;
    }
    else if ([textField isEqual:field2])
    {
        if([field2.text length] == 0 || [StringManager isEmpty:field2.text] == YES || [StringManager includeChinese:field2.text])
        {
            field2.text = @"";
        }
        modifyEmployee_name2 = field2.text;
    }
    else if ([textField isEqual:field3])
    {
        modifyEmployee_phone = field3.text;
    }
    else if ([textField isEqual:field4])
    {
        modifyEmployee_email = [textField.text lowercaseString];
    }
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:field1])
    {
        NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
        
        if (!([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1) && ![string isEqualToString:@""]){
            return NO;
        }
        
        if([StringManager includeChinese:string] == YES)
        {
            for(int i = 0; i< [string length];i++)
            {
                int a = [string characterAtIndex:i];
                if(a > 0x4e00 && a < 0x9fff){
                    return NO;
                }
            }
            return YES;
        }
        else
        {
            modifyEmployee_name1 = [field1.text stringByAppendingString:string];
        }
        
        return YES;
    }
    else if([textField isEqual:field2])
    {
        NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS2];

        if (!([[string componentsSeparatedByCharactersInSet:acceptedInput] count] > 1) && ![string isEqualToString:@""]){
            return NO;
        }
        
        if([StringManager includeChinese:string] == YES)
        {
            for(int i = 0; i< [string length];i++)
            {
                int a = [string characterAtIndex:i];
                if(a > 0x4e00 && a < 0x9fff){
                    return NO;
                }
            }
            return YES;
        }
        
        modifyEmployee_name2 = [field2.text stringByAppendingString:string];
    }
    else if ([textField isEqual:field3])
    {
        UITextRange *selRange = textField.selectedTextRange;
        UITextPosition *selStartPos = selRange.start;
        UITextPosition *selEndPos = selRange.end;
        NSInteger start = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selStartPos];
        NSInteger end = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selEndPos];
        NSRange repRange;
        if (start == end) {
            if (string.length == 0) {
                repRange = NSMakeRange(start - 1, 1);
            } else {
                repRange = NSMakeRange(start, end - start);
            }
        } else {
            repRange = NSMakeRange(start, end - start);
        }
        
        // This is what the new text will be after adding/deleting 'string'
        NSString *txt = [textField.text stringByReplacingCharactersInRange:repRange withString:string];
        // This is the newly formatted version of the phone number
        NSString *phone = [phoneFormat format:txt];
        BOOL valid = [phoneFormat isPhoneNumberValid:phone];
        
        textField.textColor = valid ? [UIColor blackColor] : [UIColor redColor];
        
        // If these are the same then just let the normal text changing take place
        if ([phone isEqualToString:txt]) {
            return YES;
        }
        else {
            // The two are different which means the adding/removal of a character had a bigger effect
            // from adding/removing phone number formatting based on the new number of characters in the text field
            // The trick now is to ensure the cursor stays after the same character despite the change in formatting.
            // So first let's count the number of non-formatting characters up to the cursor in the unchanged text.
            NSInteger cnt = 0;
            
            
            for (int i = 0; i < repRange.location + string.length; i++) {
                if ([phoneChars characterIsMember:[txt characterAtIndex:i]]) {
                    cnt++;
                }
            }
            
            // Now let's find the position, in the newly formatted string, of the same number of non-formatting characters.
            NSInteger pos = [phone length];
            NSInteger cnt2 = 0;
            for (NSInteger i = 0; i < [phone length]; i++) {
                if ([phoneChars characterIsMember:[phone characterAtIndex:i]]) {
                    cnt2++;
                }
                
                if (cnt2 == cnt) {
                    pos = i + 1;
                    break;
                }
            }
            
            // Replace the text with the updated formatting
            textField.text = phone;
            
            // Make sure the caret is in the right place
            UITextPosition *startPos = [textField positionFromPosition:textField.beginningOfDocument offset:pos];
            UITextRange *textRange = [textField textRangeFromPosition:startPos toPosition:startPos];
            textField.selectedTextRange = textRange;
            
            return NO;
        }
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) editToSave
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    isEdit = YES;
    [_saveBtn setTitle:SaveString forState:UIControlStateNormal];
    _deleteBtn.hidden = NO;
    if (isManager == YES && [appdelegate.currentEmployee.uuid isEqualToString:employeeUuid]) {
        _bottomLine.hidden = YES;
        _deleteBtn.hidden = YES;
    }
    line_y.hidden = YES;
    _scheduleBtn.hidden = YES;
    _avallabilityBtn.hidden = YES;
    [_tableView reloadData];
}

-(void) saveToEdit
{
    isEdit = NO;
    [_saveBtn setTitle:EditString forState:UIControlStateNormal];
    _bottomLine.hidden = NO;
    _deleteBtn.hidden = YES;
    line_y.hidden = NO;
    _scheduleBtn.hidden = NO;
    _avallabilityBtn.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)saveEmployee:(UIButton *)sender {
    
    [self setAllFieldResignFirstResponse];
    
    field1.text = [field1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    field2.text = [field2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    field3.text = [field3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([sender.titleLabel.text isEqualToString:EditString]) {
        [self editToSave];
    }
    else
    {
        Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
        if(employee != nil)
        {
            field4.text = employee.email;
        }
        
        if ([field1.text isEqualToString:@""] || [StringManager isEmpty:field1.text] || [field2.text isEqualToString:@""] || [StringManager isEmpty:field2.text] || [field3.text isEqualToString:@""] || [StringManager isEmpty:field3.text]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Make sure you have filled out all the blanks." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            if (field3.textColor != [UIColor redColor])
            {
                AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appdelegate managedObjectContext];
                
                modifyEmployee_name1 = [modifyEmployee_name1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                modifyEmployee_name2 = [modifyEmployee_name2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *fullname = [NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2];
                Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
                
                if ([employee.fullName isEqualToString:fullname] && [employee.phone isEqualToString:modifyEmployee_phone] && ([employee.headPortrait isEqualToData:modifyEmployeeImageData] || (employee.headPortrait == nil && modifyEmployeeImageData == nil)) &&  (([arr_positionUuid isEqualToArray:arr_oriPostionUuid] && [arr_locationUuid isEqualToArray:arr_oriLocationUuid]) || (arr_locationUuid.count == 0 && arr_positionUuid.count == 0))) {
                    
//                    if(arr_locationUuid.count == 0)
//                    {
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must tag a location for employee!" preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//                        [alertController addAction:okAction];
//                        [self presentViewController:alertController animated:YES completion:nil];
//                    }
//                    else
//                    {
//                        [self saveToEdit];
//                    }
                    [self saveToEdit];
                }
                else
                {
                    [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
                    
                    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/employee/%@",api_workplace,appdelegate.currentWorkplace.uuid,employee.uuid];
                    
                    [HttpRequestManager requestWithType:requestType_PUT withUrlString:urlstring withParaments:@{@"fullName":fullname,@"phoneNumber":modifyEmployee_phone} withSuccessBlock:^(NSData *data , NSHTTPURLResponse *response){
                        
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                        
                        if (response.statusCode == 200) {
                            
                            employee.fullName = fullname;
                            employee.phone = modifyEmployee_phone;
                            
                            if ([employee.uuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                                CurrentEmployee *ce = [DatabaseManager getCurrentEmployeeByUuid:employee.uuid];
                                ce.fullName = employee.fullName;
                                ce.phone = employee.phone;
                                
                                appdelegate.currentEmployee = ce;
                                
                                [context save:nil];
                            }
                            
                            [context save:nil];
                            
                            [self saveToEdit];
                        }
                        
                    }withFailureBlock:^(NSError *error)
                     {
                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                         NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                         [alertController addAction:cancelAction];
                         [self presentViewController:alertController animated:YES completion:nil];
                     }];
                }
            }
        }
    }
}


-(void)setAllFieldResignFirstResponse
{
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
    [field4 resignFirstResponder];
}


-(void) addEmployeePosition:(NSMutableArray *) array1 andLocation:(NSMutableArray *) array2 andEmployeeUuid:(NSString *)employee_uuid
{
//    NSMutableArray *arr_writeRequest = [NSMutableArray array];
//    for (NSString *uuid in array2) {
//        
//        Locations *location = [DatabaseManager getLocationByUuid:uuid];
//        
//        if (location.employees == nil) {
//            location.employees = [NSString stringWithFormat:@"%@",employee_uuid];
//        }
//        else
//        {
//            if (![location.employees containsString:employee_uuid]) {
//                
//                NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                location.employees = [location.employees stringByAppendingString:appendingString];
//            }
//        }
//        
//        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
//        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
//        createdate.S = location.createDate;
//        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
//        modifyDate.S = location.modifyDate;
//        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
//        haskKeyValue.S = location.uuid;
//        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        rangeKeyValue.S = location.parentUuid;
//        AWSDynamoDBAttributeValue *namaeruuid = [AWSDynamoDBAttributeValue new];
//        namaeruuid.S = location.managerUuid;
//        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
//        isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:location.isDelete]];
//        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
//        tablename.S = @"Locations";
//        AWSDynamoDBAttributeValue *locationname = [AWSDynamoDBAttributeValue new];
//        locationname.S = location.name;
//        AWSDynamoDBAttributeValue *locationaddr = [AWSDynamoDBAttributeValue new];
//        locationaddr.S = location.address;
//        AWSDynamoDBAttributeValue *locationlatitude = [AWSDynamoDBAttributeValue new];
//        locationlatitude.S = location.latitude;
//        AWSDynamoDBAttributeValue *locationlogitude = [AWSDynamoDBAttributeValue new];
//        locationlogitude.S = location.longitude;
//        AWSDynamoDBAttributeValue *locaemployees = [AWSDynamoDBAttributeValue new];
//        locaemployees.S = location.employees;
//        
//        writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"location_employees": locaemployees,@"createDate": createdate,@"managerUuid": namaeruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"location_name": locationname,@"location_addr": locationaddr,@"location_latitude": locationlatitude,@"location_longitude": locationlogitude};
//        [arr_writeRequest addObject:writeRequest];
//    }
//    
//
//    for (NSString *uuid in array1) {
//        
//        Positions *position = [DatabaseManager getPositionByUuid:uuid];
//        
//        if (position.employees == nil) {
//            position.employees = [NSString stringWithFormat:@"%@",employee_uuid];
//        }
//        else
//        {
//            if (![position.employees containsString:employee_uuid]) {
//                
//                NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                position.employees = [position.employees stringByAppendingString:appendingString];
//            }
//        }
//        
//        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
//        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
//        createdate.S = position.createDate;
//        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
//        modifyDate.S = position.modifyDate;
//        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
//        haskKeyValue.S = position.uuid;
//        AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
//        manageruuid.S = position.managerUuid;
//        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        rangeKeyValue.S = position.parentUuid;
//        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
//        isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.isDelete]];
//        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
//        tablename.S = @"Positions";
//        AWSDynamoDBAttributeValue *positionname = [AWSDynamoDBAttributeValue new];
//        positionname.S = position.name;
//        AWSDynamoDBAttributeValue *isFavor = [AWSDynamoDBAttributeValue new];
//        isFavor.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.isFavorite]];
//        AWSDynamoDBAttributeValue *color = [AWSDynamoDBAttributeValue new];
//        color.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.color]];
//        AWSDynamoDBAttributeValue *positionemployees = [AWSDynamoDBAttributeValue new];
//        positionemployees.S = position.employees;
//        
//        writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"position_employees": positionemployees,@"createDate": createdate,@"managerUuid": manageruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"position_name": positionname,@"position_isFavorite": isFavor,@"position_color": color};
//        [arr_writeRequest addObject:writeRequest];
//    }
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//     NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    AWSDynamoDBWriteRequest *writeRequest_setting = [AWSDynamoDBWriteRequest new];
//    writeRequest_setting.putRequest = [AWSDynamoDBPutRequest new];
//    
//    AWSDynamoDBAttributeValue *setting_createdate = [AWSDynamoDBAttributeValue new];
//    setting_createdate.S = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
//    AWSDynamoDBAttributeValue *setting_modifydate = [AWSDynamoDBAttributeValue new];
//    setting_modifydate.S = setting_createdate.S;
//    AWSDynamoDBAttributeValue *setting_haskKeyValue = [AWSDynamoDBAttributeValue new];
//    setting_haskKeyValue.S = [StringManager getItemID];
//    AWSDynamoDBAttributeValue *setting_manageruuid = [AWSDynamoDBAttributeValue new];
//    setting_manageruuid.S = appDelegate.currentEmployee.uuid;
//    AWSDynamoDBAttributeValue *setting_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//    setting_rangeKeyValue.S = appDelegate.currentWorkplace.uuid;
//    AWSDynamoDBAttributeValue *setting_tablename = [AWSDynamoDBAttributeValue new];
//    setting_tablename.S = @"Setting";
//    AWSDynamoDBAttributeValue *setting_isdelete = [AWSDynamoDBAttributeValue new];
//    setting_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
//    AWSDynamoDBAttributeValue *setting_employeeuuid = [AWSDynamoDBAttributeValue new];
//    setting_employeeuuid.S = newEmployeeUuid;
//    AWSDynamoDBAttributeValue *setting_email_isTimeOffTequest = [AWSDynamoDBAttributeValue new];
//    setting_email_isTimeOffTequest.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_email_isDropRequest = [AWSDynamoDBAttributeValue new];
//    setting_email_isDropRequest.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_emailg_isScheduleUpdate = [AWSDynamoDBAttributeValue new];
//    setting_emailg_isScheduleUpdate.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_email_isNewEmployee = [AWSDynamoDBAttributeValue new];
//    setting_email_isNewEmployee.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_email_isAvailabilityChange = [AWSDynamoDBAttributeValue new];
//    setting_email_isAvailabilityChange.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
//    AWSDynamoDBAttributeValue *setting_notification_isTimeOffTequest = [AWSDynamoDBAttributeValue new];
//    setting_notification_isTimeOffTequest.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_notification_isDropRequest = [AWSDynamoDBAttributeValue new];
//    setting_notification_isDropRequest.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_notification_isScheduleUpdate = [AWSDynamoDBAttributeValue new];
//    setting_notification_isScheduleUpdate.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_notification_isNewEmployee = [AWSDynamoDBAttributeValue new];
//    setting_notification_isNewEmployee.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    AWSDynamoDBAttributeValue *setting_notification_isAvailabilityChange = [AWSDynamoDBAttributeValue new];
//    setting_notification_isAvailabilityChange.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//    
//    writeRequest_setting.putRequest.item = @{@"uuid": setting_haskKeyValue,@"parentUuid" : setting_rangeKeyValue,@"createDate": setting_createdate,@"modifyDate": setting_modifydate,@"managerUuid": setting_manageruuid,@"isDelete": setting_isdelete,@"tableIdentityID": setting_tablename,@"setting_email_isTimeOffTequest": setting_email_isTimeOffTequest,@"setting_email_isDropRequest": setting_email_isDropRequest,@"setting_emailg_isScheduleUpdate": setting_emailg_isScheduleUpdate,@"setting_email_isNewEmployee": setting_email_isNewEmployee,@"setting_email_isAvailabilityChange": setting_email_isAvailabilityChange,@"setting_notification_isTimeOffTequest": setting_notification_isTimeOffTequest,@"setting_notification_isDropRequest": setting_notification_isDropRequest,@"setting_notification_isScheduleUpdate": setting_notification_isScheduleUpdate,@"setting_notification_isNewEmployee": setting_notification_isNewEmployee,@"setting_notification_isAvailabilityChange": setting_notification_isAvailabilityChange,@"setting_employeeUuid": setting_employeeuuid};
//    
//    [arr_writeRequest addObject:writeRequest_setting];
//    
//    AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
//    AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
//    batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_writeRequest};
//    batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
//    [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
//        if (task.error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
//                if([error containsString:@"Failed"])
//                {
//                    
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"The current location to add failed, please manually add." preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//                    [alertController addAction:okAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                }
//                else
//                {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
//                    [alertController addAction:okAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                }
//                
//                
//                Setting *settting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
//                settting.createDate = setting_createdate.S;
//                settting.modifyDate = setting_modifydate.S;
//                settting.uuid = setting_haskKeyValue.S;
//                settting.parentUuid = setting_rangeKeyValue.S;
//                settting.managerUuid = setting_manageruuid.S;
//                settting.isDelete = 0;
//                settting.employeeUuid = setting_employeeuuid.S;
//                settting.email_isTimeOffTequest = 1;
//                settting.email_isDropRequest = 1;
//                settting.email_isScheduleUpdate = 1;
//                settting.email_isNewEmployee = 1;
//                settting.email_isAvailabilityChange = 0;
//                settting.notification_isTimeOffTequest = 1;
//                settting.notification_isDropRequest = 1;
//                settting.notification_isScheduleUpdate = 1;
//                settting.notification_isNewEmployee = 1;
//                settting.notification_isAvailabilityChange = 1;
//                settting.email_noNotifyStartTime = nil;
//                settting.email_noNotifyEndTime = nil;
//                settting.notification_noNotifyStartTime = nil;
//                settting.notification_noNotifyEndTime = nil;
//                
//                [context save:nil];
//                
//                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
//                employeeUuid = newEmployeeUuid;
//                [self saveToEdit];
//            });
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                for (NSString *uuid in array2) {
//                    
//                    Locations *location = [DatabaseManager getLocationByUuid:uuid];
//                    
//                    if (location.employees == nil) {
//                        location.employees = [NSString stringWithFormat:@"%@",employee_uuid];
//                    }
//                    else
//                    {
//                        if (![location.employees containsString:employee_uuid]) {
//                            
//                            NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                            location.employees = [location.employees stringByAppendingString:appendingString];
//                        }
//                    }
//                    [context save:nil];
//                }
//                
//                for (NSString *uuid in array1) {
//                    
//                    Positions *position = [DatabaseManager getPositionByUuid:uuid];
//                    
//                    if (position.employees == nil) {
//                        position.employees = [NSString stringWithFormat:@"%@",employee_uuid];
//                    }
//                    else
//                    {
//                        if (![position.employees containsString:employee_uuid]) {
//                            
//                            NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                            position.employees = [position.employees stringByAppendingString:appendingString];
//                        }
//                    }
//                    [context save:nil];
//                }
//                
//                [context save:nil];
//                
//                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        return nil;
//    }];
}

-(void) syncModifyEmployeInfo
{
    modifyEmployee_name1 = [modifyEmployee_name1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    modifyEmployee_name2 = [modifyEmployee_name2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    
    if(isManager == 1)
    {
        if ([employee.fullName isEqualToString:[NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2]] && [employee.phone isEqualToString:modifyEmployee_phone] && ([employee.headPortrait isEqualToData:modifyEmployeeImageData] || (employee.headPortrait == nil && modifyEmployeeImageData == nil)) &&  (([arr_positionUuid isEqualToArray:arr_oriPostionUuid] && [arr_locationUuid isEqualToArray:arr_oriLocationUuid]) || (arr_locationUuid.count == 0 && arr_positionUuid.count == 0))) {
            
            if(arr_locationUuid.count == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must tag a location for employee!" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                [self saveToEdit];
            }
        }
        else
        {
            
            if (![employee.fullName isEqualToString:[NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2]] || ![employee.phone isEqualToString:modifyEmployee_phone] || ![employee.headPortrait isEqualToData:modifyEmployeeImageData] || (employee.headPortrait != nil || modifyEmployeeImageData != nil)) {
                
                if(arr_locationUuid.count == 0)
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must tag a location for employee!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
                    DDBEmployeesInfoModel *model = [[DDBEmployeesInfoModel alloc]init];
                    model.modify_date = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
                    model.uuid = employee.uuid;;
                    if (modifyEmployeeImageData != nil) {
                        model.portrait = [StringManager dataTransferString:modifyEmployeeImageData];
                    }
                    else if (employee.headPortrait != nil)
                    {
                        model.portrait = [StringManager dataTransferString:employee.headPortrait];
                    }
                    model.email = employee.email;
                    model.isManager = [NSNumber numberWithShort:employee.isManager];
                    model.fullname = [NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2];
                    model.password = employee.password;
                    model.phone = modifyEmployee_phone;
                    model.maxHoursPerWeek = [NSNumber numberWithShort:employee.maxHoursPerWeek];
                    
                    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
                    [[dynamoDBObjectMapper save:model]
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
                             if ([model isKindOfClass:[DDBEmployeesInfoModel class]]) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                     
                                     employee.fullName = model.fullname;
                                     employee.password = model.password;
                                     employee.phone = model.phone;
                                     employee.headPortrait = [StringManager stringTransferData:model.portrait];
                                     
                                     [context save:nil];
                                     
                                     if([employee.uuid isEqualToString:appDelegate.currentEmployee.uuid])
                                     {
                                         CurrentEmployee *ce = [DatabaseManager getCurrentEmployeeByUuid:employee.uuid];
                                         ce.fullName = model.fullname;
                                         ce.password = model.password;
                                         ce.phone = model.phone;
                                         ce.headPortrait = [StringManager stringTransferData:model.portrait];
                                         
                                         appDelegate.currentEmployee = ce;
                                         
                                         [context save:nil];
                                     }
                                     
                                     if (isManager == 1) {
                                         if ((([arr_positionUuid isEqualToArray:arr_oriPostionUuid] && [arr_locationUuid isEqualToArray:arr_oriLocationUuid]) || (arr_locationUuid.count == 0 && arr_positionUuid.count == 0))) {
                                             
                                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                             [self saveToEdit];
                                         }
                                         else
                                         {
                                             [self syncLocationAndPosition];
                                         }
                                     }
                                     else
                                     {
                                         [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                         [self saveToEdit];
                                     }
                                     
                                     
                                 });
                             }
                         }
                         return nil;
                     }];
                }
            }
            else
            {
                if(arr_locationUuid.count == 0)
                {
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"You must tag a location for employee!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [self syncLocationAndPosition];
                }
            }
        }
    }
    else
    {
        if ([employee.fullName isEqualToString:[NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2]] && [employee.phone isEqualToString:modifyEmployee_phone] && ([employee.headPortrait isEqualToData:modifyEmployeeImageData] || (employee.headPortrait == nil && modifyEmployeeImageData == nil))) {
            [self saveToEdit];
        }
        else
        {
            // employee sync employee info
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            DDBEmployeesInfoModel *model = [[DDBEmployeesInfoModel alloc]init];
            model.modify_date = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
            model.uuid = employee.uuid;;
            if (modifyEmployeeImageData != nil) {
                model.portrait = [StringManager dataTransferString:modifyEmployeeImageData];
            }
            else if (employee.headPortrait != nil)
            {
                model.portrait = [StringManager dataTransferString:employee.headPortrait];
            }
            model.email = employee.email;
            model.isManager = [NSNumber numberWithShort:employee.isManager];
            model.fullname = [NSString stringWithFormat:@"%@ %@",modifyEmployee_name1,modifyEmployee_name2];
            model.password = employee.password;
            model.phone = modifyEmployee_phone;
            model.maxHoursPerWeek = [NSNumber numberWithShort:employee.maxHoursPerWeek];
            
            AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
            [[dynamoDBObjectMapper save:model]
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
                     if ([model isKindOfClass:[DDBEmployeesInfoModel class]]) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                             NSManagedObjectContext *context = [appDelegate managedObjectContext];
                             
                             employee.fullName = model.fullname;
                             employee.password = model.password;
                             employee.phone = model.phone;
                             employee.headPortrait = [StringManager stringTransferData:model.portrait];
                             
                             [context save:nil];
                             
                             if([employee.uuid isEqualToString:appDelegate.currentEmployee.uuid])
                             {
                                 CurrentEmployee *ce = [DatabaseManager getCurrentEmployeeByUuid:employee.uuid];
                                 ce.fullName = model.fullname;
                                 ce.password = model.password;
                                 ce.phone = model.phone;
                                 ce.headPortrait = [StringManager stringTransferData:model.portrait];
                                 
                                 appDelegate.currentEmployee = ce;
                                 
                                 [context save:nil];
                             }
                             [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                             [self saveToEdit];
                         });
                     }
                 }
                 return nil;
             }];
        }
    }
}

-(void) syncLocationAndPosition
{
    NSMutableArray *arr_writeRequest_data = [NSMutableArray array];
    
    NSMutableArray *arr_inser_position = [NSMutableArray array];
    NSMutableArray *arr_delete_position = [NSMutableArray array];
    
    NSMutableArray *arr_inser_location = [NSMutableArray array];
    NSMutableArray *arr_delete_location = [NSMutableArray array];
    
    /************************************  position  ******************************************/
    {
        for (int i = 0; i < arr_oriPostionUuid.count; i++) {
            if (![arr_positionUuid containsObject:[arr_oriPostionUuid objectAtIndex:i]]) {
                [arr_delete_position addObject:[arr_oriPostionUuid objectAtIndex:i]];
            }
        }
        for (int j = 0; j < arr_positionUuid.count; j++) {
            if (![arr_oriPostionUuid containsObject:[arr_positionUuid objectAtIndex:j]]) {
                [arr_inser_position addObject:[arr_positionUuid objectAtIndex:j]];
            }
        }
        if (arr_delete_position.count != 0) {
            arr_writeRequest_data = [self getPositionAttriubte:arr_delete_position andEmployeeUuid:employeeUuid andIsDelete:YES];
        }
        if (arr_inser_position.count != 0) {
            NSMutableArray *arr_temp = [NSMutableArray array];
            arr_temp = [self getPositionAttriubte:arr_inser_position andEmployeeUuid:employeeUuid andIsDelete:NO];
            for (AWSDynamoDBWriteRequest *writerequest in arr_temp) {
                [arr_writeRequest_data addObject:writerequest];
            }
        }
    }
    
    /************************************  location  ******************************************/
    {
        for (int i = 0; i < arr_oriLocationUuid.count; i++) {
            if (![arr_locationUuid containsObject:[arr_oriLocationUuid objectAtIndex:i]]) {
                [arr_delete_location addObject:[arr_oriLocationUuid objectAtIndex:i]];
            }
        }
        for (int j = 0; j < arr_locationUuid.count; j++) {
            if (![arr_oriLocationUuid containsObject:[arr_locationUuid objectAtIndex:j]]) {
                [arr_inser_location addObject:[arr_locationUuid objectAtIndex:j]];
            }
        }
        if (arr_inser_location.count != 0) {
            NSMutableArray *arr_temp = [NSMutableArray array];
            arr_temp = [self getLocationAttriubte:arr_inser_location andEmployeeUuid:employeeUuid andIsDelete:NO];
            for (AWSDynamoDBWriteRequest *writerequest in arr_temp) {
                [arr_writeRequest_data addObject:writerequest];
            }
        }
        if (arr_delete_location.count != 0) {
            NSMutableArray *arr_temp = [NSMutableArray array];
            arr_temp = [self getLocationAttriubte:arr_delete_location andEmployeeUuid:employeeUuid andIsDelete:YES];
            for (AWSDynamoDBWriteRequest *writerequest in arr_temp) {
                [arr_writeRequest_data addObject:writerequest];
            }
        }
    }
    
    AWSDynamoDB *dynamoDB = [AWSDynamoDB defaultDynamoDB];
    AWSDynamoDBBatchWriteItemInput *batchWriteItemInput = [AWSDynamoDBBatchWriteItemInput new];
    if (arr_writeRequest_data.count != 0) {
        batchWriteItemInput.requestItems = @{@"TinyScheduleDataTable": arr_writeRequest_data};
        batchWriteItemInput.returnConsumedCapacity = AWSDynamoDBReturnConsumedCapacityTotal;
        [[dynamoDB batchWriteItem:batchWriteItemInput] continueWithBlock:^id(AWSTask *task){
            if (task.error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed save location & position" message:error preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AWSDynamoDBBatchWriteItemOutput *batchWriteItemOutput = task.result;
                    NSArray *consumedCapacity = batchWriteItemOutput.consumedCapacity;
                    NSLog(@"%lu",(unsigned long)consumedCapacity.count);
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                    
                    for (NSString *uuid in arr_delete_location) {
                        
                        Locations *location = [DatabaseManager getLocationByUuid:uuid];
                        NSMutableArray *arr_employeeuuid = [NSMutableArray arrayWithArray:[location.employees componentsSeparatedByString:@","]];
                        if ([arr_employeeuuid containsObject:employeeUuid]) {
                            [arr_employeeuuid removeObject:employeeUuid];
                            location.employees = [arr_employeeuuid componentsJoinedByString:@","];
                            [context save:nil];
                        }
                    }
                    
                    for (NSString *uuid in arr_delete_position) {
                        
                        Positions *position = [DatabaseManager getPositionByUuid:uuid];
                        NSMutableArray *arr_employeeuuid = [NSMutableArray arrayWithArray:[position.employees componentsSeparatedByString:@","]];
                        if ([arr_employeeuuid containsObject:employeeUuid]) {
                            [arr_employeeuuid removeObject:employeeUuid];
                            position.employees = [arr_employeeuuid componentsJoinedByString:@","];
                            [context save:nil];
                        }
                    }
                    
                    for (NSString *uuid in arr_inser_location) {
                        Locations *location = [DatabaseManager getLocationByUuid:uuid];
                        if (location.employees == nil) {
                            location.employees = [NSString stringWithFormat:@"%@",employeeUuid];
                        }
                        else
                        {
                            if (![location.employees containsString:employeeUuid]) {
                                
                                NSString *appendingString = [NSString stringWithFormat:@",%@",employeeUuid];
                                location.employees = [location.employees stringByAppendingString:appendingString];
                            }
                        }
                        [context save:nil];
                    }
                    
                    for (NSString *uuid in arr_inser_position) {
                        Positions *position = [DatabaseManager getPositionByUuid:uuid];
                        if (position.employees == nil) {
                            position.employees = [NSString stringWithFormat:@"%@",employeeUuid];
                        }
                        else
                        {
                            if (![position.employees containsString:employeeUuid]) {
                                
                                NSString *appendingString = [NSString stringWithFormat:@",%@",employeeUuid];
                                position.employees = [position.employees stringByAppendingString:appendingString];
                            }
                        }
                        [context save:nil];
                    }
                    
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    [self saveToEdit];
                });
            }
            return nil;
        }];
    }
    else
    {
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        [self saveToEdit];
    }
}

-(NSMutableArray *) getLocationAttriubte:(NSArray *) array andEmployeeUuid:(NSString *) employee_uuid andIsDelete:(BOOL) isdeleteItem
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
//    
//    for (NSString *uuid in array) {
//        
//        Locations *location = [DatabaseManager getLocationByUuid:uuid];
//        
//        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
//        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
//        createdate.S = location.createDate;
//        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
//        modifyDate.S = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
//        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
//        haskKeyValue.S = location.uuid;
//        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        rangeKeyValue.S = location.parentUuid;
//        AWSDynamoDBAttributeValue *namaeruuid = [AWSDynamoDBAttributeValue new];
//        namaeruuid.S = location.managerUuid;
//        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
//        isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:location.isDelete]];
//        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
//        tablename.S = @"Locations";
//        AWSDynamoDBAttributeValue *locationname = [AWSDynamoDBAttributeValue new];
//        locationname.S = location.name;
//        AWSDynamoDBAttributeValue *locationaddr = [AWSDynamoDBAttributeValue new];
//        locationaddr.S = location.address;
//        AWSDynamoDBAttributeValue *locationlatitude = [AWSDynamoDBAttributeValue new];
//        locationlatitude.S = location.latitude;
//        AWSDynamoDBAttributeValue *locationlogitude = [AWSDynamoDBAttributeValue new];
//        locationlogitude.S = location.longitude;
//        AWSDynamoDBAttributeValue *locaemployees = [AWSDynamoDBAttributeValue new];
//        NSString *temp_employees = location.employees;
//        if (isdeleteItem == YES) {
//            if ([temp_employees containsString:employee_uuid]) {
//                NSMutableArray *arr = [NSMutableArray arrayWithArray:[temp_employees componentsSeparatedByString:@","]];
//                [arr removeObject:employee_uuid];
//                if(arr.count == 0)
//                {
//                    temp_employees = nil;
//                }
//                else
//                {
//                    temp_employees = [NSString stringWithFormat:@"%@",[arr componentsJoinedByString:@","]];
//                }
//            }
//        }
//        else
//        {
//            if (temp_employees == nil) {
//                temp_employees = [NSString stringWithFormat:@"%@",employee_uuid];
//            }
//            else
//            {
//                if (![temp_employees containsString:employee_uuid]) {
//                    
//                    NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                    temp_employees = [temp_employees stringByAppendingString:appendingString];
//                }
//            }
//        }
//
//        locaemployees.S = temp_employees;
//        
//        if (temp_employees != nil) {
//            
//            writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"location_employees": locaemployees,@"createDate": createdate,@"managerUuid": namaeruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"location_name": locationname,@"location_addr": locationaddr,@"location_latitude": locationlatitude,@"location_longitude": locationlogitude};
//        }
//        else
//        {
//            writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"createDate": createdate,@"managerUuid": namaeruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"location_name": locationname,@"location_addr": locationaddr,@"location_latitude": locationlatitude,@"location_longitude": locationlogitude};
//        }
//        
//        [arr_writeRequest addObject:writeRequest];
//    }
    return arr_writeRequest;
}
-(NSMutableArray *) getPositionAttriubte:(NSArray *) array andEmployeeUuid:(NSString *) employee_uuid andIsDelete:(BOOL) isdeleteItem
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
//    for (NSString *uuid in array) {
//        
//        Positions *position = [DatabaseManager getPositionByUuid:uuid];
//        
//        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
//        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
//        createdate.S = position.createDate;
//        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
//        modifyDate.S = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
//        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
//        haskKeyValue.S = position.uuid;
//        AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
//        manageruuid.S = position.managerUuid;
//        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        rangeKeyValue.S = position.parentUuid;
//        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
//        isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.isDelete]];
//        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
//        tablename.S = @"Positions";
//        AWSDynamoDBAttributeValue *positionname = [AWSDynamoDBAttributeValue new];
//        positionname.S = position.name;
//        AWSDynamoDBAttributeValue *isFavor = [AWSDynamoDBAttributeValue new];
//        isFavor.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.isFavorite]];
//        AWSDynamoDBAttributeValue *color = [AWSDynamoDBAttributeValue new];
//        color.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithShort:position.color]];
//        AWSDynamoDBAttributeValue *positionemployees = [AWSDynamoDBAttributeValue new];
//        NSString *temp_employees = position.employees;
//        if (isdeleteItem == YES) {
//            if ([temp_employees containsString:employee_uuid]) {
//                NSMutableArray *arr = [NSMutableArray arrayWithArray:[temp_employees componentsSeparatedByString:@","]];
//                [arr removeObject:employee_uuid];
//                if(arr.count == 0)
//                {
//                    temp_employees = nil;
//                }
//                else
//                {
//                    temp_employees = [arr componentsJoinedByString:@","];
//                }
//                
//            }
//        }
//        else
//        {
//            if (temp_employees == nil) {
//                temp_employees = [NSString stringWithFormat:@"%@",employee_uuid];
//            }
//            else
//            {
//                if (![temp_employees containsString:employee_uuid]) {
//                    
//                    NSString *appendingString = [NSString stringWithFormat:@",%@",employee_uuid];
//                    temp_employees = [temp_employees stringByAppendingString:appendingString];
//                }
//            }
//        }
//        positionemployees.S = temp_employees;
//        
//        if (temp_employees != nil) {
//            
//            writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"position_employees": positionemployees,@"createDate": createdate,@"managerUuid": manageruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"position_name": positionname,@"position_isFavorite": isFavor,@"position_color": color};
//        }
//        else
//        {
//            writeRequest.putRequest.item = @{@"uuid": haskKeyValue,@"parentUuid" : rangeKeyValue,@"modifyDate": modifyDate,@"createDate": createdate,@"managerUuid": manageruuid,@"isDelete": isdelete,@"tableIdentityID": tablename,@"position_name": positionname,@"position_isFavorite": isFavor,@"position_color": color};
//        }
//        
//        [arr_writeRequest addObject:writeRequest];
//    }
    return arr_writeRequest;
}

/********************************** delete employee ****************************************/

- (IBAction)deleteEmployee:(UIButton *)sender {
    
    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    
    NSString *message = [NSString stringWithFormat:@"%@",@"Applying to join the workplace will be the only way for him to be back!"];
    
    NSArray *arr_shifts = [DatabaseManager getEmployeeShiftsEntire:employeeUuid];
    if(arr_shifts.count != 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        alertController.view.tintColor = AppMainColor;
        
        NSArray *arr = [NSArray arrayWithObjects:@"Delete All Shifts",@"Move Shifts to OpenShifts", nil];
        for (int i = 0; i < arr.count; i++) {
            
            UIAlertAction *otherButton = [UIAlertAction actionWithTitle:[arr objectAtIndex:i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                [self alertHandle:i+2];
            }];
            [alertController addAction:otherButton];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        NSString *message2 = [NSString stringWithFormat:@"Delete “%@”?",employee.fullName];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message2 message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        alertController.view.tintColor = AppMainColor;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Employee" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
            [self deleteEmployeeAllData:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)showEmployeeSchedule:(UIButton *)sender {
    [UserEntity setFilter:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"filter",employeeUuid,@"employeeUuid", nil]];
    MyScheduleViewController_phone *schedule = [MyScheduleViewController_phone new];
    [self.navigationController pushViewController:schedule animated:YES];
}

- (IBAction)showEmployeeAvailability:(UIButton *)sender {
    AvailabilityViewController_iphone *avai = [AvailabilityViewController_iphone new];
    avai.employeeUuid = employeeUuid;
    [self.navigationController pushViewController:avai animated:YES];
}

-(void) deleteEmployeeAllData:(BOOL) isDeleteEmployeeAllData
{
    [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    
    NSString *urlstring = [NSString stringWithFormat:@"%@/%@/employee/%@",api_workplace,appdelegate.currentWorkplace.uuid,employeeUuid];
    
    [HttpRequestManager requestWithType:requestType_DELETE withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data , NSHTTPURLResponse *response){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        
        NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
        NSLog(@"%@",dict);
        
        if (response.statusCode == 200) {
            
            Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
            [context deleteObject:employee];
            [context save:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withFailureBlock:^(NSError *error){
        
        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
        NSString *errorstring = [DatabaseManager serverReturnErrorMessage:error];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorstring preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
}


-(void) syncDeleteEmployee
{
    
    [self setAllFieldResignFirstResponse];
    
    Employees *employee = [DatabaseManager getEmployeeByUuid:employeeUuid];
    
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
    AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
    queryExpression.scanIndexForward = 0;
    queryExpression.indexName = @"EmailIsRegister-Index";
    
    queryExpression.keyConditionExpression = [NSString stringWithFormat:@"email = :Email"];
    queryExpression.expressionAttributeValues = @{@":Email" : employee.email};
    
    [[dynamoDBObjectMapper query:[DDBEmployeesInfoModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [KLoadingView hideKLoadingViewForView:self.view animated:NO];
                NSString *error = [DatabaseManager AWSDynamoDBErrorMessage:task.error.code];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                
                AWSDynamoDBPaginatedOutput *output = task.result;
                NSArray *arr = [NSArray arrayWithArray:output.items];
                
                if (arr.count != 0) {
                    
                    DDBEmployeesInfoModel *employeemodel = [arr objectAtIndex:0];
                    
                    DDBEmployeesInfoModel *model = [[DDBEmployeesInfoModel alloc]init];
                    model.modify_date = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
                    model.uuid = employee.uuid;
                    model.email = employee.email;
                    if (employee.headPortrait != nil) {
                        model.portrait = employeemodel.portrait;
                    }
                    
                    model.isManager = employeemodel.isManager;
                    model.isDelete = [NSNumber numberWithInt:1];
                    model.isJoinPlace = [NSNumber numberWithInt:0];
                    model.isAcceptJoined = [NSNumber numberWithInt:0];
                    model.fullname = employeemodel.fullname;
                    model.password = employeemodel.password;
                    model.phone = employeemodel.phone;
                    model.maxHoursPerWeek = employeemodel.maxHoursPerWeek;
                    [[dynamoDBObjectMapper save:model]
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
                             if ([model isKindOfClass:[DDBEmployeesInfoModel class]]) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                     NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                     
                                     [context deleteObject:employee];
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

@end
