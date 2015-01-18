//
//  PlacesViewController.h
//  Meetup
//
//  Created by Amundeep Singh on 1/17/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlacesViewControllerDelegate;


@interface PlacesViewController : UITableViewController
{
    id<PlacesViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<PlacesViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *myPlaces;

@end

@protocol PlacesViewControllerDelegate <NSObject>

- (void)PlacesViewController:(PlacesViewController*)PlacesViewController didFinishWithSelection:(NSUInteger)selection;

@end