//
//  DynanoDBModel.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/29.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "DynanoDBModel.h"


@implementation DynanoDBModel

@end

@implementation DDBEmployeesInfoModel
+ (NSString *)dynamoDBTableName {
    return AWSEmployeesTableName;
}
+ (NSString *)hashKeyAttribute {
    return @"uuid";
}
+ (NSString *)rangeKeyAttribute
{
    return @"email";
}
@end;


@implementation DDBWorkPlacesInfoModel
+ (NSString *)dynamoDBTableName {
    return AWSWorkPlacesTableName;
}
+ (NSString *)hashKeyAttribute {
    return @"uuid";
}
+ (NSString *)rangeKeyAttribute {
    return @"placeName";
}
@end;

@implementation DDBDeviceTokenModel
+ (NSString *)dynamoDBTableName {
    return AWSDeviceTokenTableName;
}
+ (NSString *) hashKeyAttribute
{
    return @"deviceToken";
}
+ (NSString *)rangeKeyAttribute {
    return @"parentUuid";
}
@end;


@implementation DDBDataModel
+ (NSString *)dynamoDBTableName {
    return AWSDataTableName;
}
+ (NSString *)hashKeyAttribute {
    return @"uuid";
}
+ (NSString *)rangeKeyAttribute {
    return @"parentUuid";
}
@end;

