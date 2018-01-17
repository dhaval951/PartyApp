//
//  UserPhotosViewController.m
//  PartyApp
//
//  Created by Admin on 12/29/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "UserPhotosViewController.h"
#import "AppConstants.h"
#import "ImageCollectionViewCell.h"
#import "IDMPhotoBrowser.h"

@interface UserPhotosViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray  *assets;

@end

@implementation UserPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Photos";
    NSURL *str = [[NSBundle mainBundle] URLForResource:@"daycare" withExtension:@"jpg"];
    self.assets = @[str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str,str
                    ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collectionview methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenSize   = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenSize.size.width;
    CGFloat cellSquareSize = (screenWidth / 3.0) - 5.0;
    return CGSizeMake(cellSquareSize, cellSquareSize);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4.0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSURL *asset = self.assets[indexPath.row];
    [cell.imageItem sd_setImageWithURL:asset placeholderImage:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotoURLs:self.assets animatedFromView:cell];
    
    // image browser controller
    browser.scaleImage = cell.imageItem.image;
    browser.displayCounterLabel = YES;
    browser.forceHideStatusBar = YES;
    browser.displayActionButton = false;
    browser.useWhiteBackgroundColor = YES;
    [browser setInitialPageIndex:indexPath.row];
    //    browser.view.tintColor = [UIColor blackColor];
    
    [self presentViewController:browser animated:true completion:^{
        
    }];
}

@end
