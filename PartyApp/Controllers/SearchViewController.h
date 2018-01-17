//
//  SearchViewController.h
//  PartyApp
//
//  Created by Admin on 12/28/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProviderDelegate;
@interface SearchViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *providerList;

@property (nonatomic, assign)   id<ProviderDelegate> delegate;
@end

@protocol ProviderDelegate <NSObject>

@optional
- (void)searchDidDismisWithData:(NSMutableArray*)data;
- (void)didPressedSeachButton;

@end
