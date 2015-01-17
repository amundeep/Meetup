//
//  ViewController.h
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController

@property (nonatomic) BOOL *pickedFriends;
@property (nonatomic, retain, readonly) NSArray *friendSelection;

@end

