//
//  UIDevice+Hardware.m
//  BarberShop
//
//  Created by Droisys Inc on 6/20/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import "UIDevice+Hardware.h"

@implementation UIDevice (Hardware)
@dynamic currentModel;

PVDeviceModel currentDeviceModel = PVDeviceModelUnknown;

-(PVDeviceModel)currentModel
{
    if (currentDeviceModel != PVDeviceModelUnknown) {
        return currentDeviceModel;
    }
    int screenHeight = (int)[[UIScreen mainScreen] bounds].size.height;
    if (self.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        if (screenHeight == 480) {
            currentDeviceModel = PVDeviceModeliPhone4S;
        }
        else if (screenHeight == 568) {
            currentDeviceModel = PVDeviceModeliPhone5S;
        }
        else if (screenHeight == 667) {
            currentDeviceModel = PVDeviceModeliPhone6;
        }
        else if (screenHeight == 736) {
            currentDeviceModel = PVDeviceModeliPhone6Plus;
        }
        else {
            currentDeviceModel = PVDeviceModeliPhone6Plus;
        }
    }
    else
    {
        if ([UIScreen mainScreen].scale == 1.0f) {
            currentDeviceModel = PVDeviceModeliPad2;
        }
        else {
            currentDeviceModel = PVDeviceModeliPadRatina;
        }
    }
    return currentDeviceModel;
}

@end
