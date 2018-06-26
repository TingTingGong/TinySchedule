//
//  SignInViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/1.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SignInViewController_iphone.h"


@interface SignInViewController_iphone ()

@end

@implementation SignInViewController_iphone

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    
    _emailErrorLabel.hidden = YES;
    _passwordErrorLabel.hidden = YES;
    
    _LogInButton.frame = CGRectMake(_LogInButton.frame.origin.x, _LogInButton.frame.origin.y, ScreenWidth-32, _LogInButton.frame.size.height);
    
    _emailLine.frame = CGRectMake(16, _emailLine.frame.origin.y, ScreenWidth-32, 1);
    _passwordLine.frame = CGRectMake(16, _passwordLine.frame.origin.y, ScreenWidth-32, 1);
    
    _emailField.text = @"";
    _passwordFiled.text = @"";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [_emailField resignFirstResponder];
    [_passwordFiled resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.tintColor = AppMainColor;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _passwordFiled.tintColor = AppMainColor;
    
    _LogInButton.layer.borderWidth = 2.0;
    _LogInButton.layer.borderColor = [AppMainColor CGColor];
    _LogInButton.layer.masksToBounds = YES;
    _LogInButton.layer.cornerRadius = 10.0;
    
    [_LogInButton setBackgroundImage:[UIImage imageNamed:@"press"] forState:UIControlStateHighlighted];
    
    [self setAllFieldResignFirstResponse];

    // Do any additional setup after loading the view from its nib.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_emailField]) {
        
        _emailErrorLabel.hidden = YES;
        [self setEmailFieldBecomeFirstResponse];
    }
    else
    {
        [self setPasswordFieldBecomeFirstResponse];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_emailField]) {
        
        [self setPasswordFieldBecomeFirstResponse];
    }
    else
    {
        [self judgeEmailAndPassword];
    }
    return YES;
}

-(void) setEmailFieldBecomeFirstResponse
{
    [_emailField becomeFirstResponder];
    [_passwordFiled resignFirstResponder];
    _emailLabel.textColor = AppMainColor;
    _emailLine.backgroundColor = AppMainColor;
    _passwordLabel.textColor = [UIColor darkGrayColor];
    _passwordLine.backgroundColor = SetColor(240, 240, 240, 1.0);
}
-(void) setPasswordFieldBecomeFirstResponse
{
    [_passwordFiled becomeFirstResponder];
    _passwordLabel.textColor = AppMainColor;
    _passwordLine.backgroundColor = AppMainColor;
    _emailLabel.textColor = [UIColor darkGrayColor];
    _emailLine.backgroundColor = SetColor(240, 240, 240, 1.0);
}
-(void) setPasswordFieldBecomeFirstResponse2
{
    [_passwordFiled resignFirstResponder];
    [_passwordFiled shake];
    _passwordErrorLabel.hidden = NO;
    _passwordFiled.text = @"";
    _passwordLabel.textColor = SetColor(230, 85, 85, 1.0);
    _passwordLine.backgroundColor = SetColor(230, 85, 85, 1.0);
}
-(void)setAllFieldResignFirstResponse
{
    [_emailField resignFirstResponder];
    [_passwordFiled resignFirstResponder];
    _emailLabel.textColor = [UIColor darkGrayColor];
    _emailLine.backgroundColor = SetColor(240, 240, 240, 1.0);
    _passwordLabel.textColor = [UIColor darkGrayColor];
    _passwordLine.backgroundColor = SetColor(240, 240, 240, 1.0);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setAllFieldResignFirstResponse];
}

//is not register ---> prompt to register
//is register -> get token -> get curent employee infomation -> get current employee all workplace
-(void) judgeEmailAndPassword
{
    NSString *emailstring = [_emailField.text lowercaseString];
    emailstring = [emailstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordstring = [_passwordFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [_emailField resignFirstResponder];
    [_passwordFiled resignFirstResponder];
    
    if (_emailField.text.length == 0 || [self.emailField.text isEqualToString:@""] || [StringManager isEmpty:_emailField.text] == YES || _passwordFiled.text.length == 0 || [_passwordFiled.text isEqualToString:@""] || [StringManager isEmpty:_passwordFiled.text] == YES || [StringManager isValidEmail:self.emailField.text] == NO) {

        [self.emailField shake];
        [self.passwordFiled shake];
        
        if ([_emailField.text length] > 0 && [StringManager isValidEmail:self.emailField.text] == NO) {
            _emailErrorLabel.hidden = NO;
        }
    }
    else if (_emailField.text.length > 0 && ![self.emailField.text isEqualToString:@""] && [StringManager isEmpty:_emailField.text] == NO && [StringManager isValidEmail:self.emailField.text] == NO) {

        [self.emailField shake];
        _emailErrorLabel.hidden = NO;
    }
    else if(_passwordFiled.text.length == 0 || [_passwordFiled.text isEqualToString:@""] || [StringManager isEmpty:_passwordFiled.text] == YES) {

        [self.passwordFiled shake];
    }
    else
    {
        _emailErrorLabel.hidden = YES;
        _passwordErrorLabel.hidden = YES;
        
        [UserEntity loginOut];
        
        [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
        
        //judge email is or not register
        //get token
        [HttpRequestManager requestWithType:nil withUrlString:api_token withParaments:@{@"username":emailstring,@"password":passwordstring,@"grant_type":@"password",@"client_id":@"frontend"} withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
            
            //get current employee basic infomation
            
            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
            
            if (response.statusCode == 200) {
                
                [UserEntity setLogInSuccessfullyToken:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"token_type"],[dict objectForKey:@"access_token"]]];
                
                [HttpRequestManager requestWithType:requestType_GET withUrlString:api_employee withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                    
                    NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
                    
                    //email & password is correct
                    if (response.statusCode == 200) {
                        
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        NSManagedObjectContext *context = [appDelegate managedObjectContext];
                        CurrentEmployee *cuemployee = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentEmployee" inManagedObjectContext:context];
                        cuemployee.uuid = [dict objectForKey:@"id"];
                        cuemployee.email = [dict objectForKey:@"email"];
                        cuemployee.password = passwordstring;
                        cuemployee.fullName = [dict objectForKey:@"fullName"];
                        cuemployee.phone = [dict objectForKey:@"phoneNumber"];
                        
                        appDelegate.currentEmployee = cuemployee;
                        [context save:nil];
                        
                        //get all workplaces
                        [HttpRequestManager requestWithType:requestType_GET withUrlString:api_employeeWorkplaces withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                            
                            [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                            NSMutableArray *arr_workplaces = (NSMutableArray *)[DatabaseManager dictionaryWithJsondata:data];
                            
                            if (response.statusCode == 200) {
                                
                                if (arr_workplaces.count == 0) {
                                    
                                    FindWorkPlaceViewController_iphone *find = [FindWorkPlaceViewController_iphone new];
                                    [self.navigationController pushViewController:find animated:YES];
                                }
                                else
                                {
                                    //save workplace and push into waitting workpalce view controller
                                    for (NSDictionary *dict in arr_workplaces) {
                                        WorkPlaces *workplace = [NSEntityDescription insertNewObjectForEntityForName:@"WorkPlaces" inManagedObjectContext:context];
                                        workplace.uuid = [dict objectForKey:@"id"];
                                        workplace.name = [dict objectForKey:@"name"];
                                        workplace.isCreator = [[dict objectForKey:@"isCreator"] intValue];
                                        workplace.isPermitted = [[dict objectForKey:@"isPermitted"] intValue];
                                        workplace.type = [[dict objectForKey:@"type"] intValue];
                                        workplace.address = [dict objectForKey:@"address"];
                                        [context save:nil];
                                    }
                                    WaitJoinWorkplaceViewController_iphone *waitting = [WaitJoinWorkplaceViewController_iphone new];
                                    [self.navigationController pushViewController:waitting animated:YES];
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
                        [KLoadingView hideKLoadingViewForView:self.view animated:YES];
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
                /*
                 {
                 error = "invalid_grant";
                 "error_description" = "invalid_username_or_password";
                 }
                 */
                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                _passwordErrorLabel.hidden = NO;
                [_passwordFiled shake];
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

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([_emailField.text length] > 0 && [StringManager isValidEmail:self.emailField.text] == NO) {
        _emailErrorLabel.hidden = NO;
    }
    else if ([textField isEqual:_passwordFiled]) {
        _passwordErrorLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toLogin:(UIButton *)sender {
    
    [_emailField resignFirstResponder];
    [_passwordFiled resignFirstResponder];
    [self judgeEmailAndPassword];
    
}

- (IBAction)toForgotPasswordView:(UIButton *)sender {
    ForgotPasswordViewController_iphone *forgot = [ForgotPasswordViewController_iphone new];
    [self.navigationController pushViewController:forgot animated:YES];
}

@end
