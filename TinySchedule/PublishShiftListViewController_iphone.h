//
//  PublishShiftListViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/2/22.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishShiftListViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *passmessage;

@property (strong, nonatomic) NSMutableArray *arr_shifts;
@property (strong, nonatomic) NSNumber *takestate;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UIButton *publishBtn;

- (IBAction)publishAllShifts:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
