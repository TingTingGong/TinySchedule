//
//  Locations+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Locations+CoreDataProperties.h"

@implementation Locations (CoreDataProperties)

+ (NSFetchRequest<Locations *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Locations"];
}

@dynamic uuid;
@dynamic name;
@dynamic address;
@dynamic latitude;
@dynamic longitude;
@dynamic employees;

@end
