//
//  FinalizeViewController.m
//  Meetup
//
//  Created by Amundeep Singh on 1/18/15.
//  Copyright (c) 2015 Amundeep Singh. All rights reserved.
//

#import "FinalizeViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MapKit/MapKit.h>

@interface FinalizeViewController (){
    NSString *vicinity;
    NSString *name;
    CLLocationCoordinate2D coord;
    MKPointAnnotation *annotation;
}

@end

@implementation FinalizeViewController
@synthesize locButton;
@synthesize peopleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frame = self.mapHolderView.frame;
    frame.size.height = 250;
    self.mapHolderView.frame = frame;
    
    self.mapView.delegate = self;
    
    
    name = [[NSUserDefaults standardUserDefaults] objectForKey:@"FINAL_NAME"];
    vicinity =[[NSUserDefaults standardUserDefaults] objectForKey:@"FINAL_VICINITY"];
    float lat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FINAL_LAT"] floatValue];
    float lon = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FINAL_LONG"] floatValue];
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
    coord = CLLocationCoordinate2DMake(lat, lon);
    
    MKCoordinateRegion region = {coord, span};
    
    annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    
    annotation.title = name;
    annotation.subtitle = vicinity;
    
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:annotation];
    
    [locButton setTitle:[NSString stringWithFormat:@"%@ (%@)", name, vicinity] forState:(UIControlStateNormal)];
    [locButton.titleLabel setNumberOfLines:3];
    [locButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [locButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [locButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [locButton setUserInteractionEnabled:NO];
    locButton.autoresizesSubviews = YES;
    locButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}
- (IBAction)getDirections:(id)sender {
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[annotation coordinate] addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:name];
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:options];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.textColor = [UIColor colorWithRed:0.4 green:0.6 blue:1 alpha:1]; /*#6699ff*/
}

- (IBAction)goBack:(id)sender {
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)orderPostmates:(id)sender {
   NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"];
    NSLog(@"You just ordered Postmates!");
    
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        
        NSArray *recipents = @[@"4085604283"];
        controller.body = [NSString stringWithFormat:@"[Your order] from [restaurant] to %@ - %@", vicinity,name];
        controller.view.tag = 1;
        controller.messageComposeDelegate = self;
        controller.recipients = recipents;
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:controller animated:YES completion:nil];
    }
    
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
