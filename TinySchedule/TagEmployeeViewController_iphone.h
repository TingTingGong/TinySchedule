//
//  TagEmployeeViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/15.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassArraySaveEmployeeUuidDelegate <NSObject>

-(void) getEmployees:(NSString *) myEmployees;

@end

@interface TagEmployeeViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *category;//0-location  1-position
@property (strong, nonatomic) NSString *employees;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(UIButton *)sender;
- (IBAction)save:(UIButton *)sender;

@property (strong, nonatomic) id <PassArraySaveEmployeeUuidDelegate> delegate;

@end
