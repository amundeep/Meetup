//
//  PlacesViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/17/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "PlacesViewController.h"
#import "FinalizeViewController.h"
#import <Firebase/Firebase.h>
#import <FacebookSDK/FacebookSDK.h>


@interface PlacesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *placesTable;

@end

@implementation PlacesViewController
@synthesize myPlaces;
@synthesize myVicinities;
@synthesize myLats;
@synthesize myLongs;
@synthesize mapHolderView;
@synthesize mapView;
@synthesize cancelButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    myPlaces = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"PlacesArray"]];
    
    NSArray *businessArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlacesArray"];
    myPlaces = [[NSMutableArray alloc] init];
    myVicinities = [[NSMutableArray alloc] init];
    myLongs = [[NSMutableArray alloc] init];
    myLats = [[NSMutableArray alloc] init];
    
    for(NSDictionary *placesDict in businessArray){
        [myPlaces addObject:placesDict[@"name"]];
        [myVicinities addObject:placesDict[@"vicinity"]];
        
    }
    
    NSLog(@"%@", myPlaces);
//    myPlaces = [[NSMutableArray alloc] initWithObjects:@"Test Object 1", @"Test Object 2", nil];
    
    
    
    CGRect frame = self.mapHolderView.frame;
    frame.size.height = 250;
    self.mapHolderView.frame = frame;
    
    self.mapView.delegate = self;
    
    NSString *loc = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
    NSMutableArray *pins = [[NSMutableArray alloc] init];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
    NSLog(@"WHATWHATWHATWHAT: %@", businessArray);
    for(NSDictionary *placesDict in businessArray){
        
        float lon = [placesDict[@"geometry"][@"location"][@"lng"] floatValue];
        [myLongs addObject:[NSNumber numberWithFloat:[placesDict[@"geometry"][@"location"][@"lng"] floatValue]]];
        float lat = [placesDict[@"geometry"][@"location"][@"lat"] floatValue];
        [myLats addObject:[NSNumber numberWithFloat:[placesDict[@"geometry"][@"location"][@"lat"] floatValue]]];
        NSLog(@"YYYYYYYYYYYYY: %f, %f", lon, lat);
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
        
        MKCoordinateRegion region = {coord, span};
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coord];
        
        annotation.title = placesDict[@"name"];
        NSLog(@"LOLOLOLOLOLOLOL%@", annotation.title);
        annotation.subtitle = placesDict[@"vicinity"];
        
        [pins addObject:annotation];
    }
    
    NSLog(@"PINSSSSSSSSSSS: %@", pins);
    
    
    float lon = [[[loc componentsSeparatedByString:@","] objectAtIndex:1] floatValue];
    float lat = [[[loc componentsSeparatedByString:@","] objectAtIndex:0] floatValue];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
    
    MKCoordinateRegion region = {coord, span};
    
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    [annotation setCoordinate:coord];
//    
//    annotation.title = @"You are here";
//    annotation.subtitle = @"Current location";
//    
//    [pins addObject:annotation];
    
    [mapView setRegion:region];
    [mapView addAnnotations:pins];

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
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSLog(@"CELL VICINITY: %@", [myVicinities objectAtIndex:(long)indexPath.row]);
    NSLog(@"CELL NAME: %@", [myPlaces objectAtIndex:(long)indexPath.row]);
    NSLog(@"CELL LAT LONG: %@,%@", [myLats objectAtIndex:(long)indexPath.row], [myLongs objectAtIndex:(long)indexPath.row]);
    
    [[NSUserDefaults standardUserDefaults] setObject:[myPlaces objectAtIndex:(long)indexPath.row] forKey:@"FINAL_NAME"];
    [[NSUserDefaults standardUserDefaults] setObject:[myVicinities objectAtIndex:(long)indexPath.row] forKey:@"FINAL_VICINITY"];
    [[NSUserDefaults standardUserDefaults] setObject:[myLats objectAtIndex:(long)indexPath.row] forKey:@"FINAL_LAT"];
    [[NSUserDefaults standardUserDefaults] setObject:[myLongs objectAtIndex:(long)indexPath.row] forKey:@"FINAL_LONG"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //NEED TO GET ATTENDEES
    
    
    
    
    
    //NOTIFY FRIENDS
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    NSArray *friendsList = [[NSUserDefaults standardUserDefaults] objectForKey:@"FriendsPicked"];
    NSLog(@"friends list: %@",friendsList);
//    for (NSDictionary<FBGraphUser>* friend in friendsList) {
//        NSLog(@"friend? %@",friend);
//    }
    
    for (NSDictionary<FBGraphUser>* friend in friendsList) {
                NSLog(@"shit %@ with id %@", friend[@"name"], friend[@"id"]);
        
        [[[myRootRef childByAppendingPath:friend[@"name"]] childByAppendingPath:@"pending invitations"] setValue:@"lmao"];
        
        
    }
    
    //ADD TO NEW EVENT ENTRY
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    
    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
    [[myRootRef childByAppendingPath:@"locName"] setValue:[myPlaces objectAtIndex:(long)indexPath.row]];
    [[myRootRef childByAppendingPath:@"locVicinity"] setValue:[myVicinities objectAtIndex:(long)indexPath.row]];
    [[myRootRef childByAppendingPath:@"locLat"] setValue:[myLats objectAtIndex:(long)indexPath.row]];
    [[myRootRef childByAppendingPath:@"locLong"] setValue:[myLongs objectAtIndex:(long)indexPath.row]];
    
    [[myRootRef childByAppendingPath:@"host"] setValue:name];
    
    Firebase *subRef = [myRootRef childByAutoId];
    
    
    
    [[subRef childByAppendingPath:@"name"] setValue:name];
    
    NSString *loc = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
    
    [[subRef childByAppendingPath:@"loc"] setValue:loc];

    
    
    
    
    
    
    UIStoryboard *storyboard = [self storyboard];
    FinalizeViewController *finalizeController = [storyboard instantiateViewControllerWithIdentifier:@"FinalizeViewController"];
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:finalizeController];
    navBar.navigationBar.tintColor = [UIColor whiteColor];
    navBar.navigationBar.barStyle = UIBarStyleBlack;
    navBar.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.navigationBar.barTintColor = [UIColor colorWithRed:0.4 green:0.6 blue:1 alpha:1]; /*#6699ff*/
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
    
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
