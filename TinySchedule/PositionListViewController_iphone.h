//
//  PositionListViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/7.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionDetailViewController_iphone.h"

@protocol PassPositionUuidDelegate <NSObject>

-(void) getPositionUuid:(NSString *)positionuuid;

@end

@interface PositionListViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSString *positionUuid;

@property (strong, nonatomic) IBOutlet UILabel *line;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(UIButton *)sender;

@property (strong, nonatomic) id <PassPositionUuidDelegate> delegate;

@end
