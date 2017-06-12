//
//  DashBoardViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/18.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstEnterAppViewController_iphone.h"
#import "MyScheduleViewController_phone.h"
#import "ShiftDetailViewController_iphone.h"
#import "CreateScheduleViewController_iphone.h"
#import "RequestViewController_phone.h"
#import "AvailabilityViewController_iphone.h"
#import "KnowledgeShiftViewController_iphone.h"
#import "HeadPortraitView.h"
#import "AppDelegate.h"


@interface DashBoardViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITableView *leftTableview;
@property (strong, nonatomic) UITableView *rightTableview;

@property (strong , nonatomic) UIRefreshControl *refreshControl;

- (IBAction)showSidebar:(UIButton *)sender;
- (IBAction)createShift:(UIButton *)sender;

-(void) initData;

@end
