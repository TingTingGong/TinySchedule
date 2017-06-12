//
//  DeviceToken+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "DeviceToken+CoreDataProperties.h"

@implementation DeviceToken (CoreDataProperties)

+ (NSFetchRequest<DeviceToken *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DeviceToken"];
}

@dynamic deviceToken;
@dynamic employeeUuid;
@dynamic endPointArn;
@dynamic parentUuid;

@end
