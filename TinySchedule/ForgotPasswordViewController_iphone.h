//
//  ForgotPasswordViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/14.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController_iphone : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailFieled;

- (IBAction)back:(UIButton *)sender;
- (IBAction)resetPassword:(UIButton *)sender;

@end
