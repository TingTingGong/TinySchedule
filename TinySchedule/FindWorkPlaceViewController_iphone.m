//
//  FindWorkPlaceViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/18.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "FindWorkPlaceViewController_iphone.h"

#define typePickerHeight 160

@interface FindWorkPlaceViewController_iphone ()

@end

@implementation FindWorkPlaceViewController_iphone
@synthesize isBack;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //arr_joinedWorkplace = [NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}
-(void )viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (isBack == YES) {
        _backBtn.hidden = NO;
        _logoutBtn.hidden = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        _backBtn.hidden = YES;
        _logoutBtn.hidden = NO;
    }
    
    _joinBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _joinBtn.frame = CGRectMake(0, 151, (ScreenWidth-1)/2, 20);
    [self.view addSubview:_joinBtn];
    [_joinBtn addTarget:self action:@selector(joinWorkplace:) forControlEvents:UIControlEventTouchUpInside];
    _line = [[UILabel alloc] initWithFrame:CGRectMake(177, 153, 1, 20)];
    _line.backgroundColor = SetColor(0, 0, 0, 0.1);
    [self.view addSubview:_line];
    _createBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _createBtn.frame = CGRectMake((ScreenWidth-1)/2+1, 151, (ScreenWidth-1)/2, 20);
    [self.view addSubview:_createBtn];
    [_createBtn addTarget:self action:@selector(createWorkplace:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(16, _joinBtn.frame.origin.y, _joinBtn.frame.size.width-16, _joinBtn.frame.size.height)];
    [lab1 setAttributedText:SetAttributeText(@"Join a workplace", AppMainColor, SemiboldFontName, 17.0)];
    [self.view addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-179, _joinBtn.frame.origin.y, 163, _joinBtn.frame.size.height)];
    lab2.textAlignment = NSTextAlignmentRight;
    [lab2 setAttributedText:SetAttributeText(@"Create a workplace", AppMainColor, SemiboldFontName, 17.0)];
    [self.view addSubview:lab2];
     
    if(ScreenWidth < 375)
    {
        _joinBtn.frame = CGRectMake(0, 128, (ScreenWidth-1)/2, 18);
        lab1.frame = CGRectMake(16, _joinBtn.frame.origin.y, _joinBtn.frame.size.width-16, _joinBtn.frame.size.height);
        lab1.font = [UIFont boldSystemFontOfSize:15.0];
         _line.frame = CGRectMake(151, 129, 1, 16);
         _createBtn.frame =CGRectMake((ScreenWidth-1)/2+1, 128, (ScreenWidth-1)/2, 18);
         lab2.frame = CGRectMake(ScreenWidth-160, _joinBtn.frame.origin.y, 144, _joinBtn.frame.size.height);
        lab2.font = [UIFont boldSystemFontOfSize:15.0];
          lab2.textAlignment = NSTextAlignmentRight;
    }
    else if(ScreenWidth == 414)
    {
         _joinBtn.frame = CGRectMake(0, 147, (ScreenWidth-1)/2, 24);
         lab1.frame = CGRectMake(16, _joinBtn.frame.origin.y, _joinBtn.frame.size.width-16, _joinBtn.frame.size.height);
         [lab1 setAttributedText:SetAttributeText(@"Join a workplace", AppMainColor, SemiboldFontName, 20.0)];
          _line.frame = CGRectMake(195, 149, 1, 20);
          _createBtn.frame =CGRectMake((ScreenWidth-1)/2+1, 147, (ScreenWidth-1)/2, 24);
          lab2.frame = CGRectMake(ScreenWidth-208, _joinBtn.frame.origin.y, 192, _joinBtn.frame.size.height);
          [lab2 setAttributedText:SetAttributeText(@"Create a workplace", AppMainColor, SemiboldFontName, 20.0)];
        lab2.textAlignment = NSTextAlignmentRight;
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)joinWorkplace:(UIButton *)sender {
    
    SearchWorkPlaceViewController_iphone *search = [SearchWorkPlaceViewController_iphone new];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)createWorkplace:(UIButton *)sender {
    CreateWorkplaceViewController_iphone *create = [CreateWorkplaceViewController_iphone new];
    [self.navigationController pushViewController:create animated:YES];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logOut:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log out?" message:@"Sure to log out?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:InternationalL(@"cancel") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [UserEntity loginOut];
//        NSArray *arr = [NSArray arrayWithArray:self.navigationController.viewControllers];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:arr.count-1] animated:YES];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[FirstEnterAppViewController_iphone class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)back:(UIButton *)sender {
}


@end
