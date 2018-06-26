//
//  Locations+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Locations+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Locations (CoreDataProperties)

+ (NSFetchRequest<Locations *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *address;
@property (nonatomic) double_t latitude;
@property (nonatomic) double_t longitude;
@property (nullable, nonatomic, copy) NSString *employees;

@end

NS_ASSUME_NONNULL_END
