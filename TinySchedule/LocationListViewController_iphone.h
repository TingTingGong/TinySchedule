//
//  LocationListViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/11.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationDetailViewController_iphone.h"

@protocol PassLocationUuidDelegate <NSObject>

-(void) getlocationUuid:(NSMutableArray *) arr_locationuuid;

@end

@interface LocationListViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *locationUuid;
@property (strong, nonatomic) NSString *employeeuuid;
@property (strong, nonatomic) NSMutableArray *arr_selectLocationuuid;
@property (assign, nonatomic) BOOL notModifyPrifileViewPassArray;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(UIButton *)sender;

@property (strong, nonatomic) id <PassLocationUuidDelegate> delegate; 

@end
