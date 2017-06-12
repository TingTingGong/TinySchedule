//
//  CreateScheduleViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/31.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveShiftViewController_iphone.h"

@interface CreateScheduleViewController_iphone : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *line;

@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIImageView *dateImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *dateTitle;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UIView *timeView;
@property (strong, nonatomic) IBOutlet UIImageView *timeImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeStartTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeEndTitle;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalHoursLabel;

@property (strong, nonatomic) IBOutlet UIView *unBreakView;
@property (strong, nonatomic) IBOutlet UIImageView *unbreakImaheView;
@property (strong, nonatomic) IBOutlet UILabel *unbreakTitle;
@property (strong, nonatomic) IBOutlet UILabel *unBreakTimeLabel;

@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UIPickerView *pickerViewTime;
@property (strong, nonatomic) UIPickerView *pickerViewUnpaid;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UITableView *tableView;

- (IBAction)back:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;

@end
