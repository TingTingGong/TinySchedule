//
//  SignUpViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "SignUpViewController_iphone.h"

@interface SignUpViewController_iphone ()
{
    BOOL isEmailExist;
    NSString *emailExistedString;
    
    DDBEmployeesInfoModel *employee_model;
}
@end

@implementation SignUpViewController_iphone


-(void) getEmailState:(BOOL)isExist andString:(NSString *)exsitedString
{
    isEmailExist = isExist;
    emailExistedString = exsitedString;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (isEmailExist == YES) {
        _emailErrorLabel.hidden = NO;
        _emailErrorLabel.text = emailExistedString;
    }
    else
    {
        _emailErrorLabel.hidden = YES;
    }
    _pswErrorLabel.hidden = YES;
    
    _nextButton.frame = CGRectMake(_nextButton.frame.origin.x, _nextButton.frame.origin.y, ScreenWidth-32, _nextButton.frame.size.height);
    
    _emailLine.frame = CGRectMake(16, _emailLine.frame.origin.y, ScreenWidth-32, 1);
    _passwordLine.frame = CGRectMake(16, _passwordLine.frame.origin.y, ScreenWidth-32, 1);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_emailField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = NO;
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"press"] forState:UIControlStateHighlighted];
    
    [self setAllFieldResignFirstResponse];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_emailField]) {
        
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
        [self setAllFieldResignFirstResponse];
    }
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_emailField]) {

        if ([_emailField.text length] > 0 && [StringManager isEmpty:_emailField.text] == NO && [StringManager isValidEmail:_emailField.text] == NO) {
            _emailErrorLabel.hidden = NO;
            _emailErrorLabel.text = InternationalL(@"ValidEmail");
        }
        else
        {
            _emailErrorLabel.hidden = YES;
        }
        [_emailField resignFirstResponder];
    }
    else
    {
        if ([_passwordField.text length] > 0 && [StringManager isEmpty:_passwordField.text] == NO  && [StringManager passwordIsLeastSevenCharacters:_passwordField.text] == NO)
        {
            _pswErrorLabel.hidden = NO;
            _pswErrorLabel.text = InternationalL(@"pswValid");
        }
        else
        {
            _pswErrorLabel.hidden = YES;
        }
        [_passwordField resignFirstResponder];
    }
}


-(void) setEmailFieldBecomeFirstResponse
{
    [_emailField becomeFirstResponder];
    [_passwordField resignFirstResponder];
    _emailLabel.textColor = SetColor(47, 194, 44, 1.0);
    _emailLine.backgroundColor = SetColor(48, 194, 45, 1.0);
    _passwordLabel.textColor = SetColor(118, 118, 118, 1.0);
    _passwordLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}
-(void) setPasswordFieldBecomeFirstResponse
{
    [_emailField resignFirstResponder];
    [_passwordField becomeFirstResponder];
    _passwordLabel.textColor = SetColor(47, 194, 44, 1.0);
    _passwordLine.backgroundColor = SetColor(48, 194, 45, 1.0);
    _emailLabel.textColor = SetColor(118, 118, 118, 1.0);
    _emailLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}
-(void)setAllFieldResignFirstResponse
{
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    _emailLabel.textColor = SetColor(118, 118, 118, 1.0);
    _emailLine.backgroundColor = SetColor(230, 230, 230, 1.0);
    _passwordLabel.textColor = SetColor(118, 118, 118, 1.0);
    _passwordLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setAllFieldResignFirstResponse];
}
-(void)judgeEmailAndPassword
{
    if (([_emailField.text isEqualToString:@""] || [_emailField.text length] == 0) || [StringManager isEmpty:_emailField.text] == YES  || [StringManager isValidEmail:_emailField.text] == NO) {
        
        _emailErrorLabel.hidden = NO;
        _emailErrorLabel.text = InternationalL(@"ValidEmail");
    }
    else if (([_passwordField.text isEqualToString:@""] || [_passwordField.text length] == 0) || [StringManager isEmpty:_passwordField.text] == YES  || ([StringManager passwordIsLeastSevenCharacters:_passwordField.text] == NO))
    {
        _pswErrorLabel.hidden = NO;
        _pswErrorLabel.text = InternationalL(@"pswValid");
    }
    else
    {
        [self setAllFieldResignFirstResponse];
        
        NSString *emailstring = [_emailField.text lowercaseString];
        
        SignUp2ViewController_iphone *signup2 = [SignUp2ViewController_iphone new];
        signup2.email = [emailstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        signup2.password = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        signup2.delegate = self;
        [self.navigationController pushViewController:signup2 animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toLogIn:(UIButton *)sender {
    
    _emailField.text = @"";
    _passwordField.text = @"";

    SignInViewController_iphone *signin = [[SignInViewController_iphone alloc] init];
    [self.navigationController pushViewController:signin animated:YES];
}

- (IBAction)next:(UIButton *)sender {

    [self judgeEmailAndPassword];
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
