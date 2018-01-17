//
//  UIImage+Resize.m
//  Pradip Vanparia
//
//  Created by Pradip Vanparia on 6/24/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (CGImageRef) CGImageWithCorrectOrientation CF_RETURNS_RETAINED
{
    if (self.imageOrientation == UIImageOrientationDown) {
        //retaining because caller expects to own the reference
        CGImageRef cgImage = [self CGImage];
        CGImageRetain(cgImage);
        return cgImage;
    }
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, 90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, -90 * M_PI/180);
    } else if (self.imageOrientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, 180 * M_PI/180);
    }
    
    [self drawAtPoint:CGPointMake(0, 0)];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    return cgImage;
}

- (UIImage *) resizedImageByMaxSize:(NSUInteger)max;
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGImageRelease(imgRef);
    CGFloat ratio = original_width/original_height;
    if (ratio<1) {
        CGFloat h_ratio = max/original_height;
        return [self drawImageInBounds:CGRectMake(0,0,round(original_width * h_ratio),max)];
    }
    else {
        CGFloat w_ratio = max/original_width;
        return [self drawImageInBounds:CGRectMake(0,0,max,round(original_height * w_ratio))];
    }
}

- (UIImage *)resizedImageByWidth:(NSUInteger) width
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = width/original_width;
    CGImageRelease(imgRef);
    return [self drawImageInBounds:CGRectMake(0,0,width,round(original_height * ratio))];
}

- (UIImage *)resizedImageByHeight:(NSUInteger) height
{
    CGImageRef imgRef = [self CGImageWithCorrectOrientation];
    CGFloat original_width  = CGImageGetWidth(imgRef);
    CGFloat original_height = CGImageGetHeight(imgRef);
    CGFloat ratio = height/original_height;
    CGImageRelease(imgRef);
    return [self drawImageInBounds:CGRectMake(0,0,round(original_width * ratio),height)];
}


- (UIImage *) drawImageInBounds:(CGRect)bounds
{
    UIImage *resizedImage;
//    @autoreleasepool {
        UIGraphicsBeginImageContext(bounds.size);
        [self drawInRect: bounds];
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
//    }
    return resizedImage;
}

- (UIImage *)imageWithColor:(UIColor *)color1
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color1 setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
