//
//  UIView+Extension.h
//  BarberShop
//
//  Created by Droisys Inc on 6/22/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UIView (Extension)

@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign)IBInspectable CGFloat borderWidth;

@property (nonatomic, assign)IBInspectable UIColor *borderColor;

@end
