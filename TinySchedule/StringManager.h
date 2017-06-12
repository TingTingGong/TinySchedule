//
//  StringManager.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/4.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeekDay.h"
#include "iconv.h"


@interface StringManager : NSObject

//fullName,email,password
+ (BOOL) isValidUserFullName:(NSString *)fullName;

+ (BOOL) isValidEmail:(NSString *)email;

+ (BOOL) passwordIsLeastSevenCharacters:(NSString *)password;

//workplace isExist
+ (BOOL) workPlaceIsExisted:(NSString *)placeName andAddr:(NSString *)placeAddr;

+ (BOOL) isEmpty:(NSString *) str;


+ (BOOL) isNuLLString:(NSString *)passString;

+ (NSString *) deleteWhiteSpaceCharacters:(NSString *)passString;

//获取字符串中所有子字符串的首字母，并改为大写
+ (NSString *) getManyFirstLetterFromString:(NSString *)passString;

//获取字符串的第一个字母
+ (NSString *) getFirstLetterFromString:(NSString *)passString;

//按照大写字母排序显示
+ (NSDictionary *) getFirstLetterDictFromArray:(NSArray *)passArray;

//获取每个item的id
+ (NSString *) getItemID;

+ (BOOL)includeChinese:(NSString *) str;

//date －> string
+ (NSString *) dateTransferString:(NSDate *)date;
//string －> date
+ (NSDate *) stringTransferDate:(NSString *)strdate;


+ (NSNumber *) stringDateTransferTimeStamp:(NSString *)stringDate;
+ (NSNumber *) stringDateTimeTransferTimeStamp:(NSString *)stringDateTime;
+ (NSNumber *) stringTimeTransferTimeStamp:(NSString *)dateStamp andTime:(NSString *) time;
+ (NSNumber *) dateTransferTimeStamp:(NSDate *)passDate;
+ (NSDate *) timeStampTransferDate:(NSNumber *)timeStamp;
+ (NSMutableDictionary *) getYearMonthDay:(NSString *)stringDate;
+ (NSMutableDictionary *) getYearMonthDayTime:(NSString *)stringDate;
+ (NSNumber *) getDayDateStamp:(NSDate *)date;//2016-10-26
+ (NSNumber *) getDayTimeStamp:(NSDate *)date;//2016-10-26 13:00

+ (NSMutableArray *) getAllDaysInOneYear;
+ (NSMutableArray *) getAllDaysInOneYear2;//ongoing

+ (void) setCalendarWeekDictionary:(NSDate *) date;
+ (void) setCalendarDayDictionary:(NSDate *) date;

//获取两个日期间隔的天数
+ (NSInteger) getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

//两个时间相差多少小时
+ (float) getIntervalHoursFromTowTime:(NSString *)time1 andTime2:(NSString *)time2;

+ (NSDictionary *)compareTwoTime:(long)time1 time2:(long)time2;

+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

- (NSDate *) calculateEndDate:(NSInteger)startHour startMinute:(NSInteger)startMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute;

//按照日期大小排序显示
//+ (NSArray *) getSortedArrayFromDate:(NSMutableArray *)passArray;

+ (NSMutableArray *)getWeekTime:(NSDate *)passDate;
+ (NSMutableDictionary *) getWeekStartDayStamp:(NSString *) string_yearMonthDay;

+(NSDictionary *) interceptionTime:(NSString *)time;
+(NSDictionary *) getHourAndMin:(NSString *)hour;

+ (NSData *) stringTransferData:(NSString *)string;
+ (NSString *) dataTransferString:(NSData *)data;

+ (NSDictionary *) getDictionaryByJsonString:(NSString *)jsonString;
+ (NSString *) getJsonStringByDictionary:(NSMutableDictionary *) dict;

+ (NSMutableDictionary *) getYearMonthDayWeekByDate:(NSDate  *) date;

+ (float) isCorrectUnPaidBreak:(float) hour andUnPaid:(NSString *) unpaid;

+ (BOOL) towTimeIsConfilict:(NSString *)time1 andTime2:(NSString *)time2 andTime3:(NSString *) time3 andTime4:(NSString *) time4;
+ (NSString *) timeRemoveAMPM:(NSString *) string;

//userID + workPlaceID + deviceToken -> pushTokenID
+ (NSData *) getPushTokenID:(NSData *)deviceToken andUserID:(NSString *)userID andWorkPlaceID:(NSString *)workPlaceID;

+ (NSString *)applicationDocumentsDirectory;


#pragma -mark CreateShift
+ (NSString *) getEnglishMonth:(long)month;
+ (NSString *) getEntireEnglishMonth:(long)month;
+ (long) getNumberMonth:(NSString *)month;
+ (NSInteger) getWeekDay:(NSDate *)date;
+ (NSString *)featureWeekdayWithDate:(long)year andMonth:(long)month andDay:(long)day;
+ (BOOL) compareTime:(NSString *)time1 andTime2:(NSString *)time2;

+ (NSMutableArray *) getSevenDaysInWeekByUserEntityCalendarDate;

+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

+ (NSString *)randomPassword;

@end
