//
//  LoginUser.h
//  PartyApp
//
//  Created by Admin on 12/14/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGINUSER [LoginUser sharedInstance]
#define ISLOGIN [LOGINUSER isLogin]

@interface LoginUser : NSObject

+(instancetype)sharedInstance;

-(BOOL)isLogin;

@end
