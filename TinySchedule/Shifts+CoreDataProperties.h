//
//  Shifts+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Shifts+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Shifts (CoreDataProperties)

+ (NSFetchRequest<Shifts *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *employeeName;
@property (nullable, nonatomic, copy) NSString *employeeUuid;
@property (nullable, nonatomic, copy) NSString *endTime;
@property (nonatomic) int16_t haveTakedEmployeesNumber;
@property (nonatomic) int16_t isDelete;
@property (nonatomic) int16_t isTake;
@property (nullable, nonatomic, copy) NSString *locationUuid;
@property (nullable, nonatomic, copy) NSString *managerUuid;
@property (nullable, nonatomic, copy) NSString *modifyDate;
@property (nonatomic) int16_t needEmployeesNumber;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *openShift_employees;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *positionUuid;
@property (nullable, nonatomic, copy) NSString *startDate;
@property (nullable, nonatomic, copy) NSString *startTime;
@property (nullable, nonatomic, copy) NSString *string_day;
@property (nullable, nonatomic, copy) NSString *string_month;
@property (nullable, nonatomic, copy) NSString *string_time;
@property (nullable, nonatomic, copy) NSString *string_week;
@property (nullable, nonatomic, copy) NSString *string_year;
@property (nonatomic) int16_t takeState;
@property (nullable, nonatomic, copy) NSString *totalHours;
@property (nullable, nonatomic, copy) NSString *unpaidBreak;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
