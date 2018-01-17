//
//  AboutProviderCell.h
//  PartyApp
//
//  Created by Admin on 12/24/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AboutProviderCellDelegate;
@class ResponsiveLabel;
@interface AboutProviderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ResponsiveLabel *lblAbout;
@property (nonatomic, weak) id <AboutProviderCellDelegate> delegate;

- (void)configureText:(NSString*)str forExpandedState:(BOOL)isExpanded;
@end

@protocol AboutProviderCellDelegate<NSObject>

-(void)cell:(AboutProviderCell *)cell isExpanded:(BOOL)expanded;

@end
