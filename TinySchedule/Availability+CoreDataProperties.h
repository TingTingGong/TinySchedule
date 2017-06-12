//
//  Availability+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Availability+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Availability (CoreDataProperties)

+ (NSFetchRequest<Availability *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *employeeUuid;
@property (nonatomic) int16_t isDelete;
@property (nullable, nonatomic, copy) NSString *managerUuid;
@property (nullable, nonatomic, copy) NSString *modifyDate;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *rotation;
@property (nullable, nonatomic, copy) NSString *string_effectiveDate1;
@property (nullable, nonatomic, copy) NSString *string_effectiveDate2;
@property (nullable, nonatomic, copy) NSString *string_yearMonthDay1;
@property (nullable, nonatomic, copy) NSString *string_yearMonthDay2;
@property (nullable, nonatomic, copy) NSString *subAvailabilities;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
