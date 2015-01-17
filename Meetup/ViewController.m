//
//  ViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
#import "AppDelegate.h">
//#include "<sys/types.h">

NSString *invitations;

@interface ViewController () <FBFriendPickerDelegate, FBLoginViewDelegate> {
    
    BOOL *pickedFriends;
    NSString *facebookId;
    CLLocationManager *locationManager;
    NSString *name;
    CLLocation *updatedLocation;
    AppDelegate *appDelegate;
    
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
    appDelegate = [[UIApplication sharedApplication] delegate];
    pickedFriends = false;
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]];
    
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
    

    
}


- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"didUpdateToLocation: %f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
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
    [[NSUserDefaults standardUserDefaults] setObject:test forKey:@"Location"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)name
{
    return name;
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
//        
//        
//        if ([snapshot.valueInExportFormat rangeOfString:@","].location == NSNotFound) {
//            NSLog(@"change detected %@",snapshot.valueInExportFormat);
//        
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [[NSDate date] dateByAddingTimeInterval:3];
//            notification.alertBody = @"New event!";
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            notification.category =  @"INVITE_CATEGORY";
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//
//            
//        }
        
//        NSLog(@"%@", snapshot.description);
        
        
        
    }];
    
    [locationManager startUpdatingLocation];
    
}


//
//-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
//    
//    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
//    [[myRootRef childByAppendingPath:name] observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {
//        //        NSLog(@"lmao %@",snapshot.valueInExportFormat);
//        
//        //        NSString *string = @"hello bla bla";
//        
//        if ([snapshot.valueInExportFormat rangeOfString:@","].location == NSNotFound) {
//            NSLog(@"change detected %@",snapshot.valueInExportFormat);
//            
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [[NSDate date] dateByAddingTimeInterval:3];
//            notification.alertBody = @"New event!";
//            notification.soundName = UILocalNotificationDefaultSoundName;
//            notification.category =  @"INVITE_CATEGORY";
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//            
//            
//        }
//        
//        //        NSLog(@"%@", snapshot.description);
//        
//        
//        
//    }];
//
//    
//    completionHandler(UIBackgroundFetchResultNewData);
//
//}


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
//    NSLog(@"Selected friends: %@", friendPickerController.selection);
//    NSMutableString *temp;
//    NSLog(@"lmao: %i friends", friendPickerController.selection.count);
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    
    for (NSDictionary<FBGraphUser>* friend in friendPickerController.selection) {
//        NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);

         [[[myRootRef childByAppendingPath:friend.name] childByAppendingPath:@"pending invitations"] setValue:@"lmao"];
        
    
    }
    
    //create new event
    myRootRef = nil;
    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com"];
    
//    [[myRootRef childByAppendingPath:@"lmao"] setValue:name];
    
    [[[myRootRef childByAppendingPath:@"lmao"] childByAutoId] setValue:name];
    
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"mykey"
//                                                    secret:@"mysecret"];
//    
//    NSURL *url = [NSURL URLWithString:@"https://example.com/user/1/flights/"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
//                                                                   consumer:consumer
//                                                                      token:accessToken
//                                                                      realm:nil
//                                                          signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
//    
//    OARequestParameter *nameParam = [[OARequestParameter alloc] initWithName:@"title"
//                                                                       value:@"My Page"];
//    OARequestParameter *descParam = [[OARequestParameter alloc] initWithName:@"description"
//                                                                       value:@"My Page Holds Text"];
//    NSArray *params = [NSArray arrayWithObjects:nameParam, descParam, nil];
//    [request setParameters:params];
//    
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(apiTicket:didFinishWithData:)
//                  didFailSelector:@selector(apiTicket:didFailWithError:)];
//    
//    
    
    
    
    
    
    // Dismiss the friend picker
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
