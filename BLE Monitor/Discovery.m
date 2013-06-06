//
//  Discovery.m
//  BLE Monitor
//
//  Created by 杨志勇 on 13-6-4.
//  Copyright (c) 2013年 杨志勇. All rights reserved.
//

#import "Discovery.h"


@interface Discovery () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
	CBCentralManager    *centralManager;
//	BOOL				pendingInit;
}
@end


@implementation Discovery


+ (id) sharedInstance
{
    static Discovery *shareDiscovery = nil;
    
    if( !shareDiscovery )
    {
        shareDiscovery = [[Discovery alloc] init];
    }
    
    return shareDiscovery;
}



- (id) init
{
    self = [super init];
    if(self)
    {
//        pendingInit = YES;
//        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];

        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() ];
        
        _discoveredPeripherals = [[NSMutableArray alloc] init];
        _connectedPeripherals = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void) dealloc
{
    assert(NO);
}


-(void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    CBPeripheral *peripheral;
    
    for (peripheral in peripherals) {
        [central connectPeripheral:peripheral options:nil];
    }
    
    [_delegate discoveryDidRefresh];
}


-(void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    CBPeripheral *peripheral;
    
    for (peripheral in peripherals) {
        [central connectPeripheral:peripheral options:nil];
    }
    
    [_delegate discoveryDidRefresh];
}


-(void) startScan
{
    [centralManager scanForPeripheralsWithServices:nil options:nil];
}

-(void) stopScan
{
    NSLog(@"停止扫描设备");
//    [centralManager stopScan];
}


-(void) connectPeripheral:(CBPeripheral*) peripheral
{
    if (![peripheral isConnected]) {
        NSLog(@"正在连接设备。。。");
        NSDictionary* connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
        [centralManager connectPeripheral:peripheral options:connectOptions];
    }
}


-(void) disconnectPeripheral:(CBPeripheral*) peripheral
{
    [centralManager cancelPeripheralConnection:peripheral];
}


-(void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![_discoveredPeripherals containsObject:peripheral]) {
        [_discoveredPeripherals addObject:peripheral];
        [_delegate discoveryDidRefresh];
    }
}


-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (![_connectedPeripherals containsObject:peripheral])
    {
        [_connectedPeripherals addObject:peripheral];
        NSLog(@"设备已连接: %@", peripheral);
        [peripheral setDelegate:self];
    }
    
    if ([_discoveredPeripherals containsObject:peripheral])
    {
        [_discoveredPeripherals removeObject:peripheral];
    }
    
    [peripheral discoverServices: nil];

    [_delegate discoveryDidRefresh];

}


-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"ailToConnectPeripheral: %@, with error: %@", [peripheral name], [error localizedDescription]);
}


-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    CBPeripheral *connectedPeripheral = nil;
    
    for (connectedPeripheral in _connectedPeripherals)
    {
        if (connectedPeripheral == peripheral)
        {
            [_connectedPeripherals removeObject:connectedPeripheral];
            NSLog(@"设备断开连接: %@", connectedPeripheral);
        }
    }
    
    [_delegate discoveryDidRefresh];
}



-(void) clearPeripherals
{
    [_discoveredPeripherals removeAllObjects];
    [_connectedPeripherals removeAllObjects];
}



- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
//    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearPeripherals];
            [_delegate discoveryDidRefresh];

            
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
//            if (previousState != -1) {
//                [discoveryDelegate discoveryStatePoweredOff];
//            }
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
//			pendingInit = NO;
//			[self loadSavedDevices];
//			[centralManager retrieveConnectedPeripherals];
//			[discoveryDelegate discoveryDidRefresh];
            
            [centralManager retrieveConnectedPeripherals];
            
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
//			[self clearDevices];
//            [discoveryDelegate discoveryDidRefresh];
//            [peripheralDelegate alarmServiceDidReset];
            
            [self clearPeripherals];
            [_delegate discoveryDidRefresh];
            
            
//			pendingInit = YES;
			break;
		}
            
        default:
        {
            break;
        }
            
	}
    
//    previousState = [centralManager state];
}


-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"发现服务：%@", peripheral.services);
    [_delegate discoveryDidRefresh];
}


@end






