//
//  SyncNewCalendar.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 17/3/6.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SyncNewCalendar : NSObject

+ (void) subscribeEventToMyCalendar:(NSArray *) arr_object andSubscribeUuid:(NSString *) subscribeuuid;
+ (void) removeEvent:(NSString *) subscribeuuid andData:(id) object andIsDelete:(int) isdelete;

@end
