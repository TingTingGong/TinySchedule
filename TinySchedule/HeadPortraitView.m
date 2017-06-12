//
//  HeadPortraitView.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/19.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "HeadPortraitView.h"

@implementation HeadPortraitView
@synthesize imageView;
@synthesize label;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.backgroundColor = [UIColor greenColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 15.0;
        [self addSubview:imageView];
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 30, 15)];
        label.textColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:10.0];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

-(void)setViewData:(NSData *)imageData andName:(NSString *)name
{
    if (imageData) {
        imageView.image = [UIImage imageWithData:imageData];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"3.png"];
    }
    label.text = name;
}

@end
