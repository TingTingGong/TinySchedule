//
//  CalendarEvents+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "CalendarEvents+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CalendarEvents (CoreDataProperties)

+ (NSFetchRequest<CalendarEvents *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *calendarIdentifier;
@property (nullable, nonatomic, copy) NSString *employeeuUuid;
@property (nullable, nonatomic, copy) NSString *eventIdentifiers;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *subscribeUuid;

@end

NS_ASSUME_NONNULL_END
