//
//  AppDelegate.m
//  PartyApp
//
//  Created by Admin on 12/4/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConstants.h"
#import "MFSideMenu.h"
#import "SocialLogin.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [GIDSignIn sharedInstance].clientID = GOOGLECLIENTID;
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSArray<UIColor *> *colours = @[RGBCOLOR(0, 174, 239),GRADIENTCOLOR2];

    UIImage *background = [UIImage add_imageWithGradient:colours size:[UIScreen mainScreen].bounds.size direction:ADDImageGradientDirectionLeftSlanted];

    [[UINavigationBar appearance] setBackgroundImage:background forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBarTintColor:BGCOLOR];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTranslucent:NO];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *mainNavigation = (UINavigationController *)self.window.rootViewController;
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)mainNavigation.viewControllers[0];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    UINavigationController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"LeftSideMenuController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    [container setCenterViewController:navigationController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    if([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:app
                                         openURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    if (handled) return handled;
    
    handled = [[Twitter sharedInstance] application:app openURL:url options:options];
    if (handled) return handled;
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                        sourceApplication:sourceApplication
//                                                               annotation:annotation];
//    if (handled) return handled;
//    
//    handled = [[Twitter sharedInstance] application:application openURL:url options:nil];
//    if (handled) return handled;
//    
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:sourceApplication
//                                      annotation:annotation];
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
