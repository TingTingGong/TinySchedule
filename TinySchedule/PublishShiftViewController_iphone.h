//
//  PublishShiftViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationListViewController_iphone.h"
#import "TagPositionViewController_iphone.h"
#import "EmployeeListViewController_iphone.h"
#import "PublishShiftListViewController_iphone.h"
#import "MessageViewController.h"

@interface PublishShiftViewController_iphone : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,PassLocationUuidDelegate,PassArraySaveEmployeeUuidDelegate,TagPositionUuidDelegate,InputMessageDelegate>

@property (strong, nonatomic) IBOutlet UIView *navBarView;
@property (strong, nonatomic) UIImageView *imageview;
@property (strong, nonatomic) UIButton *publishBtn;
@property (strong, nonatomic) UIButton *recallBtn;
@property (strong, nonatomic) IBOutlet UIButton *syncBtn;
@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) IBOutlet UILabel *line;

@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *datePicker2;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)publishOrRecallShift:(UIButton *)sender;


- (IBAction)back:(UIButton *)sender;

@end
