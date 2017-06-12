//
//  Drop+CoreDataProperties.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Drop+CoreDataProperties.h"

@implementation Drop (CoreDataProperties)

+ (NSFetchRequest<Drop *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Drop"];
}

@dynamic createDate;
@dynamic declineDropUuids;
@dynamic drop_accepteEmployeeUuid;
@dynamic dropUuids;
@dynamic isDelete;
@dynamic isDrop;
@dynamic isManagerAccepted;
@dynamic managerUuid;
@dynamic message;
@dynamic modifyDate;
@dynamic oriShiftEmployeeUuid;
@dynamic parentShiftUuid;
@dynamic parentUuid;
@dynamic state;
@dynamic swap_acceptShiftUuid;
@dynamic swapShiftUuid1;
@dynamic swapShiftUuid2;
@dynamic uuid;

@end
