//
//  Requests+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Requests+CoreDataProperties.h"

@implementation Requests (CoreDataProperties)

+ (NSFetchRequest<Requests *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Requests"];
}

@dynamic createDate;
@dynamic disposeDate;
@dynamic employeeUuid;
@dynamic isDelete;
@dynamic managerUuid;
@dynamic message;
@dynamic paidHours;
@dynamic parentUuid;
@dynamic stamp_endDate;
@dynamic stamp_startDate;
@dynamic string_startTime;
@dynamic string_endTime;
@dynamic type;
@dynamic uuid;
@dynamic waitType;

@end
