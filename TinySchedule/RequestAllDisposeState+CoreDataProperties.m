//
//  RequestAllDisposeState+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "RequestAllDisposeState+CoreDataProperties.h"

@implementation RequestAllDisposeState (CoreDataProperties)

+ (NSFetchRequest<RequestAllDisposeState *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RequestAllDisposeState"];
}

@dynamic disposeState;
@dynamic disposeTime;
@dynamic parentRequestUuid;
@dynamic parentUuid;
@dynamic sendRequestEmployeeUuid;

@end
