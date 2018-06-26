//
//  EditEmployeeViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/28.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagPositionViewController_iphone.h"
#import "LocationListViewController_iphone.h"

#import <MessageUI/MFMailComposeViewController.h>

#import "RMPhoneFormat.h"

@interface EditEmployeeViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TagPositionUuidDelegate,PassLocationUuidDelegate,MFMailComposeViewControllerDelegate,CNContactPickerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) NSString *employeeUuid;
@property (strong, nonatomic) NSString *defaultLocationuuid;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *scheduleBtn;
@property (strong, nonatomic) IBOutlet UIButton *avallabilityBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UILabel *bottomLine;

- (IBAction)back:(UIButton *)sender;
- (IBAction)saveEmployee:(UIButton *)sender;

- (IBAction)deleteEmployee:(UIButton *)sender;
- (IBAction)showEmployeeSchedule:(UIButton *)sender;
- (IBAction)showEmployeeAvailability:(UIButton *)sender;

@end
