//
//  PhotosTableViewCell.h
//  PartyApp
//
//  Created by Admin on 12/29/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoTableViewCellDelegate;
@interface PhotosTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *photo1btn;
@property (weak, nonatomic) IBOutlet UIButton *photo2Btn;
@property (weak, nonatomic) IBOutlet UIButton *photo3Btn;
@property (weak, nonatomic) IBOutlet UIButton *seeAllPhotosBtn;
@property (nonatomic, weak) id <PhotoTableViewCellDelegate> delegate;

- (IBAction)photoBtnPressed:(UIButton *)btn;
- (IBAction)seeAllPhotosBtnPressed:(id)sender;

@end

@protocol PhotoTableViewCellDelegate <NSObject>

-(void)didPressedSeeAllPhotosForCell:(PhotosTableViewCell *)cell;
-(void)cell:(PhotosTableViewCell *)cell didPressedPhoto:(UIButton *)btn;

@end
