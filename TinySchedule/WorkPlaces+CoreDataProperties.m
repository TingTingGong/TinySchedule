//
//  WorkPlaces+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "WorkPlaces+CoreDataProperties.h"

@implementation WorkPlaces (CoreDataProperties)

+ (NSFetchRequest<WorkPlaces *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WorkPlaces"];
}

@dynamic uuid;
@dynamic name;
@dynamic address;
@dynamic type;
@dynamic employeesCounts;
@dynamic latitude;
@dynamic longitude;
@dynamic isCreator;
@dynamic isPermitted;

@end
