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
@synthesize mapHolderView;
@synthesize mapView;
@synthesize cancelButton;


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
        float lat = [placesDict[@"geometry"][@"location"][@"lat"] floatValue];
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
