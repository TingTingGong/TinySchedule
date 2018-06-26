//
//  Positions+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Positions+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Positions (CoreDataProperties)

+ (NSFetchRequest<Positions *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t color;
@property (nullable, nonatomic, copy) NSString *employees;

@end

NS_ASSUME_NONNULL_END
