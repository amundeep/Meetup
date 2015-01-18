//
//  PlacesViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/17/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "PlacesViewController.h"

@interface PlacesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *placesTable;

@end

@implementation PlacesViewController
@synthesize myPlaces;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    myPlaces = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlacesArray"]];
    
    NSArray *businessArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlacesArray"];
    myPlaces = [[NSMutableArray alloc] init];
    
    for(NSDictionary *placesDict in businessArray){
        [myPlaces addObject:placesDict[@"name"]];
    }
    
    NSLog(@"%@", myPlaces);
//    myPlaces = [[NSMutableArray alloc] initWithObjects:@"Test Object 1", @"Test Object 2", nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myPlaces count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PlaceTableCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [myPlaces objectAtIndex:indexPath.row];
    NSLog(@"TEXT: %@", cell.textLabel.text);
    //    cell.classNameLabel = [myClasses objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"CELL INDEX: %li", (long)indexPath.row);
    NSLog(@"CELL NAME: %@", [myPlaces objectAtIndex:(long)indexPath.row]);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
