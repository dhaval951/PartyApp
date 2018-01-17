//
//  WSManager.h
//  Notebook
//
//  Created by Admin on 5/13/17.
//  Copyright © 2017 Pradip Vanparia. All rights reserved.
//

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#define WSMANAGER [WSManager sharedManager]

typedef void (^PVResultBlock)(BOOL success, NSURLSessionDataTask *task, id response, NSError*error);

@interface WSManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

+(NSString *)jsonStringForJsonObject:(id)jsonObject error:(NSError **)error;

-(NSURLSessionDataTask *)post:(NSString *)url
                   parameters:(id)parameters
               withComplition:(PVResultBlock)handler;


-(NSURLSessionDataTask *)get:(NSString *)url
                  parameters:(id)parameters
              withComplition:(PVResultBlock)handler;

@end
