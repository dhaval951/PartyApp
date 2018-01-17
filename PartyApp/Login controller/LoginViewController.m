//
//  LoginViewController.m
//  PartyApp
//
//  Created by Admin on 12/8/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "LoginViewController.h"
#import "AppConstants.h"
#import "UIViewController+PVAlert.h"
#import "SocialLogin.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnLoginPressed:(id)sender;
- (IBAction)btnFacebookPressed:(id)sender;
- (IBAction)btnTwitterPressed:(id)sender;
- (IBAction)btnGooglePressed:(id)sender;
- (IBAction)btnLinkedInPressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =BGCOLOR;
    self.title = @"Login";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSCharacterSet *trimSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *userEmail = [self.txtUserName.text stringByTrimmingCharactersInSet:trimSet];
    if (userEmail.length == 0) {
        [self showAlertString:@"Please enter username."];
        return;
    }
    
    NSString *password = _txtPassword.text;
    if (password.length==0) {
        [self showAlertString:@"Please enter password."];
        return;
    }
    
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    NSString* apiUrl = nil;
    userDict[@"username"] = userEmail;
    userDict[@"password"] = password;
    
    apiUrl = @"signin";
    
  
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [WSMANAGER post:apiUrl
         parameters:userDict
     withComplition:^(BOOL success, NSURLSessionDataTask *task, id response, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         if (success) {
             [[NSUserDefaults standardUserDefaults] setValue:response[@"id"] forKey:@"UserId"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [self openHomePage];
         }
         else {
             [self showAlertWithError:error];
         }
     }];
    
}

-(void)openHomePage {
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
    }];
  //  [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)btnFacebookPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:false];
    [[SocialLogin sharedInstance] loginWithFacebookFromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:false];
        if (error)
        {
            return;
        }
//        [self.navigationController dismissViewControllerAnimated:true completion:^{
//
//        }];
    }];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (IBAction)btnTwitterPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:false];
    [[SocialLogin sharedInstance] loginWithTwitterWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:false];
        if (error)
        {
            return;
        }
        else {
//        [self.navigationController dismissViewControllerAnimated:true completion:^{
//
//        }];
        }
    }];
}

- (IBAction)btnGooglePressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:false];
    [[SocialLogin sharedInstance] loginWithGoogleFromViewController:self handler:^(GIDGoogleUser *user, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:false];
        if (error)
        {
            return;
        }
//        [self.navigationController dismissViewControllerAnimated:true completion:^{
//
//        }];
    }];
}

- (IBAction)btnLinkedInPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:false];
    [[SocialLogin sharedInstance] loginWithLinkedinFromViewController:self handler:^(GIDGoogleUser *user, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:false];
        if (error)
        {
            return;
        }
        [self.navigationController dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)btnCancelPressed:(id)sender {
    [self openHomePage];
}

@end
