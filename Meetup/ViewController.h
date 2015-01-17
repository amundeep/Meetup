//
//  ViewController.h
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic) BOOL *pickedFriends;
@property (nonatomic, retain, readonly) NSArray *friendSelection;
@property  (nonatomic, retain) NSString *facebookId;
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) CLLocation *updatedLocation;
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;



@end

