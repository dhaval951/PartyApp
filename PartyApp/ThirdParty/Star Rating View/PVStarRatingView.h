//
//  PVStarRatingView.h
//  Savvy
//
//  Created by Droisys Inc on 1/20/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

@import UIKit;

typedef BOOL(^PVStarRatingViewShouldBeginGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer);

IB_DESIGNABLE
@interface PVStarRatingView : UIControl
@property (nonatomic) IBInspectable NSUInteger maximumValue;
@property (nonatomic) IBInspectable CGFloat minimumValue;
@property (nonatomic) IBInspectable CGFloat value;
@property (nonatomic) IBInspectable CGFloat spacing;
@property (nonatomic) IBInspectable BOOL allowsHalfStars;
@property (nonatomic) IBInspectable BOOL accurateHalfStars;
@property (nonatomic) IBInspectable BOOL continuous;

@property (nonatomic) BOOL shouldBecomeFirstResponder;

// Optional: if `nil` method will return `NO`.
@property (nonatomic, copy) PVStarRatingViewShouldBeginGestureRecognizerBlock shouldBeginGestureRecognizerBlock;

@property (nonatomic, strong) IBInspectable UIImage *emptyStarImage;
@property (nonatomic, strong) IBInspectable UIImage *halfStarImage;
@property (nonatomic, strong) IBInspectable UIImage *filledStarImage;
@end
