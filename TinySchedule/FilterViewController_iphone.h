//
//  FilterViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterEmployeeViewController_iphone.h"


@interface FilterViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(UIButton *)sender;

@end
