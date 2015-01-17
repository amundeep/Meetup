//
//  ViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>

@interface ViewController () <FBFriendPickerDelegate, FBLoginViewDelegate> {
    
    BOOL *pickedFriends;
    NSString *facebookId;
    CLLocationManager *locationManager;
    NSString *name;
    CLLocation *updatedLocation;
    
}


@end

@implementation ViewController
@synthesize pickedFriends;
@synthesize friendSelection;
@synthesize facebookId;
@synthesize locationManager;
@synthesize name;
@synthesize updatedLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickedFriends = false;
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:

     @[@"public_profile", @"email", @"user_friends"]];
    
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    [self.view addSubview:loginView];
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", friends.count);
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
        }
    }];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [locationManager requestAlwaysAuthorization];
    
    
    NSLog(@"%@", [self deviceLocation]);
    
    
    // Write data to Firebase
    
    
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    updatedLocation = newLocation;
    
//    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
//    }
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    Firebase *locRef = [[myRootRef childByAppendingPath:name] childByAppendingPath:@"location"];
    //    [myRootRef setValue:user.name];
    CLLocationDegrees lat = updatedLocation.coordinate.latitude;
    CLLocationDegrees lng = updatedLocation.coordinate.longitude;
    NSString *test = [NSString stringWithFormat:@"%f,%f", lat, lng];
    [locRef setValue:test];
}

//user data fetched

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
    
    name = user.name;
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    Firebase *locRef = [[myRootRef childByAppendingPath:name] childByAppendingPath:@"location"];
    
    [[myRootRef childByAppendingPath:name] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(![snapshot hasChild:@"pending invitations"]){
            [[[myRootRef childByAppendingPath:name] childByAppendingPath:@"pending invitations"] setValue:@""];
        }
    }];
    
    [locationManager startUpdatingLocation];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    if(pickedFriends == false){
        // Initialize the friend picker
        FBFriendPickerViewController *friendPickerController =
        [[FBFriendPickerViewController alloc] init];
        
//        FBViewController *controller = [[FBViewController alloc]init];
        
        friendPickerController.delegate = self;
        // Set the friend picker title
        friendPickerController.title = @"Pick Friends";
    
        // TODO: Set up the delegate to handle picker callbacks, ex: Done/Cancel button
        
    
        // Load the friend data
        [friendPickerController loadData];
        // Show the picker modally
        [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
        pickedFriends = true;
//        
//        NSLog(@"selected: %i friends", friendSelection.count);
//        for (NSDictionary<FBGraphUser>* friend in friendSelection) {
//            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//        }
    }
    

}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerController =
    (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friends: %@", friendPickerController.selection);
    
    NSLog(@"lmao: %i friends", friendPickerController.selection.count);
    for (NSDictionary<FBGraphUser>* friend in friendPickerController.selection) {
        NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
    }
    // Dismiss the friend picker
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
