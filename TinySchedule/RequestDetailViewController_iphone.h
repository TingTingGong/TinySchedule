//
//  RequestDetailViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/12/5.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestDetailViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image_portrait;
@property (strong, nonatomic) IBOutlet UILabel *label_name;
@property (strong, nonatomic) IBOutlet UILabel *label_state;
@property (strong, nonatomic) IBOutlet UILabel *label_type;
@property (strong, nonatomic) IBOutlet UILabel *label_paidhours;
@property (strong, nonatomic) IBOutlet UILabel *label_timeInterval;

@property (strong, nonatomic) IBOutlet UILabel *line1;
@property (strong, nonatomic) IBOutlet UILabel *line2;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *approveBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *employeeCancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@property (strong, nonatomic) IBOutlet UILabel *leaveTimeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *paidHourTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *paidHourContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *paidHourLine;
@property (strong, nonatomic) IBOutlet UILabel *messageTitleLabel;


@property (strong, nonatomic) IBOutlet UIImageView *l_line2;
@property (strong, nonatomic) IBOutlet UIImageView *l_line3;
@property (strong, nonatomic) IBOutlet UIImageView *l_line4;

@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UITableView *historyTableView;

- (IBAction)showHistoryState:(UIButton *)sender;

- (IBAction)employeeInfoBtn:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;
- (IBAction)approveRequest:(UIButton *)sender;
- (IBAction)cancelRequest:(UIButton *)sender;
- (IBAction)deleteRequest:(UIButton *)sender;


@end
