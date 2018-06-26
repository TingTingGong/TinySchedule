//
//  CalendarEvents+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "CalendarEvents+CoreDataProperties.h"

@implementation CalendarEvents (CoreDataProperties)

+ (NSFetchRequest<CalendarEvents *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CalendarEvents"];
}

@dynamic calendarIdentifier;
@dynamic employeeuUuid;
@dynamic eventIdentifiers;
@dynamic parentUuid;
@dynamic subscribeUuid;

@end
