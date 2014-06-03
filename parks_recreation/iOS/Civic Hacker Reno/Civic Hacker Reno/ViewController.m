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
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor colorWithRed:47/255.0f green:48/255.0f blue:6/255.0f alpha:1];
    [refresh addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refresh];
    
    parkArray = [[NSMutableArray alloc] init];
    [self reloadData:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Parks in Reno";
    [super viewWillAppear:animated];
}
-(IBAction)reloadData:(id)sender{
    [parkArray removeAllObjects];
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
    [(UIRefreshControl *)sender endRefreshing];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParksCell"];
     
     // Park name
     cell.textLabel.text = [parkArray[indexPath.row] objectForKey:@"Park Name"];
     // Park address
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ Reno",[parkArray[indexPath.row] objectForKey:@"Address"],[parkArray[indexPath.row] objectForKey:@"Quadrant"]];

     return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    self.navigationItem.title = @"Back";
    ParkDetailsViewController *destinationView = [segue destinationViewController];
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    destinationView.parkName = [parkArray[indexPath.row] objectForKey:@"Park Name"];
    destinationView.latitude = [[parkArray[indexPath.row] objectForKey:@"Latitude"] doubleValue];
    destinationView.longitude = [[parkArray[indexPath.row] objectForKey:@"Longitude"] doubleValue];


}
@end
