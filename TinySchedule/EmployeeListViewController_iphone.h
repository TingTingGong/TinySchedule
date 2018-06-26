//
//  EmployeeListViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditEmployeeViewController_iphone.h"

@protocol PassEmployeeUuidDelegate <NSObject>

-(void) getEmployeeUuid:(NSString *)employeeuuid;

@end

@interface EmployeeListViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) NSString *locationuuid;
@property (strong, nonatomic) NSString *positionuuid;
@property (strong, nonatomic) NSString *employeeUuid;
@property (strong, nonatomic) NSString *startDateStamp;
@property (strong, nonatomic) NSString *startTimeStamp;
@property (strong, nonatomic) NSString *endTimeStamp;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addEmployee:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@property (strong, nonatomic) id <PassEmployeeUuidDelegate> delegate;

@end
