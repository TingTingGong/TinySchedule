//
//  SyncNewCalendar.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/6.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "SyncNewCalendar.h"

#define ShowAlert @"isShowAlert"

@implementation SyncNewCalendar

+ (void) subscribeEventToMyCalendar:(NSArray *) arr_object andSubscribeUuid:(NSString *) subscribeuuid
{
    /*
     NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
     NSString *format = [NSString stringWithFormat:@"calshow:%f",nowTimestamp];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:format]];
     //如果要选择特定的某一天的话（默认是当前日期），calshow:后面加时间戳格式，也就是NSTimeInterval
     //注意这里计算时间戳调用的方法是-NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
     //timeIntervalSinceReferenceDate的参考时间是2000年1月1日，[NSDate date]是你希望跳到的日期。*/
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (error)
            {
                // display error message here
            }
            else if (!granted)
            {
                // display access denied error message here
            }
            else
            {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context = [appDelegate managedObjectContext];
                
                __block EKCalendar *calendar = nil;
                __block EKSource *theSource = nil;
                
                CalendarEvents *preCalendar = [DatabaseManager getMyCalendarEventsInCurrentWorkplace];
                calendar = [eventStore calendarWithIdentifier:preCalendar.calendarIdentifier];
                
                NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
                [defau setObject:@"1" forKey:ShowAlert];
                
                //还没有创见一个自定义的日历
                if (!calendar) {
                    
                    if (preCalendar != nil) {
                        [context deleteObject:preCalendar];
                        [context save:nil];
                    }
                    
                    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
                    calendar.title = appdelegate.currentWorkplace.name;
                    
                    NSArray *arr = [NSArray arrayWithArray:eventStore.sources];
                    for (EKSource *source in arr) {
                        if (source.sourceType == EKSourceTypeSubscribed) {
                            theSource = source;
                            break;
                        }
                    }
                    if (theSource) {
                        calendar.source = theSource;
                        NSError *error = nil;
                        BOOL result = [eventStore saveCalendar:calendar commit:YES error:&error];
                        if (result) {
                            NSLog(@"Saved calendar to event store.");
                            NSString *identifier = calendar.calendarIdentifier;
                            if (identifier != nil) {
                                
                                CalendarEvents *event = [NSEntityDescription insertNewObjectForEntityForName:@"CalendarEvents" inManagedObjectContext:context];
                                event.parentUuid = appDelegate.currentWorkplace.uuid;
                                event.employeeuUuid = appdelegate.currentEmployee.uuid;
                                event.subscribeUuid = subscribeuuid;
                                event.calendarIdentifier = identifier;
                                event.eventIdentifiers = nil;
                                [context save:nil];
                                
                                if (arr_object.count != 0) {
                                    [self removeEvent:subscribeuuid andData:arr_object andIsDelete:0];
                                }
                                else
                                {
                                    [self showAlert];
                                }
                            }
                        }
                        else
                        {
                            NSLog(@"Error saving calendar: %@.", error);
                        }
                    }
                    else
                    {
                        NSLog(@"Error: Local source not available");
                    }
                }
                //已经创建过日历，就直接save event
                else
                {
                    if (![preCalendar.subscribeUuid containsString:subscribeuuid]) {
                        preCalendar.subscribeUuid = [NSString stringWithFormat:@"%@,%@",preCalendar.subscribeUuid,subscribeuuid];
                        [context save:nil];
                    }
                    [self removeEvent:subscribeuuid andData:arr_object andIsDelete:0];
                }
            }
        }];
    }
    /*
     //delete a calendar
     EKEventStore *eventStore = [[EKEventStore alloc] init];
     EKCalendar *calendar = [eventStore calendarWithIdentifier:self.calendarIdentifier];
     if (calendar) {
     NSError *error = nil;
     BOOL result = [self.eventStore removeCalendar:calendar commit:YES error:&error];
     if (result) {
     NSLog(@"Deleted calendar from event store.");
     } else {
     NSLog(@"Deleting calendar failed: %@.", error);
     }
     }
     
     //delete a event
     EKEventStore* store = [EKEventStore new];
     [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
     if (!granted) { return; }
     EKEvent* eventToRemove = [store eventWithIdentifier:self.savedEventId];
     if (eventToRemove) {
     NSError* error = nil;
     [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
     }
     }];
     */
    
}

+ (void) removeEvent:(NSString *) subscribeuuid andData:(id) object andIsDelete:(int) isdelete
{
    CalendarEvents *preCalendar = [DatabaseManager getMyCalendarEventsInCurrentWorkplace];
    if (preCalendar != nil) {
        
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        
        __block EKCalendar *calendar = nil;
        
        if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
        {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (error){}
                else if (!granted){}
                else
                {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                    
                    CalendarEvents *preCalendar = [DatabaseManager getMyCalendarEventsInCurrentWorkplace];
                    
                    calendar = [eventStore calendarWithIdentifier:preCalendar.calendarIdentifier];
                    
                    if (calendar != nil) {
                        
                        if (isdelete == 1) {
                            if ([preCalendar.subscribeUuid containsString:subscribeuuid]) {
                                if ([object isKindOfClass:[Shifts class]]) {
                                    Shifts *shift = (Shifts *) object;
                                    NSMutableArray *arr_subscribeEvent = [NSMutableArray array];
                                    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[preCalendar.eventIdentifiers componentsSeparatedByString:CalendarEvent_JsonStringseparator]];
                                    for (NSString *jsonstring in arr_temp) {
                                        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
                                        if ([[dict objectForKey:CalendarEvent_SubscribeUuid] isEqualToString:subscribeuuid]) {
                                            [arr_subscribeEvent addObject:jsonstring];
                                        }
                                    }
                                    for (NSString *string in arr_subscribeEvent) {
                                        NSDictionary *dict = [StringManager getDictionaryByJsonString:string];
                                        if ([[dict objectForKey:CalendarEvent_ShiftUuid] isEqualToString:shift.uuid]) {
                                            NSString *eventidentifier = [dict objectForKey:CalendarEvent_EventIdentifier];
                                            EKEvent *eventToRemove = [eventStore eventWithIdentifier:eventidentifier];
                                            if (eventToRemove) {
                                                NSError* error = nil;
                                                [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
                                                
                                                [arr_temp removeObject:string];
                                                
                                                NSMutableString *jsonstring = nil;
                                                if (arr_temp.count != 0) {
                                                    jsonstring = [NSMutableString stringWithFormat:@"%@",[arr_temp componentsJoinedByString:CalendarEvent_JsonStringseparator]];
                                                }
                                                preCalendar.eventIdentifiers = jsonstring;
                                                [context save:nil];
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            //save event之前，先删除当前订阅分类下的所有events，然后再重新添加
                            if (preCalendar != nil && [preCalendar.subscribeUuid containsString:subscribeuuid]) {
                                
                                //找到当前subscribe下所有的event
                                NSMutableArray *arr_subscribeEvent = [NSMutableArray array];
                                NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:[preCalendar.eventIdentifiers componentsSeparatedByString:CalendarEvent_JsonStringseparator]];
                                //当前workplace下的calendar是否有event
                                if (arr_temp.count != 0) {
                                    for (NSString *jsonstring in arr_temp) {
                                        NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
                                        if ([[dict objectForKey:CalendarEvent_SubscribeUuid] isEqualToString:subscribeuuid]) {
                                            [arr_subscribeEvent addObject:jsonstring];
                                        }
                                    }
                                    //当前calendar下是否已经订阅过该类别
                                    if (arr_subscribeEvent.count != 0) {
                                        if ([object isKindOfClass:[NSArray class]]) {
                                            for (NSString *string in arr_subscribeEvent) {
                                                NSDictionary *dict = [StringManager getDictionaryByJsonString:string];
                                                NSString *eventidentifier = [dict objectForKey:CalendarEvent_EventIdentifier];
                                                EKEvent *eventToRemove = [eventStore eventWithIdentifier:eventidentifier];
                                                if (eventToRemove) {
                                                    NSError* error = nil;
                                                    [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
                                                    
                                                    if ([arr_temp containsObject:string]) {
                                                        [arr_temp removeObject:string];
                                                    }
                                                }
                                            }
                                            //直接save event to calendar
                                            NSMutableString *jsonstring = nil;
                                            if (arr_temp.count != 0) {
                                                jsonstring = [NSMutableString stringWithFormat:@"%@",[arr_temp componentsJoinedByString:CalendarEvent_JsonStringseparator]];
                                            }
                                            preCalendar.eventIdentifiers = jsonstring;
                                            [context save:nil];
                                            [self saveEvent:subscribeuuid andData:object];
                                        }
                                        else if ([object isKindOfClass:[Shifts class]])
                                        {
                                            Shifts *shift = (Shifts *)object;
                                            for (NSString *string in arr_subscribeEvent) {
                                                NSDictionary *dict = [StringManager getDictionaryByJsonString:string];
                                                if ([[dict objectForKey:CalendarEvent_ShiftUuid] isEqualToString:shift.uuid]) {
                                                    NSString *eventidentifier = [dict objectForKey:CalendarEvent_EventIdentifier];
                                                    EKEvent *eventToRemove = [eventStore eventWithIdentifier:eventidentifier];
                                                    if (eventToRemove) {
                                                        NSError* error = nil;
                                                        [eventStore removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
                                                        [arr_temp removeObject:string];
                                                        NSMutableString *jsonstring = nil;
                                                        if (arr_temp.count != 0) {
                                                            jsonstring = [NSMutableString stringWithFormat:@"%@",[arr_temp componentsJoinedByString:CalendarEvent_JsonStringseparator]];
                                                        }
                                                        preCalendar.eventIdentifiers = jsonstring;
                                                        [context save:nil];
                                                    }
                                                }
                                            }
                                            //直接save event to calendar
                                            [self saveEvent:subscribeuuid andData:object];
                                        }
                                    }
                                    else
                                    {
                                        //直接save event to calendar
                                        [self saveEvent:subscribeuuid andData:object];
                                    }
                                }
                                else
                                {
                                    //直接save event to calendar
                                    [self saveEvent:subscribeuuid andData:object];
                                }
                            }
                        }
                    }
                }
            }];
        }
    }
}

+ (void) saveEvent:(NSString *) subscribeuuid andData:(id) object
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    CalendarEvents *preCalendar = [DatabaseManager getMyCalendarEventsInCurrentWorkplace];
    EKCalendar *mycalendar = [eventStore calendarWithIdentifier:preCalendar.calendarIdentifier];
    
    NSString *eventidentifier = preCalendar.eventIdentifiers;
    
    if ([object isKindOfClass:[NSArray class]]) {
        
        NSArray *arr_saveToCalendar = (NSArray *) object;
        
        int i = 0;
        
        for (Shifts *shift in arr_saveToCalendar) {
            
            Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
            NSString *employeename = @"";
            if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                employeename = @"Open Shift";
            }
            else
            {
                Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
                employeename = employee.fullName;
            }
            NSString *positionname = @"";
            if (shift.positionUuid == nil || [shift.positionUuid isEqualToString:UnassignedPositionUuid] ) {
            }
            else
            {
                Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
                positionname = position.name;
            }
            //创建事件
            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
            
            if ([positionname isEqualToString:@""]) {
                event.title = [NSString stringWithFormat:@"%@(Shift at %@)",employeename,location.name];
            }
            else
            {
                event.title = [NSString stringWithFormat:@"%@(Shift at %@ as %@)",employeename,location.name,positionname];
            }
            event.location = [NSString stringWithFormat:@"%@\n%@",location.name,location.address];
            if (shift.notes != nil) {
                event.notes = shift.notes;
            }
            
            NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
            [tempFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            
            event.startDate = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[shift.startTime longLongValue]]];
            event.endDate   = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[shift.endTime longLongValue]]];
            //event.allDay = YES;
            
            //添加提醒
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            
            if (mycalendar != nil) {
                event.calendar = mycalendar;
            }
            
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            
            NSLog(@"%@",event.eventIdentifier);
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:subscribeuuid,CalendarEvent_SubscribeUuid,shift.uuid,CalendarEvent_ShiftUuid,event.eventIdentifier,CalendarEvent_EventIdentifier, nil];
            NSString *jsonstring = [StringManager getJsonStringByDictionary:dict];
            
            if (eventidentifier == nil) {
                if (jsonstring != nil) {
                    eventidentifier = [NSString stringWithFormat:@"%@",jsonstring];
                }
            }
            else
            {
                eventidentifier = [NSString stringWithFormat:@"%@%@%@",eventidentifier,CalendarEvent_JsonStringseparator,jsonstring];
            }
            
            preCalendar.eventIdentifiers = eventidentifier;
            [context save:nil];
            
            if (i == arr_saveToCalendar.count - 1 ) {
                [self showAlert];
            }
            
            i++;
        }
    }
    else if ([object isKindOfClass:[Shifts class]])
    {
        Shifts *shift = (Shifts *) object;
        Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
        NSString *employeename = @"";
        if ([shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
            employeename = @"Open Shift";
        }
        else
        {
            Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
            employeename = employee.fullName;
        }
        NSString *positionname = @"";
        if (shift.positionUuid == nil || [shift.positionUuid isEqualToString:UnassignedPositionUuid] ) {
        }
        else
        {
            Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
            positionname = position.name;
        }
        //创建事件
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        
        if ([positionname isEqualToString:@""]) {
            event.title = [NSString stringWithFormat:@"%@(Shift at %@)",employeename,location.name];
        }
        else
        {
            event.title = [NSString stringWithFormat:@"%@(Shift at %@ as %@)",employeename,location.name,positionname];
        }
        event.location = [NSString stringWithFormat:@"%@\n%@",location.name,location.address];
        if (shift.notes != nil) {
            event.notes = shift.notes;
        }
        
        NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
        [tempFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        
        event.startDate = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[shift.startTime longLongValue]]];
        event.endDate   = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[shift.endTime longLongValue]]];
        //event.allDay = YES;
        
        //添加提醒
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        
        NSLog(@"%@",event.eventIdentifier);
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:subscribeuuid,CalendarEvent_SubscribeUuid,shift.uuid,CalendarEvent_ShiftUuid,event.eventIdentifier,CalendarEvent_EventIdentifier, nil];
        NSString *jsonstring = [StringManager getJsonStringByDictionary:dict];
        
        if (eventidentifier == nil) {
            if (jsonstring != nil) {
                eventidentifier = [NSString stringWithFormat:@"%@",jsonstring];
            }
        }
        else
        {
            eventidentifier = [NSString stringWithFormat:@"%@%@%@",eventidentifier,CalendarEvent_JsonStringseparator,jsonstring];
        }
        
        preCalendar.eventIdentifiers = eventidentifier;
        [context save:nil];
        
        [self showAlert];
    }
}

+ (void) showAlert
{
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    if ([[defau objectForKey:ShowAlert] isEqualToString:@"1"]) {
        [UIApplication sharedApplication].keyWindow.tintColor = AppMainColor;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Subscribed!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *viewAction = [UIAlertAction actionWithTitle:@"View Events" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSinceReferenceDate];
            NSString *format = [NSString stringWithFormat:@"calshow:%f",nowTimestamp];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:format] options:@{} completionHandler:nil];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:InternationalL(@"ok") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:viewAction];
        [alertController addAction:okAction];
        alertController.view.tintColor = AppMainColor;
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate.rootController_iphone presentViewController:alertController animated:YES completion:nil];
        
        [defau removeObjectForKey:ShowAlert];
    }
}

@end
