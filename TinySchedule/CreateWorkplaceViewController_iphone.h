//
//  CreateWorkplaceViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CreateWorkplaceViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,GMSAutocompleteViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *navView;

- (IBAction)back:(UIButton *)sender;

@end
