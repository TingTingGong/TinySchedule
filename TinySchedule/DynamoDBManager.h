//
//  DynamoDBManager.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/29.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynanoDBModel.h"
#import "WorkPlaces+CoreDataProperties.h"
#import "Employees+CoreDataProperties.h"

@interface DynamoDBManager : NSObject

+ (NSArray *) getAllWorkPlaces;
+ (NSMutableArray *) getEmployeePositionLocationRequestAvailabilityWriteRequestByEmployeeUuid:(NSString *) employeeuuid andIsMoveShiftToOpenshift:(BOOL) isdelete;
+ (NSMutableArray *) getShiftWriteRequestByShiftuuid:(NSString *) uuid andDropWriteRequestByDropUuid:(NSString *) dropuuid;
+ (NSMutableArray *) getShiftWriteRequestByOriShiftuuid:(NSString *)oriShiftUuid andMyShiftUuid: (NSString *) myShiftUuid andSwapWriteRequestBySwappUuid:(NSString *) swapuuid;
+ (NSMutableArray *) getShiftWriteRequestByTakeState:(NSNumber *) takeState andArray:(NSMutableArray *) arr_shifts;
+ (NSMutableArray *) getShiftAndDrop:(NSString *) shiftuuid;

+ (DDBDataModel *) getDropDataModelByDropUuid:(NSString *) dropuuid andOriShiftUuid:(NSString *) orishiftuuid;
+ (DDBDataModel *) getSwapDataModelBySwapUuid:(NSString *) swapuuid andOriShiftUuid:(NSString *) orishiftuuid;
+ (DDBDataModel *) getShiftDataModelByShift:(Shifts *) passshift;
+ (DDBDataModel *) getRequestDataModelByRequestUuid:(NSString *)uuid and:(NSMutableDictionary *) dict andState:(NSString *) state;

+ (DDBWorkPlacesInfoModel *) getCurrentWorkPlaceModel:(CurrentWorkPlace *)workPlace;
+ (DDBDataModel *) getLocationDataModel:(Locations *)location;
+ (DDBDataModel *) getPositionDataModel:(Positions *)position;
+ (DDBDataModel *) getAvailableDataModel:(NSString *)uuid andConfiguration:(NSDictionary *) dict_configuration andSubAvailabilities:(NSString *) subAvai andNewParentUuid:(NSString *) newparentUuid;

+(void) getNewEmployee;

+(void) getAllDeviceToken;

+(BOOL) dynamodbDataSaveToLocal:(NSArray *) arr;


@end
