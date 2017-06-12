//
//  Employees+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Employees+CoreDataProperties.h"

@implementation Employees (CoreDataProperties)

+ (NSFetchRequest<Employees *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employees"];
}

@dynamic uuid;
@dynamic email;
@dynamic password;
@dynamic phone;
@dynamic fullName;
@dynamic headPortrait;
@dynamic maxHoursPerWeek;
@dynamic isManager;
@dynamic isPermitted;

@end
