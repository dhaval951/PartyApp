//
//  UIView+Extension.m
//  BarberShop
//
//  Created by Droisys Inc on 6/22/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

-(UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth/[UIScreen mainScreen].scale;
}

-(CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

@end
