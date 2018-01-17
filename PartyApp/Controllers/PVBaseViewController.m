//
//  PVBaseViewController.m
//  PartyApp
//
//  Created by Admin on 12/14/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "PVBaseViewController.h"
#import "MFSideMenu.h"

@interface PVBaseViewController ()

- (IBAction)leftBarButtonPressed:(id)sender;

@end

@implementation PVBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftBarButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

@end
