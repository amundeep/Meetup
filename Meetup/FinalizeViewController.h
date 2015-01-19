//
//  FinalizeViewController.h
//  Meetup
//
//  Created by Amundeep Singh on 1/18/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface FinalizeViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapHolderView;
@property (strong, nonatomic) IBOutlet UIButton *locButton;
@property (strong, nonatomic) IBOutlet UILabel *peopleLabel;



@end
