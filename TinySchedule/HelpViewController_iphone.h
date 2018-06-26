//
//  HelpViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/16.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController_iphone : UIViewController<MFMailComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *feedbackView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)back:(UIButton *)sender;

@end
