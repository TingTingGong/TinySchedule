//
//  DynanoDBModel.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/29.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import "Constants.h"

@class DDBWorkPlacesInfoModel;
@class DDBEmployeesInfoModel;
@class DDBDataModel;
@class AWSTask;
@class DDBDeviceTokenModel;

@interface DynanoDBModel : NSObject

@end

@interface DDBEmployeesInfoModel : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *modify_date;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *managerUuid;
@property (nonatomic, strong) NSString *parentUuid;//workpplace的uuid
@property (nonatomic, strong) NSString *parentWorkplaceName;
@property (nonatomic, strong) NSNumber *isManager;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSNumber *isDelete;
@property (nonatomic, strong) NSNumber *isJoinPlace;
@property (nonatomic, strong) NSNumber *isAcceptJoined;
@property (nonatomic, strong) NSNumber *maxHoursPerWeek;
@end


@interface DDBWorkPlacesInfoModel : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *managerEmail;//manager email
@property (nonatomic, strong) NSString *managerUuid;//manager uuid
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *employeesCounts;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@end

@interface DDBDeviceTokenModel : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *parentUuid;
@property (nonatomic, strong) NSString *employeeUuid;
@property (nonatomic, strong) NSString *endPointArn;
@end


@interface DDBDataModel : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
//public
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *modifyDate;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *managerUuid;
@property (nonatomic, strong) NSString *parentUuid;//workplace的uuid
@property (nonatomic, strong) NSNumber *isDelete;
@property (nonatomic, strong) NSString *tableIdentityID;
//Location
@property (nonatomic, strong) NSString *location_name;
@property (nonatomic, strong) NSString *location_addr;
@property (nonatomic, strong) NSString *location_latitude;
@property (nonatomic, strong) NSString *location_longitude;
@property (nonatomic, strong) NSString *location_employees;
//Positions
@property (nonatomic, strong) NSString *position_name;
@property (nonatomic, strong) NSNumber *position_isFavorite;
@property (nonatomic, strong) NSNumber *position_color;
@property (nonatomic, strong) NSString *position_employees;
//shifts
@property (nonatomic, strong) NSString *shift_employeeUuid;
@property (nonatomic, strong) NSString *shift_employeeName;
@property (nonatomic, strong) NSString *shift_positionUuid;
@property (nonatomic, strong) NSString *shift_locationUuid;
@property (nonatomic, strong) NSString *shift_startDate;
@property (nonatomic, strong) NSString *shift_startTime;
@property (nonatomic, strong) NSString *shift_endTime;
@property (nonatomic, strong) NSString *shift_totalHours;
@property (nonatomic, strong) NSString *shift_unPaidBreak;
@property (nonatomic, strong) NSString *shift_openshift_employees;
@property (nonatomic, strong) NSNumber *shift_employeesNumbers;
@property (nonatomic, strong) NSString *shift_notes;
@property (nonatomic, strong) NSString *shift_strYear;
@property (nonatomic, strong) NSString *shift_strMonth;
@property (nonatomic, strong) NSString *shift_strDay;
@property (nonatomic, strong) NSString *shift_strWeek;
@property (nonatomic, strong) NSString *shift_strTime;
@property (nonatomic, strong) NSNumber *shift_isTake;
@property (nonatomic, strong) NSNumber *shift_takedState;
@property (nonatomic, strong) NSNumber *shift_haveTakedEmployeesNumber;
//drop
@property (nonatomic, strong) NSString *drop_swapshiftuuid1;
@property (nonatomic, strong) NSString *drop_swapshiftuuid2;
@property (nonatomic, strong) NSString *drop_parentShidtUuid;
@property (nonatomic, strong) NSString *drop_oriShiftEmployeeUuid;
@property (nonatomic, strong) NSNumber *drop_isManagerAccepted;
@property (nonatomic, strong) NSNumber *drop_isDrop;//0-drop  1-swap
@property (nonatomic, strong) NSString *drop_messsage;
@property (nonatomic, strong) NSString *drop_state;//0-pending 1-accept 2-cancel
@property (nonatomic, strong) NSString *drop_dropUuids;
@property (nonatomic, strong) NSString *drop_delcineDropUuids;
@property (nonatomic, strong) NSString *drop_dropAccptedEmploueeUuid;
@property (nonatomic, strong) NSString *drop_swapAcceptedShiftUuid;

//Requests
@property (nonatomic, strong) NSString *request_employeeUuid;
@property (nonatomic, strong) NSString *request_stamp_startDate;
@property (nonatomic, strong) NSString *request_stamp_endDate;
@property (nonatomic, strong) NSString *request_string_startTime;
@property (nonatomic, strong) NSString *request_string_endTime;
@property (nonatomic, strong) NSString *request_message;
@property (nonatomic, strong) NSString *request_type;
@property (nonatomic, strong) NSNumber *request_paidHours;
@property (nonatomic, strong) NSString *request_waitType;
@property (nonatomic, strong) NSString *request_disposeStateTable;
//Available
@property (nonatomic, strong) NSString *avail_employeeUuid;
@property (nonatomic, strong) NSString *avail_title;
@property (nonatomic, strong) NSString *avail_notes;
@property (nonatomic, strong) NSString *avail_rotation;
@property (nonatomic, strong) NSString *avail_string_effectiveDate1;
@property (nonatomic, strong) NSString *avail_string_effectiveDate2;
@property (nonatomic, strong) NSString *avail_string_yearMonthDay1;
@property (nonatomic, strong) NSString *avail_string_yearMonthDay2;
@property (nonatomic, strong) NSString *avail_subAvailabilities;
//setting
@property (nonatomic, strong) NSString *setting_employeeUuid;
@property (nonatomic, strong) NSString *setting_email_noNotifyStartTime;
@property (nonatomic, strong) NSString *setting_email_noNotifyEndTime;
@property (nonatomic, strong) NSString *setting_notification_noNotifyStartTime;
@property (nonatomic, strong) NSString *setting_notification_noNotifyEndTime;
@property (nonatomic, strong) NSNumber *setting_email_isTimeOffTequest;
@property (nonatomic, strong) NSNumber *setting_email_isDropRequest;
@property (nonatomic, strong) NSNumber *setting_emailg_isScheduleUpdate;
@property (nonatomic, strong) NSNumber *setting_email_isNewEmployee;
@property (nonatomic, strong) NSNumber *setting_email_isAvailabilityChange;
@property (nonatomic, strong) NSNumber *setting_notification_isTimeOffTequest;
@property (nonatomic, strong) NSNumber *setting_notification_isDropRequest;
@property (nonatomic, strong) NSNumber *setting_notification_isScheduleUpdate;
@property (nonatomic, strong) NSNumber *setting_notification_isNewEmployee;
@property (nonatomic, strong) NSNumber *setting_notification_isAvailabilityChange;


@end

