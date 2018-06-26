

#import <Foundation/Foundation.h>
#import "WorkPlaces+CoreDataProperties.h"

@interface UserEntity : NSObject

+(void) loginOut;

+ (void) setLogInSuccessfullyToken:(NSString *)token;
+ (NSString *) getLogInSuccessfullyToken;

+ (void) setDeviceToken:(NSData *)deviceToken;
+ (NSData *) getDeviceToken;

+ (void) setFilter:(NSDictionary *)dict;
+ (NSDictionary *) getFilter;

+ (void) setCalendarDate:(NSDictionary *)dict;
+ (NSDictionary *) getCalendarDate;

+ (void) setCalendarShiftArray:(NSArray *) arr;
+ (NSArray *) getCalendarShiftArray;

//+ (void) setSubscribeSystemCalendarIdentifie:(NSString *)identifier;
//+ (NSString *) getSubscribeSystemCalendarIdentifie;
//
//+ (void) setHasSubscribeCatogaryUuid:(NSString *)uuid;
//+ (NSString *) getHasSubscribeCatogaryUuid;

@end
