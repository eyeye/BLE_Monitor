//
//  PeripheralListController.m
//  BLE Monitor
//
//  Created by 杨志勇 on 13-3-12.
//  Copyright (c) 2013年 杨志勇. All rights reserved.
//

#import "PeripheralListController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Discovery.h"

@interface PeripheralListController () <DiscoveryDelegate>

//@property(nonatomic, strong) NSMutableArray *peripheralList;
//@property(nonatomic, strong) NSMutableArray *rssiList;
//@property(nonatomic, strong) CBCentralManager *centralManager;

@end

@implementation PeripheralListController

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
    
//    self.peripheralList = [NSMutableArray array];
//    self.rssiList = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing..."];
    [self.refreshControl addTarget:self action:@selector(scanPeripherals) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl endRefreshing];
    
//    if( self.centralManager == nil)
//    {
//        self.centralManager = [CBCentralManager alloc];
//    }
//
//    self.centralManager = [self.centralManager initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];

}


- (void) viewWillAppear:(BOOL)animated
{
//    if( self.centralManager == nil)
//    {
//        self.centralManager = [CBCentralManager alloc];
//    }
//    
//    self.centralManager = [self.centralManager initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    
    NSLog(@"view will appear");
    [[Discovery sharedInstance] setDelegate:self];
//    NSLog(@"%@", [Discovery sharedInstance].connectedPeripherals);
    [self.tableView reloadData];
}


- (void) startScan
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if(self.centralManager.state == CBCentralManagerStatePoweredOn)
//        {
//            [self.centralManager scanForPeripheralsWithServices:nil
//                                                       options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
//            NSLog(@"Scanning started");
//        }
//    });
    
    [[Discovery sharedInstance] startScan];
}

-(void) stopScan
{
    [self.refreshControl endRefreshing];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if(self.centralManager.state == CBCentralManagerStatePoweredOn)
//        {
////            [self.centralManager stopScan];
//            NSLog(@"Scanning stoped");
//        }
//    });
    
    [[Discovery sharedInstance] stopScan];
}


- (void) scanPeripherals
{
    [self startScan];
    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self stopScan];
    });
}


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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
//    return [self.peripheralList count];
    if( section == 0)
    {
        NSUInteger count = [[[Discovery sharedInstance] discoveredPeripherals] count];
        NSLog(@"numberOfRowsInSection %ld: %ld", (long)section, (long)count);
        return count;
    }
    else if( section == 1 )
    {
        NSUInteger count = [[[Discovery sharedInstance] connectedPeripherals] count];
        NSLog(@"numberOfRowsInSection %ld: %ld", (long)section, (long)count);
        return count;
    }
    else
    {
        return 0;
    }
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeripheralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    CBPeripheral* peripheral;
    if( indexPath.section == 0)
    {
        peripheral = [[[Discovery sharedInstance] discoveredPeripherals] objectAtIndex:indexPath.row];
    }
    else if(indexPath.section == 1)
    {
        peripheral = [[[Discovery sharedInstance] connectedPeripherals] objectAtIndex:indexPath.row];

    }
    
    cell.textLabel.text = peripheral.name;
    
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
    
    CBPeripheral *selectPeripheral;
    
    if(indexPath.section == 0)
        selectPeripheral = [[[Discovery sharedInstance] discoveredPeripherals] objectAtIndex:indexPath.row];
    else if(indexPath.section == 1)
        selectPeripheral = [[[Discovery sharedInstance] connectedPeripherals] objectAtIndex:indexPath.row];
    else
        return;
    
    if( !selectPeripheral.isConnected )
    {
         [[Discovery sharedInstance] connectPeripheral:selectPeripheral];
    }
       

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


//- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
//{
//    NSLog(@"Discovered a peripheral: %@,  RSSI: %@", peripheral.name, RSSI);
//    
//    
//    if( ![self.peripheralList containsObject:peripheral] )
//    {
//        [self.peripheralList addObject:peripheral];
//        [self.rssiList addObject:RSSI];
//        
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [self.tableView reloadData];
//        });
//    }
//    else
//    {
//        
//    }
//
//    self.rssiList[ [self.peripheralList indexOfObject:peripheral] ] = RSSI;
//
//    return;
//}
//

- (void) discoveryDidRefresh
{
    [self.tableView reloadData];
}


-(void) discoveryDidPowerOff
{
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue %@", segue.identifier);
    
    if( [segue.identifier isEqual: @"segueToServices"])
    {
        if (self.refreshControl.isRefreshing) {
            [self stopScan];
        }
        
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        CBPeripheral *selectPeripheral = self.peripheralList[indexPath.row];
//        CBCentralManager *centralManager = self.centralManager;
        
//        CBPeripheral *selectPeripheral;
//        
//        selectPeripheral = [[[Discovery sharedInstance] discoveredPeripherals] objectAtIndex:indexPath.row];
//        
//        [[Discovery sharedInstance] connectPeripheral:selectPeripheral];
        
//        id sevicesView = segue.destinationViewController;
        
//        [sevicesView setValue:[[[Discovery sharedInstance] discoveredPeripherals] objectAtIndex:indexPath.row]
//                       forKey:@"peripheral"];
        
//        [sevicesView setValue:centralManager forKey:@"centralManager"];
    }
}


@end



