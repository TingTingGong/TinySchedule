//
//  SignInViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/1.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Shake.h"
#import "FindWorkPlaceViewController_iphone.h"
#import "ForgotPasswordViewController_iphone.h"

@interface SignInViewController_iphone : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordFiled;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLine;
@property (strong, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLine;
@property (strong, nonatomic) IBOutlet UILabel *passwordErrorLabel;

@property (strong, nonatomic) IBOutlet UIButton *LogInButton;
@property (strong, nonatomic) IBOutlet UIButton *gorgetBtn;

- (IBAction)back:(UIButton *)sender;
- (IBAction)toLogin:(UIButton *)sender;
- (IBAction)toForgotPasswordView:(UIButton *)sender;

@end
