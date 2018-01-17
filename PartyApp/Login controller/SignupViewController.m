//
//  SignupViewController.m
//  PartyApp
//
//  Created by Admin on 12/9/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "SignupViewController.h"
#import "AppConstants.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignupPressed:(id)sender;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSignupPressed:(id)sender {
    [self.view endEditing:YES];
    
    NSCharacterSet *trimSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *firstname = [self.txtFirstname.text stringByTrimmingCharactersInSet:trimSet];
    if (firstname.length == 0) {
        [self showAlertString:@"Please enter firstname."];
        return;
    }
    
    NSString *lastname = [self.txtLastname.text stringByTrimmingCharactersInSet:trimSet];
    if (lastname.length == 0) {
        [self showAlertString:@"Please enter lastname."];
        return;
    }
    
    NSString *useremail = [self.txtUsername.text stringByTrimmingCharactersInSet:trimSet];
    if (useremail.length == 0) {
        [self showAlertString:@"Please enter email address."];
        return;
    }
    
    NSString *username = [self.txtUsername.text stringByTrimmingCharactersInSet:trimSet];
    if (username.length == 0) {
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
    userDict[@"firstname"] = firstname;
    userDict[@"lastname"] = lastname;
    userDict[@"email"] = useremail;
    userDict[@"username"] = username;
    userDict[@"password"] = password;
    
    apiUrl = @"signup";
    
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
}

@end
