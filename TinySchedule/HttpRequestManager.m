//
//  HttpRequestManager.m
//  TinySchedule
//
//  Created by TinyWorks_Dev on 2017/5/8.
//  Copyright © 2017年 TinyWorks_Dev. All rights reserved.
//

#import "HttpRequestManager.h"

#define timeOutInterval 10.0

@implementation HttpRequestManager

+(void)requestWithType:(NSString *)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:( requestSuccess)successBlock withFailureBlock:( requestFailure)failureBlock
{
    if ([type isEqualToString:requestType_POST] || [type isEqualToString:requestType_PUT]) {
        
        NSDictionary *headers = @{ @"content-type": @"application/json",@"cache-control": @"no-cache" };
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutInterval];
        [request setHTTPMethod:type];
        [request setAllHTTPHeaderFields:headers];
        if (paraments != nil) {
            NSData *postData = [NSJSONSerialization dataWithJSONObject:paraments options:0 error:nil];
            [request setHTTPBody:postData];
        }
        [request setValue:[UserEntity getLogInSuccessfullyToken] forHTTPHeaderField:@"Authorization"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    failureBlock(error);
                }
                else
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    successBlock(data,httpResponse);
                }
            });
        }];
        [dataTask resume];
    }
    else if ([type isEqualToString:requestType_GET])
    {
        NSDictionary *headers = @{ @"content-type": @"application/json",@"cache-control": @"no-cache" };
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutInterval];
        [request setHTTPMethod:requestType_GET];
        [request setAllHTTPHeaderFields:headers];
        [request setValue:[UserEntity getLogInSuccessfullyToken] forHTTPHeaderField:@"Authorization"];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    failureBlock(error);
                }
                else
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    successBlock(data,httpResponse);
                }
            });
        }];
        if (sessionDataTask.state == NSURLSessionTaskStateRunning) {
            [sessionDataTask cancel];
        }
        [sessionDataTask resume];
    }
    else if ([type isEqualToString:requestType_DELETE])
    {
        NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSMutableDictionary* dictionaryAdditionalHeaders = [[NSMutableDictionary alloc] init];
        
        [dictionaryAdditionalHeaders setObject:[UserEntity getLogInSuccessfullyToken] forKey:@"Authorization"];
        [dictionaryAdditionalHeaders setObject:@"application/json" forKey:@"Content-Type"];
        [dictionaryAdditionalHeaders setObject:@0 forKey:@"Content-Length"];
        
        [urlSessionConfiguration setHTTPAdditionalHeaders: dictionaryAdditionalHeaders];
        
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration: urlSessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]];
        
        NSMutableURLRequest* mutableUrlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeOutInterval];
        [mutableUrlRequest setHTTPMethod: @"DELETE"];
        
        [[urlSession dataTaskWithRequest:mutableUrlRequest completionHandler: ^(NSData *data, NSURLResponse* response, NSError* error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (error)
                  {
                      failureBlock(error);
                  }
                  else
                  {
                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                      successBlock(data,httpResponse);
                  }
              });
          }] resume];
    }
    else if (type == nil)
    {
        NSDictionary *headers = @{ @"content-type": @"application/x-www-form-urlencoded",@"cache-control": @"no-cache" };
        NSArray *arr_key = [paraments allKeys];
        NSString *post = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",arr_key[0],[paraments objectForKey:arr_key[0]],arr_key[1],[paraments objectForKey:arr_key[1]],arr_key[2],[paraments objectForKey:arr_key[2]],arr_key[3],[paraments objectForKey:arr_key[3]]];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseURL,urlString]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOutInterval];
        [request setHTTPMethod:requestType_POST];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
        [request setValue:[UserEntity getLogInSuccessfullyToken] forHTTPHeaderField:@"Authorization"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    failureBlock(error);
                }
                else
                {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    successBlock(data,httpResponse);
                }
            });
        }];
        if (dataTask.state == NSURLSessionTaskStateRunning) {
            [dataTask cancel];
        }
        [dataTask resume];
    }
}

+(void)cancelAllRequest
{
    NSURLSessionDataTask *dataTask;
    [dataTask cancel];
}

@end
