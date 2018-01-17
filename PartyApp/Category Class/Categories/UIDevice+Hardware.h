//
//  UIDevice+Hardware.h
//  BarberShop
//
//  Created by Droisys Inc on 6/20/16.
//  Copyright © 2016 Pradip Vanparia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CURRENTMODEL [[UIDevice currentDevice] currentModel]

typedef NS_ENUM(NSInteger, PVDeviceModel) {
    PVDeviceModeliPhone4S,
    PVDeviceModeliPhone5S,
    PVDeviceModeliPhone6,
    PVDeviceModeliPhone6Plus,
    PVDeviceModeliPad2,
    PVDeviceModeliPadRatina,
    PVDeviceModelUnknown
};

@interface UIDevice (Hardware)

@property (nonatomic, readonly) PVDeviceModel currentModel;

@end
