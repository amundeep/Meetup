//
//  AppDelegate.h
//  Meetup
//
//  Created by Amundeep Singh on 1/16/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) NSString *superName;
 

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

