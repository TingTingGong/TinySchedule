//
//  LocationsViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationDetailViewController_iphone.h"

@interface LocationsViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) UIRefreshControl *refreshControl;

-(void)initData;

- (IBAction)back:(UIButton *)sender;
- (IBAction)addlocation:(UIButton *)sender;

@end
