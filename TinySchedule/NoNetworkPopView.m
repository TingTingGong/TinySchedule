//
//  NoNetworkPopView.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/28.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "NoNetworkPopView.h"

#define Widht ScreenWidth-40
#define Height 60

@interface NoNetworkPopView()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIImageView *bgImageview;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIImageView *leftimage;
@property (nonatomic , strong) UIImageView *righttimage;

@end

@implementation NoNetworkPopView

+(instancetype)shareDZK{
    
    static NoNetworkPopView * sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[NoNetworkPopView alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (instancetype)showNetworkViewto:(UIView *)view andText:(NSString *)text
{
    NoNetworkPopView *networkView = [NoNetworkPopView shareDZK];
    
    if(networkView.backView==nil)
    {
        networkView.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        networkView.backView.backgroundColor = [UIColor clearColor];
        [view addSubview:networkView.backView];
        
        networkView.frame = CGRectMake((ScreenWidth-212)/2.0, ScreenHeight-64, 220, 56);
        
        [view addSubview:networkView];
    }
    
    float width = networkView.frame.size.width;
    float height = networkView.frame.size.height;
    
    if (networkView.bgImageview == nil) {
        networkView.bgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        networkView.bgImageview.image = [UIImage imageNamed:@"networkPopview_bg"];
        networkView.bgImageview.userInteractionEnabled = YES;
        [networkView addSubview:networkView.bgImageview];
    }
    
    if (networkView.titleLabel == nil) {
        networkView.titleLabel = [[UILabel alloc] init];
        networkView.titleLabel.frame = CGRectMake(0, 18, width, 16);
        networkView.titleLabel.textAlignment = NSTextAlignmentCenter;
        networkView.titleLabel.textColor = TextColorAlpha_54;
        networkView.titleLabel.font = [UIFont systemFontOfSize:14.0];
        networkView.titleLabel.text = @"Connection Failed";
        [networkView addSubview:networkView.titleLabel];
    }
    
    if (networkView.leftimage == nil) {
        networkView.leftimage = [[UIImageView alloc] initWithFrame:CGRectMake(22, 16, 20, 20)];
        networkView.leftimage.image = [UIImage imageNamed:@"networkPopview_left"];
        networkView.leftimage.userInteractionEnabled = YES;
        [networkView addSubview:networkView.leftimage];
    }
    
    if (networkView.righttimage == nil) {
        networkView.righttimage = [[UIImageView alloc] initWithFrame:CGRectMake(width-31, 21, 10, 10)];
        networkView.righttimage.image = [UIImage imageNamed:@"networkPopview_right"];
        networkView.righttimage.userInteractionEnabled = YES;
        [networkView addSubview:networkView.righttimage];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopView)];
    [networkView addGestureRecognizer:tap];
    
    return networkView;
}

+ (void) dismissPopView
{
    NoNetworkPopView *networkView = [NoNetworkPopView shareDZK];
    if (networkView.backView != nil) {
        [networkView.backView removeFromSuperview];
        [networkView removeFromSuperview];
        networkView.backView=nil;
        networkView.bgImageview = nil;
        networkView.titleLabel = nil;
        networkView.leftimage = nil;
        networkView.righttimage = nil;
    }
}


@end
