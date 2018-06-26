//
//  LoadingView.m
//  测试1
//
//  Created by TinyWorks_Dev on 16/6/13.
//  Copyright © 2016年 dzk. All rights reserved.
//

#import "KLoadingView.h"

#define Widht 64


@interface KLoadingView()

@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIImageView *loadBgImageview;


@end
@implementation KLoadingView

+(instancetype)shareDZK{
    
    static KLoadingView * sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[KLoadingView alloc] init];
    });
    return sharedAccountManagerInstance;
}

+ (instancetype)showKLoadingViewto:(UIView *)view andText:(NSString *)text animated:(BOOL)animated;
{
    KLoadingView *load = [KLoadingView shareDZK];
    
    if(load.backView==nil)
    {
        load.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        //load.backView = [[UIView alloc] initWithFrame:view.frame];
        load.backView.backgroundColor = [UIColor clearColor];
        //load.backView.alpha = 0.3;
        [view addSubview:load.backView];
        load.center = load.backView.center;
        load.bounds = CGRectMake(0, 0, Widht, Widht);
        
        load.backgroundColor = [UIColor clearColor];
        load.layer.cornerRadius = 8;
        load.layer.masksToBounds = YES;
        
        if (load.loadBgImageview == nil) {
            load.loadBgImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Widht, Widht)];
            load.loadBgImageview.image = [UIImage imageNamed:@"loadingBg"];
            [load addSubview:load.loadBgImageview];
        }
        
        [view addSubview:load];
    }
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    int count = 8;
    for (int i=0; i<count; i++) {
        NSString *filename = [NSString stringWithFormat:@"%d",i+1];
        NSString *file = [load getMyBundlePath1:filename];
        UIImage *image = [UIImage imageWithContentsOfFile:file];
        [images addObject:image];
    }
    
    
    if (load.imageView==nil) {
        load.imageView = [[UIImageView alloc] init];
        load.imageView.frame = CGRectMake((Widht-20)/2, 22, 20, 20);
        [load addSubview:load.imageView];
    }
    load.imageView.animationImages=images;
    // 设置播放次数
    load.imageView.animationRepeatCount = 0;
    
    // 设置图片
    NSString *file = [load getMyBundlePath1:@"1"];
    load.imageView.image = [UIImage imageWithContentsOfFile:file];
    
    // 设置动画的时间
    load.imageView.animationDuration = count * 0.04;
    
    // 开始动画
    [load.imageView startAnimating];
    
//    if (load.titleLabel==nil) {
//        load.titleLabel = [[UILabel alloc] init];
//        load.titleLabel.frame = CGRectMake((Widht-100)/2, load.imageView.frame.origin.y+load.imageView.frame.size.height+7.5, 100, 15);
//        load.titleLabel.textAlignment = NSTextAlignmentCenter;
//        load.titleLabel.textColor = [UIColor whiteColor];
//        load.titleLabel.font = [UIFont systemFontOfSize:12];
//        load.titleLabel.text = text;
//        [load addSubview:load.titleLabel];
//    }

    [load show:animated];
    return load;
}
+ (void)hideKLoadingViewForView:(UIView *)view animated:(BOOL)animated
{
    KLoadingView *load = [KLoadingView shareDZK];
    [load hide:YES];
}
- (NSString*)getMyBundlePath1:(NSString *)filename
{
    NSString*boundlePath= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"loading.bundle"];
    NSBundle*libBundle = [NSBundle bundleWithPath:boundlePath];
    if ( libBundle && filename ){
        
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent:filename];
        return s;
    }
    return nil ;
}

- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak KLoadingView *weakSelf = self;
        [UIView animateWithDuration:animated ?0.3: 0 animations:^{
            //weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animated ?0.3: 0 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated
{
    if (self.backView != nil) {
        __weak KLoadingView *weakSelf = self;
        [weakSelf.imageView stopAnimating];
        [weakSelf.backView removeFromSuperview];
        [weakSelf removeFromSuperview];
        weakSelf.backView=nil;
        weakSelf.imageView=nil;
        weakSelf.loadBgImageview = nil;
        weakSelf.titleLabel=nil;
        for (UIView *subview in weakSelf.subviews) {
            [subview removeAllSubviews];
        }
        weakSelf = nil;
    }
    
}



//+ (void) changeViewControllerWithAnimation
//{
//    CATransition *animation = [CATransition animation];
//    
//    animation.duration = 0.3f;
//    
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    
//    animation.fillMode = kCAFillModeForwards;
//    
//    animation.type = kCATransitionMoveIn;
//    
//    animation.subtype = kCATransitionFromRight;
//    
//    AppDelegate *a = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [a.rootController_iphone.view.layer addAnimation:animation forKey:@"animation"];
//}

@end
