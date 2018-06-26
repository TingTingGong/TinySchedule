//
//  SaveShiftViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationListViewController_iphone.h"
#import "PositionListViewController_iphone.h"
#import "EmployeeListViewController_iphone.h"

@interface SaveShiftViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,PassLocationUuidDelegate,PassPositionUuidDelegate,PassEmployeeUuidDelegate>

@property (strong ,nonatomic) NSMutableDictionary *dict_pass;

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) UITableView *tableView;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;

@end
