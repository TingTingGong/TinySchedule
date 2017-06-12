//
//  HeadPortraitView.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadPortraitView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

-(void)setViewData:(NSData *)imageData andName:(NSString *)name;

@end
