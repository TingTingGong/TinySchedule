//
//  ShiftDetailViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditShiftViewController_iphone.h"
#import "SwapViewController_iphone.h"
#import "DropViewController_iphone.h"

@interface ShiftDetailViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (assign, nonatomic) BOOL notEditShift;

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *swapOriPositionuuid;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *line2;
@property (strong, nonatomic) UIButton *notifyBtn;
@property (strong, nonatomic) UIButton *replaceBtn;
@property (strong, nonatomic) UIButton *takeBtn;
@property (strong, nonatomic) UIButton *employeeTakeBtn;
@property (strong, nonatomic) UIButton *assignBtn;
@property (strong, nonatomic) UIButton *swapBtn;
@property (strong, nonatomic) UIButton *dropBtn;
@property (strong, nonatomic) UIButton *requestBtn;
@property (strong, nonatomic) UIButton *publishBtn;

- (IBAction)editShift:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
