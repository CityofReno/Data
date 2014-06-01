//
//  ViewController.m
//  Civic Hacker Reno
//
//  Created by Haifisch on 6/1/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import "ViewController.h"
#define PARKS_JSON_URL @"https://raw.githubusercontent.com/CityofReno/Data/master/parks_recreation/park_inventory_2014.json"
@interface ViewController () {
    NSMutableArray *parkArray;
    MBProgressHUD *HUD;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    parkArray = [[NSMutableArray alloc] init];
    [self reloadData:nil];
}
-(IBAction)reloadData:(id)sender{
    [parkArray removeAllObjects];
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
}
-(void)loadData {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:PARKS_JSON_URL]];
    if (!(data == nil)) {
        NSError *error;
        parkArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error] mutableCopy];
        if (!error) {
            //NSLog(@"%@",parkArray[0]);
            [self.tableView reloadData];
        }else {
            [[[UIAlertView alloc] initWithTitle:@"Couldn't get data!" message:@"Connect to the internet and re-try" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            NSLog(@"%@",error);
        }
    }else {
        [[[UIAlertView alloc] initWithTitle:@"Couldn't get data!" message:@"Connect to the internet and re-try" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [parkArray count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCell *cell;
     UILabel *parkName;
     UILabel *parkAddress;
     if (cell == nil) {
         cell = [[UITableViewCell alloc] init];
         
         parkName = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 300, 25)];
         parkAddress = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 300, 25)];
         
         [cell addSubview:parkAddress];
         [cell addSubview:parkName];


     }
     // Park name
     parkName.text = [parkArray[indexPath.row] objectForKey:@"Park Name"];
     // Park address
     parkAddress.text = [NSString stringWithFormat:@"%@ - %@ Reno",[parkArray[indexPath.row] objectForKey:@"Address"],[parkArray[indexPath.row] objectForKey:@"Quadrant"]];

     return cell;
 }
@end
