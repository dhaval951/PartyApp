//
//  SearchProvider.h
//  PartyApp
//
//  Created by Admin on 1/6/18.
//  Copyright © 2018 Vijay King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchProvider : NSObject

@property (nonatomic, strong) NSMutableDictionary *searchDict;
+(instancetype)sharedInstance;

@end
