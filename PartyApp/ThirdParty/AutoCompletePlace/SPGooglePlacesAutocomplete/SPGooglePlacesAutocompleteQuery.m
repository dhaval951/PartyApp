//
//  SPGooglePlacesAutocompleteQuery.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "AFNetworking.h"

@interface SPGooglePlacesAutocompleteQuery()
@property (nonatomic, copy, readwrite) SPGooglePlacesAutocompleteResultBlock resultBlock;
@end

@implementation SPGooglePlacesAutocompleteQuery

@synthesize input, sensor, key, offset, location, radius, language, types, resultBlock;

+ (SPGooglePlacesAutocompleteQuery *)query {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = kGoogleAPIKey;
        self.offset = NSNotFound;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = NSNotFound;
        self.types = -1;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

- (void)dealloc {
    googleConnection = nil;
    self.resultBlock = nil;
    input = nil;
    key = nil;
    language = nil;
}

- (NSString *)googleURLString {
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&sensor=true&key=%@",
                                                             [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], key];
    
    //types=establishment
//    if (offset != NSNotFound) {
//        [url appendFormat:@"&offset=%lu", (unsigned long)offset];
//    }
    if (location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", location.latitude, location.longitude];
    }
    if (radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", radius];
    }
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

- (void)fetchPlaces:(SPGooglePlacesAutocompleteResultBlock)block {
    if (!SPEnsureGoogleAPIKey()) {
        return;
    }
    
    if (SPIsEmptyString(self.input)) {
        // Empty input string. Don't even bother hitting Google.
        block([NSArray array], nil);
        return;
    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
        
    googleConnection  = [[AFHTTPSessionManager manager] GET:[self googleURLString]
                                                 parameters:nil
                                                   progress:nil
                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                                        if (task != googleConnection) {
                                                            return;
                                                        }
                                                        if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
                                                            [self succeedWithPlaces:[NSArray array]];
                                                            return;
                                                        }
                                                        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
                                                            [self succeedWithPlaces:[response objectForKey:@"predictions"]];
                                                            return;
                                                        }
                                                        
                                                        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
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

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place]];
    }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
    }
    [self cleanup];
}

@end
