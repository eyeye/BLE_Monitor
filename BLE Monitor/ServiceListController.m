//
//  ServiceListController.m
//  BLE Monitor
//
//  Created by 杨志勇 on 13-3-13.
//  Copyright (c) 2013年 杨志勇. All rights reserved.
//

#import "ServiceListController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Discovery.h"

@interface ServiceListController ()<DiscoveryDelegate>
//@property(nonatomic, strong) CBCentralManager *centralManager;
//@property(nonatomic, strong) CBPeripheral *peripheral;
//@property(nonatomic, strong) NSMutableArray *serviceList;
@end

@implementation ServiceListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    NSLog(@"Peripheral: %@", self.peripheral);
//    
//    self.serviceList = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing..."];
    [self.refreshControl addTarget:self action:@selector(reloadServices) forControlEvents:UIControlEventValueChanged];
    
    [[Discovery sharedInstance] setDelegate:self];
}


-(void) reloadServices
{
    NSLog(@"reloadServices start");
//    [self.tableView reloadData];
    [[Discovery sharedInstance] startScan];
    NSLog(@"reloadServices end");
}

- (void) viewWillAppear:(BOOL)animated
{
//    if( self.centralManager == nil)
//    {
//        self.centralManager = [CBCentralManager alloc];
//    }
//    
//    self.centralManager = [self.centralManager initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
//    
//    if(self.peripheral != nil)
//    {
//        NSLog(@"Connect peripheral");
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [self.centralManager connectPeripheral:self.peripheral options:nil];
//        });
//    }
//    else
//    {
//        NSLog(@"No peripheral");
//    }
    
    [[Discovery sharedInstance] setDelegate:self];
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
//- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
//    //[self cleanup];
//}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
//{
//    NSLog(@"Peripheral Connected");
//    // Make sure we get the discovery callbacks
//    peripheral.delegate = self;
//    
//    // Search only for services that match our UUID
//    [peripheral discoverServices:nil];
//}

/** The Transfer Service was discovered
 */
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
//    if (error) {
//        NSLog(@"Error discovering services: %@", [error localizedDescription]);
//        return;
//    }
//    
//    NSLog(@"Found Services.");
//    for (CBService *service in peripheral.services)
//    {
//        NSLog(@"Service: %@", service.UUID);
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    return 1;
    NSLog(@"所有连接的外设: %@", [[Discovery sharedInstance] connectedPeripherals]);
    NSInteger count = [[[Discovery sharedInstance] connectedPeripherals] count];
    NSLog(@"numberOfSectionsInTableView: %ld", (long)count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return [self.peripheral.services count];
    NSLog(@"当前连接外设的服务: %@", [[[[Discovery sharedInstance] connectedPeripherals]  objectAtIndex:section] services] );
    NSInteger count = [[[[[Discovery sharedInstance] connectedPeripherals] objectAtIndex:section] services] count];
    NSLog(@"numberOfRowsInSection: %ld", (long)count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
//    cell.textLabel.text = [ [NSString alloc] initWithFormat:@"UUID: %@", self.peripheral.services[indexPath.row] ];
    NSLog(@"cellForRowAtIndexPath: %@", indexPath);
    
    CBPeripheral* peripheral = [[[Discovery sharedInstance] connectedPeripherals] objectAtIndex:indexPath.section];
    CBService* service = [peripheral.services objectAtIndex:indexPath.row];
        
    NSLog(@"service UUID: %@", service.UUID);
    
//    cell.textLabel.text = [ [NSString alloc] initWithData:service.UUID.data encoding:NSUTF8StringEncoding];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", service.UUID ];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



//- (void)centralManagerDidUpdateState:(CBCentralManager *)central
//{
//    NSLog(@"State updated: %d", central.state);
//    
//    if (central.state != CBCentralManagerStatePoweredOn)
//    {
//        return ;
//    }
//    else
//    {
//        ;
//    }
//}


#pragma mark - Discovery delegate

-(void) discoveryDidRefresh
{
    NSLog(@"refresh services.");
    [self.tableView reloadData];
}



-(void) discoveryDidPowerOff
{
    NSLog(@"discoveryDidPowerOff.");
}


@end
