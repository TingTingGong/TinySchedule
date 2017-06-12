//
//  FilterEmployeeViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/12.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterEmployeeViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UILabel *line2;
@property (strong, nonatomic) IBOutlet UILabel *line3;
@property (strong, nonatomic) IBOutlet UIButton *excludeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *excludeImage;
@property (strong, nonatomic) IBOutlet UIButton *includeBtn;

@property (strong ,nonatomic) UITableView *tableView;

- (IBAction)excludeAll:(UIButton *)sender;
- (IBAction)includeAll:(id)sender;
- (IBAction)back:(UIButton *)sender;
- (IBAction)dismiss:(UIButton *)sender;


@end
