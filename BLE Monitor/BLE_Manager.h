//
//  BLE_Manager.h
//  BLE Monitor
//
//  Created by 杨志勇 on 13-6-4.
//  Copyright (c) 2013年 杨志勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLE_Manager : NSObject

@property(nonatomic, strong) CBCentralManager *centralManager;


@end
