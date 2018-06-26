//
//  WaitJoinWorkplaceViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/4.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchWorkPlaceViewController_iphone.h"
#import "FirstEnterAppViewController_iphone.h"

@class WorkPlaces;

@interface WaitJoinWorkplaceViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) BOOL isPopTwoViewControl;

@property (strong, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)logout:(UIButton *)sender;
- (IBAction)findOtherWorkpalce:(UIButton *)sender;


@end
