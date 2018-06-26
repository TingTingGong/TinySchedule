//
//  CalendarMiniView.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/13.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "CalendarMiniView.h"

@implementation CalendarMiniView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSArray *array = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
        
        float weekWidth = 30;
        float interval = ScreenWidth/7;
        
        for (int i = 0; i < array.count; i++) {
            UILabel *week = [[UILabel alloc] init];
            week.text     = array[i];
            week.font     = [UIFont systemFontOfSize:12];
            week.frame    = CGRectMake(i * interval, 0, interval, 30);
            week.textAlignment   = NSTextAlignmentCenter;
            week.backgroundColor = [UIColor clearColor];
            week.textColor = SetColor(167, 208, 172, 1.0);
            [self addSubview:week];
        }
        
        float dayWidth = ScreenWidth/7;
        NSArray *arr_week = [StringManager getSevenDaysInWeekByUserEntityCalendarDate];
        NSDictionary *select_dict = [StringManager getYearMonthDayWeekByDate:[[UserEntity getCalendarDate] objectForKey:@"date"]];
        if (arr_week != nil) {
            BOOL isOtherDaySelect = NO;//点击了比当前日期小的日期
            for (int i = 0; i < arr_week.count; i++) {
                WeekDay *weekday = [arr_week objectAtIndex:i];
                
                UILabel *day = [[UILabel alloc]init];
                day.text = weekday.day;
                if (weekday.isCurrentMonth == NO) {
                    day.textColor = [UIColor lightGrayColor];
                }
                day.font     = [UIFont systemFontOfSize:15];
                day.frame    = CGRectMake(i*dayWidth, weekWidth, dayWidth, 25);
                day.textAlignment   = NSTextAlignmentCenter;
                day.backgroundColor = [UIColor clearColor];
                day.textColor = TextColorAlpha_54;
            
                UILabel *lab_day = [[UILabel alloc] initWithFrame:CGRectMake(day.frame.size.width/2-25/2.0, 0, 25, 25)];
                lab_day.layer.masksToBounds = YES;
                lab_day.layer.cornerRadius = 25/2.0;
                lab_day.backgroundColor = [UIColor clearColor];
                lab_day.text = day.text;
                lab_day.textColor = [UIColor clearColor];
                lab_day.textAlignment = NSTextAlignmentCenter;
                [day addSubview:lab_day];
                
                if ([weekday.year longLongValue] == [[select_dict objectForKey:@"year"] longLongValue] && [weekday.month longLongValue] == [[select_dict objectForKey:@"month"] longLongValue] && [weekday.day longLongValue] == [[select_dict objectForKey:@"day"] longLongValue] && [[[UserEntity getCalendarDate] objectForKey:@"state"] isEqualToString:@"1"]) {
                    
                    lab_day.backgroundColor = AppMainColor;
                    lab_day.textColor = [UIColor whiteColor];
                    lab_day.font = [UIFont systemFontOfSize:15.0];
                    isOtherDaySelect = YES;
                }
                else if(weekday.isCurrentDay == YES && weekday.isCurrentMonth == YES && weekday.isCurrentYear == YES)
                {
                    lab_day.backgroundColor = AppMainColor;
                    lab_day.textColor = [UIColor whiteColor];
                    lab_day.font = [UIFont systemFontOfSize:15.0];
                    
                    NSString *todaystring = [NSString stringWithFormat:@"%@-%@-%@",weekday.year,weekday.month,weekday.day];
                    //点击了比当前日期大的日期
                    NSString *nextDatString = [NSString stringWithFormat:@"%@-%@-%@",[select_dict objectForKey:@"year"] ,[select_dict objectForKey:@"month"] ,[select_dict objectForKey:@"day"] ];
                    
                    NSNumber *dayNumber = [StringManager stringDateTransferTimeStamp:todaystring];
                    NSNumber *nextNumber = [StringManager stringDateTransferTimeStamp:nextDatString];
                    
                    if ((isOtherDaySelect == YES || [nextNumber longLongValue] > [dayNumber longLongValue]) && [[[UserEntity getCalendarDate] objectForKey:@"state"] isEqualToString:@"1"]) {
                        lab_day.hidden = YES;
                        day.textColor = AppMainColor;
                    }
                }
                [self addSubview:day];
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCaledarView:)];
        [self addGestureRecognizer:tap];
        }
    
    return self;
}
-(void)clickCaledarView:(UITapGestureRecognizer *)tap
{
    [self.delegate touchView];
}
@end
