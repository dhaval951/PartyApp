//
//  SocialLogin.m
//  PartyApp
//
//  Created by Admin on 12/7/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "SocialLogin.h"

@interface SocialLogin() <GIDSignInDelegate, GIDSignInUIDelegate>

@property (nonatomic) PVGoogleLoginCompletion googleCompletion;
@property (nonatomic) PVLinkedInLoginCompletion linkedInCompletion;
@property (nonatomic, assign) UIViewController *parentController;

@end

@implementation SocialLogin

static __strong SocialLogin *_socialLoginSharedInstance;

+(SocialLogin *)sharedInstance {
    if (!_socialLoginSharedInstance) {
        _socialLoginSharedInstance = [[SocialLogin alloc] init];
    }
    return _socialLoginSharedInstance;
}

-(void)loginWithFacebookFromViewController:(UIViewController *)viewController handler:(FBSDKLoginManagerRequestTokenHandler)handler;
{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email"]
                        fromViewController:viewController
                                   handler:handler];
}

-(void)loginWithTwitterWithCompletion:(TWTRLogInCompletion)completion;
{
    [[Twitter sharedInstance] startWithConsumerKey:TWITTERKEY consumerSecret:TWITTERSECRET];
    [[Twitter sharedInstance] logInWithCompletion:completion];
}

-(void)loginWithGoogleFromViewController:(UIViewController *)viewController handler:(PVGoogleLoginCompletion)handler
{
    _googleCompletion = handler;
    _parentController = viewController;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [_parentController presentViewController:viewController animated:false completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:false completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error;
{
    _googleCompletion(user,error);
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error;
{
    _googleCompletion(user,error);
}

-(void)loginWithLinkedinFromViewController:(UIViewController *)viewController handler:(PVLinkedInLoginCompletion)handler
{
    _linkedInCompletion = handler;
    _parentController = viewController;
    [LISDKSessionManager createSessionWithAuth:@[LISDK_BASIC_PROFILE_PERMISSION]
                                         state:nil
                        showGoToAppStoreDialog:true
                                  successBlock:^(NSString *success) {
                                      [self getLinkedinUserDetails];
                                  } errorBlock:^(NSError *error) {
                                      _linkedInCompletion(nil,error);
                                  }];
}

-(void)getLinkedinUserDetails {
    [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
                                        success:^(LISDKAPIResponse *response) {
                                            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[response.data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
                                            _linkedInCompletion(nil,nil);
                                        } error:^(LISDKAPIError *error) {
                                            _linkedInCompletion(nil,error);
                                        }];
}

@end
