//
//  HistoryShiftTime+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "HistoryShiftTime+CoreDataProperties.h"

@implementation HistoryShiftTime (CoreDataProperties)

+ (NSFetchRequest<HistoryShiftTime *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HistoryShiftTime"];
}

@dynamic string_break;
@dynamic string_endTime;
@dynamic string_hours;
@dynamic string_startTime;

@end
