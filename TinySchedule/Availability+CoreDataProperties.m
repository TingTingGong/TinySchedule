//
//  Availability+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Availability+CoreDataProperties.h"

@implementation Availability (CoreDataProperties)

+ (NSFetchRequest<Availability *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Availability"];
}

@dynamic createDate;
@dynamic employeeUuid;
@dynamic isDelete;
@dynamic managerUuid;
@dynamic modifyDate;
@dynamic notes;
@dynamic parentUuid;
@dynamic rotation;
@dynamic string_effectiveDate1;
@dynamic string_effectiveDate2;
@dynamic string_yearMonthDay1;
@dynamic string_yearMonthDay2;
@dynamic subAvailabilities;
@dynamic title;
@dynamic uuid;

@end
