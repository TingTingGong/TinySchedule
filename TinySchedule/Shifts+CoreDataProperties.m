//
//  Shifts+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Shifts+CoreDataProperties.h"

@implementation Shifts (CoreDataProperties)

+ (NSFetchRequest<Shifts *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Shifts"];
}

@dynamic createDate;
@dynamic employeeName;
@dynamic employeeUuid;
@dynamic endTime;
@dynamic haveTakedEmployeesNumber;
@dynamic isDelete;
@dynamic isTake;
@dynamic locationUuid;
@dynamic managerUuid;
@dynamic modifyDate;
@dynamic needEmployeesNumber;
@dynamic notes;
@dynamic openShift_employees;
@dynamic parentUuid;
@dynamic positionUuid;
@dynamic startDate;
@dynamic startTime;
@dynamic string_day;
@dynamic string_month;
@dynamic string_time;
@dynamic string_week;
@dynamic string_year;
@dynamic takeState;
@dynamic totalHours;
@dynamic unpaidBreak;
@dynamic uuid;

@end
