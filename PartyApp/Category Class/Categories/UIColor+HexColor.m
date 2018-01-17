//
//  UIColor+HexColor.m
//  Kiosk
//
//  Created by Droisys Inc on 7/1/16.
//  Copyright © 2016 Droisys. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    UIColor *color = nil;
    @try {
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        if ([hexString hasPrefix:@"#"])
            [scanner setScanLocation:1]; // bypass '#' character
        else
            [scanner setScanLocation:0];
        [scanner scanHexInt:&rgbValue];
        color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return color;
}
@end
