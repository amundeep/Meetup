//
//  NewEventController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/17/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "NewEventController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Firebase/Firebase.h"
#import <Foundation/Foundation.h>
#import "YPAPISample.h"
#import "PlacesViewController.h"


@interface NewEventController () <FBFriendPickerDelegate> {
    
    FBFriendPickerViewController *friendPickerController;
    BOOL *pickedFriends;
    NSMutableArray *locNames;
    NSMutableArray *locLats;
    NSMutableArray *locLongs;
//    PlacesViewController *placesViewController;
//    UINavigationController* navController;
    
    
}

@end

@implementation NewEventController
@synthesize mainTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pickedFriends = false;
    NSLog(@"stfu");
//    
//    locNames = [[NSMutableArray alloc] init];
//    locLats = [[NSMutableArray alloc] init];
//    locLongs = [[NSMutableArray alloc] init];
//
    
//    placesViewController = [[PlacesViewController alloc] initWithNibName:@"PlacesViewController" bundle:nil];
//    placesViewController.delegate = self;
//    navController = [[UINavigationController alloc] initWithRootViewController:placesViewController];
    
//    UIEdgeInsets inset = UIEdgeInsetsMake(50, 0, 0, 0);
//    self.mainTable.contentInset = inset;
//    self.mainTable.scrollIndicatorInsets = inset;
    
    // Remove extra separators
    self.mainTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}



- (IBAction)openFriendPicker:(id)sender {
    
    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
    pickedFriends = true;
    
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
    
//    locNames = [[NSMutableArray alloc] init];
    
    
//    for (NSDictionary<FBGraphUser>* friend in friendPickerController.selection) {
//        //        NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//        
//        [[[myRootRef childByAppendingPath:friend.name] childByAppendingPath:@"pending invitations"] setValue:@"lmao"];
//        
//        
//    }
    
    //create new event
//    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
//    
//    Firebase *subRef = [myRootRef childByAutoId];
//    
//    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
//    
//    [[subRef childByAppendingPath:@"name"] setValue:name];
//    
//    NSString *loc = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
//
//    
//    [[subRef childByAppendingPath:@"loc"] setValue:loc];
    
    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com/"];
    
    [[NSUserDefaults standardUserDefaults] setObject:friendPickerController.selection forKey:@"FriendsPicked"]; //NSARRAY
    
    NSLog(@"arr: %@",friendPickerController.selection);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    for (NSDictionary<FBGraphUser>* friend in friendPickerController.selection) {
        [[myRootRef childByAppendingPath:friend.name] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            NSLog(@"%@", snapshot.value[@"location"]);
//            invitations = snapshot.value[@"pending invitations"];
            NSString *tempLoc = snapshot.value[@"location"];
            locNames = [[NSMutableArray alloc] init];
            locLats = [[NSMutableArray alloc] init];
            locLongs = [[NSMutableArray alloc] init];
            NSLog(@"%@", friend.name);
            [locNames addObject:friend.name];
            [locLats addObject:[[tempLoc componentsSeparatedByString:@","] objectAtIndex:0]];
            [locLongs addObject:[[tempLoc componentsSeparatedByString:@","] objectAtIndex:1]];
            NSLog(@"%@: %@, %@", locNames, locLats, locLongs);
            [self calcMidpoint];
            
        }];
        
        
    }
    
}


//- (void)showOptionView
//{
//    
////    placesViewController.delegate = self;
//    
//    [self.navigationController presentModalViewController:navController animated:YES];
//    [navController release];
//    [placesViewController release];
//}
//
//- (void)PlacesViewController:(PlacesViewController*)PlacesViewController didFinishWithSelection:(NSUInteger)selection
//{
//    // Do something with selection here
//    
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//}

-(void)calcMidpoint{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    NSString *loc = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
    
    [locNames addObject:name];
    [locLats addObject:[[loc componentsSeparatedByString:@","] objectAtIndex:0]];
    [locLongs addObject:[[loc componentsSeparatedByString:@","] objectAtIndex:1]];
    NSLog(@"0000000000%@: %@, %@", locNames, locLats, locLongs);
    
    double totalLat = 0;
    double totalLong = 0;
    
    for(NSUInteger index = 0; index < locNames.count; index++){
        totalLat += [[locLats objectAtIndex:index] doubleValue];
        totalLong += [[locLongs objectAtIndex:index] doubleValue];
    }
    
    totalLat /= locNames.count;
    totalLong /= locNames.count;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.8f", totalLat] forKey:@"TotalLat"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.8f", totalLong] forKey:@"TotalLong"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"11111111111: %f, %f", totalLat, totalLong);
    
    
    YPAPISample *APISample = [[YPAPISample alloc] init];
    
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryTopBusinessInfoForTerm:@"lmao" location:@"san fran" completionHandler:^(NSDictionary *topBusinessJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (topBusinessJSON) { //SUCCESS
            NSArray *businessArray = topBusinessJSON[@"results"];
            NSLog(@"_____________ ARRAY__________ %@.  Length: %i", businessArray, businessArray.count);
            
            [[NSUserDefaults standardUserDefaults] setObject:businessArray forKey:@"PlacesArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            for(NSDictionary *placesDict in businessArray){
                NSLog(@"Place Name: %@", placesDict[@"name"]);
                
            }
        } else {                 //ERROR
            NSLog(@"MASSIVE ERROR FATAL DESTRUCTION");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.

//    [self showOptionView];
    
    UIStoryboard *storyboard = [self storyboard];
    PlacesViewController *placesViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlacesViewController"];
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:placesViewController];
    navBar.navigationBar.tintColor = [UIColor whiteColor];
    navBar.navigationBar.barStyle = UIBarStyleBlack;
    navBar.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.navigationBar.barTintColor = [UIColor colorWithRed:0.4 green:0.6 blue:1 alpha:1]; /*#6699ff*/
    
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
//    [navBar release];
//    [placesViewController release];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
