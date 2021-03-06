//
//  ViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h"
#import "NewEventController.h"

NSString *invitations;

@interface ViewController () <FBFriendPickerDelegate, FBLoginViewDelegate> {
    
    BOOL *pickedFriends;
    NSString *facebookId;
    CLLocationManager *locationManager;
    NSString *name;
    CLLocation *updatedLocation;
    AppDelegate *appDelegate;
    FBFriendPickerViewController *friendPickerController;
    
}


@end

@implementation ViewController
@synthesize pickedFriends;
@synthesize friendSelection;
@synthesize facebookId;
@synthesize locationManager;
@synthesize name;
@synthesize updatedLocation;
@synthesize loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    pickedFriends = false;
    
    [loginView initWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]];
    
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (self.view.center.y - (loginView.frame.size.height / 2)));
    
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
//    [friendPickerController loadData];

    
}


- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"didUpdateToLocation: %f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    updatedLocation = newLocation;

    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    Firebase *locRef = [[myRootRef childByAppendingPath:name] childByAppendingPath:@"location"];
    //    [myRootRef setValue:user.name];
    CLLocationDegrees lat = updatedLocation.coordinate.latitude;
    CLLocationDegrees lng = updatedLocation.coordinate.longitude;
    NSString *test = [NSString stringWithFormat:@"%f,%f", lat, lng];
    [locRef setValue:test];
    [[NSUserDefaults standardUserDefaults] setObject:test forKey:@"Location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//user data fetched


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    self.profilePictureView.profileID = user.id;
//    self.nameLabel.text = user.name;
    NSLog(@"OH HELLO THERE");
    name = user.name;
    appDelegate.superName = user.name;
//    super.super.super.name = user.name;
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    Firebase *locRef = [[myRootRef childByAppendingPath:name] childByAppendingPath:@"location"];
    
    [[myRootRef childByAppendingPath:name] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if(![snapshot hasChild:@"pending invitations"]){
            [[[myRootRef childByAppendingPath:name] childByAppendingPath:@"pending invitations"] setValue:@""];
        }
        
        invitations = snapshot.value[@"pending invitations"];
//        NSLog(invitations);
    }];
    
    //listen for new event
//    Firebase *eventRef = [[myRootRef childByAppendingPath:name] childByAppendingPath:@"pending invitations"];
    [[myRootRef childByAppendingPath:name] observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"lmao %@",snapshot.valueInExportFormat);

        
        
        
    }];
    
    [locationManager startUpdatingLocation];
   
    
    
    //-----------------------
    
    
    
    [self performSegueWithIdentifier:@"FBSegue" sender:self];  //COMMENT THIS OUT TO LOG OUT OF FACEBOOK

    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(pickedFriends == false){
        // Initialize the friend picker
        friendPickerController =
        [[FBFriendPickerViewController alloc] init];
        
//        FBViewController *controller = [[FBViewController alloc]init];
        
        friendPickerController.delegate = self;
        // Set the friend picker title
        friendPickerController.title = @"Pick Friends";
    
        // TODO: Set up the delegate to handle picker callbacks, ex: Done/Cancel button
        
    
        // Load the friend data
        [friendPickerController loadData];
        // Show the picker modally
//        [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
//        pickedFriends = true;
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
//    NSLog(@"Selected friends: %@", friendPickerController.selection);
//    NSMutableString *temp;
//    NSLog(@"lmao: %i friends", friendPickerController.selection.count);
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    
    for (NSDictionary<FBGraphUser>* friend in friendPickerController.selection) {
//        NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);

        [[NSUserDefaults standardUserDefaults] setObject:friendPickerController.selection forKey:@"FriendsPicked"]; //NSARRAY
//        
//         [[[myRootRef childByAppendingPath:friend.name] childByAppendingPath:@"pending invitations"] setValue:@"lmao"];
        
    
    }
    
    //create new event
    myRootRef = nil;
    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com"];
    
//    [[myRootRef childByAppendingPath:@"lmao"] setValue:name];
    
    [[[myRootRef childByAppendingPath:@"lmao"] childByAutoId] setValue:name];
    
    
    
    
    
    // Dismiss the friend picker
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
