//
//  PlacesViewController.h
//  Meetup
//
//  Created by Amundeep Singh on 1/17/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol PlacesViewControllerDelegate;


@interface PlacesViewController : UITableViewController
{
    id<PlacesViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<PlacesViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *myPlaces;
@property (strong, nonatomic) NSMutableArray *myVicinities;
@property (strong, nonatomic) NSMutableArray *myLats;
@property (strong, nonatomic) NSMutableArray *myLongs;
@property (strong, nonatomic) IBOutlet UIView *mapHolderView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@protocol PlacesViewControllerDelegate <NSObject>

- (void)PlacesViewController:(PlacesViewController*)PlacesViewController didFinishWithSelection:(NSUInteger)selection;

@end