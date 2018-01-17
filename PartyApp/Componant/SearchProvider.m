//
//  SearchProvider.m
//  PartyApp
//
//  Created by Admin on 1/6/18.
//  Copyright © 2018 Vijay King. All rights reserved.
//

#import "SearchProvider.h"

@implementation SearchProvider

static __strong SearchProvider *__seachProvider = nil;
+(instancetype)sharedInstance {
    
    if (!__seachProvider) {
        __seachProvider = [[SearchProvider alloc] init];
    }
    return __seachProvider;
}

-(NSMutableDictionary *)searchDict {
    if (!_searchDict) {
        _searchDict = [NSMutableDictionary dictionary];
    }
    return _searchDict;
}

@end
