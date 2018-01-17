//
//  SocialLogin.h
//  PartyApp
//
//  Created by Admin on 12/7/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <linkedin-sdk/LISDK.h>

#define TWITTERKEY      @"FS91HCrW9saIzBBcsG0rRCH7P"
#define TWITTERSECRET   @"4SvlwQiXse9q8qKkXGHuHYKQz5Ex3DRp9oMACR0OdVcUzE750x"

#define LINKEDINAPPCLIENTID     @"78gaqnh2fx1aqr"
#define LINKEDINAPPSECRET       @"c4PTns8ixOTj7tGB"
#define LINKEDINAPPID           @"4728934"

#define GOOGLECLIENTID          @"807701704934-iabn91f59hpfho733mv7q5her6muceec.apps.googleusercontent.com"

typedef void (^PVGoogleLoginCompletion)(GIDGoogleUser * user, NSError * error);
typedef void (^PVLinkedInLoginCompletion)(GIDGoogleUser * user, NSError * error);

@interface SocialLogin : NSObject

+(SocialLogin *)sharedInstance;

-(void)loginWithFacebookFromViewController:(UIViewController *)viewController handler:(FBSDKLoginManagerRequestTokenHandler)handler;
-(void)loginWithTwitterWithCompletion:(TWTRLogInCompletion)completion;
-(void)loginWithGoogleFromViewController:(UIViewController *)viewController handler:(PVGoogleLoginCompletion)handler;
-(void)loginWithLinkedinFromViewController:(UIViewController *)viewController handler:(PVLinkedInLoginCompletion)handler;

@end
