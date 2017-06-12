 //
//  DatabaseManager.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/3.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

#pragma mark - workPlace


+ (NSArray *) getAllWorkPlaces
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"WorkPlaces" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSArray *) getLikeWorkPlaces:(NSString *)str andArray:(NSArray *)arr
{
    if (arr.count != 0 && ![str isEqualToString:@""]) {
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeName CONTAINS[cd] %@ || placeAddress CONTAINS[cd] %@", str,str]; //predicate只能是对象
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(placeName == '%@')",str]];
        NSArray *filteredArray = [arr filteredArrayUsingPredicate:predicate];
        return filteredArray;
    }
    return nil;
}

+ (WorkPlaces *) getWorkplaceByUuid:(NSString *) uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkPlaces" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    WorkPlaces *workplace = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        workplace = [array objectAtIndex:0];
    }
    return workplace;
}


+ (CurrentWorkPlace *) getCurrentWorkPlaceByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentWorkPlace" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    CurrentWorkPlace *workplace = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        workplace = [array objectAtIndex:0];
    }
    return workplace;
}
/*
+ (WorkPlaces *) getWorkPlaceByName:(NSString *)workName andAddress:(NSString *)workAddress
{
    if (workName == nil || [workName isEqualToString:@""] || workAddress == nil || [workAddress isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WorkPlaces" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(name == '%@') AND (address == '%@')",workName,workAddress]];
    [request setPredicate:predicate];
    
    WorkPlaces *workplace = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        workplace = [array objectAtIndex:0];
    }
    return workplace;
}

+ (CurrentWorkPlace *) getCurrentWorkPlaceByName:(NSString *)workName andAddress:(NSString *)workAddress
{
    if (workName == nil || [workName isEqualToString:@""] || workAddress == nil || [workAddress isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentWorkPlace" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(name == '%@') AND (address == '%@')",workName,workAddress]];
    [request setPredicate:predicate];
    
    CurrentWorkPlace *workplace = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        workplace = [array objectAtIndex:0];
    }
    return workplace;
}
*/
#pragma mark - user
+ (NSArray *) getAllEmployees
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSMutableArray *) getAllEmployeesInLocation:(NSString *) locationuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (isJoinOnePlace == 1) AND (isAcceptJoined == 1)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_employeee = [NSMutableArray array];
    for (Employees *employee in objects) {
        NSArray *arr_locationuuid = [self getEmployeeLocationUuids:employee.uuid];
        if([arr_locationuuid containsObject:locationuuid])
        {
            [arr_employeee addObject:employee];
        }
    }
    
    return arr_employeee;
}

+ (NSArray *) getAllEmployeesNoJoinAndJoin
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];;
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSMutableDictionary *) getAllEmployeesByFullNameSorted:(NSArray *) array
{
    NSMutableDictionary *dict_employees = [NSMutableDictionary dictionary];
    
    for (Employees *employe in array) {
        
        NSString *strFiesrLetter = [NSString stringWithFormat:@"%@",[StringManager getFirstLetterFromString:employe.fullName]];
        if (dict_employees[strFiesrLetter]) {
            [dict_employees[strFiesrLetter] addObject:employe];
        }
        else
        {
            NSMutableArray *arrGroup = [NSMutableArray arrayWithObject:employe];
            [dict_employees setObject:arrGroup forKey:strFiesrLetter];
        }
    }
    
    return dict_employees;
}

+ (NSMutableDictionary *) getAllCoworkersByFullNameSorted
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *arr_mylocations = [self getEmployeeLocations:appdelegate.currentEmployee.uuid];
    NSMutableArray *arr_myCoworkers = [NSMutableArray array];
    for (Locations *location in arr_mylocations) {
        NSArray *arr = [location.employees componentsSeparatedByString:@","];
        for (NSString *uuid in arr) {
            Employees *employee = [DatabaseManager getEmployeeByUuid:uuid];
            if (![arr_myCoworkers containsObject:employee] && employee != nil) {
                [arr_myCoworkers addObject:employee];
            }
        }
    }
    
    NSMutableDictionary *dict_employees = [NSMutableDictionary dictionary];
    
    for (Employees *employee in arr_myCoworkers) {
        
        NSString *strFiesrLetter = [NSString stringWithFormat:@"%@",[StringManager getFirstLetterFromString:employee.fullName]];
        if (dict_employees[strFiesrLetter]) {
            [dict_employees[strFiesrLetter] addObject:employee];
        }
        else
        {
            NSMutableArray *arrGroup = [NSMutableArray arrayWithObject:employee];
            [dict_employees setObject:arrGroup forKey:strFiesrLetter];
        }
    }
    
    return dict_employees;
}

+ (NSMutableDictionary *) getEmployeesByLocationUuid:(NSString *)locationUuid andPositionUuid:(NSString *)positionUuid
{
    /*****仅仅是按照location来显示employee*****/
    NSMutableArray *arr_employee = [NSMutableArray array];
    Locations *location = [self getLocationByUuid:locationUuid];
    arr_employee = [NSMutableArray arrayWithArray:[location.employees componentsSeparatedByString:@","]];
    NSMutableDictionary *dict_employees = [NSMutableDictionary dictionary];
    for (NSString *uuid in arr_employee) {
        
        Employees *employee = [self getEmployeeByUuid:uuid];
        if (employee != nil) {
            NSString *strFiesrLetter = [NSString stringWithFormat:@"%@",[StringManager getFirstLetterFromString:employee.fullName]];
            if (dict_employees[strFiesrLetter]) {
                [dict_employees[strFiesrLetter] addObject:employee];
            }
            else
            {
                NSMutableArray *arrGroup = [NSMutableArray arrayWithObject:employee];
                [dict_employees setObject:arrGroup forKey:strFiesrLetter];
            }
        }
        
    }
    
    return dict_employees;
    /******按照location和position来查询*******/
//    NSMutableArray *arr_employee = [NSMutableArray array];
//    Locations *location = [self getLocationByUuid:locationUuid];
//    if (positionUuid == nil) {
//        arr_employee = [NSMutableArray arrayWithArray:[location.employees componentsSeparatedByString:@","]];
//    }
//    else
//    {
//        Positions *position = [self getPositionByUuid:positionUuid];
//        NSArray *arr1 = [location.employees componentsSeparatedByString:@","];
//        NSArray *arr2 = [position.employees componentsSeparatedByString:@","];
//        for (NSString *uuid in arr1) {
//            if ([arr2 containsObject:uuid]) {
//                [arr_employee addObject:uuid];
//            }
//        }
//    }
//    NSMutableDictionary *dict_employees = [NSMutableDictionary dictionary];
//    for (NSString *uuid in arr_employee) {
//        
//        Employees *employee = [self getEmployeeByUuid:uuid];
//        
//        NSString *strFiesrLetter = [NSString stringWithFormat:@"%@",[StringManager getFirstLetterFromString:employee.fullName]];
//        if (dict_employees[strFiesrLetter]) {
//            [dict_employees[strFiesrLetter] addObject:employee];
//        }
//        else
//        {
//            NSMutableArray *arrGroup = [NSMutableArray arrayWithObject:employee];
//            [dict_employees setObject:arrGroup forKey:strFiesrLetter];
//        }
//    }
//
//    return dict_employees;
}


+ (NSArray *) getAllJoinedEmployees
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isPermitted == 1)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSArray *) getNoJoinedEmployees
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isPermitted == 0)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSArray *) getAllNoManagerEmployees
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isManager == 0) AND (isDelete == 0)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (Employees *) getEmployeeByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    Employees *employee = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        employee = [array objectAtIndex:0];
    }
    return employee;
}

+ (Employees *) getEmployeeByEmail:(NSString *)email
{
    if (email == nil || [email isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employees" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(email == '%@') AND (isDelete == 0)",email]];
    [request setPredicate:predicate];
    
    Employees *employee = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        employee = [array objectAtIndex:0];
    }
    return employee;
}
+ (CurrentEmployee *) getCurrentEmployeeByEmail:(NSString *)email
{
    if (email == nil || [email isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentEmployee" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(email == '%@') AND (isDelete == 0)",email]];
    [request setPredicate:predicate];
    
    CurrentEmployee *employee = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        employee = [array objectAtIndex:0];
    }
    return employee;
}

+ (CurrentEmployee *) getCurrentEmployeeByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CurrentEmployee" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    CurrentEmployee *employee = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        employee = [array objectAtIndex:0];
    }
    return employee;
}


+ (NSArray *)getEmployeeAllPositionUuid:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_temp = [NSMutableArray array];
    
    for (Positions *position in objects) {
        if ([position.employees containsString:employeeUuid]) {
            [arr_temp addObject:position.uuid];
        }
    }
    
    return arr_temp;
}

+ (void) modifyEmployeeInfo:(Employees *)employee_modify
{
    if (employee_modify == nil ||  employee_modify.uuid == nil)
    {
        return;
    }
    Employees *employee = [DatabaseManager getEmployeeByEmail:employee_modify.email];
    employee = employee_modify;
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    [context save:nil];
}

+ (void) deleteOneEmployee:(Employees *)employee
{
    if (employee == nil ||  employee.uuid == nil)
    {
        return;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    [context deleteObject:employee];
    [context save:nil];
}


#pragma mark - location

+ (NSArray *) getAllLocations
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
//    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (Locations *) getLocationByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    Locations *location = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        location = [array objectAtIndex:0];
    }
    return location;
}

+ (NSMutableArray *) getEmployeeLocationUuids:(NSString *)employeeuuid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr_locations = [self getAllLocations];
    for (Locations *location in arr_locations) {
        if ([location.employees containsString:employeeuuid]) {
            [arr addObject:location.uuid];
        }
    }
    return arr;
}


+ (NSMutableArray *) getEmployeeLocations:(NSString *)employeeuuid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr_locations = [self getAllLocations];
    for (Locations *location in arr_locations) {
        if ([location.employees containsString:employeeuuid]) {
            [arr addObject:location];
        }
    }
    return arr;
}



+ (NSArray *)getEmployeeAllLocationUuid:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_temp = [NSMutableArray array];
    
    for (Locations *location in objects) {
        if ([location.employees containsString:employeeUuid]) {
            [arr_temp addObject:location.uuid];
        }
    }
    
    return arr_temp;
}

+ (NSMutableArray *) getAllLocationsSortedByFirstLetter
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '000000')"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *att_temp = [NSMutableArray arrayWithArray:objects];
    
    if (objects.count >= 2) {
        
        for (int i = 0; i < att_temp.count-1; i++) {
            
            Locations *location1 = [att_temp objectAtIndex:i];
            
            for (int j = i+1; j<att_temp.count; j++) {
                
                Locations *location2 = [att_temp objectAtIndex:j];
                
                if ([[StringManager getFirstLetterFromString:location1.name] compare:[StringManager getFirstLetterFromString:location2.name]] == NSOrderedDescending) {
                    [att_temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    
    return att_temp;
}

+ (NSString *) getDefaultLocationUuid
{
    NSArray *arr = [self getAllLocations];
    if (arr.count != 0) {
        Locations *location = [arr objectAtIndex:0];
        return location.uuid;
    }
    return nil;
}


+ (Locations *) getFirstLocationByLocationUuid:(NSString *)locationUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(locationUuid == '%@') AND (isDelete == 0) AND (employeeUuid == '000000')",locationUuid]];
    [request setPredicate:predicate];
    
    Locations *location = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        location = [array objectAtIndex:0];
    }
    return location;
}
+ (Locations *) getLocationByLocationUuid:(NSString *)locationUuid
{
    if (locationUuid == nil || [locationUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(locationUuid == '%@') AND (isDelete == 0)",locationUuid]];
    [request setPredicate:predicate];
    
    Locations *location = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        location = [array objectAtIndex:0];
    }
    return location;
}

+ (NSArray *) getAllLocationsByLocationUuid:(NSString *)locationUuid
{
    if (locationUuid == nil || [locationUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(locationUuid == '%@') AND (isDelete == 0)",locationUuid]];
    [request setPredicate:predicate];

    NSArray *array = [context executeFetchRequest:request error:&errors];
    return array;
}

+ (Locations *) getLocationByLocationUuid:(NSString *)locationUuid andEmployeeUuid:(NSString *)employeeuUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(locationUuid == '%@') AND (isDelete == 0) AND (employeeUuid == '%@')",locationUuid,employeeuUuid]];
    [request setPredicate:predicate];
    
    Locations *location = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        location = [array objectAtIndex:0];
    }
    return location;
}

+ (NSArray *) getLocationsByLocationUuid:(NSString *)locationUuid
{
    if (locationUuid == nil || [locationUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(locationUuid == '%@') AND (isDelete == 0) AND (employeeUuid != '000000')",locationUuid]];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    return array;
}


+ (NSString *) getLocationAddressByLocationUuid:(NSString *)locationUuid
{
    Locations *location  = [self getFirstLocationByLocationUuid:locationUuid];
    return location.address;
}

+ (void) deleteLocation:(Locations *)location
{
    if (location == nil ||  location.uuid == nil)
    {
        return;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    [context deleteObject:location];
    [context save:nil];
}

+ (NSArray *) getEmployeeLocationsByEmployeeUuid:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@')",employeeUuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

#pragma mark - position
+ (NSArray *) getAllPositions
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
//    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (Positions *) getPositionByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    Positions *position = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        position = [array objectAtIndex:0];
    }
    return position;
}
+ (NSMutableArray *) getEmployeePositionUuids:(NSString *)employeeuuid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr_positions = [self getAllPositions];
    for (Positions *position in arr_positions) {
        if ([position.employees containsString:employeeuuid]) {
            [arr addObject:position.uuid];
        }
    }
    return arr;
}

+ (NSMutableArray *) getEmployeePositions:(NSString *)employeeuuid
{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *arr_positions = [self getAllPositions];
    for (Positions *position in arr_positions) {
        if ([position.employees containsString:employeeuuid]) {
            [arr addObject:position];
        }
    }
    return arr;
}

+ (Positions *) getPositionByEmployeeUuid:(NSString *)employeeUuid
{
    if (employeeUuid == nil || [employeeUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(employeeUuid == '%@') AND (isDelete == 0)",employeeUuid]];
    [request setPredicate:predicate];
    
    Positions *position = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        position = [array objectAtIndex:0];
    }
    return position;
}

+ (Positions *) getMyPositionByPositionUuid:(NSString *)positionUuid
{
    if (positionUuid == nil || [positionUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(positionUuid == '%@') AND (employeeUuid == '%@') AND (isDelete == 0)",positionUuid,appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    
    Positions *position = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        position = [array objectAtIndex:0];
    }
    return position;
}

+ (Positions *) getPositionByPositionUuid:(NSString *)PositionUuid
{
    if (PositionUuid == nil || [PositionUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(positionUuid == '%@') AND (isDelete == 0)",PositionUuid]];
    [request setPredicate:predicate];
    
    Positions *position = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        position = [array objectAtIndex:0];
    }
    return position;
}

+ (NSArray *) getAllMyPositions
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Positions" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@')",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (void) deletePosition:(Positions *)position
{
    if (position == nil ||  position.uuid == nil)
    {
        return;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    [context deleteObject:position];
    [context save:nil];
}

#pragma mark - shift

+ (NSArray *) getEmployeeShiftsEntire:(NSString *)employeeuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@')",employeeuuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}


+ (NSMutableDictionary *) getAllMyShifts
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (locationUuid != nil) AND (takeState == 1)",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allShifts = [self getCalendarAndFilterShiftsDic:objects];
    
    return dict_allShifts;
}

+ (NSArray *) getAllMyShiftsArray
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (takeState == 1) AND (locationUuid != nil)",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (NSArray *) getAllShifts
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil)"]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];

    return objects;
}

+ (NSMutableDictionary *) managerGetAllShifts
{
    //all no swapdrop shift and swapdrop pending shift
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil)"]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    if (objects.count != 0) {
        
        NSMutableDictionary *dict_allShifts = [self getCalendarAndFilterShiftsDic:objects];
        
        return dict_allShifts;
    }
    return nil;
}
+ (NSMutableDictionary *) getCalendarAndFilterShiftsDic:(NSArray *) array
{
    if (array.count == 0) {
        return nil;
    }
    NSMutableArray *arr_objects = [NSMutableArray array];
    
    NSDictionary *dict = [UserEntity getCalendarDate];
    if ([[dict objectForKey:@"state"] isEqualToString:@"0"]) {
        //week
        
        NSNumber *number1 = [dict objectForKey:@"number1"];
        NSNumber *number2 = [dict objectForKey:@"number2"];
        
        for (Shifts *shift in array) {
            if ([shift.startDate longLongValue] >= [number1 longLongValue] && [shift.startDate longLongValue] <= [number2 longLongValue]) {
                [arr_objects addObject:shift];
            }
        }
    }
    else if ([[dict objectForKey:@"state"] isEqualToString:@"1"])
    {
        //day
        NSNumber *number1 = [dict objectForKey:@"number1"];
        for (Shifts *shift in array) {
            if ([shift.startDate longLongValue] == [number1 longLongValue]) {
                [arr_objects addObject:shift];
            }
        }
    }
    
    NSMutableDictionary *dict_allShifts = [NSMutableDictionary dictionary];
    
    if (arr_objects.count != 0) {
        
        for (Shifts *shift in arr_objects) {
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
            NSMutableArray *arr_temp = [dict_allShifts objectForKey:time];
            if (arr_temp.count == 0) {
                arr_temp = [NSMutableArray arrayWithObject:shift];
            }
            else
            {
                [arr_temp addObject:shift];
            }
            [dict_allShifts setObject:arr_temp forKey:time];
        }
    }
    return dict_allShifts;
}
+ (NSMutableArray *) getFreeEmployeeByShiftUuid:(NSString *)uuid
{
    Shifts *shift_temp = [self getShiftByUuid:uuid];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid != '%@') AND (locationUuid == '%@') AND (takeState == 1)",OpenShiftEmployeeUuid,shift_temp.locationUuid]];
    [request setPredicate:predicate];
    
    //当前location下所有指定employee并且未删除的shift
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    //找出不满足条件的shift
    NSMutableArray *arr_noFreeShift = [NSMutableArray array];
    for (Shifts *shift in objects) {
        Employees *employee = [DatabaseManager getEmployeeByUuid:shift.employeeUuid];
        if (employee != nil) {
            if ([shift.startTime longLongValue] >= [shift_temp.startTime longLongValue] && [shift.endTime longLongValue] <= [shift_temp.endTime longLongValue]) {
                [arr_noFreeShift addObject:shift];
            }
        }
    }
    
    //不满足条件shift中，有哪些employee
    NSMutableArray *arr_noFreeemployees = [NSMutableArray array];
    for (Shifts *shift in arr_noFreeShift) {
        Employees *employee = [self getEmployeeByUuid:shift.employeeUuid];
        if (employee != nil && ![arr_noFreeemployees containsObject:employee.uuid]) {
            [arr_noFreeemployees addObject:employee.uuid];
        }
    }
    
    NSMutableArray *arr_allEmployees = [NSMutableArray arrayWithArray:[self getAllEmployees]];
    NSMutableArray *arr_freeEmployee = [NSMutableArray array];
    for (Employees *em in arr_allEmployees) {
        NSArray *arr_employeelocationuuid = [self getEmployeeLocationUuids:em.uuid];
        if (![arr_noFreeemployees containsObject:em.uuid] && ![em.uuid isEqualToString:appdelegate.currentEmployee.uuid] && ![arr_freeEmployee containsObject:em.uuid] && [arr_employeelocationuuid containsObject:shift_temp.locationUuid]) {
            [arr_freeEmployee addObject:em.uuid];
        }
    }
    
    return arr_freeEmployee;
}

+ (NSMutableArray *) getFreeShiftsUuidByShiftUuid:(NSString *)uuid
{
    Shifts *shift_temp = [DatabaseManager getShiftByUuid:uuid];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid != '%@') AND (employeeUuid != '%@') AND (locationUuid != nil) AND (takeState == 1)",OpenShiftEmployeeUuid,appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    NSMutableArray *arr_freeShift = [NSMutableArray arrayWithArray:objects];

    NSMutableArray *arr_shifts = [NSMutableArray array];
    for (Shifts *shfit in arr_freeShift) {
        Employees *employee = [DatabaseManager getEmployeeByUuid:shfit.employeeUuid];
        NSNumber *nowStamp = [StringManager getDayTimeStamp:[NSDate date]];
        Drop *drop = [self getPendingDropByShiftUuid:shfit.uuid];
        Drop *swap = [self getPendingSwapByShiftUuid:shfit.uuid];
        
        if (employee != nil) {
            
            if (employee != nil && [shfit.startTime longLongValue] >= [nowStamp longLongValue] && drop == nil && swap == nil && [shift_temp.locationUuid isEqualToString:shfit.locationUuid]) {
                [arr_shifts addObject:shfit];
            }
        }
    }
    
    NSArray *arr_sortedShift = [self sortedShiftArrayByTime:arr_shifts];

    if (arr_sortedShift.count != 0) {
        NSMutableArray *arr_uuids = [NSMutableArray array];
        for (Shifts *shift in arr_sortedShift) {
            [arr_uuids addObject:shift.uuid];
        }
        return arr_uuids;
    }
    
    return nil;
}

+ (NSMutableDictionary *) getShiftsByEmployeeUuid:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (locationUuid != nil)",employeeUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allShifts = [self getCalendarAndFilterShiftsDic:objects];
    return dict_allShifts;
}
+ (NSMutableDictionary *) getShiftsByPositionUuid:(NSString *)positionUuid
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = nil;
    NSArray *objects = nil;
    
    if ([positionUuid isEqualToString:UnassignedPositionUuid]) {
        //指定positionUuid的shifts
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil AND (positionUuid == nil))"]];
        [request setPredicate:predicate];
        objects = [context executeFetchRequest:request error:&errors];
    }
    else
    {
        //指定positionUuid的shifts
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (positionUuid == '%@') AND (locationUuid != nil)",positionUuid]];
        [request setPredicate:predicate];
        objects = [context executeFetchRequest:request error:&errors];
    }
    
    NSMutableDictionary *dict_allShifts = [self getCalendarAndFilterShiftsDic:objects];
    return dict_allShifts;
}


+ (NSMutableDictionary *) getShiftsByLocationUuid:(NSString *)locationUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定locationUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid == '%@')",locationUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allShifts = [self getCalendarAndFilterShiftsDic:objects];
    return dict_allShifts;
}

+ (NSArray *) getShiftsArrayByLocationUuid:(NSString *)locationUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定locationUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid == '%@') AND (takeState == 1)",locationUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (NSMutableDictionary *) getShiftsByEmployeess
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil) AND (employeeUuid != '%@')",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_shifts = [self getCalendarAndFilterShiftsDic:objects];

    return dict_shifts;
}


+ (NSMutableDictionary *) getShiftsByPositions
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定positionUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil) AND (positionUuid != nil)"]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_shifts = [self getCalendarAndFilterShiftsDic:objects];
    
    return dict_shifts;
}

+ (NSMutableDictionary *) getShiftsByEmployeePositions
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (positionUuid != nil) AND (locationUuid != nil) AND (takeState == 1)",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSArray *arr_mypositionuuid = [self getEmployeeAllPositionUuid:appdelegate.currentEmployee.uuid];
    NSMutableArray *arr_myshift = [NSMutableArray array];
    for (Shifts *shift in objects) {
        if ([arr_mypositionuuid containsObject:shift.positionUuid]) {
            [arr_myshift addObject:shift];
        }
    }
    NSMutableDictionary *dict_shifts = [self getCalendarAndFilterShiftsDic:arr_myshift];
    return dict_shifts;
}

+ (NSMutableDictionary *) getEmployeeNeedActionOpenShift_dict
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (haveTakedEmployeesNumber < needEmployeesNumber) AND (locationUuid != nil) AND (takeState == 1)",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    NSMutableArray *arr_shift = [NSMutableArray array];
    for (Shifts *shift in objects) {
        if (![shift.openShift_employees containsString:appdelegate.currentEmployee.uuid]) {
            [arr_shift addObject:shift];
        }
    }
    NSMutableArray *arr_shift2 = [NSMutableArray array];
    NSArray *arr_employeelocationuuid = [self getEmployeeAllLocationUuid:appdelegate.currentEmployee.uuid];
    NSArray *arr_allMyShift = [self getAllMyShiftsArray];
    for (Shifts *shift in arr_shift) {
        BOOL isConfilict = NO;
        if ([arr_employeelocationuuid containsObject:shift.locationUuid]) {
            for (Shifts *shift2 in arr_allMyShift) {
                if (!([shift.endTime longLongValue] <= [shift2.startTime longLongValue] || [shift.startTime longLongValue] >= [shift2.endTime longLongValue])) {
                    isConfilict = YES;
                    break;
                }
            }
            if (isConfilict == NO) {
                [arr_shift2 addObject:shift];
            }
        }
    }
    
    NSMutableDictionary *dict_shifts = [self getCalendarAndFilterShiftsDic:arr_shift2];
    return dict_shifts;
}

+ (NSArray *) getEmployeeNeedActionOpenShift_array
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (haveTakedEmployeesNumber < needEmployeesNumber) AND (locationUuid != nil) AND (takeState == 1)",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_shift = [NSMutableArray array];
    for (Shifts *shift in objects) {
        if (![shift.openShift_employees containsString:appdelegate.currentEmployee.uuid]) {
            [arr_shift addObject:shift];
        }
    }
    
    NSNumber *now = [StringManager dateTransferTimeStamp:[NSDate date]];
    NSMutableArray *arr_shift2 = [NSMutableArray array];
    NSArray *arr_employeelocationuuid = [self getEmployeeAllLocationUuid:appdelegate.currentEmployee.uuid];
    for (Shifts *shift in arr_shift) {
        if ([arr_employeelocationuuid containsObject:shift.locationUuid] && [shift.endTime longLongValue] >= [now longLongValue]) {
            [arr_shift2 addObject:shift];
        }
    }
    
    return arr_shift2;
}

+ (NSMutableDictionary *) getShiftsByPositionsAndDayStamp:(NSNumber *) number
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定positionUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil)"]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_objects = [NSMutableArray array];
    
    for (Shifts *shift in objects) {
        if ([shift.startDate longLongValue] == [number longLongValue]) {
            [arr_objects addObject:shift];
        }
    }
    
    NSMutableDictionary *dict_1 = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in arr_objects) {
        
        NSString *positionuuid = shift.positionUuid;
        
        if (shift.positionUuid == nil) {
            positionuuid = UnassignedPositionUuid;
        }
        else
        {
            positionuuid = shift.positionUuid;
        }
        NSMutableArray *arr_temp = [dict_1 objectForKey:positionuuid];
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_temp addObject:shift];
        }
        [dict_1 setObject:arr_temp forKey:positionuuid];
    }
    
    return dict_1;
}
+ (NSMutableDictionary *) getShiftsByLocations
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定positionUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil)"]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_objects = [NSMutableArray array];
    
    NSDictionary *dict = [UserEntity getCalendarDate];
    if ([[dict objectForKey:@"state"] isEqualToString:@"0"]) {
        //week
        
        NSNumber *number1 = [dict objectForKey:@"number1"];
        NSNumber *number2 = [dict objectForKey:@"number2"];
        
        for (Shifts *shift in objects) {
            if ([shift.startDate longLongValue] >= [number1 longLongValue] && [shift.startDate longLongValue] <= [number2 longLongValue]) {
                [arr_objects addObject:shift];
            }
        }
    }
    else if ([[dict objectForKey:@"state"] isEqualToString:@"1"])
    {
        //day
        NSNumber *number1 = [dict objectForKey:@"number1"];
        for (Shifts *shift in objects) {
            if ([shift.startDate longLongValue] == [number1 longLongValue]) {
                [arr_objects addObject:shift];
            }
        }
    }
    
    NSMutableDictionary *dict_1 = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in arr_objects) {
        
        NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
        NSMutableArray *arr_temp = [dict_1 objectForKey:time];
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_temp addObject:shift];
        }
        [dict_1 setObject:arr_temp forKey:time];
    }
    return dict_1;
}

+ (NSMutableDictionary *) getFullShiftsByEmployeeLocations
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSArray *arr_mylocaitonuuid = [self getEmployeeAllLocationUuid:appdelegate.currentEmployee.uuid];
    NSMutableArray *arr_objects = [NSMutableArray array];
    for (NSString *locationuuid in arr_mylocaitonuuid) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid == '%@') AND (takeState == 1)",locationuuid]];
        [request setPredicate:predicate];
        NSArray *objects = [context executeFetchRequest:request error:&errors];
        for (Shifts *shift in objects) {
            [arr_objects addObject:shift];
        }
    }
    
    NSMutableDictionary *dict_shifts = [self getCalendarAndFilterShiftsDic:arr_objects];
    return dict_shifts;
}


+ (Shifts *) getShiftByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@') AND (locationUuid != nil)",uuid]];
    [request setPredicate:predicate];
    
    Shifts *shift = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        shift = [array objectAtIndex:0];
    }
    return shift;
}

+ (Shifts *) getTakedShiftUuid:(NSString *)shiftUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(employeeUuid == '%@') AND (uuid == '%@') AND (locationUuid != nil)",appdelegate.currentEmployee.uuid,shiftUuid]];
    [request setPredicate:predicate];
    
    Shifts *shift = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        shift = [array objectAtIndex:0];
    }
    return shift;
}

+ (NSMutableDictionary *) getShiftsByCalendarAndFilter
{
    NSMutableDictionary *dict_shifts;
    NSDictionary *dict_filter = [UserEntity getFilter];
    if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"0"]) {
        dict_shifts = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager managerGetAllShifts]];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"1"]) {
        dict_shifts = [NSMutableDictionary dictionaryWithDictionary:[DatabaseManager getAllMyShifts]];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"2"]) {
        dict_shifts = [DatabaseManager getShiftsByEmployeeUuid:[dict_filter objectForKey:@"employeeUuid"]];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"3"]) {
        
        dict_shifts = [DatabaseManager getShiftsByPositionUuid:[dict_filter objectForKey:@"positionUuid"]];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"4"]) {
        
        dict_shifts = [DatabaseManager getShiftsByLocationUuid:[dict_filter objectForKey:@"locationUuid"]];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"5"]) {
        
        dict_shifts = [DatabaseManager getShiftsByEmployeess];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"6"]) {
        
        dict_shifts = [DatabaseManager getShiftsByPositions];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"7"]) {
        
        dict_shifts = [DatabaseManager getShiftsByLocations];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"8"]) {
        
        dict_shifts = [DatabaseManager getFullShiftsByEmployeeLocations];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"9"]) {
        
        dict_shifts = [DatabaseManager getEmployeeNeedActionOpenShift_dict];
    }
    else if ([[dict_filter objectForKey:@"filter"] isEqualToString:@"10"]) {
        
        dict_shifts = [DatabaseManager getShiftsByEmployeePositions];
    }

    return dict_shifts;
}

+ (NSArray *) sortedShiftArrayByTime:(NSMutableArray *)array
{
    NSArray *array2 = [array sortedArrayUsingComparator:
                       ^NSComparisonResult(Shifts *obj1, Shifts *obj2) {

                           return [obj1.startTime compare:obj2.startTime];
                       }];
    
    return array2;
    
}

+ (NSArray *) sortedShiftArrayBydate:(NSMutableArray *)array
{
    NSArray *array2 = [array sortedArrayUsingComparator:
                       ^NSComparisonResult(NSString *obj1, NSString *obj2) {
                           
                           return [obj1 compare:obj1];
                       }];
    
    return array2;
    
}


+ (NSArray *) getDayShifts:(NSNumber *) dayStamp
{
    NSString *stamp = [NSString stringWithFormat:@"%@",dayStamp];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (startDate == '%@') AND (locationUuid != nil)",stamp]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (NSMutableDictionary *) getDayShiftsByEmployeeFullName:(NSNumber *) dayStamp andLocationUuid:(NSString *) locationUuid
{
    //2016-10-26 -> 1473786540   //1479398400
    NSString *stamp = [NSString stringWithFormat:@"%@",dayStamp];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid != '%@') AND (startDate == '%@') AND (locationUuid == '%@') AND (takeState == 1)",OpenShiftEmployeeUuid,stamp,locationUuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in objects) {
        
        Employees *employee = [self getEmployeeByUuid:shift.employeeUuid];
        
        NSMutableArray *arr_temp = [returnDict objectForKey:employee.fullName];
        
        if (employee != nil) {
            if (arr_temp.count == 0) {
                arr_temp = [NSMutableArray arrayWithObject:shift];
            }
            else
            {
                [arr_temp addObject:shift];
            }
            [returnDict setObject:arr_temp forKey:employee.fullName];
        }
        
    }
    
    return returnDict;
}

+ (NSMutableArray *) getEmployeeAvailableOpenshift
{
    NSNumber *nowTimeStamp = [StringManager getDayTimeStamp:[NSDate date]];
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (needEmployeesNumber > haveTakedEmployeesNumber) AND (locationUuid != nil) AND (takeState == 1)",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_temp = [NSMutableArray array];
    
    for (Shifts *shfit in objects) {
        if ([shfit.endTime longLongValue] > [nowTimeStamp longLongValue]) {
            [arr_temp addObject:shfit];
        }
    }
    
    return arr_temp;
}

+ (NSArray *) getDashboardMySchedule
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSLog(@"%@",appdelegate.currentEmployee.uuid);
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (locationUuid != nil) AND (takeState == 1)",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (NSMutableDictionary *) getAllMyAcknowledgeShifts
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    //指定employeeUuid的shifts
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (isTake == 0) AND (locationUuid != nil) AND (takeState == 1)",appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allShifts = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < objects.count; i++) {
        Shifts *shift = [objects objectAtIndex:i];
        NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
        NSMutableArray *arr_temp = [dict_allShifts objectForKey:time];
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_temp addObject:shift];
        }
        [dict_allShifts setObject:arr_temp forKey:time];
    }
    return dict_allShifts;
}

+ (NSMutableDictionary *) shiftSortedByLocationUuid:(NSDictionary *) dict_shifts
{
    NSMutableArray *arr_shifts = [NSMutableArray array];
    for (NSString *time in [dict_shifts allKeys]) {
        NSMutableArray *arr = [dict_shifts objectForKey:time];
        for (Shifts *shift in arr) {
            if (![shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid]) {
                [arr_shifts addObject:shift];
            }
        }
    }
    NSMutableDictionary *dict_return = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in arr_shifts) {
        NSMutableArray *arr_2 = [dict_return objectForKey:shift.locationUuid];
        if (arr_2.count == 0) {
            arr_2 = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_2 addObject:shift];
        }
        [dict_return setObject:arr_2 forKey:shift.locationUuid];
    }
    
    return dict_return;
}

+ (NSMutableDictionary *) shiftSortedByEmployeeUuid:(NSMutableArray *) arr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Shifts *shift in arr) {
        NSMutableArray *arr1 = [dict objectForKey:shift.employeeUuid];
        if (arr1.count == 0) {
            arr1 = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr1 addObject:shift];
        }
        [dict setObject:arr1 forKey:shift.employeeUuid];
    }
    return dict;
}

+ (NSMutableDictionary *) shiftSortedByPositionUuid:(NSMutableArray *) arr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Shifts *shift in arr) {
        NSString *positionuuid = nil;
        if (shift.positionUuid != nil) {
            positionuuid = shift.positionUuid;
        }
        else
        {
            positionuuid = UnassignedPositionUuid;
        }
        NSMutableArray *arr1 = [dict objectForKey:positionuuid];
        if (arr1.count == 0) {
            arr1 = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr1 addObject:shift];
        }
        [dict setObject:arr1 forKey:positionuuid];
    }
    return dict;
}

+ (NSMutableArray *) shiftSortedBySameStartTimeStamp:(NSMutableArray *) arr
{
    NSMutableArray *arr_result = [NSMutableArray array];
    
    for (int i = 0; i < arr.count; i++) {
        
        NSMutableDictionary *dict = nil;
        
        Shifts *shift = [arr objectAtIndex:i];
        
        int sameStartTimeShift = 1;
        
        if (i == 0) {

            for (int j = 1; j < arr.count ; j++) {
                Shifts *shift_temp = [arr objectAtIndex:j];
                if ([shift_temp.startTime longLongValue] >= [shift.startTime longLongValue] && [shift_temp.startTime longLongValue] < [shift.endTime longLongValue]) {
                    sameStartTimeShift += 1;
                }
            }
            dict = [NSMutableDictionary dictionary];
            [dict setObject:shift.string_time forKey:@"time"];
            [dict setObject:[NSNumber numberWithInt:sameStartTimeShift] forKey:@"count"];
        }
        else
        {
            Shifts *lastShift = [arr objectAtIndex:i-1];
            if ([shift.endTime longLongValue] > [lastShift.endTime longLongValue]) {
                for (int j = i+1; j < arr.count ; j++) {
                    Shifts *shift_temp = [arr objectAtIndex:j];
                    if ([shift_temp.startTime longLongValue] >= [shift.startTime longLongValue] && [shift_temp.startTime longLongValue] < [shift.endTime longLongValue]) {
                        sameStartTimeShift += 1;
                    }
                }
                //lastshift 结束时间作为开始时间，shift结束时间作为结束时间
                if ([shift.startTime longLongValue] < [lastShift.endTime longLongValue]) {
                    NSDictionary *dict1 = [StringManager interceptionTime:lastShift.string_time];
                    NSDictionary *dict2 = [StringManager interceptionTime:shift.string_time];
                    NSString *time = [NSString stringWithFormat:@"%@ %@ - %@ %@",[dict1 objectForKey:@"str3"],[dict1 objectForKey:@"str4"],[dict2 objectForKey:@"str3"],[dict2 objectForKey:@"str4"]];
                    dict = [NSMutableDictionary dictionary];
                    [dict setObject:time forKey:@"time"];
                    [dict setObject:[NSNumber numberWithInt:sameStartTimeShift] forKey:@"count"];
                }
                else
                {
                    dict = [NSMutableDictionary dictionary];
                    [dict setObject:shift.string_time forKey:@"time"];
                    [dict setObject:[NSNumber numberWithInt:sameStartTimeShift] forKey:@"count"];
                }
            }
        }
        if (dict != nil) {
            [arr_result addObject:dict];
        }
    }
    
    return arr_result;
}


+ (NSMutableArray *) getEmployeeOpenShiftsArray
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (takeState == 1) AND (locationUuid != nil)",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_my = [NSMutableArray array];
    NSArray *arr_allmyLocation = [self getEmployeeLocationUuids:appdelegate.currentEmployee.uuid];
    for (Shifts *shift in objects) {
        if ([arr_allmyLocation containsObject:shift.locationUuid]) {
            [arr_my addObject:shift];
        }
    }
    return arr_my;
}
+ (NSArray *) getManagerOpenShittArray
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (takeState == 1) AND (locationUuid != nil)",OpenShiftEmployeeUuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}
+ (NSArray *) getEntireShiftsArray
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil) AND (takeState == 1)"]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (Shifts *) getShiftByEmployeeUuid:(NSString *)employeeUuid andStartTimeStamp:(NSString *) startStamp andEndTimeStamp:(NSString *) endStamp
{
    if (employeeUuid == nil || [employeeUuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(employeeUuid == '%@') AND (isDelete == 0) AND (locationUuid != nil)",employeeUuid]];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    
    Shifts *shifttemp = nil;
    
    for (Shifts *shift in array) {
//        if (([startStamp longLongValue] >= [shift.startTime longLongValue] && [startStamp longLongValue] < [shift.endTime longLongValue]) || ([endStamp longLongValue] > [shift.startTime longLongValue] && [endStamp longLongValue] <= [shift.endTime longLongValue])) {
//            shifttemp = shift;
//            break;
//        }
        if (!([startStamp longLongValue] > [shift.endTime longLongValue] || [endStamp longLongValue] < [shift.startTime longLongValue])) {
            shifttemp = shift;
            break;
        }
    }
    return shifttemp;
}

+ (NSMutableArray *) getShiftsArrayByLocationUuid:(NSString *)locationuudi andStartStamo:(NSNumber *)number1 andEndStamp:(NSNumber *) number2 andPositionUuid:(NSString *) positionuuid andTakeState:(NSNumber *) takestate
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid == '%@') AND (positionUuid == '%@') AND (takeState == '%@')",locationuudi,positionuuid,takestate]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_result = [NSMutableArray array];
    for (Shifts *shift in objects) {
        
        if([shift.startDate longLongValue] >= [number1 longLongValue] && [shift.startDate longLongValue] <= [number2 longLongValue])
        {
            [arr_result addObject:shift];
        }
    }
    
    return arr_result;
}
+ (NSMutableArray *) getShiftsArrayByLocationUuid:(NSString *)locationuudi andStartStamo:(NSNumber *)number1 andEndStamp:(NSNumber *) number2 andEmployeeUuid:(NSString *) employeeuuid andTakeState:(NSNumber *) takestate
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid == '%@') AND (employeeUuid == '%@') AND (takeState == '%@')",locationuudi,employeeuuid,takestate]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_result = [NSMutableArray array];
    for (Shifts *shift in objects) {
        if([shift.startDate longLongValue] >= [number1 longLongValue] && [shift.startDate longLongValue] <= [number2 longLongValue])
        {
            [arr_result addObject:shift];
        }
    }
    
    return arr_result;
}

+ (NSMutableArray *) sortedShiftByStartDate:(NSMutableArray *) array
{
    if (array.count != 0) {
        
        NSMutableArray *array_temp = [NSMutableArray array];
        
        for (NSString *str1 in array) {
            
            NSString *yearMonthDay1 = [str1 substringFromIndex:4];
            NSString *month1 = [yearMonthDay1 substringWithRange:NSMakeRange(0, 3)];
            NSString *yearDay1 = [str1 substringFromIndex:7];
            long mon1 = [StringManager getNumberMonth:month1];
            NSRange range1 = [yearDay1 rangeOfString:@","];
            NSString *day1 = [yearDay1 substringWithRange:NSMakeRange(0, range1.location)];
            day1 = [day1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *year1 = [yearDay1 substringWithRange:NSMakeRange(range1.location + 2, 4)];
            NSString *mydate1 = [NSString stringWithFormat:@"%@-%lu-%@",year1,mon1,day1];
            NSNumber *number1 = [StringManager stringDateTransferTimeStamp:mydate1];
            [array_temp addObject:number1];
        }
        
        for (int  i = 0; i < [array_temp count]-1; i++) {
            
            for (int j = i+1; j<[array_temp count]; j++) {
                
                if ([array_temp[i] longLongValue]<[array_temp[j] longLongValue]) {
                    
                    [array_temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }
            }
            
        }
        NSMutableArray *arr_result = [NSMutableArray array];
        for (NSNumber *number in array_temp) {
            for (NSString *str1 in array) {
                
                NSString *yearMonthDay1 = [str1 substringFromIndex:4];
                NSString *month1 = [yearMonthDay1 substringWithRange:NSMakeRange(0, 3)];
                NSString *yearDay1 = [str1 substringFromIndex:7];
                long mon1 = [StringManager getNumberMonth:month1];
                NSRange range1 = [yearDay1 rangeOfString:@","];
                NSString *day1 = [yearDay1 substringWithRange:NSMakeRange(0, range1.location)];
                day1 = [day1 stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *year1 = [yearDay1 substringWithRange:NSMakeRange(range1.location + 2, 4)];
                NSString *mydate1 = [NSString stringWithFormat:@"%@-%lu-%@",year1,mon1,day1];
                NSNumber *number1 = [StringManager stringDateTransferTimeStamp:mydate1];
                
                if ([number1 longLongValue] == [number longLongValue]) {
                    [arr_result addObject:str1];
                    break;
                }
            }
        }
        return arr_result;
    }
    return nil;
}

+ (NSMutableArray *) sortedShiftByDate:(NSMutableArray *)array
{
    NSMutableArray *arr_temp = [NSMutableArray arrayWithArray:array];
    if (arr_temp.count >= 2) {
        
        for (int i = 0; i < arr_temp.count-1; i++) {
            
            NSString *str1 = [arr_temp objectAtIndex:i];
            NSString *yearMonthDay1 = [str1 substringFromIndex:4];
            NSString *month1 = [yearMonthDay1 substringWithRange:NSMakeRange(0, 3)];
            NSString *yearDay1 = [str1 substringFromIndex:7];
            long mon1 = [StringManager getNumberMonth:month1];
            NSRange range1 = [yearDay1 rangeOfString:@","];
            NSString *day1 = [yearDay1 substringWithRange:NSMakeRange(0, range1.location)];
            day1 = [day1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *year1 = [yearDay1 substringWithRange:NSMakeRange(range1.location + 2, 4)];
            NSString *mydate1 = [NSString stringWithFormat:@"%@-%lu-%@",year1,mon1,day1];
            NSNumber *number1 = [StringManager stringDateTransferTimeStamp:mydate1];
            
            for (int j = i+1; j<arr_temp.count; j++) {
                
                NSString *str2 = [arr_temp objectAtIndex:j];
                NSString *yearMonthDay2 = [str2 substringFromIndex:4];
                NSString *month2 = [yearMonthDay2 substringWithRange:NSMakeRange(0, 3)];
                long mon2 = [StringManager getNumberMonth:month2];
                NSString *yearDay2 = [str1 substringFromIndex:7];
                NSRange range2 = [yearDay2 rangeOfString:@","];
                NSString *day2 = [yearDay2 substringWithRange:NSMakeRange(0, range2.location)];
                day2 = [day2 stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *year2 = [yearDay2 substringWithRange:NSMakeRange(range2.location + 2, 4)];
                NSString *mydate2 = [NSString stringWithFormat:@"%@-%lu-%@",year2,mon2,day2];
                NSNumber *number2 = [StringManager stringDateTransferTimeStamp:mydate2];
                
                if ([number1 longLongValue] > [number2 longLongValue]) {
                    [arr_temp exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
    }
    return arr_temp;
}


#pragma mark - drop
+ (Drop *) getDropByUuid:(NSString *)uuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@') AND (isDelete == 0)",uuid]];
    [request setPredicate:predicate];
    
    Drop *drop = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        drop = [array objectAtIndex:0];
    }
    return drop;
}
+ (Drop *) getPendingDropByShiftUuid:(NSString *) shiftuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(parentShiftUuid == '%@') AND (isDelete == 0) AND (state == 0) AND (isDrop == 0)",shiftuuid]];
    [request setPredicate:predicate];
    
    Drop *drop = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        drop = [array objectAtIndex:0];
    }
    return drop;
}

+ (Drop *) getPendingSwapByShiftUuid:(NSString *) shiftuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(parentShiftUuid == '%@') AND (isDelete == 0) AND (state == 0) AND (isDrop == 1)",shiftuuid]];
    [request setPredicate:predicate];
    
    Drop *swap = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        swap = [array objectAtIndex:0];
    }
    return swap;
}

+ (NSArray *) getEmployeeAllDropAndSwap:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (oriShiftEmployeeUuid == '%@')",employeeUuid]];
    [request setPredicate:predicate2];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}

+ (NSArray *) getDropAndSwapByShiftUuid:(NSString *) shiftuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (parentShiftUuid == '%@')",shiftuuid]];
    [request setPredicate:predicate2];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    return objects;
}


+ (Drop *) getSwapByUuid:(NSString *) uuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@') AND (isDelete == 0) AND (isDrop == 1)",uuid]];
    [request setPredicate:predicate];
    
    Drop *swap = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        swap = [array objectAtIndex:0];
    }
    return swap;
}

//只针对employee
+ (NSMutableDictionary *) employeeGetShiftsByDropAndSwap
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (state == 0)"]];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    
    NSMutableArray *arr_shifts = [NSMutableArray array];
    for (Drop *drop in array) {
        Shifts *shift = [DatabaseManager getShiftByUuid:drop.parentShiftUuid];
        if (shift != nil && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid]) {
            [arr_shifts addObject:shift];
        }
    }

    if (arr_shifts.count != 0) {
        
        NSMutableDictionary *dict_allShifts = [NSMutableDictionary dictionary];
        
        for (Shifts *shift in arr_shifts) {
            
            NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
            NSMutableArray *arr_temp = [dict_allShifts objectForKey:time];
            if (arr_temp.count == 0) {
                arr_temp = [NSMutableArray arrayWithObject:shift];
            }
            else
            {
                [arr_temp addObject:shift];
            }
            [dict_allShifts setObject:arr_temp forKey:time];
        }
        
        return dict_allShifts;
    }
    return nil;
}

+ (NSMutableDictionary *) getShiftsByPositionUuid:(NSString *)positionUuid andDayStamp:(NSNumber *) number
{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Shifts" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    
    NSPredicate *predicate = nil;
    NSArray *objects = nil;
    
    NSMutableArray *arr_position = [NSMutableArray array];
    
    if ([positionUuid isEqualToString:UnassignedPositionUuid]) {
        //指定positionUuid的shifts
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (locationUuid != nil)"]];
        [request setPredicate:predicate];
        objects = [context executeFetchRequest:request error:&errors];
        for (Shifts *shift in objects) {
            if (shift.positionUuid == nil) {
                [arr_position addObject:shift];
            }
        }
    }
    else
    {
        //指定positionUuid的shifts
        predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (positionUuid == '%@') AND (locationUuid != nil)",positionUuid]];
        [request setPredicate:predicate];
        objects = [context executeFetchRequest:request error:&errors];
        if (objects.count != 0) {
            arr_position = [NSMutableArray arrayWithArray:objects];
        }
    }
    
    NSMutableArray *arr_objects = [NSMutableArray array];
    
    for (Shifts *shift in arr_position) {
        if ([shift.startDate longLongValue] == [number longLongValue]) {
            [arr_objects addObject:shift];
        }
    }
    
    NSMutableDictionary *dict_allShifts = [NSMutableDictionary dictionary];
    
    for (Shifts *shift in arr_objects) {
        NSString *time = [NSString stringWithFormat:@"%@ %@ %@ , %@",shift.string_week,shift.string_month,shift.string_day,shift.string_year];
        NSMutableArray *arr_temp = [dict_allShifts objectForKey:time];
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:shift];
        }
        else
        {
            [arr_temp addObject:shift];
        }
        [dict_allShifts setObject:arr_temp forKey:time];
    }
    return dict_allShifts;
}

#pragma mark - available
+ (Availability *) getAvailabilitybyUuid:(NSString *)uuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Availability" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (uuid == '%@')",uuid]];
    [request setPredicate:predicate];
    
    Availability *avai = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        avai = [array objectAtIndex:0];
    }
    return avai;
}

+ (NSMutableArray *) getDayAvailabilityByEmployeeUuid:(NSDate *) date andEmployeeUuid:(NSString *) uuid
{
    NSArray *objects = [self getEmployeeAvailabilitiesByEmployeeUuid:uuid];
    
    if (objects.count == 0) {
        return nil;
    }
    
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components_week = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    long week = [components_week weekday];//2->Mon
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    NSNumber *currentDateStamp = [StringManager stringDateTransferTimeStamp:temp];
    
    NSMutableArray *arr_requrn = [NSMutableArray array];
    
    for (Availability *availability in objects) {
        
        NSDate *day1date = [StringManager stringTransferDate:availability.string_yearMonthDay1];
        NSDateComponents *components_week = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:day1date];
        long firstDayWeek = [components_week weekday];//6->Fri
        
        //找出第一个与shift所在week相同的date
        NSDate *nextFirstDate = nil;
        
        if (firstDayWeek - week < 0) {
            nextFirstDate = [day1date dateByAddingTimeInterval:(week-firstDayWeek)*24*60*60];
        }
        else if (firstDayWeek - week == 0)
        {
            nextFirstDate = day1date;
        }
        else
        {
            nextFirstDate = [day1date dateByAddingTimeInterval:(7-(firstDayWeek - week))*24*60*60];
        }
        
        //availability中，第一个与shift week相同的日期如果大于shift的开始日期，则该availability不符合要求
        //找出availability有效时间段内与shift相同日期，且满足rotation的yyyy-mm-dd
        BOOL isContinue = NO;
        NSNumber *nextNumber = [StringManager dateTransferTimeStamp:nextFirstDate];
        if ([nextNumber longLongValue] <= [currentDateStamp longLongValue]) {
            if ([nextNumber longLongValue] == [currentDateStamp longLongValue]) {
                if ([availability.string_yearMonthDay2 isEqualToString:@"0"]) {
                    isContinue = YES;
                }
                else
                {
                    NSDate *day2date = [StringManager stringTransferDate:availability.string_yearMonthDay2];
                    NSNumber *number = [StringManager dateTransferTimeStamp:day2date];
                    if ([number longLongValue] >= [nextNumber longLongValue]) {
                        isContinue = YES;
                    }
                }
            }
            else
            {
                for (int i = 0; i < 10; i++) {
                    if ([availability.rotation isEqualToString:@"0"]) {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:7*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"1"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:14*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"2"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:21*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"3"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:28*24*60*60];
                    }
                    NSNumber *number = [StringManager dateTransferTimeStamp:nextFirstDate];
                    if ([number longLongValue] == [currentDateStamp longLongValue]) {
                        if ([availability.string_yearMonthDay2 isEqualToString:@"0"]) {
                            isContinue = YES;
                            break;
                        }
                        else
                        {
                            NSDate *day2date = [StringManager stringTransferDate:availability.string_yearMonthDay2];
                            NSNumber *number = [StringManager dateTransferTimeStamp:day2date];
                            if ([number longLongValue] >= [nextNumber longLongValue]) {
                                isContinue = YES;
                                break;
                            }
                        }
                    }
                    else if ([number longLongValue] > [currentDateStamp longLongValue])
                    {
                        break;
                    }
                }
            }
        }
        if (isContinue == YES) {
            //找到满足rotation条件，且availability的yyyy-mm-dd与shift的yyyy-mm-dd相同的日期
            //获取该availability下的时间 5:00 a.m. - 6:00 a.m. unavailability
            NSArray *arr_jsonstring = [availability.subAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
            for (NSString *jsonstring in arr_jsonstring) {
                NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
                if ([[dict objectForKey:Availability_Week] intValue]+1 == week) {
                    [arr_requrn addObject:dict];
                }
            }
        }
    }
    NSMutableArray *arr_allday = [NSMutableArray array];
    NSMutableArray *arr_fromtimeString = [NSMutableArray array];
    for (NSDictionary *dict in arr_requrn) {
        NSString *fromtime = [dict objectForKey:Availability_FromTime];
        if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
            [arr_fromtimeString addObject:fromtime];
        }
        else
        {
            [arr_allday addObject:dict];
        }
    }
    NSMutableArray *arr_fromtimeNumber = [NSMutableArray array];
    for (NSString *fromtimestring in arr_fromtimeString) {
        NSString *yearstring = [NSString stringWithFormat:@"2017-10-10 %@",[StringManager timeRemoveAMPM:fromtimestring]];
        NSNumber *number = [StringManager stringDateTimeTransferTimeStamp:yearstring];
        [arr_fromtimeNumber addObject:number];
    }
    
    [arr_fromtimeNumber sortUsingComparator:^ NSComparisonResult(NSNumber *d1, NSNumber *d2) {
        return [d1 compare:d2];
    }];
    
    NSMutableArray *arr_sortstringtimeArray = [NSMutableArray array];
    
    for (NSNumber *number in arr_fromtimeNumber) {
        
        for (NSString *string in arr_fromtimeString) {
            NSString *yearstring = [NSString stringWithFormat:@"2017-10-10 %@",[StringManager timeRemoveAMPM:string]];
            NSNumber *number2 = [StringManager stringDateTimeTransferTimeStamp:yearstring];
            if ([number longValue] == [number2 longValue]) {
                [arr_sortstringtimeArray addObject:string];
                break;
            }
        }
    }
    
    NSMutableArray *arr_result = [NSMutableArray array];
    
    for (NSString *string in arr_sortstringtimeArray) {
        for (NSDictionary *dict in arr_requrn) {
            if ([[dict objectForKey:Availability_FromTime] isEqualToString:string] && [[dict objectForKey:Availability_IsAllDay] isEqualToString:@"0"]) {
                [arr_result addObject:dict];
                break;
            }
        }
    }
    for (NSDictionary *dict in arr_allday) {
        [arr_result addObject:dict];
    }
    
    return arr_result;
}

+ (NSDictionary *) getConilictAvailabilityByEmployeeUuid:(NSString *) shiftStartDateStamp andShiftStartTimeStamp:(NSString *) shiftStartTimeStamp andShiftEndTimeStamp:(NSString *) shiftEndTimeStamp andEmployeeUuid:(NSString *) uuid andAvailabilityState:(NSString *) state
{
    
    NSArray *objects = [self getEmployeeAvailabilitiesByEmployeeUuid:uuid];
    
    if (objects.count == 0) {
        return nil;
    }
    
    NSDate *date = [StringManager timeStampTransferDate:[NSNumber numberWithLong:(long)[shiftStartDateStamp longLongValue]]];
    
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components_week = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    long week = [components_week weekday];//2->Mon
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    NSNumber *currentDateStamp = [StringManager stringDateTransferTimeStamp:temp];
    
    NSDictionary *returnDict = [NSDictionary dictionary];
    
    for (Availability *availability in objects) {
        
        NSDate *day1date = [StringManager stringTransferDate:availability.string_yearMonthDay1];
        NSDateComponents *components_week = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:day1date];
        long firstDayWeek = [components_week weekday];//6->Fri
        
        //找出第一个与shift所在week相同的date
        NSDate *nextFirstDate = nil;
        
        if (firstDayWeek - week < 0) {
            nextFirstDate = [day1date dateByAddingTimeInterval:(week-firstDayWeek)*24*60*60];
        }
        else if (firstDayWeek - week == 0)
        {
            nextFirstDate = day1date;
        }
        else
        {
            nextFirstDate = [day1date dateByAddingTimeInterval:(7-(firstDayWeek - week))*24*60*60];
        }
        
        //availability中，第一个与shift week相同的日期如果大于shift的开始日期，则该availability不符合要求
        //找出availability有效时间段内与shift相同日期，且满足rotation的yyyy-mm-dd
        BOOL isContinue = NO;
        NSNumber *nextNumber = [StringManager dateTransferTimeStamp:nextFirstDate];
        if ([nextNumber longLongValue] <= [currentDateStamp longLongValue]) {
            if ([nextNumber longLongValue] == [currentDateStamp longLongValue]) {
                if ([availability.string_yearMonthDay2 isEqualToString:@"0"]) {
                    isContinue = YES;
                }
                else
                {
                    NSDate *day2date = [StringManager stringTransferDate:availability.string_yearMonthDay2];
                    NSNumber *number = [StringManager dateTransferTimeStamp:day2date];
                    if ([number longLongValue] >= [nextNumber longLongValue]) {
                        isContinue = YES;
                    }
                }
            }
            else
            {
                for (int i = 0; i < 10; i++) {
                    if ([availability.rotation isEqualToString:@"0"]) {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:7*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"1"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:14*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"2"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:21*24*60*60];
                    }
                    else if ([availability.rotation isEqualToString:@"3"])
                    {
                        nextFirstDate = [nextFirstDate dateByAddingTimeInterval:28*24*60*60];
                    }
                    NSNumber *number = [StringManager dateTransferTimeStamp:nextFirstDate];
                    if ([number longLongValue] == [currentDateStamp longLongValue]) {
                        if ([availability.string_yearMonthDay2 isEqualToString:@"0"]) {
                            isContinue = YES;
                            break;
                        }
                        else
                        {
                            NSDate *day2date = [StringManager stringTransferDate:availability.string_yearMonthDay2];
                            NSNumber *number = [StringManager dateTransferTimeStamp:day2date];
                            if ([number longLongValue] >= [nextNumber longLongValue]) {
                                isContinue = YES;
                                break;
                            }
                        }
                    }
                    else if ([number longLongValue] > [currentDateStamp longLongValue])
                    {
                        break;
                    }
                }
            }
        }
        if (isContinue == YES) {
            //找到满足rotation条件，且availability的yyyy-mm-dd与shift的yyyy-mm-dd相同的日期
            //获取该availability下的时间 5:00 a.m. - 6:00 a.m. unavailability
            NSArray *arr_jsonstring = [availability.subAvailabilities componentsSeparatedByString:Availability_JsonStringseparator];
            NSMutableArray *arr_dict = [NSMutableArray array];
            for (NSString *jsonstring in arr_jsonstring) {
                NSDictionary *dict = [StringManager getDictionaryByJsonString:jsonstring];
                if ([[dict objectForKey:Availability_State] isEqualToString:state] && [[dict objectForKey:Availability_Week] intValue]+1 == week) {
                    [arr_dict addObject:dict];
                }
            }
            if(arr_dict.count != 0)
            {
                for (NSDictionary *dict in arr_dict) {
                    if ([[dict objectForKey:Availability_IsAllDay] isEqualToString:@"1"]) {
                        returnDict = dict;
                        break;
                    }
                    else
                    {
                        NSString *yearMonthDay = [StringManager dateTransferString:nextFirstDate];
                        NSString *fromTime = [dict objectForKey:Availability_FromTime];
                        NSString *toTime = [dict objectForKey:Availability_ToTime];
                        if([fromTime containsString:@"p.m."] && ![fromTime containsString:@"12"])
                        {
                            NSRange range = [fromTime rangeOfString:@":"];
                            NSString *preTwo = [fromTime substringToIndex:range.location];
                            NSInteger re = [preTwo intValue];
                            if (![preTwo containsString:@"12"]) {
                                re = [preTwo intValue] + 12;
                            }
                            fromTime = [fromTime stringByReplacingOccurrencesOfString:preTwo withString:[NSString stringWithFormat:@"%lu",(long)re]];
                            fromTime = [fromTime stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
                            fromTime = [NSString stringWithFormat:@"%@ %@",yearMonthDay,fromTime];
                        }
                        else
                        {
                            if([fromTime containsString:@"p.m."])
                            {
                                fromTime = [fromTime stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
                            }
                            else if ([fromTime containsString:@"a.m."])
                            {
                                fromTime = [fromTime stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
                            }
                            fromTime = [NSString stringWithFormat:@"%@ %@",yearMonthDay,fromTime];
                        }
                        
                        if([toTime containsString:@"p.m."] && ![toTime containsString:@"12"])
                        {
                            NSRange range = [toTime rangeOfString:@":"];
                            NSString *preTwo = [toTime substringToIndex:range.location];
                            NSInteger re = [preTwo intValue];
                            if (![preTwo containsString:@"12"]) {
                                re = [preTwo intValue] + 12;
                            }
                            toTime = [toTime stringByReplacingOccurrencesOfString:preTwo withString:[NSString stringWithFormat:@"%lu",(long)re]];
                            toTime = [toTime stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
                            toTime = [NSString stringWithFormat:@"%@ %@",yearMonthDay,toTime];
                        }
                        else
                        {
                            if([toTime containsString:@"p.m."])
                            {
                                toTime = [toTime stringByReplacingOccurrencesOfString:@" p.m." withString:@""];
                            }
                            else if ([toTime containsString:@"a.m."])
                            {
                                toTime = [toTime stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
                            }
                            toTime = [NSString stringWithFormat:@"%@ %@",yearMonthDay,toTime];
                        }
                        //numner1和number2是avilability的开始结束值
                        NSNumber *number1 = [StringManager stringDateTimeTransferTimeStamp:fromTime];
                        NSNumber *number2 = [StringManager stringDateTimeTransferTimeStamp:toTime];
                        if (([shiftStartTimeStamp longLongValue] >= [number1 longLongValue] && [shiftStartTimeStamp longLongValue] < [number2 longLongValue]) || ([shiftEndTimeStamp longLongValue] > [number1 longLongValue] && [shiftEndTimeStamp longLongValue] <= [number2 longLongValue])) {
                            returnDict = dict;
                            break;
                        }
                    }
                }
            }
        }
    }
    
    return returnDict;
    
    //availability有效时间内的第一个与shift相关的week，并相继找出10个yyyy-mm-dd的日期（并且10个日期都在有效时间段内），与shift进行对比
    //availability的week减去shift的week，若为负数，则availability的第一天加上7天就是第一个shift所在的week，若是正书，差值＊24*60*60
    //计算availability的开始日期算出是周几
}


+ (NSArray *) getEmployeeAvailabilitiesByEmployeeUuid:(NSString *)employeeUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Availability" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (parentUuid == '%@')",employeeUuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];

    return objects;
}

+ (NSMutableString *) getConflictAvailabilityInDay:(NSMutableArray *) arr_weeks
{
    NSMutableString *string = nil;
    for (NSArray *arr_week in arr_weeks) {
        for (int i = 0; i < arr_week.count-1; i++) {
            
            NSDictionary *dict1 = [arr_week objectAtIndex:i];
            NSString *time1 = [dict1 objectForKey:Availability_FromTime];
            NSString *time2 = [dict1 objectForKey:Availability_ToTime];
            
            for (int j = i+1; j<arr_week.count; j++) {
                
                NSDictionary *dict2 = [arr_week objectAtIndex:j];
                NSString *time3 = [dict2 objectForKey:Availability_FromTime];
                NSString *time4 = [dict2 objectForKey:Availability_ToTime];
                
                BOOL isconflict = [StringManager towTimeIsConfilict:time1 andTime2:time2 andTime3:time3 andTime4:time4];
                if (isconflict == YES) {
                    NSString *week = @"";
                    if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"0"]) {
                        week = @"Sunday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"1"]) {
                        week = @"Monday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"2"]) {
                        week = @"Tuesday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"3"]) {
                        week = @"Wednesday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"4"]) {
                        week = @"Thursday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"5"]) {
                        week = @"Friday";
                    }
                    else if ([[dict1 objectForKey:Availability_Week]  isEqualToString:@"6"]) {
                        week = @"Saturday";
                    }
                    if (string == nil) {
                        string = [NSMutableString stringWithFormat:@"%@",week];
                    }
                    else
                    {
                        if (![string containsString:week]) {
                            string = [NSMutableString stringWithFormat:@"%@, %@",string,week];
                        }
                    }
                    break;
                }
            }
        }
    }
    return string;
}


#pragma mark - request

+ (NSMutableDictionary *) getAllRequests
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (parentUuid == '%@')",appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allRequestsCate = [NSMutableDictionary dictionary];
    
    //0-need your 2-other request
    for (int i = 0; i < objects.count; i++) {
        Requests *request = [objects objectAtIndex:i];
        NSMutableArray *arr_temp;
        if ([request.waitType isEqualToString:@"0"]) {
           arr_temp  = [dict_allRequestsCate objectForKey:@"0"];
        }
        else
        {
            arr_temp  = [dict_allRequestsCate objectForKey:@"2"];
        }
        
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:request];
        }
        else
        {
            [arr_temp addObject:request];
        }
        if ([request.waitType isEqualToString:@"0"]) {
            if (arr_temp.count != 0) {
                [dict_allRequestsCate setObject:arr_temp forKey:request.waitType];
            }
        }
        else
        {
            if (arr_temp.count != 0) {
                [dict_allRequestsCate setObject:arr_temp forKey:@"2"];
            }
        }
    }

    NSEntityDescription *entity_drop = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity_drop];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
    [request setPredicate:predicate2];
    
    NSArray *array_drop = [context executeFetchRequest:request error:&errors];
    NSMutableArray *arr_total1 = [dict_allRequestsCate objectForKey:@"0"];
    NSMutableArray *arr_total2 = [dict_allRequestsCate objectForKey:@"1"];
    NSMutableArray *arr_total3 = [dict_allRequestsCate objectForKey:@"2"];
    if (arr_total1.count == 0) {
        arr_total1 = [NSMutableArray array];
    }
    if (arr_total2.count == 0) {
        arr_total2 = [NSMutableArray array];
    }
    if (arr_total3.count == 0) {
        arr_total3 = [NSMutableArray array];
    }
    
    //0:(1)employee发起的drop/swap还未被manager同意 (2)employee发起的drop/swap包涵manager，被manager同意后，manager还未同意或者拒绝drop，swap
    //1:(1)  (2)
    
    
    for (Drop *drop in array_drop) {
        
        Shifts *orishift = [DatabaseManager getShiftByUuid:drop.parentShiftUuid];
        Employees *oriemployee = [DatabaseManager getEmployeeByUuid:orishift.employeeUuid];
        
        if (oriemployee != nil && orishift != nil) {
            
            //0-drop/swap(employee发起的drop，manager还没处理)
            if (drop.isManagerAccepted == 0 && [drop.state isEqualToString:@"0"]) {

                if (![arr_total1 containsObject:drop]) {
                    [arr_total1 addObject:drop];
                }
            }
            //0-drop(employee发起的drop包涵manager)
            else if (drop.isManagerAccepted == 1 && drop.isDrop == 0 && [drop.state isEqualToString:@"0"] && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && ![drop.declineDropUuids containsString:appdelegate.currentEmployee.uuid])
            {
                if (![arr_total1 containsObject:drop]) {
                    [arr_total1 addObject:drop];
                }
            }
            else if ([drop.oriShiftEmployeeUuid isEqualToString:appdelegate.currentEmployee.uuid])
            {
                if ([drop.state isEqualToString:@"0"]) {
                    if (![arr_total2 containsObject:drop]) {
                        [arr_total2 addObject:drop];
                    }
                }
                else
                {
                    if (![arr_total3 containsObject:drop]) {
                        [arr_total3 addObject:drop];
                    }
                }
            }
            //1-drop
            else if (drop.isManagerAccepted == 1 && [drop.state isEqualToString:@"0"] && drop.isDrop == 0)
            {
                if (![arr_total2 containsObject:drop]) {
                    [arr_total2 addObject:drop];
                }
            }
            //0/1-swap
            else if (drop.isManagerAccepted == 1 && drop.isDrop == 1 && [drop.state isEqualToString:@"0"])
            {
                NSArray *arr_shiftuuid = [drop.dropUuids componentsSeparatedByString:@","];
                NSArray *arr_declineShiftuuid = [drop.declineDropUuids componentsSeparatedByString:@","];

                for (NSString *shiftuuid in arr_shiftuuid) {
                    
                    Shifts *s = [DatabaseManager getShiftByUuid:shiftuuid];
                    
                    BOOL isDecline = NO;
                    
                    if ([s.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        
                        //是否我已经拒绝过
                        for (NSString *declineShiftuuid in arr_declineShiftuuid) {
                            
                            Shifts *s2 = [DatabaseManager getShiftByUuid:declineShiftuuid];
                            
                            if ([s2.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                                
                                isDecline = YES;
                                break;
                            }
                        }
                        if (isDecline == YES) {
                            if (![arr_total2 containsObject:drop]) {
                                [arr_total2 addObject:drop];
                            }
                        }
                        else
                        {
                            if (![arr_total1 containsObject:drop]) {
                                [arr_total1 addObject:drop];
                            }
                        }
                        break;
                    }
                }
                BOOL isDecline2 = NO;
                for (NSString *shiftuuid in arr_shiftuuid) {
                    
                    Shifts *s = [DatabaseManager getShiftByUuid:shiftuuid];
                    
                    if ([s.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        
                        isDecline2 = YES;
                        break;
                    }
                }
                if (isDecline2 == NO) {
                    if (![arr_total2 containsObject:drop]) {
                        [arr_total2 addObject:drop];
                    }
                }
            }
            //1-swap
            else if (drop.isManagerAccepted == 1 && [drop.state isEqualToString:@"0"] && drop.isDrop == 1)
            {
                if (![arr_total2 containsObject:drop]) {
                    [arr_total2 addObject:drop];
                }
            }
            else if (![drop.state isEqualToString:@"0"])
            {
                if (![arr_total3 containsObject:drop]) {
                    [arr_total3 addObject:drop];
                }
            }
        }
    }
    if (arr_total1.count != 0) {
        [dict_allRequestsCate setObject:arr_total1 forKey:@"0"];
    }
    if (arr_total2.count != 0) {
        [dict_allRequestsCate setObject:arr_total2 forKey:@"1"];
    }
    if (arr_total3.count != 0) {
        [dict_allRequestsCate setObject:arr_total3 forKey:@"2"];
    }
    
    return dict_allRequestsCate;
}

+ (Requests *) getRequestByUuid:(NSString *)uuid
{
    if (uuid == nil || [uuid isEqualToString:@""])
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(uuid == '%@') AND (isDelete == 0) AND (parentUuid == '%@')",uuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    Requests *myrequest = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        myrequest = [array objectAtIndex:0];
    }
    return myrequest;
}

+ (NSMutableDictionary *) getAllMyRequests
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (parentUuid == '%@')",appdelegate.currentEmployee.uuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    NSMutableDictionary *dict_allRequestsCate = [NSMutableDictionary dictionary];
    
    //0 1 2
    for (int i = 0; i < objects.count; i++) {
        Requests *request = [objects objectAtIndex:i];
        NSMutableArray *arr_temp;
        if ([request.waitType isEqualToString:@"0"]) {
            arr_temp = [dict_allRequestsCate objectForKey:@"1"];
        }
        else
        {
            arr_temp = [dict_allRequestsCate objectForKey:@"2"];
        }
        if (arr_temp.count == 0) {
            arr_temp = [NSMutableArray arrayWithObject:request];
        }
        else
        {
            [arr_temp addObject:request];
        }
        if ([request.waitType isEqualToString:@"0"]) {
            if (arr_temp.count != 0) {
                [dict_allRequestsCate setObject:arr_temp forKey:@"1"];
            }
        }
        else
        {
            if (arr_temp.count != 0) {
                [dict_allRequestsCate setObject:arr_temp forKey:@"2"];
            }
        }
    }
    
    NSEntityDescription *entity_drop = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
    [request setEntity:entity_drop];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0)"]];
    [request setPredicate:predicate2];
    
    NSArray *array_drop = [context executeFetchRequest:request error:&errors];
    NSMutableArray *arr_total1 = [dict_allRequestsCate objectForKey:@"0"];
    NSMutableArray *arr_total2 = [dict_allRequestsCate objectForKey:@"1"];
    NSMutableArray *arr_total3 = [dict_allRequestsCate objectForKey:@"2"];
    if (arr_total1.count == 0) {
        arr_total1 = [NSMutableArray array];
    }
    if (arr_total2.count == 0) {
        arr_total2 = [NSMutableArray array];
    }
    if (arr_total3.count == 0) {
        arr_total3 = [NSMutableArray array];
    }
    
    
    for (Drop *drop in array_drop) {

        Shifts *orishift = [DatabaseManager getShiftByUuid:drop.parentShiftUuid];
        Employees *oriemployee = [DatabaseManager getEmployeeByUuid:orishift.employeeUuid];
        
        if (oriemployee != nil && orishift != nil) {
            
            //0
            if (drop.isManagerAccepted == 1 && drop.isDrop == 0 && [drop.state isEqualToString:@"0"] && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && ![drop.declineDropUuids containsString:appdelegate.currentEmployee.uuid])
            {
                if (![arr_total1 containsObject:drop]) {
                    [arr_total1 addObject:drop];
                }
            }
            //1
            else if ((drop.isManagerAccepted == 1 && drop.isDrop == 0 && [drop.state isEqualToString:@"0"] && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && [drop.declineDropUuids containsString:appdelegate.currentEmployee.uuid]) || ([drop.oriShiftEmployeeUuid isEqualToString:appdelegate.currentEmployee.uuid] && [drop.state isEqualToString:@"0"]))
            {
                if (![arr_total2 containsObject:drop]) {
                    [arr_total2 addObject:drop];
                }
            }
            
            else if (drop.isManagerAccepted == 1 && drop.isDrop == 1 && [drop.state isEqualToString:@"0"])
            {
                NSArray *arr_shiftuuid = [drop.dropUuids componentsSeparatedByString:@","];
                NSArray *arr_declineShiftuuid = [drop.declineDropUuids componentsSeparatedByString:@","];
                
                for (NSString *shiftuuid in arr_shiftuuid) {
                    
                    Shifts *s = [DatabaseManager getShiftByUuid:shiftuuid];
                    
                    BOOL isDecline = NO;
                    
                    if ([s.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        
                        //是否我已经拒绝过
                        for (NSString *declineShiftuuid in arr_declineShiftuuid) {
                            
                            Shifts *s2 = [DatabaseManager getShiftByUuid:declineShiftuuid];

                            if ([s2.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
 
                                isDecline = YES;
                                break;
                            }
                        }
                        if (isDecline == YES) {
                            if (![arr_total2 containsObject:drop]) {
                                [arr_total2 addObject:drop];
                            }
                        }
                        else
                        {
                            if (![arr_total1 containsObject:drop]) {
                                [arr_total1 addObject:drop];
                            }
                        }
                        break;
                    }
                }
            }
            else if (((![drop.state isEqualToString:@"0"]) && drop.isDrop == 0 && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && [drop.declineDropUuids containsString:appdelegate.currentEmployee.uuid]) || ((![drop.state isEqualToString:@"0"]) && [drop.oriShiftEmployeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) || (![drop.state isEqualToString:@"0"] && drop.isDrop == 0 && [drop.drop_accepteEmployeeUuid isEqualToString:appdelegate.currentEmployee.uuid]))
            {
                if (![arr_total3 containsObject:drop]) {
                    [arr_total3 addObject:drop];
                }
            }
            else if ([drop.drop_accepteEmployeeUuid isEqualToString:appdelegate.currentEmployee.uuid] && ![arr_total3 containsObject:drop])
            {
                [arr_total3 addObject:drop];
            }
            else if (![drop.state isEqualToString:@"0"] && [drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && ![arr_total3 containsObject:drop])
            {
                [arr_total3 addObject:drop];
            }
            else if (![drop.state isEqualToString:@"0"] && drop.isDrop == 1)
            {
                Shifts *shift = [DatabaseManager getShiftByUuid:drop.swap_acceptShiftUuid];
                if (shift != nil) {
                    if ([shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid] && ![arr_total3 containsObject:drop]) {
                        [arr_total3 addObject:drop];
                    }
                }
                else
                {
                    NSArray *arr_shiftuuid = [drop.dropUuids componentsSeparatedByString:@","];
                    NSArray *arr_declineShiftuuid = [drop.declineDropUuids componentsSeparatedByString:@","];
                    for (NSString *uuid in arr_shiftuuid) {
                        
                        Shifts *s = [DatabaseManager getShiftByUuid:uuid];
                        
                        if ([s.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                            
                            //是否我已经拒绝过
                            for (NSString *declineShiftuuid in arr_declineShiftuuid) {
                                
                                Shifts *s2 = [DatabaseManager getShiftByUuid:declineShiftuuid];
                                
                                if ([s2.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                                    
                                    if (![arr_total3 containsObject:drop]) {
                                        [arr_total3 addObject:drop];
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                NSArray *arr_shiftuuid = [drop.dropUuids componentsSeparatedByString:@","];
                BOOL isContainMe = NO;
                for (NSString *shiftuuid in arr_shiftuuid) {
                    Shifts *s = [DatabaseManager getShiftByUuid:shiftuuid];
                    if ([s.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        isContainMe = YES;
                        break;
                    }
                }
                if (isContainMe == YES && ![arr_total3 containsObject:drop]) {
                    [arr_total3 addObject:drop];
                }
            }
        }
    }
    if (arr_total1.count != 0) {
        [dict_allRequestsCate setObject:arr_total1 forKey:@"0"];
    }
    if (arr_total2.count != 0) {
        [dict_allRequestsCate setObject:arr_total2 forKey:@"1"];
    }
    if (arr_total3.count != 0) {
        [dict_allRequestsCate setObject:arr_total3 forKey:@"2"];
    }
    
    return dict_allRequestsCate;
}

+ (NSArray *) getEmployeeAllRequestToDelete:(NSString *) employeeuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError* errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entityDesc1];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (employeeUuid == '%@') AND (parentUuid == '%@')",employeeuuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    
    return objects;
}

+ (NSArray *) getAllNeedActionRequests
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *arr_needAction = nil;
    
    if (appdelegate.currentEmployee.isManager == 1) {
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        NSError* errors = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDesc1 = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
        [request setEntity:entityDesc1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (parentUuid == '%@') AND waitType == '0'",appdelegate.currentWorkplace.uuid]];
        [request setPredicate:predicate];
        
        NSArray *objects = [context executeFetchRequest:request error:&errors];
        if (objects.count != 0) {
            arr_needAction = [NSMutableArray arrayWithArray:objects];
        }
        
        NSEntityDescription *entity_drop = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
        [request setEntity:entity_drop];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (state == '0') AND (isManagerAccepted == 0)"]];
        [request setPredicate:predicate2];
        
        NSArray *array_drop = [context executeFetchRequest:request error:&errors];
        if (array_drop.count != 0) {
            
            if (arr_needAction.count == 0) {
                
                arr_needAction = [NSMutableArray arrayWithArray:array_drop];
            }
            else
            {
                for (Drop *drop in array_drop) {
                    [arr_needAction addObject:drop];
                }
            }
        }
        return arr_needAction;
    }
    else
    {
        NSManagedObjectContext *context = [appdelegate managedObjectContext];
        NSError* errors = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity_drop = [NSEntityDescription entityForName:@"Drop" inManagedObjectContext:context];
        [request setEntity:entity_drop];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (state == '0') AND (isManagerAccepted == 1) AND (oriShiftEmployeeUuid != '%@')",appdelegate.currentEmployee.uuid]];
        [request setPredicate:predicate2];
        
        NSArray *array_drop = [context executeFetchRequest:request error:&errors];
        
        NSMutableArray *arr_needAction = [NSMutableArray array];
        for (Drop *drop in array_drop) {
            if (drop.isDrop == 0) {
                if ([drop.dropUuids containsString:appdelegate.currentEmployee.uuid] && ![drop.declineDropUuids containsString:appdelegate.currentEmployee.uuid]) {
                    [arr_needAction addObject:drop];
                }
            }
            else if (drop.isDrop == 1)
            {
                NSArray *arr_shiftuuid = [drop.dropUuids componentsSeparatedByString:@","];
                for (NSString *shiftuuid in arr_shiftuuid) {
                    Shifts *shift = [DatabaseManager getShiftByUuid:shiftuuid];
                    if ([shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
                        [arr_needAction addObject:drop];
                        break;
                    }
                }
            }
        }
        return arr_needAction;
    }
}

+ (Requests *) getConfilictRequestByEmployeeUuid:(NSString *) emplloyeeuuid andShifStartTimeStamp:(NSString *) stamp1 andShifEndTimeStamp:(NSString *) stamp2
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (parentUuid == '%@') AND (employeeUuid == '%@')",appdelegate.currentWorkplace.uuid,emplloyeeuuid]];
    [request setPredicate:predicate];
    
    Requests *myrequest = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        for (Requests *request in array) {
            if (([request.stamp_startDate longLongValue] >= [stamp1 longLongValue] && [request.stamp_endDate longLongValue] <= [stamp2 longLongValue]) || ([stamp1 longLongValue] >= [request.stamp_startDate longLongValue] && [stamp2 longLongValue] <= [request.stamp_endDate longLongValue]) || ([request.stamp_startDate longLongValue] >= [stamp1 longLongValue] && [request.stamp_startDate longLongValue] < [stamp2 longLongValue]) || ([request.stamp_endDate longLongValue] > [stamp1 longLongValue] && [request.stamp_endDate longLongValue] <= [stamp2 longLongValue])) {
                myrequest = request;
                break;
            }
        }
    }
    return myrequest;
}

+ (Requests *) getSelfConfilictRequest:(NSNumber *) stampstartDate andRequestEndTimeStamp:(NSNumber *) stampEndDate andTime1:(NSString *) time1 andTime2:(NSString *) time2
{
    //time1 == nil,stampstartDate->2017-2-23的stamp
    //time2 != nil,stampstartDate->2017-2-23 3:00 p.m.的stamp
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Requests" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(isDelete == 0) AND (parentUuid == '%@') AND (employeeUuid == '%@') AND (waitType != '2')",appdelegate.currentWorkplace.uuid,appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    
    Requests *myrequest = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        for (Requests *request in array) {
            if (request.string_startTime != nil && request.string_endTime != nil) {
                
                NSNumber *oriNumner1 = nil;
                NSNumber *oriNumner2 = nil;
                
                if (time1 != nil && time2 != nil) {
                    oriNumner1 = [StringManager stringTimeTransferTimeStamp:request.stamp_startDate andTime:request.string_startTime];
                    oriNumner2 = [StringManager stringTimeTransferTimeStamp:request.stamp_startDate andTime:request.string_endTime];
                    
                }
                else
                {
                    NSDictionary *dict1 = [StringManager getYearMonthDay:request.stamp_startDate];
                    NSDictionary *dict2 = [StringManager getYearMonthDay:request.stamp_endDate];
                    NSString *oriyearMonthDay1 = [NSString stringWithFormat:@"%@-%@-%@",[dict1 objectForKey:@"year"],[dict1 objectForKey:@"month"],[dict1 objectForKey:@"day"]];
                    NSString *oriyearMonthDay2 = [NSString stringWithFormat:@"%@-%@-%@",[dict2 objectForKey:@"year"],[dict2 objectForKey:@"month"],[dict2 objectForKey:@"day"]];
                    oriNumner1 = [StringManager stringDateTransferTimeStamp:oriyearMonthDay1];
                    oriNumner2 = [StringManager stringDateTransferTimeStamp:oriyearMonthDay2];
                }
                if (!([stampstartDate longLongValue] > [oriNumner2 longLongValue] || [stampEndDate longLongValue] < [oriNumner1 longLongValue])) {
                    myrequest = request;
                    break;
                }
            }
            else
            {
                if (time1 != nil && time2 != nil)
                {
                    NSDictionary *dict1 = [StringManager getYearMonthDay:[NSString stringWithFormat:@"%@",stampstartDate]];
                    NSDictionary *dict2 = [StringManager getYearMonthDay:[NSString stringWithFormat:@"%@",stampEndDate]];
                    NSString *yearMonthDay1 = [NSString stringWithFormat:@"%@-%@-%@",[dict1 objectForKey:@"year"],[dict1 objectForKey:@"month"],[dict1 objectForKey:@"day"]];
                    NSString *yearMonthDay2 = [NSString stringWithFormat:@"%@-%@-%@",[dict2 objectForKey:@"year"],[dict2 objectForKey:@"month"],[dict2 objectForKey:@"day"]];
                    NSNumber *createNumber1 = [StringManager stringDateTransferTimeStamp:yearMonthDay1];
                    NSNumber *createNumber2 = [StringManager stringDateTransferTimeStamp:yearMonthDay2];
                    if (!([createNumber1 longLongValue] > [request.stamp_endDate longLongValue] || [createNumber2 longLongValue] < [request.stamp_startDate longLongValue])) {
                        myrequest = request;
                        break;
                    }
                }
                else
                {
                    if (!([stampstartDate longLongValue] > [request.stamp_endDate longLongValue] || [stampEndDate longLongValue] < [request.stamp_startDate longLongValue])) {
                        myrequest = request;
                        break;
                    }
                }
            }
        }
    }
    return myrequest;
}


+ (NSArray *) getRequestAllDisposeState:(NSString *)requestUuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(parentRequestUuid == '%@')",requestUuid]];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    return array;
}

+ (void) saveRequestDisposeTable:(NSString *)modelRequestDisposeString
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSArray *arr = [modelRequestDisposeString componentsSeparatedByString:RequestDisposeState_JsonStringseparator];
    for (NSString *json in arr) {
        NSDictionary *dict = [StringManager getDictionaryByJsonString:json];
        
        RequestAllDisposeState *dispose = [self getRequestDispose:[dict objectForKey:RequestDisposeState_ParentUuid] andParentRequestUuid:[dict objectForKey:RequestDisposeState_ParentRequestUuid] andSendEmployeeUuid:[dict objectForKey:RequestDisposeState_SendRequestEmployeeUuid] andDisposeState:[dict objectForKey:RequestDisposeState_State] andDisposeTime:[dict objectForKey:RequestDisposeState_DisposeTime]];
        if (dispose == nil) {
            dispose = [NSEntityDescription insertNewObjectForEntityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
        }
        dispose.parentUuid = [dict objectForKey:RequestDisposeState_ParentUuid];
        dispose.parentRequestUuid = [dict objectForKey:RequestDisposeState_ParentRequestUuid];
        dispose.sendRequestEmployeeUuid = [dict objectForKey:RequestDisposeState_SendRequestEmployeeUuid];
        dispose.disposeTime = [dict objectForKey:RequestDisposeState_DisposeTime];
        dispose.disposeState = [dict objectForKey:RequestDisposeState_State];
        
        [context save:nil];
    }
}

+ (RequestAllDisposeState *) getRequestDispose:(NSString *) parentUuid andParentRequestUuid:(NSString *)parentRequestUuid andSendEmployeeUuid:(NSString *) employeuuid andDisposeState:(NSString *) disposeState andDisposeTime:(NSString *)disposeTime
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RequestAllDisposeState" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(parentUuid == '%@') AND (parentRequestUuid == '%@') AND (sendRequestEmployeeUuid == '%@') AND (disposeTime == '%@') AND (disposeState == '%@')",parentUuid,parentRequestUuid,employeuuid,disposeTime,disposeState]];
    [request setPredicate:predicate];
    
    RequestAllDisposeState *dispose = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        dispose = [array objectAtIndex:0];
    }
    return dispose;
}

#pragma mark - historyShiftTime

+ (NSArray *) getHistoryShiftTime
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HistoryShiftTime" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    return array;
}

+(HistoryShiftTime *) getExistShiftTime:(Shifts *)shift
{
    if (shift == nil)
    {
        return nil;
    }
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"HistoryShiftTime" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSDictionary *dict = [StringManager interceptionTime:shift.string_time];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(string_startTime == '%@') AND (string_endTime == '%@') AND (string_break == '%@')",[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str1"],[dict objectForKey:@"str2"]],[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"str3"],[dict objectForKey:@"str4"]],shift.unpaidBreak]];
    [request setPredicate:predicate];
    
    HistoryShiftTime *history = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        history = [array objectAtIndex:0];
    }
    return history;
}

+ (NSMutableArray *) sortedRequestByDisposeDate:(NSArray *) array
{
    NSMutableArray *array_temp = [NSMutableArray array];
    for (id obj in array) {
        
        if ([obj isKindOfClass:[Requests class]]) {
            
            Requests *request = obj;
            [array_temp addObject:request.disposeDate];
        }
        else
        {
            Drop *drop = obj;
            [array_temp addObject:drop.modifyDate];
        }
    }
    
    NSMutableArray *arr_result = [NSMutableArray array];
    
    if (array_temp.count != 0) {
        NSArray *array2 = [array_temp sortedArrayUsingComparator:
                           ^NSComparisonResult(NSString *obj1, NSString *obj2) {
                               
            return [obj2 compare:obj1];
        }];
        
        for (NSString *string in array2) {
            for (id obj in array) {
                
                if ([obj isKindOfClass:[Requests class]]) {
                    
                    Requests *request = obj;
                    if ([request.disposeDate isEqualToString:string]) {
                        [arr_result addObject:request];
                        break;
                    }
                }
                else
                {
                    Drop *drop = obj;
                    if ([drop.modifyDate isEqualToString:string]) {
                        [arr_result addObject:drop];
                        break;
                    }
                }
            }
        }
    }
    return arr_result;
}


#pragma mark - setting
+ (Setting *) getEmployeeSetting:(NSString *) employeeuuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    [request setEntity:entity];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(employeeUuid == '%@')",employeeuuid]];
//    [request setPredicate:predicate];
    
    
    
    Setting *setting = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        setting = [array objectAtIndex:0];
    }

    return setting;
}

#pragma mark - devicetoken
+ (DeviceToken *) getDeviceTokenByDeviceID:(NSString *) uuid;
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceToken" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(deviceToken == '%@') AND (parentUuid == '%@')",uuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    DeviceToken *device = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        device = [array objectAtIndex:0];
    }
    return device;
}

+ (DeviceToken *) getDeviceTokenByDeviceModel:(DDBDeviceTokenModel *) model
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceToken" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(deviceToken == '%@') AND (parentUuid == '%@') AND (employeeUuid == '%@') AND (endPointArn == '%@')",model.deviceToken,model.parentUuid,model.employeeUuid,model.endPointArn]];
    [request setPredicate:predicate];
    
    DeviceToken *device = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        device = [array objectAtIndex:0];
    }
    return device;
}

+ (DeviceToken *) getDeviceTokenByDeviceModel2:(DDBDeviceTokenModel *) model
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceToken" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(deviceToken == '%@') AND (parentUuid == '%@') AND (employeeUuid == '%@')",model.deviceToken,model.parentUuid,model.employeeUuid]];
    [request setPredicate:predicate];
    
    DeviceToken *device = nil;
    NSArray *array = [context executeFetchRequest:request error:&errors];
    if ([array count] > 0)
    {
        device = [array objectAtIndex:0];
    }
    return device;
}

+ (NSArray *) getDeviceTokenByEmployeeUuid:(NSString *) uuid
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceToken" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(employeeUuid == '%@') AND (parentUuid == '%@')",uuid,appdelegate.currentWorkplace.uuid]];
    [request setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:request error:&errors];
    return array;
}

#pragma mark - calendarevent

+ (CalendarEvents *) getMyCalendarEventsInCurrentWorkplace;
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSError *errors = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CalendarEvents" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(parentUuid == '%@') AND (employeeuUuid == '%@')",appdelegate.currentWorkplace.uuid,appdelegate.currentEmployee.uuid]];
    [request setPredicate:predicate];
    
    CalendarEvents *event = nil;
    NSArray *objects = [context executeFetchRequest:request error:&errors];
    if ([objects count] > 0)
    {
        event = [objects objectAtIndex:0];
    }
    return event;
}

+ (void) syncShiftToCalendar:(NSString *) shiftuuid andIsDelete:(int) isdelete
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Shifts *shift = [self getShiftByUuid:shiftuuid];
    CalendarEvents *event = [self getMyCalendarEventsInCurrentWorkplace];
    if ([event.subscribeUuid containsString:shift.locationUuid]) {
        [SyncNewCalendar removeEvent:shift.locationUuid andData:shift andIsDelete:isdelete];
    }
    
    else
    {
        NSArray *arr = [event.subscribeUuid componentsSeparatedByString:@","];
        if ([arr containsObject:@"2"])
        {
            [SyncNewCalendar removeEvent:@"2" andData:shift andIsDelete:isdelete];
        }
        else if ([arr containsObject:@"0"] && [shift.employeeUuid isEqualToString:appdelegate.currentEmployee.uuid]) {
            [SyncNewCalendar removeEvent:@"0" andData:shift andIsDelete:isdelete];
        }
        else if ([arr containsObject:@"1"] && [shift.employeeUuid isEqualToString:OpenShiftEmployeeUuid])
        {
            [SyncNewCalendar removeEvent:@"1" andData:shift andIsDelete:isdelete];
        }
    }
}

#pragma mark - notitification
+ (NSString *) getNotificationOfRequest:(Requests *) request
{
    NSString *timestring = @"";
    NSDictionary *dict = [StringManager getYearMonthDay:request.stamp_startDate];
    NSDictionary *dict2 = [StringManager getYearMonthDay:request.stamp_endDate];
    if (request.string_startTime == nil) {
        timestring = [NSString stringWithFormat:@"%@, %@ %@ - %@, %@ %@",[dict objectForKey:@"week"],[StringManager getEntireEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"],[dict2 objectForKey:@"week"],[StringManager getEntireEnglishMonth:[[dict2 objectForKey:@"month"] longValue]],[dict2 objectForKey:@"day"]];
    }
    else
    {
        NSString *str1 = request.string_startTime;
        if ([str1 containsString:@"a.m."]) {
            str1 = [str1 stringByReplacingOccurrencesOfString:@"a.m." withString:@"AM"];
        }
        else if([str1 containsString:@"p.m."])
        {
            str1 = [str1 stringByReplacingOccurrencesOfString:@"p.m." withString:@"PM"];
        }
        NSString *str2 = request.string_endTime;
        if ([str2 containsString:@"a.m."]) {
            str2 = [str2 stringByReplacingOccurrencesOfString:@"a.m." withString:@"AM"];
        }
        else if([str2 containsString:@"p.m."])
        {
            str2 = [str2 stringByReplacingOccurrencesOfString:@"p.m." withString:@"PM"];
        }
        timestring = [NSString stringWithFormat:@"%@ - %@, %@, %@ %@",str1,str2,[dict objectForKey:@"week"],[StringManager getEntireEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"]];
    }
    return timestring;
}

+ (NSString *) getNotificationOfShift:(Shifts *)shift
{
    NSString *timestring = @"";
    NSDictionary *dict = [StringManager getYearMonthDay:shift.startDate];
    Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
    Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
    NSString *str = shift.string_time;
    str = [str stringByReplacingOccurrencesOfString:@"a.m." withString:@"AM"];
    str = [str stringByReplacingOccurrencesOfString:@"p.m." withString:@"PM"];
    timestring = [NSString stringWithFormat:@"%@ | %@, %@, %@ %@ | at %@",shift.employeeName,str,[dict objectForKey:@"week"],[StringManager getEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"],location.name];
    if (position != nil) {
        timestring = [NSString stringWithFormat:@"%@ | as %@",timestring,position.name];
    }
    return timestring;
}

+ (NSString *) getMyselfNotificationOfShift:(Shifts *)shift
{
    NSString *timestring = @"";
    NSDictionary *dict = [StringManager getYearMonthDay:shift.startDate];
    Locations *location = [DatabaseManager getLocationByUuid:shift.locationUuid];
    Positions *position = [DatabaseManager getPositionByUuid:shift.positionUuid];
    NSString *str = shift.string_time;
    str = [str stringByReplacingOccurrencesOfString:@"a.m." withString:@"AM"];
    str = [str stringByReplacingOccurrencesOfString:@"p.m." withString:@"PM"];
    timestring = [NSString stringWithFormat:@"%@, %@, %@ %@ | at %@",str,[dict objectForKey:@"week"],[StringManager getEnglishMonth:[[dict objectForKey:@"month"] longValue]],[dict objectForKey:@"day"],location.name];
    if (position != nil) {
        timestring = [NSString stringWithFormat:@"%@ | as %@",timestring,position.name];
    }
    return timestring;
}


#pragma mark - public method
+ (void) deleteItem:(id)object
{
    if (object == nil)
    {
        return;
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    [context deleteObject:object];
    [context save:nil];
}

+ (void) eraseAllDate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self deleteAllObjectsInContext:appDelegate.managedObjectContext usingModel:appDelegate.managedObjectModel];
    [appDelegate.managedObjectContext save:nil];
}

+ (void) deleteAllObjectsInContext:(NSManagedObjectContext *)context
                       usingModel:(NSManagedObjectModel *)model
{
    NSArray *entities = model.entities;
    for (NSEntityDescription *entityDescription in entities)
    {
        if (![entityDescription.name isEqualToString:@"CalendarEvents"]) {
            [self deleteAllObjectsWithEntityName:entityDescription.name inContext:context];
        }
    }
}

+ (void) deleteAllObjectsWithEntityName:(NSString *)entityName
                             inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest =
    [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.includesSubentities = NO;
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items)
    {
        [context deleteObject:managedObject];
    }
}

#pragma mark - server return error message
+ (NSDictionary *) dictionaryWithJsondata:(NSData *) jsonData
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        
        return nil;
    }
    return dic;
}
+ (NSString *) serverReturnErrorMessage:(NSError *) error
{
    NSString *message = nil;
    if (error.code == -1009) {
        message = @"The Internet connection appears to be offline.";
    }
    else if (error.code == -1200){
        message = @"An SSL error has occurred and a secure connection to the server cannot be made.";
    }
    else if (error.code == -1001){
        message = @"The request timeout.";
    }
    else if (error.code == -9806) {
        message = @"CFNetwork SSLHandshake failed.";
    }
    else if (error.code == 54)
    {
        message = @"Connection reset by peer.";
    }
    else if (error.code == -1005)
    {
        message = @"The network connection was lost.";
    }
    else
    {
        message = [NSString stringWithFormat:@"%@",error];
    }
    return message;
}

+ (NSString *) AWSDynamoDBErrorMessage:(NSInteger) errorCode
{
    NSString *message = @"The Internet connection appears to be offline.";
    if (errorCode == -1009) {
        message = @"The Internet connection appears to be offline.";
    }
    else if (errorCode == -1200){
        message = @"An SSL error has occurred and a secure connection to the server cannot be made.";
    }
    else if (errorCode == -1001){
        message = @"The request timeout.";
    }
    else if (errorCode == -9806) {
        message = @"CFNetwork SSLHandshake failed.";
    }
    else if (errorCode == 54)
    {
        message = @"Connection reset by peer.";
    }
    else if (errorCode == -1005)
    {
        message = @"The network connection was lost.";
    }
    return message;
}

+ (BOOL) userIsOpenNotification
{
//    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
//    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//        /*
//         UNAuthorizationStatusNotDetermined : 没有做出选择
//         UNAuthorizationStatusDenied : 用户未授权
//         UNAuthorizationStatusAuthorized ：用户已授权
//         */
//        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
//        {
//            NSLog(@"未选择");
//        }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
//            NSLog(@"未授权");
//        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
//            NSLog(@"已授权");        
//        }       
//    }];
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

@end
