//
//  Setting+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Setting+CoreDataProperties.h"

@implementation Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Setting"];
}

@dynamic createDate;
@dynamic email_isAvailabilityChange;
@dynamic email_isDropRequest;
@dynamic email_isNewEmployee;
@dynamic email_isScheduleUpdate;
@dynamic email_isTimeOffTequest;
@dynamic email_noNotifyEndTime;
@dynamic email_noNotifyStartTime;
@dynamic employeeUuid;
@dynamic isDelete;
@dynamic managerUuid;
@dynamic modifyDate;
@dynamic notification_isAvailabilityChange;
@dynamic notification_isDropRequest;
@dynamic notification_isNewEmployee;
@dynamic notification_isScheduleUpdate;
@dynamic notification_isTimeOffTequest;
@dynamic notification_noNotifyEndTime;
@dynamic notification_noNotifyStartTime;
@dynamic parentUuid;
@dynamic uuid;

@end
