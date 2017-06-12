//
//  FirstEnterAppViewController_iphone.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/2.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController_iphone.h"
#import "SignInViewController_iphone.h"
#import "WaitJoinWorkplaceViewController_iphone.h"
#import "FindWorkPlaceViewController_iphone.h"


@interface FirstEnterAppViewController_iphone : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *signUpBtn;
@property (strong, nonatomic) UIButton *signInBtn;
@property (strong, nonatomic) UILabel *label;


@end
