//
//  Discovery.h
//  BLE Monitor
//
//  Created by 杨志勇 on 13-6-4.
//  Copyright (c) 2013年 杨志勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol DiscoveryDelegate <NSObject>

-(void) discoveryDidRefresh;
-(void) discoveryDidPowerOff;

@end



@interface Discovery : NSObject

+ (id) sharedInstance;
-(void) startScan;
-(void) stopScan;

-(void) connectPeripheral:(CBPeripheral*) peripheral;
-(void) disconnectPeripheral:(CBPeripheral*) peripheral;
//- (void) connectPeripheral:(CBPeripheral*)peripheral;

@property (strong, nonatomic) id<DiscoveryDelegate> delegate;


@property (strong, nonatomic) NSMutableArray *discoveredPeripherals;
@property (strong, nonatomic) NSMutableArray *connectedPeripherals;

@end




