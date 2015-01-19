

//
//  AppDelegate.m
//  Zen
//
//  Created by Zuhayeer Musa on 1/16/15.
//  Copyright (c) 2015 Zuhayeer Musa. All rights reserved.
//

#import "AppDelegate.h"
#import <Firebase/Firebase.h>
#import <MapKit/MapKit.h>

NSString * const kInviteCategoryIdentifier = @"INVITE_CATEGORY";
bool watching;
@interface AppDelegate (){

Firebase *myRootRef;

}
@end

@implementation AppDelegate
@synthesize superName;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
    // create actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Yes";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;   // If YES requires passcode, but does not unlock the device
    
    UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
    declineAction.identifier = @"DECLINE_IDENTIFIER";
    declineAction.title = @"No";
    declineAction.activationMode = UIUserNotificationActivationModeBackground;
    declineAction.destructive = NO;
    declineAction.authenticationRequired = NO;
    
    // create a category
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = kInviteCategoryIdentifier;
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction, declineAction]
                    forContext:UIUserNotificationActionContextMinimal];
    
    // registration
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    watching = true;
    __block UIBackgroundTaskIdentifier background_task;

    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //run the app without startUpdatingLocation. backgroundTimeRemaining decremented from 600.00

        while(watching)
        {

            [NSThread sleepForTimeInterval:1]; //wait for 1 sec

            Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];

                    [[myRootRef childByAppendingPath:superName] observeEventType:FEventTypeChildChanged withBlock:^(FDataSnapshot *snapshot) {

                        if ([snapshot.valueInExportFormat rangeOfString:@","].location == NSNotFound) {

                            UILocalNotification *notification = [[UILocalNotification alloc] init];
                            if(watching){

                               watching = false;
                                [self sendNotification];
                            }

                        }

                    }];



        }

        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    });

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.attosoft.Zen.Zen" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Zen" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Zen.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark helpers/handlers

-(void)sendNotification {
    
    Firebase *rootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    NSLog(@"sending notif");
//    NSString *eventName = [[rootRef childByAppendingPath:superName] childByAppendingPath:@"pending invitations"];

        Firebase *eventRef = [[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
        
//        eventRef = [eventRef childByAppendingPath:eventName];
        
        
        [[eventRef childByAppendingPath:@"locName"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *newSnap) {
            
            [[eventRef childByAppendingPath:@"host"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *hostSnap) {
                NSLog(@"snap val %@",[newSnap value]);
                NSString *locName = [newSnap value];
                NSString *hostName = [hostSnap value];
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [[NSDate date] dateByAddingTimeInterval:0];
                notification.alertBody =  [NSString stringWithFormat:@"Attend hangout at %@ with %@?", locName,hostName];
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.category = kInviteCategoryIdentifier;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }];

        }];
    
    
//    Firebase *eventRef = [[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com"];
//    
//    eventRef = [eventRef childByAppendingPath:eventName];
    
    
    NSString *locName;
//    NSString *locName = [eventRef valueForKeyPath:@"locName"];
    

//    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
    
    
    
   
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        
        Firebase *subRef = [myRootRef childByAutoId];
        
        [[subRef childByAppendingPath:@"name"] setValue:superName];
        
        NSString *loc = [[NSUserDefaults standardUserDefaults] objectForKey:@"Location"];
        
        [[subRef childByAppendingPath:@"loc"] setValue:loc];
        
        //myRootRef =[[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
        subRef = [[Firebase alloc] initWithUrl:@"https://downtime.firebaseio.com"];
        
        [[[subRef childByAppendingPath:superName] childByAppendingPath:@"pending invitations"] setValue:@""];
        
        
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://downtime-events.firebaseio.com/lmao"];
        
        [[myRootRef childByAppendingPath:@"locLat"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *latSnap) {
            [[myRootRef childByAppendingPath:@"locLong"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *longSnap) {
//            NSLog(@"snap val %@",[newSnap value]);
                NSString *lat = [latSnap value];
                NSString *lng = [longSnap value];
                
                float latitude = [lat floatValue];
                float longitude = [lng floatValue];
            
            }];
        }];
        
        NSLog(@"%@",superName);

    }
    else if ([identifier isEqualToString:@"DECLINE_IDENTIFIER"]) {
        NSLog(@"Lights off.");
    }
    
    if (completionHandler) {
        completionHandler();
    }
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

