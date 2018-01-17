//
//  SPGooglePlacesPlaceDetailQuery.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/18/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesPlaceDetailQuery.h"
#import "AFNetworking.h"

@interface SPGooglePlacesPlaceDetailQuery()
@property (nonatomic, copy, readwrite) SPGooglePlacesPlaceDetailResultBlock resultBlock;
@end

@implementation SPGooglePlacesPlaceDetailQuery

@synthesize reference, sensor, key, language, resultBlock;

+ (SPGooglePlacesPlaceDetailQuery *)query {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = kGoogleAPIKey;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

- (void)dealloc {
    
    googleConnection = nil;
    self.resultBlock = nil;
    reference = nil;
    key = nil;
    language = nil;
}

- (NSString *)googleURLString {
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=%@&key=%@",
                            reference, SPBooleanStringForBool(sensor), key];
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
    return url;
}

- (void)cleanup {
    googleConnection = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaceDetail:(SPGooglePlacesPlaceDetailResultBlock)block {
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    googleConnection  = [[AFHTTPSessionManager manager] GET:[self googleURLString]
                             parameters:nil
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                    if (task != googleConnection) {
                                        return;
                                    }
                                    if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
                                        [self succeedWithPlace:[response objectForKey:@"result"]];
                                        return;
                                    }
                                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
                                    [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];

                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    if (task != googleConnection) {
                                        return;
                                    }
                                    [self failWithError:error];
                                }];
    
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlace:(NSDictionary *)placeDictionary {
    if (self.resultBlock != nil) {
        self.resultBlock(placeDictionary, nil);
    }
    [self cleanup];
}

@end
