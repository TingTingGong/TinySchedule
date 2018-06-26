//
//  ConfigurationViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/10/21.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfigurationDelegate <NSObject>

-(void) getConfigurationSetting:(NSDictionary *)dict;

@end

@interface ConfigurationViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableDictionary *dict;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITextField *textFiled;
@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) UIView *bgBlackView;
@property (strong, nonatomic) UIView *bgWhiteView;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIPickerView *effectivePickerView;
@property (strong, nonatomic) UIPickerView *effectivePickerView2;
@property (strong, nonatomic) UIPickerView *rotationPickerView;

- (IBAction)back:(UIButton *)sender;
- (IBAction)saveConfiguration:(UIButton *)sender;

@property (strong, nonatomic) id <ConfigurationDelegate> delegate;

@end
