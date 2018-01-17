//
//  UIColor+HexColor.h
//  Kiosk
//
//  Created by Droisys Inc on 7/1/16.
//  Copyright © 2016 Droisys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
