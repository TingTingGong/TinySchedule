//
//  WorkPlaces+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "WorkPlaces+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WorkPlaces (CoreDataProperties)

+ (NSFetchRequest<WorkPlaces *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) int16_t type;
@property (nonatomic) int16_t employeesCounts;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nonatomic) int16_t isCreator;
@property (nonatomic) int16_t isPermitted;

@end

NS_ASSUME_NONNULL_END
