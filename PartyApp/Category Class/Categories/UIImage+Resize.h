//
//  UIImage+Resize.h
//  Pradip Vanparia
//
//  Created by Pradip Vanparia on 6/24/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *) resizedImageByMaxSize:(NSUInteger)max;
- (UIImage *)resizedImageByWidth:(NSUInteger) width;
- (UIImage *)resizedImageByHeight:(NSUInteger) height;
- (UIImage *)imageWithColor:(UIColor *)color1;


@end
