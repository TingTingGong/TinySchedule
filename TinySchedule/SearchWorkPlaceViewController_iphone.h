//
//  SearchWorkPlaceViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitJoinWorkplaceViewController_iphone.h"
@class WorkPlaces;


@interface SearchWorkPlaceViewController_iphone : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITextField *textField;
@property (strong ,nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
