//
//  ViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <FBFriendPickerDelegate>{
    
    BOOL *pickedFriends;
    
}


@end

@implementation ViewController
@synthesize pickedFriends;
@synthesize friendSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickedFriends = false;
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"public_profile", @"email", @"user_friends"]];
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
        
        NSLog(@"selected: %i friends", friendSelection.count);
        for (NSDictionary<FBGraphUser>* friend in friendSelection) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
        }
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
