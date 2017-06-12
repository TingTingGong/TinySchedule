//
//  LandscapeWeekViewController_iphone.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/11/2.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "LandscapeWeekViewController_iphone.h"

@interface LandscapeWeekViewController_iphone ()

@end

@implementation LandscapeWeekViewController_iphone

-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)deviceOrientChange:(NSNotification *)noti
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            
            break;
            
        case UIDeviceOrientationLandscapeRight:
            break;
            
        default:
            
            break;
            
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
