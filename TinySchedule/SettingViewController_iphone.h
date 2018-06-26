//
//  SettingViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkPlacesViewController_iphone.h"
#import "EditEmployeeViewController_iphone.h"
#import "AlertViewController_iphone.h"
#import "PublishShiftViewController_iphone.h"
#import "HelpViewController_iphone.h"

@interface SettingViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void) initData;

- (IBAction)back:(UIButton *)sender;

@end
