//
//  LandscapeDayViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/2.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandscapeDayViewController_iphone : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong , nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic)  UITableView *leftTableView;

@property (strong, nonatomic)  UITableView *rightTableView;

@property (strong, nonatomic) NSDictionary *dict_shifts;
@property (strong, nonatomic) NSDictionary *dict_filter;

@end
