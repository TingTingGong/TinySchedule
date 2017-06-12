//
//  EditShiftViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationListViewController_iphone.h"
#import "PositionListViewController_iphone.h"
#import "EmployeeListViewController_iphone.h"

@interface EditShiftViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UITextFieldDelegate,PassLocationUuidDelegate,PassPositionUuidDelegate,PassEmployeeUuidDelegate>


@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UIPickerView *pickerViewTime;
@property (strong, nonatomic) UIPickerView *pickerViewUnpaid;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) UILabel *line2;
@property (strong, nonatomic) UIButton *unPublishBtn;
@property (strong, nonatomic) UIButton *deleteBtn;

- (IBAction)back:(UIButton *)sender;

- (IBAction)saveModifyShift:(UIButton *)sender;

@end
