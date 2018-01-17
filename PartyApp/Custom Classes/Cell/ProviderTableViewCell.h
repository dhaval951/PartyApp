//
//  ProviderTableViewCell.h
//  PartyApp
//
//  Created by Admin on 12/11/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVStarRatingView.h"

@interface ProviderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *providerImageView;
@property (weak, nonatomic) IBOutlet UILabel *providerName;
@property (weak, nonatomic) IBOutlet UILabel *providerDesc;
@property (weak, nonatomic) IBOutlet PVStarRatingView *rating;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
