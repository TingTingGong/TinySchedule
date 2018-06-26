//
//  DeviceToken+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "DeviceToken+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceToken (CoreDataProperties)

+ (NSFetchRequest<DeviceToken *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deviceToken;
@property (nullable, nonatomic, copy) NSString *employeeUuid;
@property (nullable, nonatomic, copy) NSString *endPointArn;
@property (nullable, nonatomic, copy) NSString *parentUuid;

@end

NS_ASSUME_NONNULL_END
