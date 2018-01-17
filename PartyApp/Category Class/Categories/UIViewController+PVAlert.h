//
//  UIViewController+PVAlert.h
//  A360
//
//  Created by Admin on 6/15/17.
//  Copyright © 2017 Pradip Vanparia. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^VoidBlock)();

typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();

@interface UIViewController (PVAlert)


//@property (nonatomic, copy) DismissBlock _Nullable dismissBlock;
//@property (nonatomic, copy) CancelBlock _Nullable cancelBlock;


- (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
- (void)showAlertString:(nullable NSString*)string;
- (void)showAlertString:(nullable NSString *)string completion:(void (^_Nullable)(void))completion;
- (void)showAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message completion:(void (^_Nullable)(void))completion;
- (void)showAlertWithError:(nullable NSError *)error;

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                  message:(nullable NSString*) message;

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                  message:(nullable NSString*) message
                        cancelButtonTitle:(nullable NSString*) cancelButtonTitle;

- (UIAlertController*_Nonnull) alertViewWithTitle:(nullable NSString*) title
                                  message:(nullable NSString*) message
                        cancelButtonTitle:(nullable NSString*) cancelButtonTitle
                        otherButtonTitles:(nullable NSArray*) otherButtons
                                onDismiss:(nullable DismissBlock) dismissed
                                 onCancel:(nullable CancelBlock) cancelled;

@end
