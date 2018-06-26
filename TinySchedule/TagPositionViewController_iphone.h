//
//  TagPositionViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/16.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionDetailViewController_iphone.h"

@protocol TagPositionUuidDelegate <NSObject>

-(void) getTagPositionUuid:(NSMutableArray *) arr_position_uuid;

@end

@interface TagPositionViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *employeeuuid;
@property (strong, nonatomic) NSMutableArray *arr_selectPositionuuid;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL notModifyPrifileViewPassArray;

- (IBAction)back:(UIButton *)sender;

@property (strong, nonatomic) id <TagPositionUuidDelegate> delegate;

@end
