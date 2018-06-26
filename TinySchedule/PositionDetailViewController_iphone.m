//
//  PositionDetailViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/14.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "PositionDetailViewController_iphone.h"

#define scrowHeight 44
#define rowHeight1 44
#define rowHeight2 56

#define createPosition @"Create Position"

@interface PositionDetailViewController_iphone ()
{
    float interval;
    NSArray *arr_color;

    NSString *oriEmployees;
    NSString *employees;
    NSString *name;
    int colorNumber;
    UIButton *lastBtn;
    
    NSString *newPositionuuid;
}
@end

@implementation PositionDetailViewController_iphone
@synthesize uuid;

@synthesize isEmployeeSeePositionDetail;
@synthesize isCreatePosition;

-(void) getEmployees:(NSString *)myEmployees
{
    employees = myEmployees;
    [_tableView reloadData];
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        interval = 22;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    if (isEmployeeSeePositionDetail == YES) {
        _saveBtn.hidden = YES;
        _deleteBtn.hidden = YES;
        _line.hidden = YES;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee.isManager == 1 && isCreatePosition == YES) {
        _saveBtn.hidden = NO;
        _deleteBtn.hidden = YES;
        _line.hidden = YES;
        _titleLabel.text = createPosition;
    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [_textField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (isEmployeeSeePositionDetail == YES) {
        return NO;
    }
    return YES;
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([StringManager isEmpty:textField.text] && [string isEqualToString:@" "]) {
        return NO;
    }

    if (isEmployeeSeePositionDetail == YES) {
        return NO;
    }
    
    name = [_textField.text stringByAppendingString:string];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.view.backgroundColor = SetColor(250, 250, 250, 1.0);
    
    _tableView.frame = CGRectMake(0, NavibarHeight+44, _tableView.frame.size.width, ScreenHeight-NavibarHeight-50-44);
    
    newPositionuuid = [StringManager getItemID];
    
    arr_color = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5],[NSNumber numberWithInteger:6],[NSNumber numberWithInteger:7],[NSNumber numberWithInteger:8],[NSNumber numberWithInteger:9],[NSNumber numberWithInteger:10],[NSNumber numberWithInteger:11],[NSNumber numberWithInteger:12],[NSNumber numberWithInteger:12], nil];
    
    float offWidth = (arr_color.count*2 + 1) * interval;
    _scrollView.contentSize = CGSizeMake(offWidth, scrowHeight);
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, scrowHeight-1, offWidth, 0.5)];
    line.backgroundColor = SepearateLineColor;
    [_scrollView addSubview:line];
    
    Positions *position = [DatabaseManager getPositionByUuid:uuid];
    
    for (int i = 0; i < arr_color.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(interval-10+i*2*interval + 5, 11, interval, interval);
        btn.backgroundColor = [MostColor getPositionColor:[NSNumber numberWithInteger:i+1]];
        [btn setBackgroundImage:[UIImage imageNamed:@"s_color_selected"] forState:UIControlStateSelected];
        
        btn.tag = i+1;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = interval/2.0;
        [btn addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];

        if (uuid != nil) {
            
            if (position.color == btn.tag) {
                btn.selected = YES;
                lastBtn = btn;
            }
        }
        else
        {
            if(i == 0)
            {
                lastBtn = btn;
                btn.selected = YES;
                colorNumber = 1;
            }
        }
        [_scrollView addSubview:btn];
    }
    if (uuid != nil) {
        
        employees = position.employees;
        oriEmployees = position.employees;
        name = position.name;
        colorNumber = position.color;
        [_backBtn setImage:[UIImage imageNamed:@"back2_dark"] forState:UIControlStateNormal];
    }
    else
    {
        [_backBtn setImage:[UIImage imageNamed:@"back_dark"] forState:UIControlStateNormal];
    }
    [_tableView reloadData];

    // Do any additional setup after loading the view from its nib.
}

-(void)selectColor:(UIButton *)sender
{
    if (isEmployeeSeePositionDetail == NO || isCreatePosition == YES) {
        sender.selected = YES;
        lastBtn.selected = NO;
        lastBtn = sender;
        colorNumber = (int)sender.tag;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if (employees == nil || [[employees componentsSeparatedByString:@","] count] == 0) {
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
    if (indexPath.section == 1 && indexPath.row > 0) {
        return rowHeight2;
    }
    return rowHeight1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
    
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        imageview.image = [UIImage imageNamed:@"s_position_dark"];
        [cell.contentView addSubview:imageview];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 42, 16)];
        [lab setAttributedText: SetAttributeText(@"NAME", TextColorAlpha_87, SemiboldFontName, 14.0)];
         [cell.contentView addSubview:lab];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(150, 7, ScreenWidth - 166, 30)];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
        _textField.text = name;
        _textField.textColor = SetColor(0, 0, 0, 0.54);
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont fontWithName:RegularFontName size:17.0];
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [cell.contentView addSubview:_textField];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, rowHeight1-1, ScreenWidth, 0.5)];
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
            [btn_tag.titleLabel setFont:[UIFont fontWithName:RegularFontName size:17.0]];
             [btn_tag addTarget:self action:@selector(tagEmployee) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_tag];

             if (isEmployeeSeePositionDetail == YES) {
                 btn_tag.hidden = YES;
             }
            
            UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(16, rowHeight1-1, ScreenWidth, 0.5)];
            line.backgroundColor = SepearateLineColor;
            [cell.contentView addSubview:line];
        }
        else
        {
            if (uuid == nil || employees != nil) {
                
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
                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, ScreenWidth-110, rowHeight2)];
                lab.text = employee.fullName;
                lab.textColor = TextColorAlpha_54;
                lab.font = [UIFont fontWithName:RegularFontName size:17.0];
                [cell.contentView addSubview:lab];
                
                if (isEmployeeSeePositionDetail == YES) {
                    cellImageview.hidden = YES;
                    ima.frame = CGRectMake(16, ima.frame.origin.y, ima.frame.size.width, ima.frame.size.height);
                    lab.frame = CGRectMake(68, lab.frame.origin.y, lab.frame.size.width, lab.frame.size.height);
                }
                
                UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(50, rowHeight2-1, ScreenWidth-50, 0.5)];
                line.backgroundColor = SepearateLineColor;
                [cell.contentView addSubview:line];

                if(indexPath.row == arr.count)
                {
                    line.frame = CGRectMake(0, rowHeight2-1, ScreenWidth, 0.5);
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
            [_textField resignFirstResponder];
            if (indexPath.row == 0) {
                if(isEmployeeSeePositionDetail == NO || isCreatePosition == YES)
                {
                    [self tagEmployee];
                }
            }
            else
            {
                NSArray *arr = [employees componentsSeparatedByString:@","];
                Employees *employee = [DatabaseManager getEmployeeByUuid:[arr objectAtIndex:indexPath.row-1]];
                EditEmployeeViewController_iphone *edit = [[EditEmployeeViewController_iphone alloc]init];
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
        [_tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
      name = _textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    name = _textField.text;
    [_textField resignFirstResponder];
    return YES;
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
    
    _textField.text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(_textField.text != nil && [_textField.text length] > 0)
    {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        
        [KLoadingView showKLoadingViewto:self.view andText:nil animated:YES];
        
        NSString *urlstring = [NSString stringWithFormat:@"%@",api_position];
        NSString *requesttype = @"";
        NSDictionary *params = nil;
        
        if (uuid == nil) {
            requesttype = requestType_POST;
            params = @{@"name":_textField.text,@"workplaceId":appdelegate.currentWorkplace.uuid,@"color":[NSString stringWithFormat:@"%d",colorNumber]};
        }
        else
        {
            requesttype = requestType_PUT;
            urlstring = [NSString stringWithFormat:@"%@/%@",urlstring,uuid];
            params = @{@"name":_textField.text,@"color":[NSString stringWithFormat:@"%d",colorNumber]};
        }
        
        [HttpRequestManager requestWithType:requesttype withUrlString:urlstring withParaments:params withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
            
            if (response.statusCode == 200) {
                
                if (uuid == nil) {
                    Positions *position = [NSEntityDescription insertNewObjectForEntityForName:@"Positions" inManagedObjectContext:context];
                    position.uuid = [dict objectForKey:@"id"];
                    position.name = _textField.text;
                    position.color = colorNumber;
                    //position.employees = model.location_employees;
                    
                    [context save:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    Positions *position = [DatabaseManager getPositionByUuid:uuid];
                    position.name = _textField.text;
                    position.color = colorNumber;
                    //position.employees = model.location_employees;
                    
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
    else
    {
        NSString *message = [NSString stringWithFormat:@"'Name' looks empty!"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

- (IBAction)deletePosition:(UIButton *)sender {
    Positions *position = [DatabaseManager getPositionByUuid:uuid];
    
    NSString *message = [NSString stringWithFormat:@"Delete “%@”?",position.name];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    alertController.view.tintColor = AppMainColor;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete Position" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        NSString *urlstring = [NSString stringWithFormat:@"%@/%@",api_position,position.uuid];
        
        [HttpRequestManager requestWithType:requestType_DELETE withUrlString:urlstring withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
            
            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
            
            if (response.statusCode == 200) {
                
                [context deleteObject:position];
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
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
