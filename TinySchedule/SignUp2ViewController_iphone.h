//
//  SignUp2ViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindWorkPlaceViewController_iphone.h"
#import "RMPhoneFormat.h"

@protocol SignUpEmailExistedDelegate <NSObject>

-(void) getEmailState:(BOOL) isExist andString:(NSString *) exsitedString;

@end

@interface SignUp2ViewController_iphone : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *nameLine;
@property (strong, nonatomic) IBOutlet UILabel *nameErrorLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UILabel *phoneLine;
@property (strong, nonatomic) IBOutlet UILabel *phoneErrorLabel;

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)back:(UIButton *)sender;
- (IBAction)signUp:(UIButton *)sender;

@property (strong, nonatomic) id <SignUpEmailExistedDelegate> delegate;

@end
