//
//  Positions+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Positions+CoreDataProperties.h"

@implementation Positions (CoreDataProperties)

+ (NSFetchRequest<Positions *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Positions"];
}

@dynamic uuid;
@dynamic name;
@dynamic color;
@dynamic employees;

@end
