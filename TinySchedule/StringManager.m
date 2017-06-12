//
//  StringManager.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 16/8/4.
//  Copyright © 2016年 TinyWorks_Dev. All rights reserved.
//

#import "StringManager.h"

@implementation StringManager

+ (BOOL) isValidUserFullName:(NSString *)fullName
{
    NSString *userNameRegex = @"^([A-z][A-z]*( |$))+";//the first character of first name and last name must be upper
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:fullName];
    if (B == YES) {
        fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([fullName containsString:@" "]) {
            return B;
        }
        else
            return NO;
    }
    return B;
}

+ (BOOL) isValidEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) passwordIsLeastSevenCharacters:(NSString *)password
{
    __block NSUInteger count = 0;
    [password enumerateSubstringsInRange:NSMakeRange(0, [password length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        count++;
    }];
    if (count >= 7) {
        return YES;
    }
    return NO;
}

+ (NSString *)randomPassword
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 7; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

+ (BOOL) workPlaceIsExisted:(NSString *)placeName andAddr:(NSString *)placeAddr
{
    
    return YES;
}

+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (BOOL) isNuLLString:(NSString *)passString
{
    if (!passString) {
        return NO;
    }
    
    if (![passString isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (passString.length < 1) {
        return NO;
    }
    
    if ([passString containsString:@"null"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)includeChinese:(NSString *) str
{
    if ([str length] == 0 || [self isEmpty:str] == YES) {
        return YES;
    }
    for(int i = 0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

+(NSString *) deleteWhiteSpaceCharacters:(NSString *)passString
{
    NSString *tempString = passString;
    tempString = [tempString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tempString = [tempString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return tempString;
}


+ (NSString *) getManyFirstLetterFromString:(NSString *)passString
{
    passString = [passString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *arr_character = [NSMutableArray array];
    NSArray *list = [passString componentsSeparatedByString:@" "];// 以空格分割成数组
    for (NSString *str in list) {
        NSMutableString *temp = [NSMutableString stringWithString:str];
        CFStringTransform((CFMutableStringRef)temp, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((CFMutableStringRef)temp, NULL, kCFStringTransformStripDiacritics, NO);
        NSString *strPY = [temp capitalizedString];
        [arr_character addObject:[strPY substringWithRange:NSMakeRange(0, 1)]];
    }
    
    NSString *result = @"";
    for (NSString *str in  arr_character) {
        result = [result stringByAppendingString:str];
    }
    return result;
}

+ (NSString *) getFirstLetterFromString:(NSString *)passString
{
    NSMutableString *temp = [NSMutableString stringWithString:passString];
    CFStringTransform((CFMutableStringRef)temp, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)temp, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *strPY = [temp capitalizedString];
    return [strPY substringWithRange:NSMakeRange(0, 1)];
}


+ (NSDictionary *) getFirstLetterDictFromArray:(NSArray *)passArray
{
    NSMutableDictionary *dictFirstLeterToNames = [NSMutableDictionary dictionary];
    for (NSString *name in passArray) {
        NSString *strFiesrLetter = [StringManager getFirstLetterFromString:name];
        if (dictFirstLeterToNames[strFiesrLetter]) {
            [dictFirstLeterToNames[strFiesrLetter] addObject:name];
        }
        else
        {
            NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:name];
            [dictFirstLeterToNames setObject:arrGroupNames forKey:strFiesrLetter];
        }
    }
    return dictFirstLeterToNames;
}

+ (NSString *) getItemID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    return (__bridge NSString *)string;
}
+ (NSString *) dateTransferString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}


+ (NSDate *) stringTransferDate:(NSString *)strdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strdate];
    return date;
}
+ (NSNumber *) stringDateTransferTimeStamp:(NSString *)stringDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    
    NSDate *mydate = [formatter dateFromString:stringDate];

    NSNumber *stamp = [NSNumber numberWithLong:[mydate timeIntervalSince1970]];
    
    return stamp;
}
+ (NSNumber *) stringDateTimeTransferTimeStamp:(NSString *)stringDateTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    
    NSDate *mydate = [formatter dateFromString:stringDateTime];
    
    NSNumber *stamp = [NSNumber numberWithLong:[mydate timeIntervalSince1970]];
    
    return stamp;
}

+ (NSNumber *) stringTimeTransferTimeStamp:(NSString *)dateStamp andTime:(NSString *) time
{
    //dateStamp->1475688970    time:5:30 p.m.
    NSNumber *needNumber;
    
    NSDictionary *dict = [StringManager getYearMonthDay:[NSString stringWithFormat:@"%@",dateStamp]];
    NSString *yearMonthDay = [NSString stringWithFormat:@"%@-%@-%@",[dict objectForKey:@"year"],[dict objectForKey:@"month"],[dict objectForKey:@"day"]];
    
    NSString *string = @"";
    if ([time containsString:@"a.m."]) {
        string = [time stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
    }
    else
    {
        string = [time stringByReplacingOccurrencesOfString:@" p.m." withString:@""];//5:30
        NSRange range = [string rangeOfString:@":"];
        NSString *s1 = [string substringWithRange:NSMakeRange(0, range.location)];//5
        NSString *s2 = [string substringWithRange:NSMakeRange(range.location + 1, 2)];//30
        if (![s1 containsString:@"12"]) {
            int re = [s1 intValue] + 12;
            string = [NSString stringWithFormat:@"%d:%@",re,s2];
        }
    }
    
    NSString *finalString = [NSString stringWithFormat:@"%@ %@",yearMonthDay,string];
    needNumber = [self stringDateTimeTransferTimeStamp:finalString];
    
    return needNumber;
}

+ (NSNumber *) dateTransferTimeStamp:(NSDate *)passDate
{
    NSTimeInterval interval = [passDate timeIntervalSince1970];
    long long totalMilliseconds = interval;
    return [NSNumber numberWithDouble:totalMilliseconds];
}

+ (NSDate *) timeStampTransferDate:(NSNumber *)timeStamp
{
    NSTimeInterval tempMilli = [timeStamp doubleValue];
    NSTimeInterval seconds = tempMilli;
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

+ (NSInteger) getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

+ (NSMutableDictionary *) getYearMonthDay:(NSString *)stringDate
{
    NSTimeInterval tempMilli = [stringDate doubleValue];
    NSTimeInterval seconds = tempMilli;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    //NSLog(@"传入的时间戳=%f",seconds);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    NSString *str_week = [self featureWeekdayWithDate:year andMonth:month andDay:day];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLong:year] forKey:@"year"];
    [dict setObject:[NSNumber numberWithLong:month] forKey:@"month"];
    [dict setObject:[NSNumber numberWithLong:day] forKey:@"day"];
    [dict setObject:str_week forKey:@"week"];
    return dict;
}

+ (NSMutableDictionary *) getYearMonthDayWeekByDate:(NSDate  *) date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLong:year] forKey:@"year"];
    [dict setObject:[NSNumber numberWithLong:month] forKey:@"month"];
    [dict setObject:[NSNumber numberWithLong:day] forKey:@"day"];
    [dict setObject:[StringManager featureWeekdayWithDate:year andMonth:month andDay:day] forKey:@"week"];
    
    return dict;
}

+ (NSMutableDictionary *) getYearMonthDayTime:(NSString *)stringDate
{
    NSTimeInterval tempMilli = [stringDate doubleValue];
    NSTimeInterval seconds = tempMilli;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    //NSLog(@"传入的时间戳=%f",seconds);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components_hour = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour) fromDate:date];
    NSDateComponents *components_monute = [[NSCalendar currentCalendar] components:(NSCalendarUnitMinute) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    long hour = [components_hour hour];
    long minute = [components_monute minute];
    NSString *str_week = [self featureWeekdayWithDate:year andMonth:month andDay:day];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithLong:year] forKey:@"year"];
    [dict setObject:[NSNumber numberWithLong:month] forKey:@"month"];
    [dict setObject:[NSNumber numberWithLong:day] forKey:@"day"];
    [dict setObject:str_week forKey:@"week"];
    if (hour > 12) {
        hour = hour - 12;
        [dict setObject:@"p.m." forKey:@"end"];
    }
    else
    {
        [dict setObject:@"a.m." forKey:@"end"];
    }
    [dict setObject:[NSNumber numberWithLong:hour] forKey:@"hour"];
    
    [dict setObject:[NSNumber numberWithLong:minute] forKey:@"minute"];
    return dict;
}

- (NSDate *) calculateEndDate:(NSInteger)startHour startMinute:(NSInteger)startMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *nowDateComp = [calendar components:unitFlags fromDate: [NSDate date]];
    NSDateComponents *startDateComp = [[NSDateComponents alloc]init];
    [startDateComp setYear:[nowDateComp year]];
    [startDateComp setMonth:[nowDateComp month]];
    [startDateComp setDay:[nowDateComp day]];
    [startDateComp setHour:startHour];
    [startDateComp setMinute:startMinute];
    [startDateComp setSecond:0];
    NSCalendar *startCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startDate = [startCal dateFromComponents:startDateComp];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:startDate];
    NSDate *localeDate = [startDate  dateByAddingTimeInterval: interval];//需要将标准时间转成本地时间
    //初始化为以localeDate为基准，然后过了(endHour*3600+endMinute*60)秒的时间
    NSDate *endDate =[[NSDate alloc]initWithTimeInterval:(endHour*3600+endMinute*60) sinceDate:localeDate];
    return endDate;
}

+ (NSMutableArray *) getAllDaysInOneYear

{
    NSMutableArray *arr = [NSMutableArray array];

    for (int i = 0; i < 365; i++) {
        
        NSDate *nextDate;
        if (i == 0) {
            nextDate = [NSDate date];
        }
        else
        {
            nextDate = [NSDate dateWithTimeIntervalSinceNow:i * 24 * 60 * 60];
        }
        
        NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:nextDate];
        NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:nextDate];
        NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:nextDate];
        
        
        long year = [components_year year];
        long month = [components_month month];
        long day = [components_day day];
        NSString *str_week = [self featureWeekdayWithDate:year andMonth:month andDay:day];
        
        
        NSString *showString = [NSString stringWithFormat:@"%@, %@ %lu %lu",str_week,[self getEnglishMonth:month],day,year];
        NSString *string_yearMonthDay = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:showString,@"show",string_yearMonthDay,@"hiden", nil];
        [arr addObject:dict];
    }
    
    return arr;
}

+ (NSMutableArray *) getAllDaysInOneYear2
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getAllDaysInOneYear]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"ongoing",@"show",@"0",@"hiden", nil];
    [arr insertObject:dict atIndex:0];
    return arr;
}

+ (float) getIntervalHoursFromTowTime:(NSString *)time1 andTime2:(NSString *)time2
{
    float hours = 0.00;
    
    NSRange range = [time1 rangeOfString:@":"];
    NSString *str1 = [time1 substringWithRange:NSMakeRange(0, range.location)];
    NSString *str2 = [time1 substringWithRange:NSMakeRange(range.location + 1, 2)];
    NSRange range2 = [time2 rangeOfString:@":"];
    NSString *str3 = [time2 substringWithRange:NSMakeRange(0, range2.location)];
    NSString *str4 = [time2 substringWithRange:NSMakeRange(range2.location +1 ,2)];
    
    if (![time1 containsString:@"12"] && [time1 containsString:@"p.m."]) {
        str1 = [NSString stringWithFormat:@"%d",[str1 intValue] + 12];
    }
    if (![time2 containsString:@"12"] && [time2 containsString:@"p.m."]) {
        str3 = [NSString stringWithFormat:@"%d",[str3 intValue] + 12];
    }
    
    time1 = [NSString stringWithFormat:@"%@:%@",str1,str2];
    time2 = [NSString stringWithFormat:@"%@:%@",str3,str4];
    hours = [self dateTimeDifferenceWithStartTime:time1 endTime:time2];
    
    return hours;
}

+ (float)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    startTime = [NSString stringWithFormat:@"2017-10-10 %@",startTime];
    endTime = [NSString stringWithFormat:@"2017-10-10 %@",endTime];
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval value=[endD timeIntervalSinceDate:startD];
    return value/3600.0;
}

+ (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}


+ (NSMutableArray *)getWeekTime:(NSDate *)passDate
{
    if (passDate == nil) {
        passDate = [NSDate date];
    }
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSDate *beginDate1 = nil;
    NSDate *beginDate2 = nil;
    NSDate *beginDate3 = nil;
    NSDate *beginDate4 = nil;
    NSDate *beginDate5 = nil;
    
    NSDateFormatter *f0 = [[NSDateFormatter alloc] init];
    [f0 setDateFormat:@"YYYY"];
    NSString *currentYear = [f0 stringFromDate:[NSDate date]];
    
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MM"];
    NSString *currentMonth = [f stringFromDate:[NSDate date]];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"dd"];
    NSString *currentDay = [f2 stringFromDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:passDate];
    if (ok) {
        beginDate1 = [beginDate dateByAddingTimeInterval:1 * 24 * 60 * 60 ];
        beginDate2 = [beginDate dateByAddingTimeInterval:2 * 24 * 60 * 60 ];
        beginDate3 = [beginDate dateByAddingTimeInterval:3 * 24 * 60 * 60 ];
        beginDate4 = [beginDate dateByAddingTimeInterval:4 * 24 * 60 * 60 ];
        beginDate5 = [beginDate dateByAddingTimeInterval:5 * 24 * 60 * 60 ];
        endDate = [beginDate dateByAddingTimeInterval:   6 * 24 * 60 * 60 ];
    }
    else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *beginString1 = [myDateFormatter stringFromDate:beginDate1];
    NSString *beginString2 = [myDateFormatter stringFromDate:beginDate2];
    NSString *beginString3 = [myDateFormatter stringFromDate:beginDate3];
    NSString *beginString4 = [myDateFormatter stringFromDate:beginDate4];
    NSString *beginString5 = [myDateFormatter stringFromDate:beginDate5];
    NSDateFormatter *myDateFormatter2 = [[NSDateFormatter alloc] init];
    [myDateFormatter2 setDateFormat:@"MM"];
    NSString *beginMonth = [myDateFormatter2 stringFromDate:beginDate];
    NSString *endMonth = [myDateFormatter2 stringFromDate:endDate];
    NSString *beginMonth1 = [myDateFormatter2 stringFromDate:beginDate1];
    NSString *beginMonth2 = [myDateFormatter2 stringFromDate:beginDate2];
    NSString *beginMonth3 = [myDateFormatter2 stringFromDate:beginDate3];
    NSString *beginMonth4 = [myDateFormatter2 stringFromDate:beginDate4];
    NSString *beginMonth5 = [myDateFormatter2 stringFromDate:beginDate5];
    NSDateFormatter *myDateFormatter3 = [[NSDateFormatter alloc] init];
    [myDateFormatter3 setDateFormat:@"YYYY"];
    NSString *beginYear = [myDateFormatter3 stringFromDate:beginDate];
    NSString *endYear = [myDateFormatter3 stringFromDate:endDate];
    NSString *beginYear1 = [myDateFormatter3 stringFromDate:beginDate1];
    NSString *beginYear2 = [myDateFormatter3 stringFromDate:beginDate2];
    NSString *beginYear3 = [myDateFormatter3 stringFromDate:beginDate3];
    NSString *beginYear4 = [myDateFormatter3 stringFromDate:beginDate4];
    NSString *beginYear5 = [myDateFormatter3 stringFromDate:beginDate5];
    
    NSMutableArray *arr_week = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        WeekDay *weekday = [[WeekDay alloc]init];
        if (i == 0) {
            weekday.day = beginString;
            weekday.month = beginMonth;
            weekday.year = beginYear;
            if ([beginMonth containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 1){
            weekday.day = beginString1;
            weekday.month = beginMonth1;
            weekday.year = beginYear1;
            if ([beginMonth1 containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString1 containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear1 containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 2){
            weekday.day = beginString2;
            weekday.month = beginMonth2;
            weekday.year = beginYear2;
            if ([beginMonth2 containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString2 containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear2 containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 3){
            weekday.day = beginString3;
            weekday.month = beginMonth3;
            weekday.year = beginYear3;
            if ([beginMonth3 containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString3 containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear3 containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 4){
            weekday.day = beginString4;
            weekday.month = beginMonth4;
            weekday.year = beginYear4;
            if ([beginMonth4 containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString4 containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear4 containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 5){
            weekday.day = beginString5;
            weekday.month = beginMonth5;
            weekday.year = beginYear5;
            if ([beginMonth5 containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([beginString5 containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([beginYear5 containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        else if (i == 6){
            weekday.day = endString;
            weekday.month = endMonth;
            weekday.year = endYear;
            if ([endMonth containsString:currentMonth]) {
                weekday.isCurrentMonth = YES;
            }
            else
            {
                weekday.isCurrentMonth = NO;
            }
            if ([endString containsString:currentDay]) {
                weekday.isCurrentDay = YES;
            }
            else
            {
                weekday.isCurrentDay = NO;
            }
            if ([endYear containsString:currentYear]) {
                weekday.isCurrentYear = YES;
            }
            else
            {
                weekday.isCurrentYear = NO;
            }
        }
        [arr_week addObject:weekday];
    }

    return arr_week;
    
}

+ (NSMutableDictionary *) getWeekStartDayStamp:(NSString *) string_yearMonthDay{
    
    NSMutableDictionary *dict_stamp = [NSMutableDictionary dictionary];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string_yearMonthDay];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    
    long week = [[calendar components: NSCalendarUnitWeekday fromDate:date] weekday]-1;
    
    NSDate *firstDay = nil;
    NSDate *lastDay = nil;
    
    if (week == 0) {
        
        firstDay = date;
        lastDay = [date dateByAddingTimeInterval:   6 * 24 * 60 * 60 ];
    }
    //周一
    else if (week == 1)
    {
        firstDay = [date dateByAddingTimeInterval: -1 * 24 * 60 * 60];
        lastDay = [date dateByAddingTimeInterval:   5 * 24 * 60 * 60 ];
    }
    else if (week == 2)
    {
        firstDay = [date dateByAddingTimeInterval: -2 * 24 * 60 * 60];
        lastDay = [date dateByAddingTimeInterval:   4 * 24 * 60 * 60 ];
    }
    else if (week == 3)
    {
        firstDay = [date dateByAddingTimeInterval: -3 * 24 * 60 * 60];
        lastDay = [date dateByAddingTimeInterval:   3 * 24 * 60 * 60 ];
    }
    else if (week == 4)
    {
        firstDay = [date dateByAddingTimeInterval: -4 * 24 * 60 * 60];
        lastDay = [date dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
    }
    else if (week == 5)
    {
        firstDay = [date dateByAddingTimeInterval: -5 * 24 * 60 * 60];
        lastDay = [date dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
    }
    else if (week == 6)
    {
        firstDay = [date dateByAddingTimeInterval: -6 * 24 * 60 * 60];
        lastDay = date;
    }
    
    NSString *first = [self dateTransferString:firstDay];
    NSString *last = [self dateTransferString:lastDay];
    
    NSNumber *number1 = [self stringDateTransferTimeStamp:first];
    NSNumber *number2 = [self stringDateTransferTimeStamp:last];
    
    [dict_stamp setObject:@"0" forKey:@"state"];
    [dict_stamp setObject:number1 forKey:@"number1"];
    [dict_stamp setObject:number2 forKey:@"number2"];
    [dict_stamp setObject:date forKey:@"date"];
    
    return dict_stamp;
}

+(NSDictionary *) interceptionTime:(NSString *)time
{
    NSDictionary *dict = nil;
    NSString *str1 = @"";
    NSString *str2 = @"";
    NSString *str3 = @"";
    NSString *str4 = @"";
    
    NSRange range;
    if ([time containsString:@"-"]) {
        range = [time rangeOfString:@"-"];
    }
    else if([time containsString:@"～"])
    {
        range = [time rangeOfString:@"～"];
    }
    NSString *s1 = [time substringWithRange:NSMakeRange(0, range.location)];
    s1 = [s1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *s2 = [time substringFromIndex:range.location+1]; //截取字符串
    s2 = [s2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (s1.length == 9) {
        str1 = [s1 substringWithRange:NSMakeRange(0, 5)];
        str2 = [s1 substringWithRange:NSMakeRange(5, 4)];
    }
    else if (s1.length == 8)
    {
        str1 = [s1 substringWithRange:NSMakeRange(0, 4)];
        str2 = [s1 substringWithRange:NSMakeRange(4, 4)];
    }
    else
    {
        str1 = @"05:00";
        str2 = @"a.m.";
    }
    if (s2.length == 9) {
        str3 = [s2 substringWithRange:NSMakeRange(0, 5)];
        str4 = [s2 substringWithRange:NSMakeRange(5, 4)];
    }
    else if (s2.length == 8)
    {
        str3 = [s2 substringWithRange:NSMakeRange(0, 4)];
        str4 = [s2 substringWithRange:NSMakeRange(4, 4)];
    }
    else
    {
        str3 = @"05:00";
        str4 = @"a.m.";
    }
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:str1,@"str1",str2,@"str2",str3,@"str3",str4,@"str4", nil];
    return dict;
}

+(NSDictionary *) getHourAndMin:(NSString *)hour
{
    NSString *hour_temp = [NSString stringWithFormat:@"%.2f",[hour floatValue]];
    NSDictionary *dict = nil;
    NSRange range = [hour_temp rangeOfString:@"."];
    NSString *s1 = [hour_temp substringWithRange:NSMakeRange(0, range.location)];
    s1 = [NSString stringWithFormat:@"%@h",s1];
    NSString *s2 = [hour_temp substringFromIndex:range.location+1]; //截取字符串
    int re = [s2 floatValue] * 60/100;
    s2 = [NSString stringWithFormat:@"%dm",re];
    if (re == 0) {
        s2 = @"00m";
    }
    dict = [NSDictionary dictionaryWithObjectsAndKeys:s1,@"hour",s2,@"min", nil];
    return dict;
}

+ (float) isCorrectUnPaidBreak:(float) hour andUnPaid:(NSString *) unpaid
{
    float unPaidFloatHour = 0.0;
    if (![unpaid containsString:@"hour"]) {
        NSString *str = [unpaid substringWithRange:NSMakeRange(0, 2)];
        unPaidFloatHour = [str intValue]/60.0;
    }
    else
    {
        if ([unpaid length] > 10) {
            NSString *str1 = [unpaid substringWithRange:NSMakeRange(0, 1)];
            NSString *str2 = [unpaid substringWithRange:NSMakeRange(7, 2)];
            unPaidFloatHour = [str2 intValue]/60.0+[str1 intValue];
        }
        else
        {
            if ([unpaid containsString:@"hours"]) {
                unPaidFloatHour = 2.0;
            }
            else
            {
                unPaidFloatHour = 1.0;
            }
        }
    }
    return hour-unPaidFloatHour;
}

+ (NSData *) stringTransferData:(NSString *)string
{
    if (string != nil) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
        return data;
    }
    return nil;
}
+ (NSString *) dataTransferString:(NSData *)data
{
    if (data != nil) {
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        return base64Encoded;
    }
    return nil;
}

+ (NSNumber *) getDayDateStamp:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];

    return [self stringDateTransferTimeStamp:temp];
}

+ (NSNumber *) getDayTimeStamp:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    NSDateComponents *components_hour = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour) fromDate:date];
    NSDateComponents *components_minute = [[NSCalendar currentCalendar] components:(NSCalendarUnitMinute) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    long hour = [components_hour hour];
    long minute = [components_minute minute];
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu %lu:%lu",year,month,day,hour,minute];
    return [self stringDateTimeTransferTimeStamp:temp];
}

+ (NSDictionary *) getDictionaryByJsonString:(NSString *)jsonString
{
    //NSString* str=@"{\"status\":\"1\",\"url\":\"http://www.baidu.com\"}";;
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json parsing：%@",err);
        return nil;
    }
    return dic;
}
+ (NSString *) getJsonStringByDictionary:(NSMutableDictionary *) dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+ (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从utf8转utf8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 丢弃不正确的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}


+ (NSData *) getPushTokenID:(NSData *)deviceToken andUserID:(NSString *)userID andWorkPlaceID:(NSString *)workPlaceID
{
    NSData *resultToken;
    
    return resultToken;
}
+ (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
/*
 + (NSMutableDictionary *)getFirstLetterToModelsDict:(NSArray<DTOContactsInfo *> *)array
 {s
    NSMutableDictionary *dictFirLetToModels = [NSMutableDictionary dictionary];
    //对得到的通讯录列表模型数组便利
    for (DTOContactsInfo *contact in array)
    {
        //获取这一模型对应的姓名的首字母
        NSString *nameFirstLetter = [ABUtil getFirstLetterFromString:contact.name];
        //如果首字母已经在字典中有了，那么直接将对象添加到这个字母对应的模型对象数组中
        if ([[dictFirLetToModels allKeys] containsObject:nameFirstLetter])
        {
            //#warning TODO: 这里可以对数组进行汉字排序,只有这样才能每个组里面的列表也按照姓名拼音排序
            //对对象数组for循环，当compareName(a.name,b.name)>0的时候，插在后面
            //#warning TODO: 汉字拼音排序暂时未实现
            [(NSMutableArray *)dictFirLetToModels[nameFirstLetter] addObject:contact];
        }
        else
        {
            //如果之前没有这个首字母，则往字典中新加入一个@“首字母”：可变数组的元素
            NSMutableArray *arrSubModels = [NSMutableArray array];
            [arrSubModels addObject:contact];
            [dictFirLetToModels setObject:arrSubModels forKey:nameFirstLetter];
        }
    }
    return dictFirLetToModels;
}
*/

+ (void) setCalendarWeekDictionary:(NSDate *)date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    NSDictionary *dict = [StringManager getWeekStartDayStamp:temp];
    [UserEntity setCalendarDate:dict];
}

+ (void) setCalendarDayDictionary:(NSDate *) date
{
    NSDateComponents *components_year = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    NSDateComponents *components_month = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    NSDateComponents *components_day = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    long year = [components_year year];
    long month = [components_month month];
    long day = [components_day day];
    NSString *temp = [NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
    NSNumber *number = [StringManager stringDateTransferTimeStamp:temp];
    NSMutableDictionary *dict_temp = [NSMutableDictionary dictionary];
    [dict_temp setObject:@"1" forKey:@"state"];
    [dict_temp setObject:number forKey:@"number1"];
    [dict_temp setObject:date forKey:@"date"];
    [UserEntity setCalendarDate:dict_temp];
}

+ (NSString *) getEnglishMonth:(long)month
{
    NSString *strMonth = @"";
    if (month == 1) {
        strMonth =  @"Jan";
    }
    else if (month == 2)
    {
        strMonth =  @"Feb";
    }
    else if (month == 3)
    {
        strMonth =  @"Mar";
    }
    else if (month == 4)
    {
        strMonth =  @"Apr";
    }
    else if (month == 5)
    {
        strMonth =  @"May";
    }
    else if (month == 6)
    {
        strMonth =  @"Jun";
    }
    else if (month == 7)
    {
        strMonth =  @"Jul";
    }
    else if (month == 8)
    {
        strMonth =  @"Aug";
    }
    else if (month == 9)
    {
        strMonth =  @"Sep";
    }
    else if (month == 10)
    {
        strMonth =  @"Oct";
    }
    else if (month == 11)
    {
        strMonth =  @"Nov";
    }
    else
    {
        strMonth =  @"Dec";
    }
    return strMonth;
}

+ (NSString *) getEntireEnglishMonth:(long)month
{
    NSString *strMonth = @"";
    if (month == 1) {
        strMonth =  @"January";
    }
    else if (month == 2)
    {
        strMonth =  @"February";
    }
    else if (month == 3)
    {
        strMonth =  @"March";
    }
    else if (month == 4)
    {
        strMonth =  @"April";
    }
    else if (month == 5)
    {
        strMonth =  @"May";
    }
    else if (month == 6)
    {
        strMonth =  @"June";
    }
    else if (month == 7)
    {
        strMonth =  @"July";
    }
    else if (month == 8)
    {
        strMonth =  @"August";
    }
    else if (month == 9)
    {
        strMonth =  @"September";
    }
    else if (month == 10)
    {
        strMonth =  @"October";
    }
    else if (month == 11)
    {
        strMonth =  @"November";
    }
    else
    {
        strMonth =  @"December";
    }
    return strMonth;
}
+(long) getNumberMonth:(NSString *)month
{
    long number = 1;
    if ([month isEqualToString:@"Jan"]) {
        number = 1;
    }
    else if ([month isEqualToString:@"Feb"])
    {
        number = 2;
    }
    else if ([month isEqualToString:@"Mar"])
    {
        number = 3;
    }
    else if ([month isEqualToString:@"Apr"])
    {
        number = 4;
    }
    else if ([month isEqualToString:@"May"])
    {
        number = 5;
    }
    else if ([month isEqualToString:@"Jun"])
    {
        number = 6;
    }
    else if ([month isEqualToString:@"Jul"])
    {
        number = 7;
    }
    else if ([month isEqualToString:@"Aug"])
    {
        number = 8;
    }
    else if ([month isEqualToString:@"Sep"])
    {
        number = 9;
    }
    else if ([month isEqualToString:@"Oct"])
    {
        number = 10;
    }
    else if ([month isEqualToString:@"Nov"])
    {
        number = 11;
    }
    else
    {
        number = 12;
    }
    return number;
}

+ (NSDictionary *)compareTwoTime:(long)time1 time2:(long)time2

{
    NSDate *date1 = [self timeStampTransferDate:[NSNumber numberWithLong:time1]];
    NSDate *date2 = [self timeStampTransferDate:[NSNumber numberWithLong:time2]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitHour | NSCalendarUnitMinute ;
    NSDateComponents *cmps = [calendar components:unit fromDate:date1 toDate:date2 options:0];
    NSInteger hour = [cmps hour];
    NSInteger min = [cmps minute];
    NSString *hourstring = [NSString stringWithFormat:@"%luh",(long)hour];
    NSString *minstring = [NSString stringWithFormat:@"%lum",(long)min];
    if (min == 0) {
        minstring = @"00m";
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:hourstring,@"hour",minstring,@"min", nil];
    return dict;
}

+ (BOOL) towTimeIsConfilict:(NSString *)time1 andTime2:(NSString *)time2 andTime3:(NSString *) time3 andTime4:(NSString *) time4
{
    NSString *string1 = [self timeRemoveAMPM:time1];
    NSString *string2 = [self timeRemoveAMPM:time2];
    NSString *string3 = [self timeRemoveAMPM:time3];
    NSString *string4 = [self timeRemoveAMPM:time4];
    
    NSString *year1 = [NSString stringWithFormat:@"2017-10-10 %@",string1];
    NSString *year2 = [NSString stringWithFormat:@"2017-10-10 %@",string2];
    NSString *year3 = [NSString stringWithFormat:@"2017-10-10 %@",string3];
    NSString *year4 = [NSString stringWithFormat:@"2017-10-10 %@",string4];
    NSNumber *number1 = [self stringDateTimeTransferTimeStamp:year1];
    NSNumber *number2 = [self stringDateTimeTransferTimeStamp:year2];
    NSNumber *number3 = [self stringDateTimeTransferTimeStamp:year3];
    NSNumber *number4 = [self stringDateTimeTransferTimeStamp:year4];
    
    if (!([number3 longLongValue] >= [number2 longLongValue] || [number4 longLongValue] <= [number1 longLongValue])) {
        return YES;;
    }
    return NO;
}

+ (NSString *) timeRemoveAMPM:(NSString *) string
{
    NSString *string1 = @"";
    if ([string containsString:@"a.m."]) {
        string1 = [string stringByReplacingOccurrencesOfString:@" a.m." withString:@""];
    }
    else
    {
        string1 = [string stringByReplacingOccurrencesOfString:@" p.m." withString:@""];//5:30
        NSRange range = [string1 rangeOfString:@":"];
        NSString *s1 = [string1 substringWithRange:NSMakeRange(0, range.location)];//5
        NSString *s2 = [string1 substringWithRange:NSMakeRange(range.location + 1, 2)];//30
        if (![s1 containsString:@"12"]) {
            int re = [s1 intValue] + 12;
            string1 = [NSString stringWithFormat:@"%d:%@",re,s2];
        }
    }
    return string1;
}


+ (NSString *)featureWeekdayWithDate:(long)year andMonth:(long)month andDay:(long)day{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:day];
    [_comps setMonth:month];
    [_comps setYear:year];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    long _weekday = [weekdayComponents weekday];
    NSString *week = [NSString stringWithFormat:@"%lu",(unsigned long)_weekday];
    if ([week isEqualToString:@"2"]) {
        week = @"Mon";
    }
    else if ([week isEqualToString:@"3"]) {
        week = @"Tue";
    }
    else if ([week isEqualToString:@"4"]) {
        week = @"Wed";
    }
    else if ([week isEqualToString:@"5"]) {
        week = @"Thr";
    }
    else if ([week isEqualToString:@"6"]) {
        week = @"Fri";
    }
    else if ([week isEqualToString:@"7"]) {
        week = @"Sat";
    }
    else if ([week isEqualToString:@"1"]) {
        week = @"Sun";
    }
    return week;
}

+ (NSInteger) getWeekDay:(NSDate *)date
{
    NSDateComponents *components_week = [[NSCalendar currentCalendar] components:(NSCalendarUnitWeekday) fromDate:date];
    long week = [components_week weekday] - 1;
    return week;
}

+ (NSMutableArray *) getSevenDaysInWeekByUserEntityCalendarDate
{
    NSDictionary *dict_date = [UserEntity getCalendarDate];
    
    NSString *string_yearMonthDay = [self dateTransferString:[dict_date objectForKey:@"date"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *mydate = [dateFormatter dateFromString:string_yearMonthDay];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    
    long week = [[calendar components: NSCalendarUnitWeekday fromDate:mydate] weekday]-1;
    
    NSDate *firstDay = nil;
    NSDate *secondDay = nil;
    NSDate *thirdDay = nil;
    NSDate *forthDay = nil;
    NSDate *friDay = nil;
    NSDate *sixDay = nil;
    NSDate *lastDay = nil;
    
    if (week == 0) {
        
        firstDay    = mydate;
        secondDay   = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
        thirdDay    = [mydate dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
        forthDay    = [mydate dateByAddingTimeInterval:   3 * 24 * 60 * 60 ];
        friDay      = [mydate dateByAddingTimeInterval:   4 * 24 * 60 * 60 ];
        sixDay      = [mydate dateByAddingTimeInterval:   5 * 24 * 60 * 60 ];
        lastDay     = [mydate dateByAddingTimeInterval:   6 * 24 * 60 * 60 ];
    }
    //周一
    else if (week == 1)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60];
        secondDay   = mydate;
        thirdDay    = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
        forthDay    = [mydate dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
        friDay      = [mydate dateByAddingTimeInterval:   3 * 24 * 60 * 60 ];
        sixDay      = [mydate dateByAddingTimeInterval:   4 * 24 * 60 * 60 ];
        lastDay     = [mydate dateByAddingTimeInterval:   5 * 24 * 60 * 60 ];
    }
    else if (week == 2)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -2 * 24 * 60 * 60];
        secondDay   = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60];
        thirdDay    = mydate;
        forthDay    = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
        friDay      = [mydate dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
        sixDay      = [mydate dateByAddingTimeInterval:   3 * 24 * 60 * 60 ];
        lastDay     = [mydate dateByAddingTimeInterval:   4 * 24 * 60 * 60 ];
    }
    else if (week == 3)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -3 * 24 * 60 * 60];
        secondDay   = [mydate dateByAddingTimeInterval:   -2 * 24 * 60 * 60];
        thirdDay    = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60 ];
        forthDay    = mydate;
        friDay      = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
        sixDay      = [mydate dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
        lastDay     = [mydate dateByAddingTimeInterval:   3 * 24 * 60 * 60 ];
    }
    else if (week == 4)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -4 * 24 * 60 * 60];
        secondDay   = [mydate dateByAddingTimeInterval:   -3 * 24 * 60 * 60];
        thirdDay    = [mydate dateByAddingTimeInterval:   -2 * 24 * 60 * 60 ];
        forthDay    = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60 ];
        friDay      = mydate;
        sixDay      = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
        lastDay     = [mydate dateByAddingTimeInterval:   2 * 24 * 60 * 60 ];
    }
    else if (week == 5)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -5 * 24 * 60 * 60];
        secondDay   = [mydate dateByAddingTimeInterval:   -4 * 24 * 60 * 60];
        thirdDay    = [mydate dateByAddingTimeInterval:   -3 * 24 * 60 * 60 ];
        forthDay    = [mydate dateByAddingTimeInterval:   -2 * 24 * 60 * 60 ];
        friDay      = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60 ];
        sixDay      = mydate;
        lastDay     = [mydate dateByAddingTimeInterval:   1 * 24 * 60 * 60 ];
    }
    else if (week == 6)
    {
        firstDay    = [mydate dateByAddingTimeInterval:   -6 * 24 * 60 * 60];
        secondDay   = [mydate dateByAddingTimeInterval:   -5 * 24 * 60 * 60];
        thirdDay    = [mydate dateByAddingTimeInterval:   -4 * 24 * 60 * 60 ];
        forthDay    = [mydate dateByAddingTimeInterval:   -3 * 24 * 60 * 60 ];
        friDay      = [mydate dateByAddingTimeInterval:   -2 * 24 * 60 * 60 ];
        sixDay      = [mydate dateByAddingTimeInterval:   -1 * 24 * 60 * 60 ];
        lastDay     = mydate;
    }
    NSDictionary *dict_today = [self getYearMonthDayWeekByDate:[NSDate date]];
    NSDictionary *dict_1 = [self getYearMonthDayWeekByDate:firstDay];
    NSDictionary *dict_2 = [self getYearMonthDayWeekByDate:secondDay];
    NSDictionary *dict_3 = [self getYearMonthDayWeekByDate:thirdDay];
    NSDictionary *dict_4 = [self getYearMonthDayWeekByDate:forthDay];
    NSDictionary *dict_5 = [self getYearMonthDayWeekByDate:friDay];
    NSDictionary *dict_6 = [self getYearMonthDayWeekByDate:sixDay];
    NSDictionary *dict_7 = [self getYearMonthDayWeekByDate:lastDay];
    NSArray *arr_temp = [NSArray arrayWithObjects:dict_1,dict_2,dict_3,dict_4,dict_5,dict_6,dict_7, nil];
    NSMutableArray *arr_week = [NSMutableArray array];
    for (NSDictionary *dcit in arr_temp) {
        WeekDay *week = [WeekDay new];
        week.year = [NSString stringWithFormat:@"%@",[dcit objectForKey:@"year"]];
        week.month = [NSString stringWithFormat:@"%@",[dcit objectForKey:@"month"]];
        week.day = [NSString stringWithFormat:@"%@",[dcit objectForKey:@"day"]];
        if ([[dcit objectForKey:@"year"] longLongValue] == [[dict_today objectForKey:@"year"] longLongValue]) {
            week.isCurrentYear = YES;
        }
        if ([[dcit objectForKey:@"month"] longLongValue] == [[dict_today objectForKey:@"month"] longLongValue]) {
            week.isCurrentMonth = YES;
        }
        if ([[dcit objectForKey:@"day"] longLongValue] == [[dict_today objectForKey:@"day"] longLongValue]) {
            week.isCurrentDay = YES;
        }
        [arr_week addObject:week];
    }
    return arr_week;
}

+ (BOOL) compareTime:(NSString *)time1 andTime2:(NSString *)time2
{
    NSDate *firstDate = [self transfertoDate:time1];
    
    NSTimeInterval _fitstDate = [firstDate timeIntervalSince1970]*1;
    
    NSDate *secondDate = [self transfertoDate:time2];
    NSTimeInterval _secondDate = [secondDate timeIntervalSince1970]*1;
    
    if (_fitstDate - _secondDate > 0) {
        return YES;
    }
    else
        return NO;
}
+ (NSDate *) transfertoDate:(NSString *)mydate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [formatter dateFromString:mydate];
    return date;
}


+ (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

@end
