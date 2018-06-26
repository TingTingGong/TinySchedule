//
//  RequestAllDisposeState+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "RequestAllDisposeState+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RequestAllDisposeState (CoreDataProperties)

+ (NSFetchRequest<RequestAllDisposeState *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *disposeState;
@property (nullable, nonatomic, copy) NSString *disposeTime;
@property (nullable, nonatomic, copy) NSString *parentRequestUuid;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *sendRequestEmployeeUuid;

@end

NS_ASSUME_NONNULL_END
