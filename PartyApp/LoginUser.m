//
//  LoginUser.m
//  PartyApp
//
//  Created by Admin on 12/14/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "LoginUser.h"

@implementation LoginUser

static __strong LoginUser *_loginUserSharedInstance = nil;

+(instancetype)sharedInstance;
{
    if (!_loginUserSharedInstance) {
        _loginUserSharedInstance = [[LoginUser alloc] init];
    }
    
    return _loginUserSharedInstance;
}

-(BOOL)isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}

@end
