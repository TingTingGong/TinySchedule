//
//  MyScheduleViewController_phone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShiftDetailViewController_iphone.h"
#import "FilterViewController_iphone.h"
#import "CalendarMiniView.h"
#import "LandscapeDayViewController_iphone.h"
#import "LandscapeWeekViewController_iphone.h"
#import "DropViewController_iphone.h"
#import "SwapViewController_iphone.h"
#import "GFCalendar.h"

@interface MyScheduleViewController_phone : UIViewController<UITableViewDelegate,UITableViewDataSource,TouchCalendarMiniViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titlelabel;
@property (strong, nonatomic) IBOutlet UIButton *filterBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;

@property (strong, nonatomic)  UIImageView *bgImageView;
//@property (strong, nonatomic) UITableView *tableView;//其他分类下的时间分类
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic) UIRefreshControl *refreshControl;


- (IBAction)back:(UIButton *)sender;
- (IBAction)toFilterController:(UIButton *)sender;
- (IBAction)addShift:(UIButton *)sender;

@end
