//
//  AvailabilityViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvailabilityDetailViewController.h"

@interface AvailabilityViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *employeeUuid;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *createBtn;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;

- (IBAction)createAvailable:(UIButton *)sender;

-(void) initData;

- (IBAction)back:(UIButton *)sender;
- (IBAction)disposeAvailability:(UIButton *)sender;

@end
