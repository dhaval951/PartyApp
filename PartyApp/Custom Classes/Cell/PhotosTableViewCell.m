//
//  PhotosTableViewCell.m
//  PartyApp
//
//  Created by Admin on 12/29/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "PhotosTableViewCell.h"

@implementation PhotosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)photoBtnPressed:(UIButton *)btn {
    
}

- (IBAction)seeAllPhotosBtnPressed:(id)sender {
    [_delegate didPressedSeeAllPhotosForCell:self];
}

@end
