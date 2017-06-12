//
//  PositionDetailViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/14.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagEmployeeViewController_iphone.h"

@interface PositionDetailViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PassArraySaveEmployeeUuidDelegate>

@property (strong, nonatomic) NSString *uuid;

@property (assign, nonatomic) BOOL isEmployeeSeePositionDetail;
@property (assign, nonatomic) BOOL isCreatePosition;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)deletePosition:(UIButton *)sender;


@end
