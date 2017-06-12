//
//  DatabaseManager.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkPlaces+CoreDataProperties.h"
#import "Employees+CoreDataProperties.h"
#import "Availability+CoreDataProperties.h"
#import "Shifts+CoreDataProperties.h"
#import "Requests+CoreDataProperties.h"
#import "RequestAllDisposeState+CoreDataProperties.h"
#import "Locations+CoreDataProperties.h"
#import "Positions+CoreDataProperties.h"
#import "HistoryShiftTime+CoreDataProperties.h"
#import "CurrentEmployee+CoreDataProperties.h"
#import "CurrentWorkPlace+CoreDataProperties.h"
#import "Drop+CoreDataProperties.h"
#import "Setting+CoreDataProperties.h"
#import "DeviceToken+CoreDataProperties.h"
#import "CalendarEvents+CoreDataProperties.h"
#import "DynanoDBModel.h"


@interface DatabaseManager : NSObject

#pragma mark - workPlaces

+ (NSArray *) getAllWorkPlaces;
+ (WorkPlaces *) getWorkplaceByUuid:(NSString *) uuid;
+ (CurrentWorkPlace *) getCurrentWorkPlaceByUuid:(NSString *)uuid;
+ (NSArray *) getLikeWorkPlaces:(NSString *)str andArray:(NSArray *)arr;
#pragma mark - employees

+ (NSArray *) getAllEmployees;
+ (NSMutableArray *) getAllEmployeesInLocation:(NSString *) locationuuid;
+ (NSArray *) getAllEmployeesNoJoinAndJoin;
+ (NSMutableDictionary *) getAllEmployeesByFullNameSorted:(NSArray *) array;
+ (NSMutableDictionary *) getAllCoworkersByFullNameSorted;
+ (NSMutableDictionary *) getEmployeesByLocationUuid:(NSString *)locationUuid andPositionUuid:(NSString *)positionUuid;
+ (NSArray *) getAllJoinedEmployees;
+ (NSArray *) getNoJoinedEmployees;
+ (NSArray *) getAllNoManagerEmployees;

+ (CurrentEmployee *) getCurrentEmployeeByEmail:(NSString *)email;
+ (CurrentEmployee *) getCurrentEmployeeByUuid:(NSString *)uuid;
+ (Employees *) getEmployeeByUuid:(NSString *)uuid;
+ (Employees *) getEmployeeByEmail:(NSString *)email;
+ (NSArray *)getEmployeeAllPositionUuid:(NSString *)employeeUuid;


#pragma mark - location

+ (NSArray *) getAllLocations;
+ (Locations *) getLocationByUuid:(NSString *)uuid;
+ (NSMutableArray *) getEmployeeLocationUuids:(NSString *)employeeuuid;
+ (NSMutableArray *) getEmployeeLocations:(NSString *)employeeuuid;
+ (NSMutableArray *) getAllLocationsSortedByFirstLetter;
+ (void) deleteLocation:(Locations *)location;
+ (NSString *) getDefaultLocationUuid;


#pragma mark - position

+ (NSArray *) getAllPositions;
+ (Positions *) getPositionByUuid:(NSString *)uuid;
+ (NSMutableArray *) getEmployeePositionUuids:(NSString *)employeeuuid;
+ (NSMutableArray *) getEmployeePositions:(NSString *)employeeuuid;
+ (NSArray *) getAllMyPositions;
+ (Positions *) getPositionByEmployeeUuid:(NSString *)employeeUuid;


#pragma mark - shift
+ (NSArray *) getAllShifts;
+ (NSArray *) getEmployeeShiftsEntire:(NSString *) employeeuuid;
+ (NSMutableDictionary *) managerGetAllShifts;
+ (NSMutableDictionary *) getAllMyShifts;
+ (NSMutableDictionary *) getShiftsByCalendarAndFilter;
+ (Shifts *) getShiftByUuid:(NSString *)uuid;
+ (NSMutableDictionary *) getShiftsByEmployeeUuid:(NSString *)employeeUuid;
+ (NSMutableDictionary *) getShiftsByPositionUuid:(NSString *)positionUuid;
+ (NSMutableDictionary *) getShiftsByLocationUuid:(NSString *)locationUuid;
+ (NSArray *) getShiftsArrayByLocationUuid:(NSString *)locationUuid;
+ (NSMutableArray *) getFreeEmployeeByShiftUuid:(NSString *)uuid;
+ (NSMutableArray *) getFreeShiftsUuidByShiftUuid:(NSString *)uuid;
+ (NSMutableDictionary *) getShiftsByEmployeess;
+ (NSMutableDictionary *) getShiftsByPositions;
+ (NSMutableDictionary *) getShiftsByLocations;
+ (NSMutableDictionary *) getFullShiftsByEmployeeLocations;
+ (NSMutableDictionary *) getShiftsByEmployeePositions;
+ (NSMutableDictionary *) getEmployeeNeedActionOpenShift_dict;
+ (NSArray *) getEmployeeNeedActionOpenShift_array;
+ (NSArray *) sortedShiftArrayByTime:(NSMutableArray *)array;
+ (NSMutableArray *) sortedShiftByStartDate:(NSMutableArray *) array;
+ (NSMutableDictionary *) getDayShiftsByEmployeeFullName:(NSNumber *) dayStamp andLocationUuid:(NSString *) locationUuid;
+ (NSMutableArray *) getEmployeeAvailableOpenshift;
+ (NSArray *) getDashboardMySchedule;
+ (NSMutableDictionary *) getAllMyAcknowledgeShifts;
+ (NSMutableDictionary *) getShiftsByPositionsAndDayStamp:(NSNumber *) number;
+ (NSArray *) getAllMyShiftsArray;
+ (NSMutableArray *) getEmployeeOpenShiftsArray;
+ (NSArray *) getManagerOpenShittArray;
+ (NSArray *) getEntireShiftsArray;
+ (Shifts *) getShiftByEmployeeUuid:(NSString *)employeeUuid andStartTimeStamp:(NSString *) startStamp andEndTimeStamp:(NSString *) endStamp;
+ (NSMutableArray *) getShiftsArrayByLocationUuid:(NSString *)locationuudi andStartStamo:(NSNumber *)number1 andEndStamp:(NSNumber *) number2 andPositionUuid:(NSString *) positionuuid andTakeState:(NSNumber *) takestate;
+ (NSMutableArray *) getShiftsArrayByLocationUuid:(NSString *)locationuudi andStartStamo:(NSNumber *)number1 andEndStamp:(NSNumber *) number2 andEmployeeUuid:(NSString *) employeeuuid andTakeState:(NSNumber *) takestate;
+ (NSMutableDictionary *) getShiftsByPositionUuid:(NSString *)positionUuid andDayStamp:(NSNumber *) number;

//schedule landscape
+ (NSMutableDictionary *) shiftSortedByLocationUuid:(NSDictionary *) dict_shifts;
+ (NSMutableDictionary *) shiftSortedByEmployeeUuid:(NSMutableArray *) arr;
+ (NSMutableDictionary *) shiftSortedByPositionUuid:(NSMutableArray *) arr;
+ (NSMutableArray *) shiftSortedBySameStartTimeStamp:(NSMutableArray *) arr;

#pragma mark -  drop
+ (Drop *) getDropByUuid:(NSString *) uuid;
+ (Drop *) getPendingDropByShiftUuid:(NSString *) shiftuuid;
+ (NSMutableDictionary *) employeeGetShiftsByDropAndSwap;
+ (Drop *) getSwapByUuid:(NSString *) uuid;
+ (Drop *) getPendingSwapByShiftUuid:(NSString *) shiftuuid;
+ (NSArray *) getEmployeeAllDropAndSwap:(NSString *) employeeUuid;
+ (NSArray *) getDropAndSwapByShiftUuid:(NSString *) shiftuuid;


#pragma mark - available
+ (Availability *) getAvailabilitybyUuid:(NSString *)uuid;
+ (NSArray *) getEmployeeAvailabilitiesByEmployeeUuid:(NSString *)employeeUuid;
+ (NSMutableArray *) getDayAvailabilityByEmployeeUuid:(NSDate *) date andEmployeeUuid:(NSString *) uuid;
+ (NSDictionary *) getConilictAvailabilityByEmployeeUuid:(NSString *) shiftStartDateStamp andShiftStartTimeStamp:(NSString *) shiftStartTimeStamp andShiftEndTimeStamp:(NSString *) shiftEndTimeStamp andEmployeeUuid:(NSString *) uuid andAvailabilityState:(NSString *) state;
+ (NSMutableString *) getConflictAvailabilityInDay:(NSMutableArray *) arr_weeks;


#pragma mark - request

+ (NSMutableDictionary *) getAllRequests;
+ (Requests *) getRequestByUuid:(NSString *)uuid;
+ (NSMutableDictionary *) getAllMyRequests;
+ (NSArray *) getEmployeeAllRequestToDelete:(NSString *) employeeuuid;
+ (NSArray *) getAllNeedActionRequests;
+ (Requests *) getConfilictRequestByEmployeeUuid:(NSString *) emplloyeeuuid andShifStartTimeStamp:(NSString *) stamp1 andShifEndTimeStamp:(NSString *) stamp2;
+ (Requests *) getSelfConfilictRequest:(NSNumber *) stampstartDate andRequestEndTimeStamp:(NSNumber *) stampEndDate andTime1:(NSString *) time1 andTime2:(NSString *) time2;
+ (NSArray *) getRequestAllDisposeState:(NSString *) requestUuid;
+ (void) saveRequestDisposeTable:(NSString *) modelRequestDisposeString;
+ (RequestAllDisposeState *) getRequestDispose:(NSString *) parentUuid andParentRequestUuid:(NSString *)parentRequestUuid andSendEmployeeUuid:(NSString *) employeuuid andDisposeState:(NSString *) disposeState andDisposeTime:(NSString *)disposeTime;
+ (NSMutableArray *) sortedRequestByDisposeDate:(NSArray *) array;


#pragma mark - historyShiftTime
+(NSArray *) getHistoryShiftTime;
+(HistoryShiftTime *) getExistShiftTime:(Shifts *)shift;

#pragma mark - setting
+ (Setting *) getEmployeeSetting:(NSString *) employeeuuid;

#pragma mark - devicetoken
+ (DeviceToken *) getDeviceTokenByDeviceModel:(DDBDeviceTokenModel *) model;
+ (NSArray *) getDeviceTokenByEmployeeUuid:(NSString *) uuid;
+ (DeviceToken *) getDeviceTokenByDeviceModel2:(DDBDeviceTokenModel *) model;

#pragma mark - calendarevent
+ (CalendarEvents *) getMyCalendarEventsInCurrentWorkplace;
+ (void) syncShiftToCalendar:(NSString *) shiftuuid andIsDelete:(int) isdelete;


#pragma mark - notification
+ (NSString *) getNotificationOfRequest:(Requests *) request;
+ (NSString *) getNotificationOfShift:(Shifts *) shift;
+ (NSString *) getMyselfNotificationOfShift:(Shifts *)shift;


#pragma mark - public method
+ (void) deleteItem:(id)object;

+ (void) eraseAllDate;

#pragma mark - AWS Return Error
+ (NSString *) AWSDynamoDBErrorMessage:(NSInteger) errorCode;
+ (BOOL) userIsOpenNotification;

#pragma mark - server return error message
+ (NSDictionary *) dictionaryWithJsondata:(NSData *) data;
+ (NSString *) serverReturnErrorMessage:(NSError *) error;

@end
