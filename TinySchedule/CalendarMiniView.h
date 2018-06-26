//
//  CalendarMiniView.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/13.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchCalendarMiniViewDelegate <NSObject>

-(void)touchView;

@end

@interface CalendarMiniView : UIView

@property (assign , nonatomic) id <TouchCalendarMiniViewDelegate> delegate;

@end
