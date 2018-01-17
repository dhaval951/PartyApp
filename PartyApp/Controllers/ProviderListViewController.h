//
//  ProviderListViewController.h
//  PartyApp
//
//  Created by Admin on 12/9/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "PVBaseViewController.h"
#import "SearchViewController.h"

@protocol ProviderDelegate;
@interface ProviderListViewController : PVBaseViewController <ProviderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)loadProviderListFromServer;
@end
