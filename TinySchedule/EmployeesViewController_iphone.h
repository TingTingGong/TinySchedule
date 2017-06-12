//
//  EmployeesViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEmployeesViewController_iphone.h"

@interface EmployeesViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIButton *addBtn;

-(void)initEmployees;

- (IBAction)back:(UIButton *)sender;
- (IBAction)addEmployee:(UIButton *)sender;

@end
