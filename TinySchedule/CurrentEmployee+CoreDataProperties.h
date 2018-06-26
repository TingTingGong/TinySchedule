//
//  CurrentEmployee+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "CurrentEmployee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CurrentEmployee (CoreDataProperties)

+ (NSFetchRequest<CurrentEmployee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, retain) NSData *headPortrait;
@property (nonatomic) int16_t maxHoursPerWeek;
@property (nonatomic) int16_t isManager;
@property (nonatomic) int16_t isPermitted;




@end

NS_ASSUME_NONNULL_END
