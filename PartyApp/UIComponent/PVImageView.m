//
//  PVImageView.m
//  PartyApp
//
//  Created by Admin on 12/24/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "PVImageView.h"

/**
 * Product placeholder image name.
 */
static NSString *const defaultPlaceholderImage = @"placeholder.png";


@implementation PVImageView

#pragma mark - Initialization

- (instancetype)init {
    if ((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // rendering options
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = true;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.layer setMinificationFilter:kCAFilterTrilinear];
    self.clipsToBounds = YES;
    // placeholder image
    self.placeholderImage = [UIImage imageNamed:defaultPlaceholderImage];
}


@end

