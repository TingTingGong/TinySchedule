//
//  NewEmployeesViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/8.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEmployeesViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arr_newEmployees;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lab_title;

- (IBAction)back:(UIButton *)sender;

@end
