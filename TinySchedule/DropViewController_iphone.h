//
//  DropViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/30.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShiftDetailViewController_iphone.h"

@interface DropViewController_iphone : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *category;//0-drop  1-assign/offer  2-find replace
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *dropuuid;
@property (assign, nonatomic) BOOL isShowShiftDetail;

@property (strong, nonatomic) IBOutlet UIView *shiftView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UIImageView *portraitView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shiftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UILabel *tableHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *line1;
@property (strong, nonatomic) IBOutlet UILabel *potentialTakerBtn;

@property (strong, nonatomic) UIButton *selectAllBtn;
@property (strong, nonatomic) UIButton *selectNoneBtn;
@property (strong, nonatomic) UIButton *cancelRequestBtn;
@property (strong, nonatomic) UIButton *acceptBtn;
@property (strong, nonatomic) UIButton *declineBtn;

@property (strong, nonatomic) IBOutlet UIButton *showShiftDetailBtn;

- (IBAction)back:(UIButton *)sender;
- (IBAction)send:(UIButton *)sender;
- (IBAction)seeShiftDetail:(UIButton *)sender;

@end
