//
//  AvailabilityDetailViewController.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/21.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigurationViewController_iphone.h"

@interface AvailabilityDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,ConfigurationDelegate>

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *employeeuuid;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UIImageView *preferrImageView;
@property (strong, nonatomic) UIButton *preferBtn;
@property (strong, nonatomic) UIButton *unavailabilityBtn;
@property (strong, nonatomic) UIButton *allDayButton;
@property (strong, nonatomic) UIPickerView *pickerViewTime;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)toConfiguration:(UIButton *)sender;

@end
