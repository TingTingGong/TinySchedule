//
//  Setting+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Setting+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Setting (CoreDataProperties)

+ (NSFetchRequest<Setting *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createDate;
@property (nonatomic) int16_t email_isAvailabilityChange;
@property (nonatomic) int16_t email_isDropRequest;
@property (nonatomic) int16_t email_isNewEmployee;
@property (nonatomic) int16_t email_isScheduleUpdate;
@property (nonatomic) int16_t email_isTimeOffTequest;
@property (nullable, nonatomic, copy) NSString *email_noNotifyEndTime;
@property (nullable, nonatomic, copy) NSString *email_noNotifyStartTime;
@property (nullable, nonatomic, copy) NSString *employeeUuid;
@property (nonatomic) int16_t isDelete;
@property (nullable, nonatomic, copy) NSString *managerUuid;
@property (nullable, nonatomic, copy) NSString *modifyDate;
@property (nonatomic) int16_t notification_isAvailabilityChange;
@property (nonatomic) int16_t notification_isDropRequest;
@property (nonatomic) int16_t notification_isNewEmployee;
@property (nonatomic) int16_t notification_isScheduleUpdate;
@property (nonatomic) int16_t notification_isTimeOffTequest;
@property (nullable, nonatomic, copy) NSString *notification_noNotifyEndTime;
@property (nullable, nonatomic, copy) NSString *notification_noNotifyStartTime;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
