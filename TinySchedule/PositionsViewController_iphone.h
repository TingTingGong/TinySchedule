//
//  PositionsViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/6.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionDetailViewController_iphone.h"

@interface PositionsViewController_iphone : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) IBOutlet UIView *navbarView;

-(void) initData;

- (IBAction)back:(UIButton *)sender;
- (IBAction)addposition:(UIButton *)sender;

@end
