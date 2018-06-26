//
//  CreateRequestViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/22.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateRequestViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) IBOutlet UILabel *line;

- (IBAction)back:(UIButton *)sender;
- (IBAction)sendRequest:(UIButton *)sender;

@end
