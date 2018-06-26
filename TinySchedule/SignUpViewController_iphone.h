//
//  SignUpViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp2ViewController_iphone.h"
#import "SignInViewController_iphone.h"

@interface SignUpViewController_iphone : UIViewController<UITextFieldDelegate,SignUpEmailExistedDelegate>

@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;

@property (strong, nonatomic) IBOutlet UILabel *emailLine;
@property (strong, nonatomic) IBOutlet UILabel *passwordLine;


@property (strong, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (strong, nonatomic) IBOutlet UILabel *pswErrorLabel;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *logInBtn;
@property (strong, nonatomic) IBOutlet UILabel *label;

- (IBAction)toLogIn:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;


@end
