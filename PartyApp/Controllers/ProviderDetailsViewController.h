//
//  ProviderDetailsViewController.h
//  PartyApp
//
//  Created by Admin on 12/21/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderDetailsViewController : UIViewController

@property (nonatomic, assign) NSString *productId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
