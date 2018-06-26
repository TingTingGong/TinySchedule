//
//  HistoryShiftTime+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "HistoryShiftTime+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HistoryShiftTime (CoreDataProperties)

+ (NSFetchRequest<HistoryShiftTime *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *string_break;
@property (nullable, nonatomic, copy) NSString *string_endTime;
@property (nullable, nonatomic, copy) NSString *string_hours;
@property (nullable, nonatomic, copy) NSString *string_startTime;

@end

NS_ASSUME_NONNULL_END
