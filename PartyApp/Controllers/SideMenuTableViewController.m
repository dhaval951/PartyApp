//
//  SideMenuTableViewController.m
//  PartyApp
//
//  Created by Admin on 12/9/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "MFSideMenu.h"

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            break;
        case 1:
            cell.textLabel.text = @"My party";
            break;
        case 2:
            cell.textLabel.text = @"My photo";
            break;
        case 3:
            cell.textLabel.text = @"Inbox";
            break;
        case 4:
            cell.textLabel.text = @"Provider";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    UIViewController *vc = nil;
    UIStoryboard *storyboard_myprofile = [UIStoryboard storyboardWithName:@"MyProfile" bundle:[NSBundle mainBundle]];
    
    switch (indexPath.row) {
        case 0:

            if([[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] != nil){
                vc = [storyboard_myprofile instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
            }
            else{
//                UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//
//                vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserPhotosViewController"];

                UIStoryboard *loginStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
                    UIViewController *viewController = [loginStoryBoard instantiateInitialViewController];
                
                    [self presentViewController:viewController animated:false completion:^{
                        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
                            
                        }];
                    }];
                return;
            }
            break;
        case 1:
            break;
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserPhotosViewController"];
            break;
        case 3:
            break;
        case 4:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProviderListViewController"];
            break;
        default:
            break;
    }
    if (!vc) {
        vc = [[UIViewController alloc] init];
    }

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.menuContainerViewController setCenterViewController:nav];
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

@end
