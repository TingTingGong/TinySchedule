//
//  WeekDay.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/9/13.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekDay : NSObject

@property (strong , nonatomic) NSString *day;
@property (strong , nonatomic) NSString *month;
@property (strong , nonatomic) NSString *year;
@property (assign , nonatomic) BOOL isCurrentDay;
@property (assign , nonatomic) BOOL isCurrentMonth;
@property (assign , nonatomic) BOOL isCurrentYear;

@end
