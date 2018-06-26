//
//  Drop+CoreDataProperties.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/4/17.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "Drop+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Drop (CoreDataProperties)

+ (NSFetchRequest<Drop *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createDate;
@property (nullable, nonatomic, copy) NSString *declineDropUuids;
@property (nullable, nonatomic, copy) NSString *drop_accepteEmployeeUuid;
@property (nullable, nonatomic, copy) NSString *dropUuids;
@property (nonatomic) int16_t isDelete;
@property (nonatomic) int16_t isDrop;
@property (nonatomic) int16_t isManagerAccepted;
@property (nullable, nonatomic, copy) NSString *managerUuid;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSString *modifyDate;
@property (nullable, nonatomic, copy) NSString *oriShiftEmployeeUuid;
@property (nullable, nonatomic, copy) NSString *parentShiftUuid;
@property (nullable, nonatomic, copy) NSString *parentUuid;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *swap_acceptShiftUuid;
@property (nullable, nonatomic, copy) NSString *swapShiftUuid1;
@property (nullable, nonatomic, copy) NSString *swapShiftUuid2;
@property (nullable, nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
