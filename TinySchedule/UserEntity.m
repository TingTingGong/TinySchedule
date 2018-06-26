

#import "UserEntity.h"

#define kIsLogin @"login"
#define kIsLoginSuccessfullyToken @"loginsuccessfullytoken"
#define kDeviceToken @"device_token"
#define kFilter @"filter"
#define kCalendar @"calendar"
#define kCalendarShiftArray @"calendarshiftarray"
//#define kCalendarIdentifier @"canlendar-identifier"
//#define kSubscribeCategaryUuid @"subscribe-categaryUuid"


@implementation UserEntity


+(void) loginOut
{
    [DatabaseManager eraseAllDate];
    AppDelegate *appd = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appd.currentWorkplace = nil;
    appd.currentEmployee = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kFilter];
    [defaults removeObjectForKey:kCalendar];
    [defaults removeObjectForKey:kCalendarShiftArray];
    [defaults removeObjectForKey:kIsLoginSuccessfullyToken];
    //[defaults removeObjectForKey:kCalendarIdentifier];
    [defaults synchronize];
}

+ (void) setLogInSuccessfullyToken:(NSString *)token
{
    if (token) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:token forKey:kIsLoginSuccessfullyToken];
        [defaults synchronize];
    }
}
+ (NSString *) getLogInSuccessfullyToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kIsLoginSuccessfullyToken];
}

+ (void) setDeviceToken:(NSData *)deviceToken
{
    if (deviceToken) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:deviceToken forKey:kDeviceToken];
        [defaults synchronize];
    }
}

+ (NSData *) getDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kDeviceToken];
}

+ (void) setFilter:(NSDictionary *)dict;
{
    if (dict) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict forKey:kFilter];
        [defaults synchronize];
    }
}
+ (NSDictionary *) getFilter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kFilter];
}

+ (void) setCalendarDate:(NSDictionary *)dict
{
    if (dict) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dict forKey:kCalendar];
        [defaults synchronize];
    }
}
+ (NSDictionary *) getCalendarDate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kCalendar];
}

+ (void) setCalendarShiftArray:(NSArray *) arr
{
    if (arr) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:arr forKey:kCalendarShiftArray];
        [defaults synchronize];
    }
}
+ (NSArray *) getCalendarShiftArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kCalendarShiftArray];
}

//+ (void) setSubscribeSystemCalendarIdentifie:(NSString *)identifier
//{
//    if (identifier) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *allIdentifier = [NSString stringWithFormat:@"%@",[defaults objectForKey:kCalendarIdentifier]];
//        if (allIdentifier == nil || [allIdentifier containsString:@"null"]) {
//            [defaults setObject:identifier forKey:kCalendarIdentifier];
//        }
//        else
//        {
//            NSArray *arr = [NSArray arrayWithArray:[allIdentifier componentsSeparatedByString:@","]];
//            if (![arr containsObject:identifier]) {
//                allIdentifier = [NSString stringWithFormat:@"%@,%@",allIdentifier,identifier];
//                [defaults setObject:allIdentifier forKey:kCalendarIdentifier];
//            }
//        }
//        
//        [defaults synchronize];
//    }
//}
////idetifier1,identifier2,identifier2
//+ (NSString *) getSubscribeSystemCalendarIdentifie
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults objectForKey:kCalendarIdentifier];
//}
//
//
//+ (void) setHasSubscribeCatogaryUuid:(NSString *)uuid
//{
//    if (uuid) {
//
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *allUuid = [NSString stringWithFormat:@"%@",[defaults objectForKey:kSubscribeCategaryUuid]];
//        if (allUuid == nil || [allUuid containsString:@"null"]) {
//            [defaults setObject:uuid forKey:kSubscribeCategaryUuid];
//        }
//        else
//        {
//            NSArray *arr = [NSArray arrayWithArray:[allUuid componentsSeparatedByString:@","]];
//            if (![arr containsObject:uuid]) {
//                allUuid = [NSString stringWithFormat:@"%@,%@",allUuid,uuid];
//                [defaults setObject:allUuid forKey:kSubscribeCategaryUuid];
//            }
//        }
//        [defaults synchronize];
//    }
//}
//+ (NSString *) getHasSubscribeCatogaryUuid;
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return [defaults objectForKey:kSubscribeCategaryUuid];
//}

@end
