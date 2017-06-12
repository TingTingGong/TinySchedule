//
//  RequestViewController_phone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestDetailViewController_iphone.h"
#import "CreateRequestViewController_iphone.h"
#import "DropViewController_iphone.h"
#import "SwapViewController_iphone.h"

@interface RequestViewController_phone : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void)initData_request;
- (IBAction)back:(UIButton *)sender;
- (IBAction)createRequest:(UIButton *)sender;

@end
