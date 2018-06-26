//
//  FindWorkPlaceViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/18.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWorkplaceViewController_iphone.h"
#import "SearchWorkPlaceViewController_iphone.h"
#import "WaitJoinWorkplaceViewController_iphone.h"
#import "FirstEnterAppViewController_iphone.h"

@interface FindWorkPlaceViewController_iphone : UIViewController

@property (assign, nonatomic)  BOOL isBack;

@property (strong, nonatomic)  UIButton *joinBtn;
@property (strong, nonatomic)  UIButton *createBtn;
@property (strong, nonatomic)  UILabel *line;

@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;


- (IBAction)logOut:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
