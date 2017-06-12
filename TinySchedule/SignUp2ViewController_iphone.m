//
//  SignUp2ViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#define ACCEPTABLE_CHARECTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

#import "SignUp2ViewController_iphone.h"

@interface SignUp2ViewController_iphone ()
{
    NSString *myuuid;
    
    RMPhoneFormat *phoneFormat;
    NSMutableCharacterSet *phoneChars;
}
@end

@implementation SignUp2ViewController_iphone
@synthesize email;
@synthesize password;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    _nameErrorLabel.hidden = YES;
    _phoneErrorLabel.hidden = YES;
    
    _signUpButton.frame = CGRectMake(_signUpButton.frame.origin.x, _signUpButton.frame.origin.y, ScreenWidth-32, _signUpButton.frame.size.height);
    
    [_nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    
    _nameLine.frame = CGRectMake(16, _nameLine.frame.origin.y, ScreenWidth-32, 1);
    _phoneLine.frame = CGRectMake(16, _phoneLine.frame.origin.y, ScreenWidth-32, 1);

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_nameField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_signUpButton setBackgroundImage:[UIImage imageNamed:@"press"] forState:UIControlStateHighlighted];
    
    myuuid = [StringManager getItemID];
    
    phoneFormat = [[RMPhoneFormat alloc] init];
    phoneChars = [[NSCharacterSet decimalDigitCharacterSet] mutableCopy];
    [phoneChars addCharactersInString:@"+*#,"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_nameField]) {
        
        [self setNameFieldBecomeFirstResponse];
    }
    else
    {
        [self setPhoneFieldBecomeFirstResponse];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_nameField]) {
        
        [self setPhoneFieldBecomeFirstResponse];
    }
    else
    {
        [self setAllFieldResignFirstResponse];
    }
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_nameField]) {

        _nameField.text = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([_nameField.text length] > 0 && [StringManager isEmpty:_nameField.text] == NO && [StringManager isValidUserFullName:_nameField.text] == NO) {
            _nameErrorLabel.hidden = NO;
            _nameErrorLabel.text = InternationalL(@"fullName");
        }
        else
        {
            _nameErrorLabel.hidden = YES;
        }
        [_nameField resignFirstResponder];
    }
    else
    {
        _phoneField.text = [_phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([_phoneField.text length] != 0) {
            _phoneErrorLabel.hidden = YES;
        }
    }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_nameField]) {
        if (![ACCEPTABLE_CHARECTERS containsString:string] && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    else if ([textField isEqual:_phoneField])
    {
        // For some reason, the 'range' parameter isn't always correct when backspacing through a phone number
        // This calculates the proper range from the text field's selection range.
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


-(void) setNameFieldBecomeFirstResponse
{
    [_nameField becomeFirstResponder];
    [_phoneField resignFirstResponder];
    _nameLabel.textColor = SetColor(47, 194, 44, 1.0);;
    _nameLine.backgroundColor = SetColor(48, 194, 45, 1.0);;
    _phoneLabel.textColor = SetColor(118, 118, 118, 1.0);
    _phoneLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}
-(void) setPhoneFieldBecomeFirstResponse
{
    [_nameField resignFirstResponder];
    [_phoneField becomeFirstResponder];
    _phoneLabel.textColor = SetColor(47, 194, 44, 1.0);;
    _phoneLine.backgroundColor = SetColor(48, 194, 45, 1.0);;
    _nameLabel.textColor = SetColor(118, 118, 118, 1.0);
    _nameLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}
-(void)setAllFieldResignFirstResponse
{
    [_nameField resignFirstResponder];
    [_phoneField resignFirstResponder];
    _nameLabel.textColor = SetColor(118, 118, 118, 1.0);
    _nameLine.backgroundColor = SetColor(230, 230, 230, 1.0);
    _phoneLabel.textColor = SetColor(118, 118, 118, 1.0);
    _phoneLine.backgroundColor = SetColor(230, 230, 230, 1.0);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setAllFieldResignFirstResponse];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//register -> get token -> get current employee into
- (IBAction)signUp:(UIButton *)sender {
    
    _nameField.text = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _phoneField.text = [_phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self setAllFieldResignFirstResponse];
    
    if ([_nameField.text isEqualToString:@""] || [_nameField.text length] == 0 || [StringManager isEmpty:_nameField.text] == YES  || [StringManager isValidUserFullName:_nameField.text] == NO) {
        _nameErrorLabel.hidden = NO;
        _nameErrorLabel.text = InternationalL(@"fullName");
    }
    else if ([_phoneField.text isEqualToString:@""] || [_phoneField.text length] == 0  || [StringManager isEmpty:_phoneField.text] == YES)
    {
        _phoneErrorLabel.hidden = NO;
        _phoneErrorLabel.text = InternationalL(@"phone");
    }
    else
    {
        if (_phoneField.textColor != [UIColor redColor]) {
            
            [KLoadingView showKLoadingViewto:self.view andText:@"Loading" animated:YES];
            
            _nameErrorLabel.hidden = YES;
            _phoneErrorLabel.hidden = YES;
            
            //register
            [HttpRequestManager requestWithType:requestType_POST withUrlString:api_employee withParaments:@{@"password":password,@"email":email,@"fullName":_nameField.text,@"phoneNumber":_phoneField.text} withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                
                //get token
                if (response.statusCode == 200) {
                    
                    [HttpRequestManager requestWithType:nil withUrlString:api_token withParaments:@{@"username":email,@"password":password,@"grant_type":@"password",@"client_id":@"frontend"} withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                        
                        //get current employee basic infomation
                        if (response.statusCode == 200) {
                            
                            NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
                            [UserEntity setLogInSuccessfullyToken:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"token_type"],[dict objectForKey:@"access_token"]]];
                            
                            [HttpRequestManager requestWithType:requestType_GET withUrlString:api_employee withParaments:nil withSuccessBlock:^(NSData *data,NSHTTPURLResponse *response){
                                
                                [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                                NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
                                
                                //next,push into create/join workplace
                                if (response.statusCode == 200) {
                                    
                                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                    CurrentEmployee *cuemployee = [NSEntityDescription insertNewObjectForEntityForName:@"CurrentEmployee" inManagedObjectContext:context];
                                    cuemployee.uuid = [dict objectForKey:@"id"];
                                    cuemployee.email = [dict objectForKey:@"email"];
                                    cuemployee.password = password;
                                    cuemployee.fullName = [dict objectForKey:@"fullName"];
                                    cuemployee.phone = [dict objectForKey:@"phoneNumber"];
                                    [context save:nil];
                                    
                                    appDelegate.currentEmployee = cuemployee;
                                    
                                    FindWorkPlaceViewController_iphone *find = [FindWorkPlaceViewController_iphone new];
                                    [self.navigationController pushViewController:find animated:YES];
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
                //email already registed
                else
                {
                    [KLoadingView hideKLoadingViewForView:self.view animated:YES];
                    
                    NSDictionary *dict = [DatabaseManager dictionaryWithJsondata:data];
                    NSString *error = [NSString stringWithFormat:@"%@",[dict objectForKey:@"error"]];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                        [self.delegate getEmailState:YES andString:error];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
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
}

@end
