//
//  DynamoDBManager.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/29.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "DynamoDBManager.h"

@implementation DynamoDBManager

+ (NSArray *) getAllWorkPlaces
{
    AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
        AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    [[dynamoDBObjectMapper scan:[DDBWorkPlacesInfoModel class] expression:scanExpression] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task){
        if (!task.error) {
            AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
            NSArray *arr_workPlaces = [NSArray arrayWithArray:paginatedOutput.items];
            return arr_workPlaces;
        }
        else
        {
            NSLog(@"Error: [%@]", task.error);
            return nil;
        }
    }];
    return nil;
}

+ (NSMutableArray *) getEmployeePositionLocationRequestAvailabilityWriteRequestByEmployeeUuid:(NSString *) employeeuuid  andIsMoveShiftToOpenshift:(BOOL) isdelete
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
//    NSArray *arr_location = [DatabaseManager getEmployeeLocationUuids:employeeuuid];
//    NSArray *arr_position = [DatabaseManager getEmployeePositionUuids:employeeuuid];
//    NSArray *arr_request = [DatabaseManager getEmployeeAllRequestToDelete:employeeuuid];
//    NSArray *arr_availability = [DatabaseManager getEmployeeAvailabilitiesByEmployeeUuid:employeeuuid];
//    NSArray *arr_drop = [DatabaseManager getEmployeeAllDropAndSwap:employeeuuid];
//    NSArray *arr_shifts = [DatabaseManager getEmployeeShiftsEntire:employeeuuid];
//    
//    
//    NSString *modifyd = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
//    
//    for (NSString *locationuuid in arr_location) {
//        
//        Locations *location = [DatabaseManager getLocationByUuid:locationuuid];
//        NSMutableArray *arr_employeeuuid = [NSMutableArray arrayWithArray:[location.employees componentsSeparatedByString:@","]];
//        [arr_employeeuuid removeObject:employeeuuid];
//        
//        NSString *employeess = nil;
//        if (arr_employeeuuid.count != 0) {
//            employeess = [arr_employeeuuid componentsJoinedByString:@","];
//        }
//        
//        AWSDynamoDBWriteRequest *writeRequest_location = [AWSDynamoDBWriteRequest new];
//        writeRequest_location.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *l_createdate = [AWSDynamoDBAttributeValue new];
//        l_createdate.S = location.createDate;
//        AWSDynamoDBAttributeValue *l_modifyDate = [AWSDynamoDBAttributeValue new];
//        l_modifyDate.S = modifyd;
//        AWSDynamoDBAttributeValue *l_haskKeyValue = [AWSDynamoDBAttributeValue new];
//        l_haskKeyValue.S = location.uuid;
//        AWSDynamoDBAttributeValue *l_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        l_rangeKeyValue.S = location.parentUuid;
//        AWSDynamoDBAttributeValue *l_manageruuid = [AWSDynamoDBAttributeValue new];
//        l_manageruuid.S = location.managerUuid;
//        AWSDynamoDBAttributeValue *l_isdelete = [AWSDynamoDBAttributeValue new];
//        l_isdelete.N = [NSString stringWithFormat:@"%hd",location.isDelete];
//        AWSDynamoDBAttributeValue *l_tablename = [AWSDynamoDBAttributeValue new];
//        l_tablename.S = @"Locations";
//        AWSDynamoDBAttributeValue *l_locationname = [AWSDynamoDBAttributeValue new];
//        l_locationname.S = location.name;
//        AWSDynamoDBAttributeValue *l_locationaddr = [AWSDynamoDBAttributeValue new];
//        l_locationaddr.S = location.address;
//        AWSDynamoDBAttributeValue *l_locationlatitude = [AWSDynamoDBAttributeValue new];
//        l_locationlatitude.S = location.latitude;
//        AWSDynamoDBAttributeValue *l_locationlongitude = [AWSDynamoDBAttributeValue new];
//        l_locationlongitude.S = location.longitude;
//        AWSDynamoDBAttributeValue *l_locationemployees = [AWSDynamoDBAttributeValue new];
//        l_locationemployees.S = employeess;
//        if(employeess == nil)
//        {
//            writeRequest_location.putRequest.item = @{@"createDate": l_createdate,@"modifyDate" : l_modifyDate,@"uuid": l_haskKeyValue,@"managerUuid": l_manageruuid,@"parentUuid": l_rangeKeyValue,@"isDelete": l_isdelete,@"tableIdentityID": l_tablename,@"location_name": l_locationname,@"location_addr": l_locationaddr,@"location_latitude": l_locationlatitude,@"location_longitude": l_locationlongitude};
//        }
//        else
//        {
//            writeRequest_location.putRequest.item = @{@"createDate": l_createdate,@"modifyDate" : l_modifyDate,@"uuid": l_haskKeyValue,@"managerUuid": l_manageruuid,@"parentUuid": l_rangeKeyValue,@"isDelete": l_isdelete,@"tableIdentityID": l_tablename,@"location_name": l_locationname,@"location_addr": l_locationaddr,@"location_latitude": l_locationlatitude,@"location_longitude": l_locationlongitude,@"location_employees": l_locationemployees};
//        }
//        [arr_writeRequest addObject:writeRequest_location];
//    }
//    for (NSString *positionuuid in arr_position) {
//        
//        Positions *position = [DatabaseManager getPositionByUuid:positionuuid];
//        NSMutableArray *arr_employeeuuid = [NSMutableArray arrayWithArray:[position.employees componentsSeparatedByString:@","]];
//        [arr_employeeuuid removeObject:employeeuuid];
//        
//        NSString *employeess = nil;
//        if (arr_employeeuuid.count != 0) {
//            employeess = [arr_employeeuuid componentsJoinedByString:@","];
//        }
//        
//        AWSDynamoDBWriteRequest *writeRequest_position = [AWSDynamoDBWriteRequest new];
//        writeRequest_position.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *p_createdate = [AWSDynamoDBAttributeValue new];
//        p_createdate.S = position.createDate;
//        AWSDynamoDBAttributeValue *p_modifyDate = [AWSDynamoDBAttributeValue new];
//        p_modifyDate.S = modifyd;
//        AWSDynamoDBAttributeValue *p_haskKeyValue = [AWSDynamoDBAttributeValue new];
//        p_haskKeyValue.S = position.uuid;
//        AWSDynamoDBAttributeValue *p_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        p_rangeKeyValue.S = position.parentUuid;
//        AWSDynamoDBAttributeValue *p_manageruuid = [AWSDynamoDBAttributeValue new];
//        p_manageruuid.S = position.managerUuid;
//        AWSDynamoDBAttributeValue *p_isdelete = [AWSDynamoDBAttributeValue new];
//        p_isdelete.N = [NSString stringWithFormat:@"%hd",position.isDelete];
//        AWSDynamoDBAttributeValue *p_tablename = [AWSDynamoDBAttributeValue new];
//        p_tablename.S = @"Positions";
//        AWSDynamoDBAttributeValue *p_positionname = [AWSDynamoDBAttributeValue new];
//        p_positionname.S = position.name;
//        AWSDynamoDBAttributeValue *p_isfavorite = [AWSDynamoDBAttributeValue new];
//        p_isfavorite.N = [NSString stringWithFormat:@"%hd",position.isFavorite];
//        AWSDynamoDBAttributeValue *p_color = [AWSDynamoDBAttributeValue new];
//        p_color.N = [NSString stringWithFormat:@"%hd",position.color];
//        AWSDynamoDBAttributeValue *p_positionmployees = [AWSDynamoDBAttributeValue new];
//        p_positionmployees.S = employeess;
//        if(employeess == nil)
//        {
//            writeRequest_position.putRequest.item = @{@"createDate": p_createdate,@"modifyDate" : p_modifyDate,@"uuid": p_haskKeyValue,@"managerUuid": p_manageruuid,@"parentUuid": p_rangeKeyValue,@"isDelete": p_isdelete,@"tableIdentityID": p_tablename,@"p_positionname": p_positionname,@"position_isFavorite": p_isfavorite,@"position_color": p_color};
//        }
//        else
//        {
//            writeRequest_position.putRequest.item = @{@"createDate": p_createdate,@"modifyDate" : p_modifyDate,@"uuid": p_haskKeyValue,@"managerUuid": p_manageruuid,@"parentUuid": p_rangeKeyValue,@"isDelete": p_isdelete,@"tableIdentityID": p_tablename,@"position_name": p_positionname,@"position_isFavorite": p_isfavorite,@"position_color": p_color,@"position_employees": p_positionmployees};
//        }
//        [arr_writeRequest addObject:writeRequest_position];
//    }
//    
//    for (Requests *request in arr_request) {
//        
//        AWSDynamoDBWriteRequest *writeRequest_request = [AWSDynamoDBWriteRequest new];
//        writeRequest_request.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *r_createdate = [AWSDynamoDBAttributeValue new];
//        r_createdate.S = request.createDate;
//        AWSDynamoDBAttributeValue *r_modifyDate = [AWSDynamoDBAttributeValue new];
//        r_modifyDate.S = modifyd;
//        AWSDynamoDBAttributeValue *r_haskKeyValue = [AWSDynamoDBAttributeValue new];
//        r_haskKeyValue.S = request.uuid;
//        AWSDynamoDBAttributeValue *r_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        r_rangeKeyValue.S = request.parentUuid;
//        AWSDynamoDBAttributeValue *r_isdelete = [AWSDynamoDBAttributeValue new];
//        r_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//        AWSDynamoDBAttributeValue *r_tablename = [AWSDynamoDBAttributeValue new];
//        r_tablename.S = @"Requests";
//        
//        writeRequest_request.putRequest.item = @{@"createDate": r_createdate,@"modifyDate" : r_modifyDate,@"uuid": r_haskKeyValue,@"parentUuid": r_rangeKeyValue,@"isDelete": r_isdelete,@"tableIdentityID": r_tablename};
//        
//        [arr_writeRequest addObject:writeRequest_request];
//    }
//    
//    for (Availability *avai in arr_availability) {
//        
//        AWSDynamoDBWriteRequest *writeRequest_avai = [AWSDynamoDBWriteRequest new];
//        writeRequest_avai.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *a_createdate = [AWSDynamoDBAttributeValue new];
//        a_createdate.S = avai.createDate;
//        AWSDynamoDBAttributeValue *a_modifyDate = [AWSDynamoDBAttributeValue new];
//        a_modifyDate.S = modifyd;
//        AWSDynamoDBAttributeValue *a_haskKeyValue = [AWSDynamoDBAttributeValue new];
//        a_haskKeyValue.S = avai.uuid;
//        AWSDynamoDBAttributeValue *a_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        a_rangeKeyValue.S = avai.parentUuid;
//        AWSDynamoDBAttributeValue *a_isdelete = [AWSDynamoDBAttributeValue new];
//        a_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//        AWSDynamoDBAttributeValue *a_tablename = [AWSDynamoDBAttributeValue new];
//        a_tablename.S = @"Availability";
//        
//        writeRequest_avai.putRequest.item = @{@"createDate": a_createdate,@"modifyDate" : a_modifyDate,@"uuid": a_haskKeyValue,@"parentUuid": a_rangeKeyValue,@"isDelete": a_isdelete,@"tableIdentityID": a_tablename};
//        
//        [arr_writeRequest addObject:writeRequest_avai];
//    }
//    
//    for (Drop *drop in arr_drop) {
//        
//        AWSDynamoDBWriteRequest *writeRequest_drop = [AWSDynamoDBWriteRequest new];
//        writeRequest_drop.putRequest = [AWSDynamoDBPutRequest new];
//        
//        AWSDynamoDBAttributeValue *d_createdate = [AWSDynamoDBAttributeValue new];
//        d_createdate.S = drop.createDate;
//        AWSDynamoDBAttributeValue *d_modifyDate = [AWSDynamoDBAttributeValue new];
//        d_modifyDate.S = modifyd;
//        AWSDynamoDBAttributeValue *d_haskKeyValue = [AWSDynamoDBAttributeValue new];
//        d_haskKeyValue.S = drop.uuid;
//        AWSDynamoDBAttributeValue *d_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//        d_rangeKeyValue.S = drop.parentUuid;
//        AWSDynamoDBAttributeValue *d_isdelete = [AWSDynamoDBAttributeValue new];
//        d_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//        AWSDynamoDBAttributeValue *d_tablename = [AWSDynamoDBAttributeValue new];
//        d_tablename.S = @"Drop";
//        
//        writeRequest_drop.putRequest.item = @{@"createDate": d_createdate,@"modifyDate" : d_modifyDate,@"uuid": d_haskKeyValue,@"parentUuid": d_rangeKeyValue,@"isDelete": d_isdelete,@"tableIdentityID": d_tablename};
//        
//        [arr_writeRequest addObject:writeRequest_drop];
//    }
//    
//    if (isdelete == YES) {
//        for (Shifts *shift in arr_shifts) {
//            
//            AWSDynamoDBWriteRequest *writeRequest_shift = [AWSDynamoDBWriteRequest new];
//            writeRequest_shift.putRequest = [AWSDynamoDBPutRequest new];
//            
//            AWSDynamoDBAttributeValue *s_createdate = [AWSDynamoDBAttributeValue new];
//            s_createdate.S = shift.createDate;
//            AWSDynamoDBAttributeValue *s_modifyDate = [AWSDynamoDBAttributeValue new];
//            s_modifyDate.S = modifyd;
//            AWSDynamoDBAttributeValue *s_haskKeyValue = [AWSDynamoDBAttributeValue new];
//            s_haskKeyValue.S = shift.uuid;
//            AWSDynamoDBAttributeValue *s_rangeKeyValue = [AWSDynamoDBAttributeValue new];
//            s_rangeKeyValue.S = shift.parentUuid;
//            AWSDynamoDBAttributeValue *s_isdelete = [AWSDynamoDBAttributeValue new];
//            s_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//            AWSDynamoDBAttributeValue *s_tablename = [AWSDynamoDBAttributeValue new];
//            s_tablename.S = @"Shifts";
//            
//            writeRequest_shift.putRequest.item = @{@"createDate": s_createdate,@"modifyDate" : s_modifyDate,@"uuid": s_haskKeyValue,@"parentUuid": s_rangeKeyValue,@"isDelete": s_isdelete,@"tableIdentityID": s_tablename};
//            
//            [arr_writeRequest addObject:writeRequest_shift];
//        }
//    }
//    else
//    {
//        NSMutableArray *arr_useshift = [NSMutableArray array];
//        NSNumber *nowDate = [StringManager dateTransferTimeStamp:[NSDate date]];
//        
//        NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
//        [defau setObject:nowDate forKey:@"nowdate"];
//        
//        for (Shifts *shift in arr_shifts) {
//            if ([shift.endTime longLongValue] > [nowDate longLongValue] || shift.takeState == 0) {
//                [arr_useshift addObject:shift];
//            }
//        }
//        for (Shifts *shift in arr_useshift) {
//            
//            AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
//            writeRequest.putRequest = [AWSDynamoDBPutRequest new];
//            
//            AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
//            createdate.S = shift.createDate;
//            AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
//            modifyDate.S = modifyd;
//            AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
//            haskKeyValue.S = shift.uuid;
//            AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
//            rangeKeyValue.S = shift.parentUuid;
//            AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
//            manageruuid.S = shift.managerUuid;
//            AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
//            isdelete.N = [NSString stringWithFormat:@"%hd",shift.isDelete];
//            AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
//            tablename.S = @"Shifts";
//            
//            AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
//            employeeuuid.S = OpenShiftEmployeeUuid;
//            AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
//            employeename.S = OpenShiftEmployeeName;
//            AWSDynamoDBAttributeValue *locationuuid = [AWSDynamoDBAttributeValue new];
//            locationuuid.S = shift.locationUuid;
//            AWSDynamoDBAttributeValue *positionuuid = [AWSDynamoDBAttributeValue new];
//            if (shift.positionUuid != nil) {
//                positionuuid.S = shift.positionUuid;
//            }
//            AWSDynamoDBAttributeValue *startdate = [AWSDynamoDBAttributeValue new];
//            startdate.S = shift.startDate;
//            AWSDynamoDBAttributeValue *starttime = [AWSDynamoDBAttributeValue new];
//            starttime.S = shift.startTime;
//            AWSDynamoDBAttributeValue *endtime = [AWSDynamoDBAttributeValue new];
//            endtime.S = shift.endTime;
//            AWSDynamoDBAttributeValue *totalhours = [AWSDynamoDBAttributeValue new];
//            totalhours.S = shift.totalHours;
//            AWSDynamoDBAttributeValue *unbreak = [AWSDynamoDBAttributeValue new];
//            unbreak.S = shift.unpaidBreak;
//
//            AWSDynamoDBAttributeValue *shiftnotes = [AWSDynamoDBAttributeValue new];
//            if (shift.notes != nil) {
//                shiftnotes.S = shift.notes;
//            }
//            AWSDynamoDBAttributeValue *str_year = [AWSDynamoDBAttributeValue new];
//            str_year.S = shift.string_year;
//            AWSDynamoDBAttributeValue *str_month = [AWSDynamoDBAttributeValue new];
//            str_month.S = shift.string_month;
//            AWSDynamoDBAttributeValue *str_day = [AWSDynamoDBAttributeValue new];
//            str_day.S = shift.string_day;
//            AWSDynamoDBAttributeValue *str_week = [AWSDynamoDBAttributeValue new];
//            str_week.S = shift.string_week;
//            AWSDynamoDBAttributeValue *str_time = [AWSDynamoDBAttributeValue new];
//            str_time.S = shift.string_time;
//            AWSDynamoDBAttributeValue *istake = [AWSDynamoDBAttributeValue new];
//            istake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//            AWSDynamoDBAttributeValue *takestate = [AWSDynamoDBAttributeValue new];
//            takestate.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
//            AWSDynamoDBAttributeValue *needemployeenumber = [AWSDynamoDBAttributeValue new];
//            needemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
//            AWSDynamoDBAttributeValue *havetakeemployeenumber = [AWSDynamoDBAttributeValue new];
//            havetakeemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
//            
//            if (shift.positionUuid == nil && shift.notes == nil) {
//                
//                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber};
//            }
//            else if (shift.positionUuid == nil && shift.notes != nil)
//            {
//                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_notes": shiftnotes};
//            }
//            else if (shift.positionUuid != nil && shift.notes != nil)
//            {
//                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_notes": shiftnotes};
//            }
//            else if (shift.positionUuid != nil && shift.notes == nil)
//            {
//                writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid};
//            }
//            
//            [arr_writeRequest addObject:writeRequest];
//        }
//    }
    
    return arr_writeRequest;
}

//employee accept drop the shift
+ (NSMutableArray *) getShiftWriteRequestByShiftuuid:(NSString *)uuid andDropWriteRequestByDropUuid:(NSString *) dropuuid;
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
    Shifts *shift = [DatabaseManager getShiftByUuid:uuid];
    
    NSString *modifyd = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    
    AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
    writeRequest.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
    createdate.S = shift.createDate;
    AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
    modifyDate.S = modifyd;
    AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
    haskKeyValue.S = shift.uuid;
    AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
    rangeKeyValue.S = shift.parentUuid;
    AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
    manageruuid.S = shift.managerUuid;
    AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
    isdelete.N = [NSString stringWithFormat:@"%hd",shift.isDelete];
    AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
    tablename.S = @"Shifts";
    
    AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
    AppDelegate *appdelete = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    employeeuuid.S = appdelete.currentEmployee.uuid;
    AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
    Employees *employee = [DatabaseManager getEmployeeByUuid:appdelete.currentEmployee.uuid];
    employeename.S = employee.fullName;
    
    AWSDynamoDBAttributeValue *locationuuid = [AWSDynamoDBAttributeValue new];
    locationuuid.S = shift.locationUuid;
    AWSDynamoDBAttributeValue *positionuuid = [AWSDynamoDBAttributeValue new];
    if (shift.positionUuid != nil) {
        positionuuid.S = shift.positionUuid;
    }
    AWSDynamoDBAttributeValue *startdate = [AWSDynamoDBAttributeValue new];
    startdate.S = shift.startDate;
    AWSDynamoDBAttributeValue *starttime = [AWSDynamoDBAttributeValue new];
    starttime.S = shift.startTime;
    AWSDynamoDBAttributeValue *endtime = [AWSDynamoDBAttributeValue new];
    endtime.S = shift.endTime;
    AWSDynamoDBAttributeValue *totalhours = [AWSDynamoDBAttributeValue new];
    totalhours.S = shift.totalHours;
    AWSDynamoDBAttributeValue *unbreak = [AWSDynamoDBAttributeValue new];
    unbreak.S = shift.unpaidBreak;

    AWSDynamoDBAttributeValue *shiftnotes = [AWSDynamoDBAttributeValue new];
    if (shift.notes != nil) {
        shiftnotes.S = shift.notes;
    }
    AWSDynamoDBAttributeValue *str_year = [AWSDynamoDBAttributeValue new];
    str_year.S = shift.string_year;
    AWSDynamoDBAttributeValue *str_month = [AWSDynamoDBAttributeValue new];
    str_month.S = shift.string_month;
    AWSDynamoDBAttributeValue *str_day = [AWSDynamoDBAttributeValue new];
    str_day.S = shift.string_day;
    AWSDynamoDBAttributeValue *str_week = [AWSDynamoDBAttributeValue new];
    str_week.S = shift.string_week;
    AWSDynamoDBAttributeValue *str_time = [AWSDynamoDBAttributeValue new];
    str_time.S = shift.string_time;
    AWSDynamoDBAttributeValue *istake = [AWSDynamoDBAttributeValue new];
    istake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
    AWSDynamoDBAttributeValue *takestate = [AWSDynamoDBAttributeValue new];
    takestate.N = [NSString stringWithFormat:@"%hd",shift.takeState];
    
    if (shift.positionUuid == nil && shift.notes == nil) {
        
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate};
    }
    else if (shift.positionUuid == nil && shift.notes != nil)
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_notes": shiftnotes};
    }
    else if (shift.positionUuid != nil && shift.notes != nil)
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_positionUuid": positionuuid,@"shift_notes": shiftnotes};
    }
    else
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_notes": shiftnotes};
    }
    
    [arr_writeRequest addObject:writeRequest];
    
    
    Drop *drop = [DatabaseManager getDropByUuid:dropuuid];
    
    AWSDynamoDBWriteRequest *writeRequest2 = [AWSDynamoDBWriteRequest new];
    writeRequest2.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *createdate2 = [AWSDynamoDBAttributeValue new];
    createdate2.S = drop.createDate;
    AWSDynamoDBAttributeValue *modifyDate2 = [AWSDynamoDBAttributeValue new];
    modifyDate2.S = modifyd;
    AWSDynamoDBAttributeValue *haskKeyValue2 = [AWSDynamoDBAttributeValue new];
    haskKeyValue2.S = drop.uuid;
    AWSDynamoDBAttributeValue *rangeKeyValue2 = [AWSDynamoDBAttributeValue new];
    rangeKeyValue2.S = drop.parentUuid;
    AWSDynamoDBAttributeValue *manageruuid2 = [AWSDynamoDBAttributeValue new];
    manageruuid2.S = drop.managerUuid;
    AWSDynamoDBAttributeValue *isdelete2 = [AWSDynamoDBAttributeValue new];
    isdelete2.N = [NSString stringWithFormat:@"%hd",drop.isDelete];
    AWSDynamoDBAttributeValue *tablename2 = [AWSDynamoDBAttributeValue new];
    tablename2.S = @"Drop";
    AWSDynamoDBAttributeValue *parentshiftuuid = [AWSDynamoDBAttributeValue new];
    parentshiftuuid.S = drop.parentShiftUuid;
    AWSDynamoDBAttributeValue *orishiftemployeeuuid = [AWSDynamoDBAttributeValue new];
    orishiftemployeeuuid.S = drop.oriShiftEmployeeUuid;
    AWSDynamoDBAttributeValue *ismanageraccept = [AWSDynamoDBAttributeValue new];
    ismanageraccept.N = [NSString stringWithFormat:@"%hd",drop.isManagerAccepted];
    AWSDynamoDBAttributeValue *isdrop = [AWSDynamoDBAttributeValue new];
    isdrop.N = [NSString stringWithFormat:@"%hd",drop.isDrop];
    AWSDynamoDBAttributeValue *message = [AWSDynamoDBAttributeValue new];
    if (drop.message != nil) {
        message.S = drop.message;
    }
    AWSDynamoDBAttributeValue *state = [AWSDynamoDBAttributeValue new];
    state.S = @"1";
    AWSDynamoDBAttributeValue *Dropuuids = [AWSDynamoDBAttributeValue new];
    Dropuuids.S = drop.dropUuids;
    
    AWSDynamoDBAttributeValue *DeclineDropuuids = [AWSDynamoDBAttributeValue new];
    if (drop.declineDropUuids != nil) {
        DeclineDropuuids.S = drop.declineDropUuids;
    }
    
    AWSDynamoDBAttributeValue *acceptedemployee = [AWSDynamoDBAttributeValue new];
    acceptedemployee.S = appdelete.currentEmployee.uuid;
    
    
    if (drop.message != nil && drop.declineDropUuids != nil) {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"drop_parentShidtUuid": parentshiftuuid,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid,@"drop_isManagerAccepted": ismanageraccept,@"drop_isDrop": isdrop,@"drop_messsage": message,@"drop_state": state,@"drop_dropUuids": Dropuuids,@"drop_delcineDropUuids": DeclineDropuuids,@"drop_dropAccptedEmploueeUuid": acceptedemployee};
    }
    else if (drop.message != nil && drop.declineDropUuids == nil)
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"drop_parentShidtUuid": parentshiftuuid,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid,@"drop_isManagerAccepted": ismanageraccept,@"drop_isDrop": isdrop,@"drop_messsage": message,@"drop_state": state,@"drop_dropUuids": Dropuuids,@"drop_dropAccptedEmploueeUuid": acceptedemployee};
    }
    else if (drop.message == nil && drop.declineDropUuids != nil)
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"drop_parentShidtUuid": parentshiftuuid,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid,@"drop_isManagerAccepted": ismanageraccept,@"drop_isDrop": isdrop,@"drop_state": state,@"drop_dropUuids": Dropuuids,@"drop_delcineDropUuids": DeclineDropuuids,@"drop_dropAccptedEmploueeUuid": acceptedemployee};
    }
    else
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"drop_parentShidtUuid": parentshiftuuid,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid,@"drop_isManagerAccepted": ismanageraccept,@"drop_isDrop": isdrop,@"drop_state": state,@"drop_dropUuids": Dropuuids,@"drop_dropAccptedEmploueeUuid": acceptedemployee};
    }
    
    [arr_writeRequest addObject:writeRequest2];
    
    return arr_writeRequest;
}

//employee swap the shift
+ (NSMutableArray *) getShiftWriteRequestByOriShiftuuid:(NSString *)oriShiftUuid andMyShiftUuid: (NSString *) myShiftUuid andSwapWriteRequestBySwappUuid:(NSString *) swapuuid;
{
    
    //swap shift,只交换时间地点职位
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
    Shifts *orishift = [DatabaseManager getShiftByUuid:oriShiftUuid];
    Shifts *myshift = [DatabaseManager getShiftByUuid:myShiftUuid];
    
    Employees *oriemployee = [DatabaseManager getEmployeeByUuid:orishift.employeeUuid];
    Employees *acceptemployee = [DatabaseManager getEmployeeByUuid:myshift.employeeUuid];
    
    NSString *mymodifydate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    
    AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
    writeRequest.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
    createdate.S = orishift.createDate;
    AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
    modifyDate.S = mymodifydate;
    AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
    haskKeyValue.S = orishift.uuid;
    AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
    rangeKeyValue.S = orishift.parentUuid;
    AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
    manageruuid.S = orishift.managerUuid;
    AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
    isdelete.N = [NSString stringWithFormat:@"%hd",orishift.isDelete];
    AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
    tablename.S = @"Shifts";
    AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
    employeeuuid.S = orishift.employeeUuid;
    AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
    employeename.S = oriemployee.fullName;
    
    
    AWSDynamoDBAttributeValue *locationuuid = [AWSDynamoDBAttributeValue new];
    locationuuid.S = orishift.locationUuid;
    AWSDynamoDBAttributeValue *positionuuid = [AWSDynamoDBAttributeValue new];
    if (orishift.positionUuid != nil) {
        positionuuid.S = orishift.positionUuid;
    }
    AWSDynamoDBAttributeValue *startdate = [AWSDynamoDBAttributeValue new];
    startdate.S = myshift.startDate;
    AWSDynamoDBAttributeValue *starttime = [AWSDynamoDBAttributeValue new];
    starttime.S = myshift.startTime;
    AWSDynamoDBAttributeValue *endtime = [AWSDynamoDBAttributeValue new];
    endtime.S = myshift.endTime;
    AWSDynamoDBAttributeValue *totalhours = [AWSDynamoDBAttributeValue new];
    totalhours.S = myshift.totalHours;
    AWSDynamoDBAttributeValue *unbreak = [AWSDynamoDBAttributeValue new];
    unbreak.S = myshift.unpaidBreak;

    AWSDynamoDBAttributeValue *shiftnotes = [AWSDynamoDBAttributeValue new];
    if (myshift.notes != nil) {
        shiftnotes.S = myshift.notes;
    }
    AWSDynamoDBAttributeValue *str_year = [AWSDynamoDBAttributeValue new];
    str_year.S = myshift.string_year;
    AWSDynamoDBAttributeValue *str_month = [AWSDynamoDBAttributeValue new];
    str_month.S = myshift.string_month;
    AWSDynamoDBAttributeValue *str_day = [AWSDynamoDBAttributeValue new];
    str_day.S = myshift.string_day;
    AWSDynamoDBAttributeValue *str_week = [AWSDynamoDBAttributeValue new];
    str_week.S = myshift.string_week;
    AWSDynamoDBAttributeValue *str_time = [AWSDynamoDBAttributeValue new];
    str_time.S = myshift.string_time;
    AWSDynamoDBAttributeValue *istake = [AWSDynamoDBAttributeValue new];
    istake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
    AWSDynamoDBAttributeValue *takestate = [AWSDynamoDBAttributeValue new];
    takestate.N = [NSString stringWithFormat:@"%hd",myshift.takeState];
    
    if (orishift.positionUuid == nil && myshift.notes == nil) {
        
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate};
    }
    else if (orishift.positionUuid == nil && myshift.notes != nil)
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_notes": shiftnotes};
    }
    else if (orishift.positionUuid != nil && myshift.notes != nil)
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_positionUuid": positionuuid,@"shift_notes": shiftnotes};
    }
    else
    {
        writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"isDelete": isdelete,@"shift_employeeUuid": employeeuuid,@"shift_employeeName":employeename,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate};
    }
    
    [arr_writeRequest addObject:writeRequest];
    
    
    AWSDynamoDBWriteRequest *writeRequest2 = [AWSDynamoDBWriteRequest new];
    writeRequest2.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *createdate2 = [AWSDynamoDBAttributeValue new];
    createdate2.S = myshift.createDate;
    AWSDynamoDBAttributeValue *modifyDate2 = [AWSDynamoDBAttributeValue new];
    modifyDate2.S = mymodifydate;
    AWSDynamoDBAttributeValue *haskKeyValue2 = [AWSDynamoDBAttributeValue new];
    haskKeyValue2.S = myshift.uuid;
    AWSDynamoDBAttributeValue *rangeKeyValue2 = [AWSDynamoDBAttributeValue new];
    rangeKeyValue2.S = myshift.parentUuid;
    AWSDynamoDBAttributeValue *manageruuid2 = [AWSDynamoDBAttributeValue new];
    manageruuid2.S = myshift.managerUuid;
    AWSDynamoDBAttributeValue *isdelete2 = [AWSDynamoDBAttributeValue new];
    isdelete2.N = [NSString stringWithFormat:@"%hd",myshift.isDelete];
    AWSDynamoDBAttributeValue *tablename2 = [AWSDynamoDBAttributeValue new];
    tablename2.S = @"Shifts";
    AWSDynamoDBAttributeValue *employeeuuid2 = [AWSDynamoDBAttributeValue new];
    employeeuuid2.S = myshift.employeeUuid;
    AWSDynamoDBAttributeValue *employeename2 = [AWSDynamoDBAttributeValue new];
    employeename2.S = acceptemployee.fullName;
    
    AWSDynamoDBAttributeValue *locationuuid2 = [AWSDynamoDBAttributeValue new];
    locationuuid2.S = myshift.locationUuid;
    AWSDynamoDBAttributeValue *positionuuid2 = [AWSDynamoDBAttributeValue new];
    if (myshift.positionUuid != nil) {
        positionuuid2.S = myshift.positionUuid;
    }
    AWSDynamoDBAttributeValue *startdate2 = [AWSDynamoDBAttributeValue new];
    startdate2.S = orishift.startDate;
    AWSDynamoDBAttributeValue *starttime2 = [AWSDynamoDBAttributeValue new];
    starttime2.S = orishift.startTime;
    AWSDynamoDBAttributeValue *endtime2 = [AWSDynamoDBAttributeValue new];
    endtime2.S = orishift.endTime;
    AWSDynamoDBAttributeValue *totalhours2 = [AWSDynamoDBAttributeValue new];
    totalhours2.S = orishift.totalHours;
    AWSDynamoDBAttributeValue *unbreak2 = [AWSDynamoDBAttributeValue new];
    unbreak2.S = orishift.unpaidBreak;
    AWSDynamoDBAttributeValue *shiftnotes2 = [AWSDynamoDBAttributeValue new];
    if (orishift.notes != nil) {
        shiftnotes2.S = orishift.notes;
    }
    AWSDynamoDBAttributeValue *str_year2 = [AWSDynamoDBAttributeValue new];
    str_year2.S = orishift.string_year;
    AWSDynamoDBAttributeValue *str_month2 = [AWSDynamoDBAttributeValue new];
    str_month2.S = orishift.string_month;
    AWSDynamoDBAttributeValue *str_day2 = [AWSDynamoDBAttributeValue new];
    str_day2.S = orishift.string_day;
    AWSDynamoDBAttributeValue *str_week2 = [AWSDynamoDBAttributeValue new];
    str_week2.S = orishift.string_week;
    AWSDynamoDBAttributeValue *str_time2 = [AWSDynamoDBAttributeValue new];
    str_time2.S = orishift.string_time;
    AWSDynamoDBAttributeValue *istake2 = [AWSDynamoDBAttributeValue new];
    istake2.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
    AWSDynamoDBAttributeValue *takestate2 = [AWSDynamoDBAttributeValue new];
    takestate2.N = [NSString stringWithFormat:@"%hd",orishift.takeState];
    
    if (myshift.positionUuid == nil && orishift.notes == nil) {
        
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"shift_employeeUuid": employeeuuid2,@"shift_employeeName":employeename2,@"shift_locationUuid": locationuuid2,@"shift_startDate": startdate2,@"shift_startTime": starttime2,@"shift_endTime": endtime2,@"shift_totalHours": totalhours2,@"shift_unPaidBreak": unbreak2,@"shift_strYear": str_year2,@"shift_strMonth": str_month2,@"shift_strDay": str_day2,@"shift_strWeek": str_week2,@"shift_strTime": str_time2,@"shift_isTake": istake2,@"shift_takedState": takestate2};
    }
    else if (myshift.positionUuid == nil && orishift.notes != nil)
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"shift_employeeUuid": employeeuuid2,@"shift_employeeName":employeename2,@"shift_locationUuid": locationuuid2,@"shift_startDate": startdate2,@"shift_startTime": starttime2,@"shift_endTime": endtime2,@"shift_totalHours": totalhours2,@"shift_unPaidBreak": unbreak2,@"shift_strYear": str_year2,@"shift_strMonth": str_month2,@"shift_strDay": str_day2,@"shift_strWeek": str_week2,@"shift_strTime": str_time2,@"shift_isTake": istake2,@"shift_takedState": takestate2,@"shift_notes": shiftnotes2};
    }
    else if (myshift.positionUuid != nil && orishift.notes != nil)
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"shift_employeeUuid": employeeuuid2,@"shift_employeeName":employeename2,@"shift_locationUuid": locationuuid2,@"shift_startDate": startdate2,@"shift_startTime": starttime2,@"shift_endTime": endtime2,@"shift_totalHours": totalhours2,@"shift_unPaidBreak": unbreak2,@"shift_strYear": str_year2,@"shift_strMonth": str_month2,@"shift_strDay": str_day2,@"shift_strWeek": str_week,@"shift_strTime": str_time2,@"shift_isTake": istake2,@"shift_takedState": takestate2,@"shift_positionUuid": positionuuid2,@"shift_notes": shiftnotes2};
    }
    else
    {
        writeRequest2.putRequest.item = @{@"createDate": createdate2,@"modifyDate" : modifyDate2,@"uuid": haskKeyValue2,@"managerUuid": manageruuid2,@"parentUuid": rangeKeyValue2,@"isDelete": isdelete2,@"tableIdentityID": tablename2,@"isDelete": isdelete2,@"shift_employeeUuid": employeeuuid2,@"shift_employeeName":employeename2,@"shift_locationUuid": locationuuid2,@"shift_startDate": startdate2,@"shift_startTime": starttime2,@"shift_endTime": endtime2,@"shift_totalHours": totalhours2,@"shift_unPaidBreak": unbreak2,@"shift_strYear": str_year2,@"shift_strMonth": str_month2,@"shift_strDay": str_day2,@"shift_strWeek": str_week2,@"shift_strTime": str_time2,@"shift_isTake": istake2,@"shift_takedState": takestate2};
    }
    
    [arr_writeRequest addObject:writeRequest2];
    
    
    Drop *swap = [DatabaseManager getDropByUuid:swapuuid];
    
    AWSDynamoDBWriteRequest *writeRequest3 = [AWSDynamoDBWriteRequest new];
    writeRequest3.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *createdate3 = [AWSDynamoDBAttributeValue new];
    createdate3.S = swap.createDate;
    AWSDynamoDBAttributeValue *modifyDate3 = [AWSDynamoDBAttributeValue new];
    modifyDate3.S = mymodifydate;
    AWSDynamoDBAttributeValue *haskKeyValue3 = [AWSDynamoDBAttributeValue new];
    haskKeyValue3.S = swap.uuid;
    AWSDynamoDBAttributeValue *rangeKeyValue3 = [AWSDynamoDBAttributeValue new];
    rangeKeyValue3.S = swap.parentUuid;
    AWSDynamoDBAttributeValue *manageruuid3 = [AWSDynamoDBAttributeValue new];
    manageruuid3.S = swap.managerUuid;
    AWSDynamoDBAttributeValue *isdelete3 = [AWSDynamoDBAttributeValue new];
    isdelete3.N = [NSString stringWithFormat:@"%hd",swap.isDelete];
    AWSDynamoDBAttributeValue *tablename3 = [AWSDynamoDBAttributeValue new];
    tablename3.S = @"Drop";
    AWSDynamoDBAttributeValue *parentshiftuuid3 = [AWSDynamoDBAttributeValue new];
    parentshiftuuid3.S = myShiftUuid;
    AWSDynamoDBAttributeValue *orishiftemployeeuuid3 = [AWSDynamoDBAttributeValue new];
    orishiftemployeeuuid3.S = swap.oriShiftEmployeeUuid;
    AWSDynamoDBAttributeValue *ismanageraccept3 = [AWSDynamoDBAttributeValue new];
    ismanageraccept3.N = [NSString stringWithFormat:@"%hd",swap.isManagerAccepted];
    AWSDynamoDBAttributeValue *isdrop3 = [AWSDynamoDBAttributeValue new];
    isdrop3.N = [NSString stringWithFormat:@"%hd",swap.isDrop];
    AWSDynamoDBAttributeValue *message3 = [AWSDynamoDBAttributeValue new];
    if (swap.message != nil) {
        message3.S = swap.message;
    }
    AWSDynamoDBAttributeValue *state3 = [AWSDynamoDBAttributeValue new];
    state3.S = @"1";
    AWSDynamoDBAttributeValue *Dropuuids3 = [AWSDynamoDBAttributeValue new];
    Dropuuids3.S = swap.dropUuids;
    
    AWSDynamoDBAttributeValue *DeclineDropuuids = [AWSDynamoDBAttributeValue new];
    if (swap.declineDropUuids != nil) {
        DeclineDropuuids.S = swap.declineDropUuids;
    }
    
    AWSDynamoDBAttributeValue *accepteshiftuuid = [AWSDynamoDBAttributeValue new];
    accepteshiftuuid.S = myShiftUuid;
    
    AWSDynamoDBAttributeValue *swapshiftuuid1 = [AWSDynamoDBAttributeValue new];
    swapshiftuuid1.S = orishift.uuid;
    AWSDynamoDBAttributeValue *swapshiftuuid2 = [AWSDynamoDBAttributeValue new];
    swapshiftuuid2.S = myShiftUuid;
    
    if (swap.message != nil && swap.declineDropUuids != nil) {
        writeRequest3.putRequest.item = @{@"createDate": createdate3,@"modifyDate" : modifyDate3,@"uuid": haskKeyValue3,@"managerUuid": manageruuid3,@"parentUuid": rangeKeyValue3,@"isDelete": isdelete3,@"tableIdentityID": tablename3,@"drop_parentShidtUuid": parentshiftuuid3,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid3,@"drop_isManagerAccepted": ismanageraccept3,@"drop_isDrop": isdrop3,@"drop_messsage": message3,@"drop_state": state3,@"drop_dropUuids": Dropuuids3,@"drop_delcineDropUuids": DeclineDropuuids,@"drop_swapAcceptedShiftUuid": accepteshiftuuid,@"drop_swapshiftuuid1":swapshiftuuid1,@"drop_swapshiftuuid2":swapshiftuuid2};
    }
    else if (swap.message == nil && swap.declineDropUuids != nil)
    {
        writeRequest3.putRequest.item = @{@"createDate": createdate3,@"modifyDate" : modifyDate3,@"uuid": haskKeyValue3,@"managerUuid": manageruuid3,@"parentUuid": rangeKeyValue3,@"isDelete": isdelete3,@"tableIdentityID": tablename3,@"drop_parentShidtUuid": parentshiftuuid3,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid3,@"drop_isManagerAccepted": ismanageraccept3,@"drop_isDrop": isdrop3,@"drop_state": state3,@"drop_dropUuids": Dropuuids3,@"drop_delcineDropUuids": DeclineDropuuids,@"drop_swapAcceptedShiftUuid": accepteshiftuuid,@"drop_swapshiftuuid1":swapshiftuuid1,@"drop_swapshiftuuid2":swapshiftuuid2};
    }
    else if (swap.message != nil && swap.declineDropUuids == nil)
    {
        writeRequest3.putRequest.item = @{@"createDate": createdate3,@"modifyDate" : modifyDate3,@"uuid": haskKeyValue3,@"managerUuid": manageruuid3,@"parentUuid": rangeKeyValue3,@"isDelete": isdelete3,@"tableIdentityID": tablename3,@"drop_parentShidtUuid": parentshiftuuid3,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid3,@"drop_isManagerAccepted": ismanageraccept3,@"drop_isDrop": isdrop3,@"drop_messsage": message3,@"drop_state": state3,@"drop_dropUuids": Dropuuids3,@"drop_swapAcceptedShiftUuid": accepteshiftuuid,@"drop_swapshiftuuid1":swapshiftuuid1,@"drop_swapshiftuuid2":swapshiftuuid2};
    }
    else
    {
        writeRequest3.putRequest.item = @{@"createDate": createdate3,@"modifyDate" : modifyDate3,@"uuid": haskKeyValue3,@"managerUuid": manageruuid3,@"parentUuid": rangeKeyValue3,@"isDelete": isdelete3,@"tableIdentityID": tablename3,@"drop_parentShidtUuid": parentshiftuuid3,@"drop_oriShiftEmployeeUuid": orishiftemployeeuuid3,@"drop_isManagerAccepted": ismanageraccept3,@"drop_isDrop": isdrop3  ,@"drop_state": state3,@"drop_dropUuids": Dropuuids3,@"drop_swapAcceptedShiftUuid": accepteshiftuuid,@"drop_swapshiftuuid1":swapshiftuuid1,@"drop_swapshiftuuid2":swapshiftuuid2};
    }
    
    [arr_writeRequest addObject:writeRequest3];
    
    return arr_writeRequest;
}

+ (NSMutableArray *) getShiftWriteRequestByTakeState:(NSNumber *) takeState andArray:(NSMutableArray *) arr_shifts
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    
    for (Shifts *shift in arr_shifts) {

        NSString *mymodifydate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        
        AWSDynamoDBWriteRequest *writeRequest = [AWSDynamoDBWriteRequest new];
        writeRequest.putRequest = [AWSDynamoDBPutRequest new];
        
        AWSDynamoDBAttributeValue *createdate = [AWSDynamoDBAttributeValue new];
        createdate.S = shift.createDate;
        AWSDynamoDBAttributeValue *modifyDate = [AWSDynamoDBAttributeValue new];
        modifyDate.S = mymodifydate;
        AWSDynamoDBAttributeValue *haskKeyValue = [AWSDynamoDBAttributeValue new];
        haskKeyValue.S = shift.uuid;
        AWSDynamoDBAttributeValue *rangeKeyValue = [AWSDynamoDBAttributeValue new];
        rangeKeyValue.S = shift.parentUuid;
        AWSDynamoDBAttributeValue *manageruuid = [AWSDynamoDBAttributeValue new];
        manageruuid.S = shift.managerUuid;
        AWSDynamoDBAttributeValue *isdelete = [AWSDynamoDBAttributeValue new];
        isdelete.N = [NSString stringWithFormat:@"%hd",shift.isDelete];
        AWSDynamoDBAttributeValue *tablename = [AWSDynamoDBAttributeValue new];
        tablename.S = @"Shifts";
        
        AWSDynamoDBAttributeValue *employeeuuid = [AWSDynamoDBAttributeValue new];
        employeeuuid.S = shift.employeeUuid;
        AWSDynamoDBAttributeValue *employeename = [AWSDynamoDBAttributeValue new];
        employeename.S = shift.employeeName;
        if (shift.employeeName == nil) {
            Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
            if (employee != nil) {
                employeename.S = employee.fullName;
            }
            else
            {
                employeename.S = OpenShiftEmployeeName;
            }
        }
        AWSDynamoDBAttributeValue *locationuuid = [AWSDynamoDBAttributeValue new];
        locationuuid.S = shift.locationUuid;
        AWSDynamoDBAttributeValue *positionuuid = [AWSDynamoDBAttributeValue new];
        if (shift.positionUuid != nil) {
            positionuuid.S = shift.positionUuid;
        }
        AWSDynamoDBAttributeValue *startdate = [AWSDynamoDBAttributeValue new];
        startdate.S = shift.startDate;
        AWSDynamoDBAttributeValue *starttime = [AWSDynamoDBAttributeValue new];
        starttime.S = shift.startTime;
        AWSDynamoDBAttributeValue *endtime = [AWSDynamoDBAttributeValue new];
        endtime.S = shift.endTime;
        AWSDynamoDBAttributeValue *totalhours = [AWSDynamoDBAttributeValue new];
        totalhours.S = shift.totalHours;
        AWSDynamoDBAttributeValue *unbreak = [AWSDynamoDBAttributeValue new];
        unbreak.S = shift.unpaidBreak;
        AWSDynamoDBAttributeValue *openshiftemployees = [AWSDynamoDBAttributeValue new];
        if (shift.openShift_employees != nil) {
            openshiftemployees.S = shift.openShift_employees;
        }
        AWSDynamoDBAttributeValue *needemployeenumber = [AWSDynamoDBAttributeValue new];
        needemployeenumber.N = [NSString stringWithFormat:@"%hd",shift.needEmployeesNumber];
        if (shift.needEmployeesNumber == 0) {
            needemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
        }
        AWSDynamoDBAttributeValue *shiftnotes = [AWSDynamoDBAttributeValue new];
        if (shift.notes != nil) {
            shiftnotes.S = shift.notes;
        }
        AWSDynamoDBAttributeValue *str_year = [AWSDynamoDBAttributeValue new];
        str_year.S = shift.string_year;
        AWSDynamoDBAttributeValue *str_month = [AWSDynamoDBAttributeValue new];
        str_month.S = shift.string_month;
        AWSDynamoDBAttributeValue *str_day = [AWSDynamoDBAttributeValue new];
        str_day.S = shift.string_day;
        AWSDynamoDBAttributeValue *str_week = [AWSDynamoDBAttributeValue new];
        str_week.S = shift.string_week;
        AWSDynamoDBAttributeValue *str_time = [AWSDynamoDBAttributeValue new];
        str_time.S = shift.string_time;
        AWSDynamoDBAttributeValue *istake = [AWSDynamoDBAttributeValue new];
        istake.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
        AWSDynamoDBAttributeValue *takestate = [AWSDynamoDBAttributeValue new];
        takestate.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[takeState intValue]]];
        AWSDynamoDBAttributeValue *havetakeemployeenumber = [AWSDynamoDBAttributeValue new];
        havetakeemployeenumber.N = [NSString stringWithFormat:@"%hd",shift.haveTakedEmployeesNumber];
        if (shift.haveTakedEmployeesNumber == 0) {
            havetakeemployeenumber.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:0]];
        }
        
        if (shift.positionUuid == nil && shift.openShift_employees == nil && shift.notes == nil) {
            
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid == nil && shift.openShift_employees != nil && shift.notes != nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_openshift_employees": openshiftemployees,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid != nil && shift.openShift_employees == nil && shift.notes != nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid != nil && shift.openShift_employees != nil && shift.notes == nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_openshift_employees": openshiftemployees,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid != nil && shift.openShift_employees == nil && shift.notes == nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid == nil && shift.openShift_employees != nil && shift.notes == nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_openshift_employees": openshiftemployees,@"shift_employeeName":employeename};
        }
        else if (shift.positionUuid == nil && shift.openShift_employees == nil && shift.notes != nil)
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
        }
        else
        {
            writeRequest.putRequest.item = @{@"createDate": createdate,@"modifyDate" : modifyDate,@"uuid": haskKeyValue,@"managerUuid": manageruuid,@"parentUuid": rangeKeyValue,@"isDelete": isdelete,@"tableIdentityID": tablename,@"isDelete": isdelete,@"shift_employeeUuid": employeeuuid,@"shift_locationUuid": locationuuid,@"shift_startDate": startdate,@"shift_startTime": starttime,@"shift_endTime": endtime,@"shift_totalHours": totalhours,@"shift_unPaidBreak": unbreak,@"shift_employeesNumbers": needemployeenumber,@"shift_strYear": str_year,@"shift_strMonth": str_month,@"shift_strDay": str_day,@"shift_strWeek": str_week,@"shift_strTime": str_time,@"shift_isTake": istake,@"shift_takedState": takestate,@"shift_haveTakedEmployeesNumber": havetakeemployeenumber,@"shift_positionUuid": positionuuid,@"shift_openshift_employees": openshiftemployees,@"shift_notes": shiftnotes,@"shift_employeeName":employeename};
        }
        
        [arr_writeRequest addObject:writeRequest];
    }
    return arr_writeRequest;
}

+ (NSMutableArray *) getShiftAndDrop:(NSString *) shiftuuid
{
    NSMutableArray *arr_writeRequest = [NSMutableArray array];
    NSArray *arr_drop = [DatabaseManager getDropAndSwapByShiftUuid:shiftuuid];
    Shifts *shift = [DatabaseManager getShiftByUuid:shiftuuid];
    NSString *modifyd = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
    
    for (Drop *drop in arr_drop) {
        
        AWSDynamoDBWriteRequest *writeRequest_drop = [AWSDynamoDBWriteRequest new];
        writeRequest_drop.putRequest = [AWSDynamoDBPutRequest new];
        
        AWSDynamoDBAttributeValue *d_createdate = [AWSDynamoDBAttributeValue new];
        d_createdate.S = drop.createDate;
        AWSDynamoDBAttributeValue *d_modifyDate = [AWSDynamoDBAttributeValue new];
        d_modifyDate.S = modifyd;
        AWSDynamoDBAttributeValue *d_haskKeyValue = [AWSDynamoDBAttributeValue new];
        d_haskKeyValue.S = drop.uuid;
        AWSDynamoDBAttributeValue *d_rangeKeyValue = [AWSDynamoDBAttributeValue new];
        d_rangeKeyValue.S = drop.parentUuid;
        AWSDynamoDBAttributeValue *d_isdelete = [AWSDynamoDBAttributeValue new];
        d_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
        AWSDynamoDBAttributeValue *d_tablename = [AWSDynamoDBAttributeValue new];
        d_tablename.S = @"Drop";
        
        writeRequest_drop.putRequest.item = @{@"createDate": d_createdate,@"modifyDate" : d_modifyDate,@"uuid": d_haskKeyValue,@"parentUuid": d_rangeKeyValue,@"isDelete": d_isdelete,@"tableIdentityID": d_tablename};
        
        [arr_writeRequest addObject:writeRequest_drop];
    }
    
    AWSDynamoDBWriteRequest *writeRequest_shift = [AWSDynamoDBWriteRequest new];
    writeRequest_shift.putRequest = [AWSDynamoDBPutRequest new];
    
    AWSDynamoDBAttributeValue *s_createdate = [AWSDynamoDBAttributeValue new];
    s_createdate.S = shift.createDate;
    AWSDynamoDBAttributeValue *s_modifyDate = [AWSDynamoDBAttributeValue new];
    s_modifyDate.S = modifyd;
    AWSDynamoDBAttributeValue *s_haskKeyValue = [AWSDynamoDBAttributeValue new];
    s_haskKeyValue.S = shift.uuid;
    AWSDynamoDBAttributeValue *s_rangeKeyValue = [AWSDynamoDBAttributeValue new];
    s_rangeKeyValue.S = shift.parentUuid;
    AWSDynamoDBAttributeValue *s_isdelete = [AWSDynamoDBAttributeValue new];
    s_isdelete.N = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1]];
    AWSDynamoDBAttributeValue *s_tablename = [AWSDynamoDBAttributeValue new];
    s_tablename.S = @"Shifts";
    
    writeRequest_shift.putRequest.item = @{@"createDate": s_createdate,@"modifyDate" : s_modifyDate,@"uuid": s_haskKeyValue,@"parentUuid": s_rangeKeyValue,@"isDelete": s_isdelete,@"tableIdentityID": s_tablename};
    
    [arr_writeRequest addObject:writeRequest_shift];
    
    return arr_writeRequest;
}

+ (DDBDataModel *) getDropDataModelByDropUuid:(NSString *)dropuuid andOriShiftUuid:(NSString *) orishiftuuid
{
    Drop *drop = [DatabaseManager getDropByUuid:dropuuid];
    Shifts *oriShift = [DatabaseManager getShiftByUuid:orishiftuuid];
    DDBDataModel *model = [[DDBDataModel alloc]init];
    
    if (drop == nil) {
        model.createDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.modifyDate = model.createDate;
        model.uuid = [StringManager getItemID];
        
        model.managerUuid = oriShift.managerUuid;
        model.parentUuid = oriShift.parentUuid;
        model.isDelete = [NSNumber numberWithInt:0];
    }
    else
    {
        model.createDate = drop.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = drop.uuid;
        model.managerUuid = drop.managerUuid;
        model.parentUuid = drop.parentUuid;
        model.isDelete = [NSNumber numberWithShort:drop.isDelete];
    }
    model.tableIdentityID = @"Drop";
    model.drop_isDrop = [NSNumber numberWithInt:0];
    model.drop_parentShidtUuid = orishiftuuid;
    model.drop_oriShiftEmployeeUuid = oriShift.employeeUuid;
    
    return model;
}

+ (DDBDataModel *) getSwapDataModelBySwapUuid:(NSString *)swapuuid andOriShiftUuid:(NSString *) orishiftuuid
{
    Drop *swap = [DatabaseManager getSwapByUuid:swapuuid];
    Shifts *oriShift = [DatabaseManager getShiftByUuid:orishiftuuid];
    DDBDataModel *model = [[DDBDataModel alloc]init];
    
    if (swap == nil) {
        model.createDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.modifyDate = model.createDate;
        model.uuid = [StringManager getItemID];
        
        model.managerUuid = oriShift.managerUuid;
        model.parentUuid = oriShift.parentUuid;
        model.isDelete = [NSNumber numberWithInt:0];
        model.drop_state = @"0";
    }
    else
    {
        model.createDate = swap.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = swap.uuid;
        model.managerUuid = swap.managerUuid;
        model.parentUuid = swap.parentUuid;
        model.isDelete = [NSNumber numberWithShort:swap.isDelete];
    }
    model.tableIdentityID = @"Drop";
    model.drop_isDrop = [NSNumber numberWithInt:1];
    model.drop_parentShidtUuid = orishiftuuid;
    model.drop_oriShiftEmployeeUuid = oriShift.employeeUuid;
    
    return model;
}

+ (DDBDataModel *) getShiftDataModelByShift:(Shifts *) passshift
{
    DDBDataModel *model = [[DDBDataModel alloc]init];
    model.createDate = passshift.createDate;
    model.modifyDate = passshift.modifyDate;
    model.uuid = passshift.uuid;
    model.managerUuid = passshift.employeeUuid;
    model.parentUuid = passshift.parentUuid;
    model.tableIdentityID = @"Shifts";
    model.isDelete = [NSNumber numberWithShort:passshift.isDelete];
    model.shift_employeeUuid = passshift.employeeUuid;
    if ([passshift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
        model.shift_employeeName = OpenShiftEmployeeName;
    }
    else
    {
        Employees *employee = [DatabaseManager getEmployeeByUuid:passshift.employeeUuid];
        model.shift_employeeName = employee.fullName;
    }
    if (passshift.positionUuid != nil) {
        model.shift_positionUuid = passshift.positionUuid;
    }
    model.shift_locationUuid = passshift.locationUuid;
    model.shift_startDate = passshift.startDate;
    model.shift_startTime = passshift.startTime;
    model.shift_endTime = passshift.endTime;
    model.shift_totalHours = passshift.totalHours;
    model.shift_unPaidBreak = passshift.unpaidBreak;
    model.shift_employeesNumbers = [NSNumber numberWithShort:passshift.needEmployeesNumber];
    if (passshift.openShift_employees != nil) {
        model.shift_openshift_employees = passshift.openShift_employees;
    }
    if (passshift.notes != nil) {
        model.shift_notes = passshift.notes;
    }
    model.shift_strYear = passshift.string_year;
    model.shift_strMonth = passshift.string_month;
    model.shift_strDay = passshift.string_day;
    model.shift_strWeek = passshift.string_week;
    model.shift_strTime = passshift.string_time;
    model.shift_isTake = [NSNumber numberWithShort:passshift.isTake];
    model.shift_haveTakedEmployeesNumber = [NSNumber numberWithShort:passshift.haveTakedEmployeesNumber];
    model.shift_takedState = [NSNumber numberWithShort:passshift.takeState];
    return model;
}

+ (DDBDataModel *) getRequestDataModelByRequestUuid:(NSString *)uuid and:(NSMutableDictionary *) dict andState:(NSString *)state
{
    DDBDataModel *model = [[DDBDataModel alloc]init];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (uuid == nil) {
        model.createDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.modifyDate = model.createDate;
        model.uuid = [StringManager getItemID];
        model.parentUuid = appdelegate.currentWorkplace.uuid;
        model.tableIdentityID = @"Requests";
        model.isDelete = [NSNumber numberWithInt:0];
        model.request_employeeUuid = appdelegate.currentEmployee.uuid;
        model.request_stamp_startDate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"startStamp"]];
        model.request_stamp_endDate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"endStamp"]];
        if ([[dict objectForKey:@"state"] isEqualToString:@"1"]) {
            model.request_string_startTime = [dict objectForKey:@"startTime"];
            model.request_string_endTime = [dict objectForKey:@"endTime"];
        }
        if (![[dict objectForKey:@"message"] isEqualToString:@""]) {
            model.request_message = [dict objectForKey:@"message"];
        }
        model.request_type = [dict objectForKey:@"type"];
        model.request_paidHours = [dict objectForKey:@"hours"];
        model.request_waitType = [dict objectForKey:@"requeststate"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.parentUuid forKey:RequestDisposeState_ParentUuid];
        [dict setObject:model.uuid forKey:RequestDisposeState_ParentRequestUuid];
        [dict setObject:model.request_employeeUuid forKey:RequestDisposeState_SendRequestEmployeeUuid];
        [dict setObject:model.createDate forKey:RequestDisposeState_DisposeTime];
        [dict setObject:model.request_waitType forKey:RequestDisposeState_State];
        NSString *jsonstring = [StringManager getJsonStringByDictionary:dict];
        model.request_disposeStateTable = jsonstring;
    }
    else
    {
        Requests *request = [DatabaseManager getRequestByUuid:uuid];
        model.createDate = request.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = request.uuid;
        model.managerUuid = request.managerUuid;
        model.parentUuid = request.parentUuid;
        model.isDelete = [NSNumber numberWithShort:request.isDelete];
        model.tableIdentityID = @"Requests";
        model.request_employeeUuid = request.employeeUuid;
        model.request_stamp_startDate = request.stamp_startDate;
        model.request_stamp_endDate = request.stamp_endDate;
        if (request.string_startTime != nil) {
            model.request_string_startTime = request.string_startTime;
            model.request_string_endTime = request.string_endTime;
        }
        if (request.message != nil) {
            model.request_message = request.message;
        }
        model.request_type = request.type;
        model.request_paidHours = [NSNumber numberWithShort:request.paidHours];
        model.request_waitType = state;
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:model.parentUuid forKey:RequestDisposeState_ParentUuid];
        [dict setObject:model.uuid forKey:RequestDisposeState_ParentRequestUuid];
        
        if ([state isEqualToString:@"1"] || [state isEqualToString:@"2"]) {
            [dict setObject:appdelegate.currentEmployee.uuid forKey:RequestDisposeState_SendRequestEmployeeUuid];
        }
        else if ([state isEqualToString:@"3"])
        {
            [dict setObject:model.request_employeeUuid forKey:RequestDisposeState_SendRequestEmployeeUuid];
        }
        
        [dict setObject:model.modifyDate forKey:RequestDisposeState_DisposeTime];
        [dict setObject:model.request_waitType forKey:RequestDisposeState_State];
        
        NSMutableString *mystring = nil;
        
        NSString *jsonstring = [StringManager getJsonStringByDictionary:dict];
        
        NSArray *arr_dispose = [DatabaseManager getRequestAllDisposeState:uuid];
        for (RequestAllDisposeState *state in arr_dispose) {
            NSMutableDictionary *dict_temp = [NSMutableDictionary dictionary];
            [dict_temp setObject:state.parentUuid forKey:RequestDisposeState_ParentUuid];
            [dict_temp setObject:state.parentRequestUuid forKey:RequestDisposeState_ParentRequestUuid];
            [dict_temp setObject:state.sendRequestEmployeeUuid forKey:RequestDisposeState_SendRequestEmployeeUuid];
            [dict_temp setObject:state.disposeTime forKey:RequestDisposeState_DisposeTime];
            [dict_temp setObject:state.disposeState forKey:RequestDisposeState_State];
            NSString *string = [StringManager getJsonStringByDictionary:dict_temp];
            if (mystring == nil) {
                mystring = [NSMutableString stringWithFormat:@"%@",string];
            }
            else
            {
                mystring = [NSMutableString stringWithFormat:@"%@%@%@",mystring,RequestDisposeState_JsonStringseparator,string];
            }
        }
        mystring = [NSMutableString stringWithFormat:@"%@%@%@",mystring,RequestDisposeState_JsonStringseparator,jsonstring];
        model.request_disposeStateTable = mystring;
    }
    
    return model;
}




//+ (DDBEmployeesInfoModel *) getEmployeeModel:(Employees *)employee
//{
//    DDBEmployeesInfoModel *model = [[DDBEmployeesInfoModel alloc]init];
//    model.create_date = employee.createDate;
//    model.uuid = employee.uuid;
//    if (employee.parentUuid != nil) {
//        model.parentUuid = employee.parentUuid;
//    }
//    model.email = employee.email;
//    if (employee.workPlaceUuid != nil) {
//        model.workPlaceUuid = employee.workPlaceUuid;
//    }
//    if (employee.managerUuid != nil) {
//        model.managerUuid = employee.managerUuid;
//    }
//    model.isManager = employee.isManager;
//    model.isDelete = employee.isDelete;
//    model.isJoinPlace = employee.isJoinOnePlace;
//    model.isAcceptJoined = employee.isAcceptJoined;
//    model.fullname = employee.fullName;
//    model.password = employee.password;
//    model.phone = employee.phone;
//    if (employee.headPortrait != nil) {
//        model.portrait = [StringManager dataTransferString:employee.headPortrait];
//    }
//    model.maxHoursPerWeek = [NSNumber numberWithInt:50];
//    
//    return model;
//
//}

+ (DDBWorkPlacesInfoModel *) getCurrentWorkPlaceModel:(CurrentWorkPlace *)workPlace
{
    DDBWorkPlacesInfoModel *model = [[DDBWorkPlacesInfoModel alloc]init];
    model.uuid = workPlace.uuid;

    model.placeName = workPlace.name;
    model.placeAddress = workPlace.address;
    //model.type = workPlace.type;
    model.employeesCounts = [NSNumber numberWithShort:workPlace.employeesCounts];
    model.latitude = workPlace.latitude;
    model.longitude = workPlace.longitude;
    return model;
}

+ (DDBDataModel *) getPositionDataModel:(Positions *)position
{
    DDBDataModel *model = [[DDBDataModel alloc]init];
//    model.createDate = position.createDate;
//    model.modifyDate = position.modifyDate;
//    model.uuid = position.uuid;
//    model.managerUuid = position.managerUuid;
//    model.parentUuid = position.parentUuid;
//    model.tableIdentityID = @"Positions";
//    model.isDelete = [NSNumber numberWithShort:position.isDelete];
//    model.position_name = position.name;
//    model.position_isFavorite = [NSNumber numberWithShort:position.isFavorite];
//    model.position_color = [NSNumber numberWithShort:position.color];
//    if (position.employees != nil) {
//        
//        model.position_employees = position.employees;
//    }
    return model;
}

+ (DDBDataModel *) getLocationDataModel:(Locations *)location;
{
    DDBDataModel *model = [[DDBDataModel alloc]init];
//    model.createDate = location.createDate;
//    model.modifyDate = location.modifyDate;
//    model.uuid = location.uuid;
//    model.managerUuid = location.managerUuid;
//    model.parentUuid = location.parentUuid;
//    model.tableIdentityID = @"Locations";
//    model.isDelete = [NSNumber numberWithShort:location.isDelete];
//    model.location_name = location.name;
//    model.location_addr = location.address;
//    model.location_latitude = location.latitude;
//    model.location_longitude = location.longitude;
//    model.location_employees = location.employees;
    return model;
}

+ (DDBDataModel *) getAvailableDataModel:(NSString *)uuid andConfiguration:(NSDictionary *) dict_configuration andSubAvailabilities:(NSString *) subAvai andNewParentUuid:(NSString *) newparentUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DDBDataModel *model = [[DDBDataModel alloc]init];
    Availability *availability = [DatabaseManager getAvailabilitybyUuid:uuid];
    if (availability == nil) {
        model.createDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.modifyDate = model.createDate;
        model.uuid = newparentUuid;
        model.parentUuid = appdelegate.currentWorkplace.uuid;
        model.isDelete = [NSNumber numberWithInt:0];
    }
    else
    {
        model.createDate = availability.createDate;
        model.modifyDate = [NSString stringWithFormat:@"%@",[StringManager dateTransferTimeStamp:[NSDate date]]];
        model.uuid = availability.uuid;
        model.managerUuid = availability.managerUuid;
        model.parentUuid = availability.parentUuid;
        model.isDelete = [NSNumber numberWithShort:availability.isDelete];
    }
    model.tableIdentityID = @"Availability";
    model.avail_employeeUuid = [dict_configuration objectForKey:Availability_Configuration_EmployeeUuid];
    model.avail_title = [dict_configuration objectForKey:Availability_Configuration_Title];
    model.avail_rotation = [dict_configuration objectForKey:Availability_Configuration_Rotation];
    model.avail_string_effectiveDate1 = [dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate1];
    model.avail_string_effectiveDate2 = [dict_configuration objectForKey:Availability_Configuration_StringEffectiveDate2];
    model.avail_string_yearMonthDay1 = [dict_configuration objectForKey:Availability_Configuration_YearMonthDay1];
    model.avail_string_yearMonthDay2 = [dict_configuration objectForKey:Availability_Configuration_YearMonthDay2];
    model.avail_subAvailabilities = subAvai;
    if ([dict_configuration objectForKey:Availability_Configuration_Notes] != nil) {
        model.avail_notes = [dict_configuration objectForKey:Availability_Configuration_Notes];
    }
    
    return model;
}

+(void) getNewEmployee
{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    if (appDelegate.currentWorkplace.uuid != nil) {
//        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//        AWSDynamoDBQueryExpression *queryExpression = [AWSDynamoDBQueryExpression new];
//        queryExpression.scanIndexForward = 0;
//        queryExpression.indexName = @"CurrentWorkplaceAllEmployees-Index";
//        queryExpression.keyConditionExpression = [NSString stringWithFormat:@"parentUuid = :UUID"];
//        queryExpression.expressionAttributeValues = @{@":UUID" : appDelegate.currentWorkplace.uuid};
//        
//        [[dynamoDBObjectMapper query:[DDBEmployeesInfoModel class] expression:queryExpression] continueWithBlock:^id(AWSTask *task) {
//            if (task.error) {
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            }
//            else {
//                AWSDynamoDBPaginatedOutput *output = task.result;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSArray *arr = [NSArray arrayWithArray:output.items];
//                    if (arr.count != 0) {
//
//                        for (DDBEmployeesInfoModel *employeeModel in arr) {
//                            
//                            Employees *employee2 = [DatabaseManager getEmployeeByUuid:employeeModel.uuid];
//                            if (employee2 == nil) {
//                                Employees *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employees" inManagedObjectContext:context];
//                                employee.createDate = employeeModel.create_date;
//                                employee.modifyDate = employeeModel.modify_date;
//                                employee.uuid = employeeModel.uuid;
//                                employee.managerUuid = employeeModel.managerUuid;
//                                employee.parentUuid = employeeModel.parentUuid;
//                                employee.parentWorkplaceName = employeeModel.parentWorkplaceName;
//                                employee.email = employeeModel.email;
//                                employee.isManager = [employeeModel.isManager shortValue];
//                                employee.isDelete = [employeeModel.isDelete shortValue];
//                                employee.isJoinOnePlace = [employeeModel.isJoinPlace shortValue];
//                                employee.isAcceptJoined = [employeeModel.isAcceptJoined shortValue];
//                                employee.fullName = employeeModel.fullname;
//                                employee.password = employeeModel.password;
//                                employee.phone = employeeModel.phone;
//                                employee.headPortrait = [StringManager stringTransferData:employeeModel.portrait];
//                                employee.maxHoursPerWeek = [employeeModel.maxHoursPerWeek shortValue];
//                                [context save:nil];
//                            }
//                            else
//                            {
//                                employee2.createDate = employeeModel.create_date;
//                                employee2.modifyDate = employeeModel.modify_date;
//                                employee2.uuid = employeeModel.uuid;
//                                employee2.managerUuid = employeeModel.managerUuid;
//                                employee2.parentUuid = employeeModel.parentUuid;
//                                employee2.parentWorkplaceName = employeeModel.parentWorkplaceName;
//                                employee2.email = employeeModel.email;
//                                employee2.isManager = [employeeModel.isManager shortValue];
//                                employee2.isDelete = [employeeModel.isDelete shortValue];
//                                employee2.isJoinOnePlace = [employeeModel.isJoinPlace shortValue];
//                                employee2.isAcceptJoined = [employeeModel.isAcceptJoined shortValue];
//                                employee2.fullName = employeeModel.fullname;
//                                employee2.password = employeeModel.password;
//                                employee2.phone = employeeModel.phone;
//                                employee2.headPortrait = [StringManager stringTransferData:employeeModel.portrait];
//                                employee2.maxHoursPerWeek = [employeeModel.maxHoursPerWeek shortValue];
//                                [context save:nil];
//                                
//                                if ([employeeModel.uuid isEqualToString:appDelegate.currentEmployee.uuid]) {
//                                    CurrentEmployee *currentemployee = [DatabaseManager getCurrentEmployeeByUuid:employee2.uuid];
//                                    currentemployee.modifyDate = employee2.modifyDate;
//                                    currentemployee.managerUuid = employee2.managerUuid;
//                                    currentemployee.parentUuid = employee2.parentUuid;
//                                    currentemployee.parentWorkplaceName = employee2.parentWorkplaceName;
//                                    currentemployee.fullName = employee2.fullName;
//                                    currentemployee.phone = employee2.phone;
//                                    currentemployee.headPortrait = employee2.headPortrait;
//                                    [context save:nil];
//                                }
//                            }
//                        }
//                    }
//                    NSArray *arr_local = [DatabaseManager getAllEmployeesNoJoinAndJoin];
//                    for(Employees *employee in arr_local)
//                    {
//                        BOOL isExist = NO;
//                        for (DDBEmployeesInfoModel *employeeModel in arr) {
//                            if([employeeModel.uuid isEqualToString:employee.uuid])
//                            {
//                                isExist = YES;
//                            }
//                        }
//                        if(isExist == NO)
//                        {
//                            [context deleteObject:employee];
//                        }
//                        isExist = NO;
//                    }
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                });
//            }
//            return nil;
//        }];
//    }
}

+(void) getAllDeviceToken
{
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.currentEmployee.parentUuid != nil) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        AWSDynamoDBObjectMapper *dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];
//        AWSDynamoDBQueryExpression *queryExpression2 = [AWSDynamoDBQueryExpression new];
//        queryExpression2.scanIndexForward = 0;
//        queryExpression2.indexName = @"CurrentWorkplaceAllDevices-Index";
//        queryExpression2.keyConditionExpression = [NSString stringWithFormat:@"parentUuid = :puuid"];
//        queryExpression2.expressionAttributeValues = @{@":puuid" : appDelegate.currentEmployee.parentUuid};
//        [[dynamoDBObjectMapper query:[DDBDeviceTokenModel class] expression:queryExpression2] continueWithBlock:^id(AWSTask *task) {
//            if (task.error) {
//                NSLog(@"%@",task.error);
//            }
//            else
//            {
//                AWSDynamoDBPaginatedOutput *output = task.result;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//                    NSArray *arr_device = output.items;
//                    for (DDBDeviceTokenModel *deviceModel in arr_device) {
//                        DeviceToken *device2 = [DatabaseManager getDeviceTokenByDeviceModel2:deviceModel];
//                        if(device2 == nil)
//                        {
//                            DeviceToken *device = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceToken" inManagedObjectContext:context];
//                            device.employeeUuid = deviceModel.employeeUuid;
//                            device.parentUuid = deviceModel.parentUuid;
//                            device.deviceToken = deviceModel.deviceToken;
//                            device.endPointArn = deviceModel.endPointArn;
//                            [context save:nil];
//                        }
//                        else
//                        {
//                            device2.employeeUuid = deviceModel.employeeUuid;
//                            device2.parentUuid = deviceModel.parentUuid;
//                            device2.deviceToken = deviceModel.deviceToken;
//                            device2.endPointArn = deviceModel.endPointArn;
//                            [context save:nil];
//                        }
//                    }
//                });
//            }
//            return nil;
//        }];
//    }
}


+ (BOOL) dynamodbDataSaveToLocal:(NSArray *) arr
{
    __block BOOL isTake = YES;
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    
//    [self getAllDeviceToken];
//    
//    __block BOOL isTake = YES;
//    
//    if (arr.count != 0) {
//        for (DDBDataModel *model in arr) {
//            
//            if ([model.tableIdentityID isEqualToString:@"Positions"]) {
//                Positions *position2 = [DatabaseManager getPositionByUuid:model.uuid];
//                if (position2 == nil && [model.isDelete intValue] == 0) {
//                    Positions *position = [NSEntityDescription insertNewObjectForEntityForName:@"Positions" inManagedObjectContext:context];
//                    position.createDate = model.createDate;
//                    position.modifyDate = model.modifyDate;
//                    position.uuid = model.uuid;
//                    position.parentUuid = model.parentUuid;
//                    position.managerUuid = model.managerUuid;
//                    position.isDelete = [model.isDelete shortValue];
//                    position.color = [model.position_color shortValue];
//                    position.name = model.position_name;
//                    position.isFavorite = [model.position_isFavorite shortValue];
//                    position.employees = model.position_employees;
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && position2 != nil) {
//                        [context deleteObject:position2];
//                    }
//                    else
//                    {
//                        position2.createDate = model.createDate;
//                        position2.modifyDate = model.modifyDate;
//                        position2.uuid = model.uuid;
//                        position2.parentUuid = model.parentUuid;
//                        position2.managerUuid = model.managerUuid;
//                        position2.isDelete = [model.isDelete shortValue];
//                        position2.color = [model.position_color shortValue];
//                        position2.name = model.position_name;
//                        position2.isFavorite = [model.position_isFavorite shortValue];
//                        position2.employees = model.position_employees;
//                    }
//                    
//                    [context save:nil];
//                }
//            }
//            else if([model.tableIdentityID isEqualToString:@"Locations"])
//            {
//                Locations *location2 = [DatabaseManager getLocationByUuid:model.uuid];
//                if (location2 == nil && [model.isDelete intValue] == 0) {
//                    Locations *location = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:context];
//                    location.uuid = model.uuid;
//                    location.name = model.location_name;
//                    location.address = model.location_addr;
//                    location.latitude = model.location_latitude;
//                    location.longitude = model.location_longitude;
//                    location.employees = model.location_employees;
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && location2 != nil) {
//                        [context deleteObject:location2];
//                    }
//                    else
//                    {
//                        location2.uuid = model.uuid;
//                        location2.name = model.location_name;
//                        location2.address = model.location_addr;
//                        location2.latitude = model.location_latitude;
//                        location2.longitude = model.location_longitude;
//                        location2.employees = model.location_employees;
//                    }
//                    
//                    [context save:nil];
//                }
//            }
//            else if ([model.tableIdentityID isEqualToString:@"Shifts"])
//            {
//                if ([model.shift_isTake intValue] == 0 && [model.shift_employeeUuid isEqualToString:appDelegate.currentEmployee.uuid] && [model.shift_takedState intValue] == 1 && [model.isDelete intValue] == 0) {
//                    isTake = NO;
//                }
//                Shifts *shift2 = [DatabaseManager getShiftByUuid:model.uuid];
//                if (shift2 == nil && [model.isDelete intValue] == 0) {
//                    Shifts *shift = [NSEntityDescription insertNewObjectForEntityForName:@"Shifts" inManagedObjectContext:context];
//                    shift.createDate = model.createDate;
//                    shift.modifyDate = model.modifyDate;
//                    shift.uuid = model.uuid;
//                    shift.employeeUuid = model.shift_employeeUuid;
//                    shift.employeeName = model.shift_employeeName;
//                    shift.parentUuid = model.parentUuid;
//                    shift.managerUuid = model.managerUuid;
//                    shift.positionUuid = model.shift_positionUuid;
//                    shift.locationUuid = model.shift_locationUuid;
//                    shift.isDelete = [model.isDelete shortValue];
//                    shift.isTake = [model.shift_isTake shortValue];
//                    shift.needEmployeesNumber = [model.shift_employeesNumbers shortValue];
//                    shift.startDate = model.shift_startDate;
//                    shift.startTime = model.shift_startTime;
//                    shift.endTime = model.shift_endTime;
//                    shift.totalHours = model.shift_totalHours;
//                    shift.unpaidBreak = model.shift_unPaidBreak;
//                    shift.notes = model.shift_notes;
//                    shift.string_year = model.shift_strYear;
//                    shift.string_month = model.shift_strMonth;
//                    shift.string_day = model.shift_strDay;
//                    shift.string_week = model.shift_strWeek;
//                    shift.string_time = model.shift_strTime;
//                    shift.takeState = [model.shift_takedState shortValue];
//                    shift.haveTakedEmployeesNumber = [model.shift_haveTakedEmployeesNumber shortValue];
//                    shift.openShift_employees = model.shift_openshift_employees;
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && shift2 != nil) {
//                        [context deleteObject:shift2];
//                    }
//                    else
//                    {
//                        shift2.createDate = model.createDate;
//                        shift2.modifyDate = model.modifyDate;
//                        shift2.uuid = model.uuid;
//                        shift2.employeeUuid = model.shift_employeeUuid;
//                        shift2.employeeName = model.shift_employeeName;
//                        shift2.parentUuid = model.parentUuid;
//                        shift2.managerUuid = model.managerUuid;
//                        shift2.positionUuid = model.shift_positionUuid;
//                        shift2.locationUuid = model.shift_locationUuid;
//                        shift2.isDelete = [model.isDelete shortValue];
//                        shift2.isTake = [model.shift_isTake shortValue];
//                        shift2.needEmployeesNumber = [model.shift_employeesNumbers shortValue];
//                        shift2.startDate = model.shift_startDate;
//                        shift2.startTime = model.shift_startTime;
//                        shift2.endTime = model.shift_endTime;
//                        shift2.totalHours = model.shift_totalHours;
//                        shift2.unpaidBreak = model.shift_unPaidBreak;
//                        shift2.notes = model.shift_notes;
//                        shift2.string_year = model.shift_strYear;
//                        shift2.string_month = model.shift_strMonth;
//                        shift2.string_day = model.shift_strDay;
//                        shift2.string_week = model.shift_strWeek;
//                        shift2.string_time = model.shift_strTime;
//                        shift2.takeState = [model.shift_takedState shortValue];
//                        shift2.haveTakedEmployeesNumber = [model.shift_haveTakedEmployeesNumber shortValue];
//                        shift2.openShift_employees = model.shift_openshift_employees;
//                    }
//                    [context save:nil];
//                }
//            }
//            else if ([model.tableIdentityID isEqualToString:@"Drop"])
//            {
//                
//                Drop *drop2 = [DatabaseManager getDropByUuid:model.uuid];
//                if (drop2 == nil && [model.isDelete intValue] == 0) {
//                    Drop *drop = [NSEntityDescription insertNewObjectForEntityForName:@"Drop" inManagedObjectContext:context];
//                    drop.createDate = model.createDate;
//                    drop.modifyDate = model.modifyDate;
//                    drop.uuid = model.uuid;
//                    drop.parentUuid = model.parentUuid;
//                    drop.managerUuid = model.managerUuid;
//                    drop.parentShiftUuid = model.drop_parentShidtUuid;
//                    drop.isDelete = [model.isDelete shortValue];
//                    drop.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
//                    drop.isDrop = [model.drop_isDrop shortValue];
//                    drop.state = model.drop_state;
//                    drop.message = model.drop_messsage;
//                    drop.dropUuids = model.drop_dropUuids;
//                    drop.declineDropUuids = model.drop_delcineDropUuids;
//                    drop.drop_accepteEmployeeUuid = model.drop_dropAccptedEmploueeUuid;
//                    drop.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
//                    drop.swapShiftUuid1 = model.drop_swapshiftuuid1;
//                    drop.swapShiftUuid2 = model.drop_swapshiftuuid2;
//                    drop.oriShiftEmployeeUuid = model.drop_oriShiftEmployeeUuid;
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && drop2 != nil) {
//                        [context deleteObject:drop2];
//                    }
//                    else
//                    {
//                        drop2.createDate = model.createDate;
//                        drop2.modifyDate = model.modifyDate;
//                        drop2.uuid = model.uuid;
//                        drop2.parentUuid = model.parentUuid;
//                        drop2.managerUuid = model.managerUuid;
//                        drop2.parentShiftUuid = model.drop_parentShidtUuid;
//                        drop2.isDelete = [model.isDelete shortValue];
//                        drop2.isManagerAccepted = [model.drop_isManagerAccepted shortValue];
//                        drop2.isDrop = [model.drop_isDrop shortValue];
//                        drop2.state = model.drop_state;
//                        drop2.message = model.drop_messsage;
//                        drop2.dropUuids = model.drop_dropUuids;
//                        drop2.declineDropUuids = model.drop_delcineDropUuids;
//                        drop2.drop_accepteEmployeeUuid = model.drop_dropAccptedEmploueeUuid;
//                        drop2.swap_acceptShiftUuid = model.drop_swapAcceptedShiftUuid;
//                        drop2.oriShiftEmployeeUuid = model.drop_oriShiftEmployeeUuid;
//                        drop2.swapShiftUuid1 = model.drop_swapshiftuuid1;
//                        drop2.swapShiftUuid2 = model.drop_swapshiftuuid2;
//                    }
//                    [context save:nil];
//                }
//            }
//            else if([model.tableIdentityID isEqualToString:@"Requests"])
//            {
//                Requests *request2 = [DatabaseManager getRequestByUuid:model.uuid];
//                if (request2 == nil && [model.isDelete intValue] == 0) {
//                    Requests *request = [NSEntityDescription insertNewObjectForEntityForName:@"Requests" inManagedObjectContext:context];
//                    request.createDate = model.createDate;
//                    request.disposeDate = model.modifyDate;
//                    request.uuid = model.uuid;
//                    request.employeeUuid = model.request_employeeUuid;
//                    request.parentUuid = model.parentUuid;
//                    request.managerUuid = model.managerUuid;
//                    request.isDelete = [model.isDelete shortValue];
//                    request.type = model.request_type;
//                    request.stamp_startDate = model.request_stamp_startDate;
//                    request.stamp_endDate = model.request_stamp_endDate;
//                    request.string_startTime = model.request_string_startTime;
//                    request.string_endTime = model.request_string_endTime;
//                    request.paidHours = [model.request_paidHours shortValue];
//                    request.message = model.request_message;
//                    request.waitType = model.request_waitType;
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && request2 != nil) {
//                        [context deleteObject:request2];
//                    }
//                    else
//                    {
//                        request2.createDate = model.createDate;
//                        request2.disposeDate = model.modifyDate;
//                        request2.uuid = model.uuid;
//                        request2.employeeUuid = model.request_employeeUuid;
//                        request2.parentUuid = model.parentUuid;
//                        request2.managerUuid = model.managerUuid;
//                        request2.isDelete = [model.isDelete shortValue];
//                        request2.type = model.request_type;
//                        request2.stamp_startDate = model.request_stamp_startDate;
//                        request2.stamp_endDate = model.request_stamp_endDate;
//                        request2.string_startTime = model.request_string_startTime;
//                        request2.string_endTime = model.request_string_endTime;
//                        request2.paidHours = [model.request_paidHours shortValue];
//                        request2.message = model.request_message;
//                        request2.waitType = model.request_waitType;
//                    }
//                    [context save:nil];
//                }
//                [DatabaseManager saveRequestDisposeTable:model.request_disposeStateTable];
//            }
//            else if([model.tableIdentityID isEqualToString:@"Availability"])
//            {
//                Availability *avai2 = [DatabaseManager getAvailabilitybyUuid:model.uuid];
//                if (avai2 == nil && [model.isDelete intValue] == 0) {
//                    Availability *avai = [NSEntityDescription insertNewObjectForEntityForName:@"Availability" inManagedObjectContext:context];
//                    avai.createDate = model.createDate;
//                    avai.modifyDate = model.modifyDate;
//                    avai.uuid = model.uuid;
//                    avai.managerUuid = model.managerUuid;
//                    avai.parentUuid = model.parentUuid;
//                    avai.isDelete = [model.isDelete shortValue];
//                    avai.title = model.avail_title;
//                    avai.rotation = model.avail_rotation;
//                    avai.string_yearMonthDay1 = model.avail_string_yearMonthDay1;
//                    avai.string_yearMonthDay2 = model.avail_string_yearMonthDay2;
//                    avai.string_effectiveDate1 = model.avail_string_effectiveDate1;
//                    avai.string_effectiveDate2 = model.avail_string_effectiveDate2;
//                    avai.notes = model.avail_notes;
//                    avai.subAvailabilities = model.avail_subAvailabilities;
//                    avai.employeeUuid = model.avail_employeeUuid;
//                    
//                    [context save:nil];
//                }
//                else
//                {
//                    if ([model.isDelete intValue] == 1 && avai2 != nil) {
//                        [context deleteObject:avai2];
//                    }
//                    else
//                    {
//                        avai2.createDate = model.createDate;
//                        avai2.modifyDate = model.modifyDate;
//                        avai2.uuid = model.uuid;
//                        avai2.managerUuid = model.managerUuid;
//                        avai2.parentUuid = model.parentUuid;
//                        avai2.isDelete = [model.isDelete shortValue];
//                        avai2.title = model.avail_title;
//                        avai2.rotation = model.avail_rotation;
//                        avai2.string_yearMonthDay1 = model.avail_string_yearMonthDay1;
//                        avai2.string_yearMonthDay2 = model.avail_string_yearMonthDay2;
//                        avai2.string_effectiveDate1 = model.avail_string_effectiveDate1;
//                        avai2.string_effectiveDate2 = model.avail_string_effectiveDate2;
//                        avai2.notes = model.avail_notes;
//                        avai2.subAvailabilities = model.avail_subAvailabilities;
//                        avai2.employeeUuid = model.avail_employeeUuid;;
//                    }
//                    [context save:nil];
//                }
//            }
//            else if([model.tableIdentityID isEqualToString:@"Setting"] && [model.isDelete intValue] == 0)
//            {
//                Setting *setting2 = [DatabaseManager getEmployeeSetting:model.setting_employeeUuid];
//                if (setting2 == nil) {
//                    Setting *settting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
//                    settting.createDate = model.createDate;
//                    settting.modifyDate = model.modifyDate;
//                    settting.uuid = model.uuid;
//                    settting.parentUuid = model.parentUuid;
//                    settting.managerUuid = model.managerUuid;
//                    settting.isDelete = [model.isDelete shortValue];
//                    settting.employeeUuid = model.setting_employeeUuid;
//                    settting.email_isTimeOffTequest = [model.setting_email_isTimeOffTequest shortValue];
//                    settting.email_isDropRequest = [model.setting_email_isDropRequest shortValue];
//                    settting.email_isScheduleUpdate = [model.setting_emailg_isScheduleUpdate shortValue];
//                    settting.email_isNewEmployee = [model.setting_email_isNewEmployee shortValue];
//                    settting.email_isAvailabilityChange = [model.setting_email_isAvailabilityChange shortValue];
//                    settting.notification_isTimeOffTequest = [model.setting_notification_isTimeOffTequest shortValue];
//                    settting.notification_isDropRequest = [model.setting_notification_isDropRequest shortValue];
//                    settting.notification_isScheduleUpdate = [model.setting_notification_isScheduleUpdate shortValue];
//                    settting.notification_isNewEmployee = [model.setting_notification_isNewEmployee shortValue];
//                    settting.notification_isAvailabilityChange = [model.setting_notification_isAvailabilityChange shortValue];
//                    settting.email_noNotifyStartTime = model.setting_email_noNotifyStartTime;
//                    settting.email_noNotifyEndTime = model.setting_email_noNotifyEndTime;
//                    settting.notification_noNotifyStartTime = model.setting_notification_noNotifyStartTime;
//                    settting.notification_noNotifyEndTime = model.setting_notification_noNotifyStartTime;
//                    
//                    [context save:nil];
//                }
//                else
//                {
//                    setting2.createDate = model.createDate;
//                    setting2.modifyDate = model.modifyDate;
//                    setting2.uuid = model.uuid;
//                    setting2.parentUuid = model.parentUuid;
//                    setting2.managerUuid = model.managerUuid;
//                    setting2.isDelete = [model.isDelete shortValue];
//                    setting2.employeeUuid = model.setting_employeeUuid;
//                    setting2.email_isTimeOffTequest = [model.setting_email_isTimeOffTequest shortValue];
//                    setting2.email_isDropRequest = [model.setting_email_isDropRequest shortValue];
//                    setting2.email_isScheduleUpdate = [model.setting_emailg_isScheduleUpdate shortValue];
//                    setting2.email_isNewEmployee = [model.setting_email_isNewEmployee shortValue];
//                    setting2.email_isAvailabilityChange = [model.setting_email_isAvailabilityChange shortValue];
//                    setting2.notification_isTimeOffTequest = [model.setting_notification_isTimeOffTequest shortValue];
//                    setting2.notification_isDropRequest = [model.setting_notification_isDropRequest shortValue];
//                    setting2.notification_isScheduleUpdate = [model.setting_notification_isScheduleUpdate shortValue];
//                    setting2.notification_isNewEmployee = [model.setting_notification_isNewEmployee shortValue];
//                    setting2.notification_isAvailabilityChange = [model.setting_notification_isAvailabilityChange shortValue];
//                    setting2.email_noNotifyStartTime = model.setting_email_noNotifyStartTime;
//                    setting2.email_noNotifyEndTime = model.setting_email_noNotifyEndTime;
//                    setting2.notification_noNotifyStartTime = model.setting_notification_noNotifyStartTime;
//                    setting2.notification_noNotifyEndTime = model.setting_notification_noNotifyStartTime;
//                }
//            }
//        }
//    }
    return isTake;
}


@end
