//
//  HttpRequestManager.h
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/5/8.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestManager : NSObject

/** 请求成功的回调 */
typedef void(^requestSuccess)(NSData *data,NSHTTPURLResponse *response);
typedef void(^requestFailure)(NSError *error);


+(void)requestWithType:(NSString *)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock;

+(void)cancelAllRequest;

@end
