//
//  WSManager.m
//  Notebook
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 Pradip Vanparia. All rights reserved.
//

#import "WSManager.h"

static NSString * const APIBaseURLString = @"http://ec2-18-217-9-191.us-east-2.compute.amazonaws.com:8001/api/";

@implementation WSManager

+(NSString *)jsonStringForJsonObject:(id)jsonObject error:(NSError **)error;
{
    if (!jsonObject) {
        return nil;
    }
    if (![NSJSONSerialization isValidJSONObject:jsonObject]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:error];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else return nil;
}

+ (instancetype)sharedManager {
    static WSManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WSManager alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

    });
    
    return _sharedClient;
}
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super  initWithBaseURL:url];
    if (self) {
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

-(NSURLSessionDataTask *)post:(NSString *)url
                   parameters:(id)parameters
               withComplition:(PVResultBlock)handler;
{
    __block PVResultBlock block = [handler copy];
    
    NSURLSessionDataTask *__task = [self POST:url
                                   parameters:parameters
                                     progress:nil
                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                          [self handleResponseForTask:task
                                                         withResponse:responseObject
                                                       withComplition:block];
                                      }
                                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                          if (block)
                                              block(NO, task, nil, error);
                                          block = nil;
                                      }];
    return __task;
}

-(NSURLSessionDataTask *)get:(NSString *)url
                  parameters:(id)parameters
              withComplition:(PVResultBlock)handler;
{
    __block PVResultBlock block = [handler copy];
    
    NSURLSessionDataTask *__task = [self GET:url
                                  parameters:parameters
                                    progress:nil
                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                        [self handleResponseForTask:task
                                                       withResponse:responseObject
                                                     withComplition:block];
                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                         if (block)
                                             block(NO, task, nil, error);
                                         block = nil;
                                     }];
    return __task;
}

-(void)handleResponseForTask:(NSURLSessionDataTask * _Nonnull)task
                withResponse:(id _Nullable)responseObject
              withComplition:(PVResultBlock)block;
{
    NSDictionary *responseDict = responseObject;
    
    if ([[responseDict allKeys] containsObject:@"error"]) {
        if ([responseDict[@"error"] intValue] == 0) {
            if (block)
                block(YES, task, responseDict,nil);
            block = nil;
        }
    }
    
    if ([[responseDict allKeys] containsObject:@"success"]) {
        if ([responseDict[@"success"] intValue] == 1) {
            if (block)
                block(YES, task, responseDict,nil);
            block = nil;
        }
    }
  
    if ([responseDict[@"message"] isKindOfClass:[NSString class]]) {
        NSError *error = [NSError errorWithDomain:@"Error" code:INT32_MAX userInfo:@{NSLocalizedDescriptionKey:responseDict[@"message"]}];
        if (block)
            block(NO, task, responseDict,error);
        block = nil;
    }
    else if ([responseDict[@"Message"] isKindOfClass:[NSString class]]) {
        NSError *error = [NSError errorWithDomain:@"Error" code:INT32_MAX userInfo:@{NSLocalizedDescriptionKey:responseDict[@"Message"]}];
        if (block)
            block(NO, task, responseDict,error);
        block = nil;
    }
    else {
        NSError *error = [NSError errorWithDomain:@"Error" code:INT32_MAX userInfo:@{NSLocalizedDescriptionKey:@"Something went wrong. Please try again later."}];
        if (block)
            block(NO, task, responseObject,error);
        block = nil;
    }
}

@end
