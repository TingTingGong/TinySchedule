//
//  Requests+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Requests+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Requests (CoreDataProperties)

+ (NSFetchRequest<Requests *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *disposeDate;
@property (nullable, nonatomic, copy) NSString *employeeUuid;
@property (nonatomic) int16_t isDelete;
@property (nullable, nonatomic, copy) NSString *managerUuid;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic) int16_t paidHours;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *stamp_endDate;
@property (nullable, nonatomic, copy) NSString *stamp_startDate;
@property (nullable, nonatomic, copy) NSString *string_startTime;
@property (nullable, nonatomic, copy) NSString *string_endTime;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *waitType;

@end

NS_ASSUME_NONNULL_END
