//
//  LandscapeViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/9.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandscapeViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic)  UITableView *leftTableView;

@property (strong, nonatomic)  UITableView *rightTableView;

@property (strong, nonatomic) NSDictionary *dict_shifts;
@property (strong, nonatomic) NSDictionary *dict_filter;

/*day/today,current week,current month*/
/*all schedules,my schedule,employee,position,location,all employees,all positions,all locations,*/

@end
