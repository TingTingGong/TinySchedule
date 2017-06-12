//
//  FirstEnterAppViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/2.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "FirstEnterAppViewController_iphone.h"


@interface FirstEnterAppViewController_iphone ()

@end

@implementation FirstEnterAppViewController_iphone


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appdelegate.currentEmployee != nil && appdelegate.currentWorkplace == nil) {
        
        NSArray *arr_workplace = [DatabaseManager getAllWorkPlaces];
        if (arr_workplace.count == 0) {
            
            FindWorkPlaceViewController_iphone *find = [FindWorkPlaceViewController_iphone new];
            [self.navigationController pushViewController:find animated:NO];
        }
        else
        {
            WaitJoinWorkplaceViewController_iphone *wait = [WaitJoinWorkplaceViewController_iphone new];
            [self.navigationController pushViewController:wait animated:NO];
        }
    }
    
    if (ScreenWidth == 320) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 79, ScreenWidth, 307)];
        _pageControl.frame = CGRectMake(0, 79+307+10, _pageControl.frame.size.width, _pageControl.frame.size.height);
    }
    else if (ScreenWidth == 375) {
        _label1.frame = CGRectMake(0, 44, _label1.frame.size.width, 36);
        _label2.frame = CGRectMake(0, 84, _label2.frame.size.width, 21);
        _label1.font = [UIFont fontWithName:SemiboldFontName size:30.0];
        _label2.font = [UIFont fontWithName:RegularFontName size:18.0];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 155, ScreenWidth, 307)];
        _pageControl.frame = CGRectMake(0, 410, _pageControl.frame.size.width, _pageControl.frame.size.height);
    }
    else if (ScreenWidth == 414)
    {
        _label1.frame = CGRectMake(0, 52, _label1.frame.size.width, 43);
        _label2.frame = CGRectMake(0, 99, _label2.frame.size.width, 24);
        _label1.font = [UIFont fontWithName:SemiboldFontName size:36.0];
        _label2.font = [UIFont fontWithName:RegularFontName size:20.0];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth, 307)];
        _pageControl.frame = CGRectMake(0, 440, _pageControl.frame.size.width, _pageControl.frame.size.height);
    }
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    NSArray *arr_imagename = [NSArray arrayWithObjects:@"signUpBg_1",@"signUpBg_2",@"signUpBg_3", nil];
    for (int i = 0; i < arr_imagename.count; i++) {
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, _scrollView.frame.size.height);
        [btn setImage:[UIImage imageNamed:[arr_imagename objectAtIndex:i]] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        [_scrollView addSubview:btn];
    }
    
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = SetColor(0, 0, 0, 0.54);
    _pageControl.pageIndicatorTintColor = SetColor(216, 216, 216, 1.0);
    [self.view addSubview:_pageControl];
    
    _signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signUpBtn.frame = CGRectMake(16, 553, ScreenWidth-32, 54);
    [_signUpBtn setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_signUpBtn.titleLabel setAttributedText:SetAttributeText(@"Sign Up", [UIColor whiteColor], SemiboldFontName, 20.0)];
    [_signUpBtn setBackgroundImage:[UIImage imageNamed:@"signUp"] forState:UIControlStateNormal];
    [_signUpBtn addTarget:self action:@selector(toSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpBtn];
    
     NSString *str1 = @"Have an account?";
     NSString *str2 = @"Log In";
     CGSize size = [StringManager labelAutoCalculateRectWith:str1 FontSize:17.0 MaxSize:CGSizeMake(250, 20)];
     CGSize size2 = [StringManager labelAutoCalculateRectWith:str2 FontSize:17.0 MaxSize:CGSizeMake(100, 20)];
     
     _label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - size.width-size2.width)/2, 615, size.width, 20)];
    [_label setAttributedText:SetAttributeText(str1, SetColor(0, 0, 0, 0.54), RegularFontName, 17.0)];
     _label.text = str1;
    [self.view addSubview:_label];
     
    _signInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _signInBtn.frame = CGRectMake(_label.frame.origin.x+_label.frame.size.width+10, 615,size2.width+20, 20);
    [_signInBtn setTitle:str2 forState:UIControlStateNormal];
    [_signInBtn setTintColor:AppMainColor];
    [_signInBtn.titleLabel setAttributedText:SetAttributeText(@"Log In", AppMainColor, SemiboldFontName, 17.0)];
    [_signInBtn addTarget:self action:@selector(toSignIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signInBtn];
     
     if(ScreenWidth == 414)
     {
         _signUpBtn.frame = CGRectMake(16, ScreenHeight-108, ScreenWidth-32, 54);
         _label.frame = CGRectMake(_label.frame.origin.x, ScreenHeight-108+54+8, _label.frame.size.width, _label.frame.size.height);
         _signInBtn.frame = CGRectMake(_signInBtn.frame.origin.x, ScreenHeight-108+54+8, _signInBtn.frame.size.width, _signInBtn.frame.size.height);
     }
     else if (ScreenWidth == 320)
     {
         _signUpBtn.frame = CGRectMake(16, 450, ScreenWidth-32, 48);
         _label.frame = CGRectMake(56, 450+48+8, 145, _label.frame.size.height);
         _signInBtn.frame = CGRectMake(203, 450+48+8, _signInBtn.frame.size.width, _signInBtn.frame.size.height);
     }
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index=_scrollView.contentOffset.x/ScreenWidth;
    _pageControl.currentPage=index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)toSignUp{
    SignUpViewController_iphone *signup = [[SignUpViewController_iphone alloc] init];
    [self.navigationController pushViewController:signup animated:YES];
}

- (void)toSignIn{
    SignInViewController_iphone *signin = [[SignInViewController_iphone alloc] init];
    [self.navigationController pushViewController:signin animated:YES];
}
@end
