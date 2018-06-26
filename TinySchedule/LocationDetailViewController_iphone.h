//
//  LocationDetailViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagEmployeeViewController_iphone.h"

@interface LocationDetailViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate,PassArraySaveEmployeeUuidDelegate>

@property (strong, nonatomic) NSString *uuid;

@property (assign, nonatomic) BOOL isEmployeeSeeDetail;
@property (assign, nonatomic) BOOL isCreateLocation;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)deleteLocation:(UIButton *)sender;

@end
