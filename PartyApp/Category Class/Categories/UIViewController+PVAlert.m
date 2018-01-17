//
//  UIViewController+PVAlert.m
//  A360
//
//  Created by Admin on 6/15/17.
//  Copyright © 2017 Pradip Vanparia. All rights reserved.
//

#import "UIViewController+PVAlert.h"
#import <objc/runtime.h>

@implementation UIViewController (PVAlert)

- (void)showAlertString:(nullable NSString*)string;
{
    [self showAlertString:string completion:nil];
}

- (void)showAlertWithError:(NSError *_Nullable)error;
{
    if(error.code == NSURLErrorTimedOut
       && [error.domain isEqualToString:NSURLErrorDomain]) {
        
        error = [NSError errorWithDomain:NSURLErrorDomain
                                    code:NSURLErrorTimedOut
                                userInfo:@{NSLocalizedDescriptionKey : NSLocalizedString(@"TimeoutError", nil)}];
    }
    [self showAlertWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription completion:nil];
}

- (void)showAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;
{
    [self showAlertWithTitle:title message:message completion:nil];
}
- (void)showAlertString:(nullable NSString *)string completion:(void (^_Nullable)(void))completion;
{
    [self showAlertWithTitle:@"Alert" message:string completion:completion];

//    [self showAlertWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] message:string completion:completion];
}

- (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message completion:(void (^_Nullable)(void))completion;
{
    [self alertViewWithTitle:title
                     message:message
           cancelButtonTitle:NSLocalizedString(@"OK", nil)
           otherButtonTitles:nil
                   onDismiss:nil
                    onCancel:completion];
}

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                          message:(nullable NSString*) message;
{
    return [self alertViewWithTitle:title
                            message:message
                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                  otherButtonTitles:nil
                          onDismiss:nil
                           onCancel:nil];
}

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                          message:(nullable NSString*) message
                                cancelButtonTitle:(nullable NSString*) cancelButtonTitle;
{
    return [self alertViewWithTitle:title
                            message:message
                  cancelButtonTitle:cancelButtonTitle
                  otherButtonTitles:nil
                          onDismiss:nil
                           onCancel:nil];
}

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                          message:(nullable NSString*) message
                                cancelButtonTitle:(nullable NSString*) cancelButtonTitle
                                otherButtonTitles:(nullable NSArray*) otherButtons
                                        onDismiss:(nullable DismissBlock) dismissed
                                         onCancel:(nullable CancelBlock) cancelled;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButtonTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelled) {
                cancelled();
            }
        }]];
    }
    if (otherButtons) {
        for (NSString *btnTitle in otherButtons) {
            [alert addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (dismissed) {
                    dismissed([otherButtons indexOfObject:action.title]);
                }
            }]];

        }
    }
    
    [self.topmost presentViewController:alert animated:true completion:nil];
    return alert;
}

- (UIViewController *)topmost
{
    UIViewController *topmostController = self;
    
    UIViewController *above;
    while ((above = topmostController.presentedViewController)) {
        topmostController = above;
    }
    
    return topmostController;
}

@end
