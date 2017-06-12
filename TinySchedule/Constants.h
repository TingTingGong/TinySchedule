/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "AWSCore.h"

FOUNDATION_EXPORT  AWSRegionType   const CognitoRegionType;
FOUNDATION_EXPORT  AWSRegionType   const DefaultServiceRegionType;
FOUNDATION_EXPORT  NSString        *const CognitoIdentityPoolId;
FOUNDATION_EXPORT  NSString        *const SNSPlatformApplicationArn;
FOUNDATION_EXPORT  NSString        *const MobileAnalyticsAppId;
FOUNDATION_EXPORT  NSString        *const MandrillSendEmailApiKey;

FOUNDATION_EXPORT  NSString        *const AWSWorkPlacesTableName;
FOUNDATION_EXPORT  NSString        *const AWSEmployeesTableName;
FOUNDATION_EXPORT  NSString        *const AWSDataTableName;
FOUNDATION_EXPORT  NSString        *const AWSDeviceTokenTableName;


//DynamoDB table name
#define   S_EMPLOYEES              @"table_identity_id_employees"
#define   S_WORKPLACES             @"table_identity_id_workPlaces"
#define   S_AVAILABLE              @"table_identity_id_available"
#define   S_AVAILABLEWEEKDAYS      @"table_identity_id_avaiWeekdays"
#define   S_POSITIONS              @"table_identity_id_positions"
#define   S_JOBSITES               @"table_identity_id_jobsites"
#define   S_LOCATIONS              @"table_identity_id_locations"
#define   S_REQUESTS               @"table_identity_id_requests"
#define   S_SHIFTS                 @"table_identity_id_shifts"




