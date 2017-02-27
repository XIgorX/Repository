//
//  MapViewController.m
//  FacebookClient
//
//  Created by Igor on 19.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

//#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>

//#import <GoogleMapsBase/GoogleMapsBase.h>

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil photoID:(NSString *)photoID bundle:(NSBundle *)nibBundleOrNil
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    self.photoID = photoID;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:self.photoID
                                  parameters:@{@"fields": @"place"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[[result objectForKey:@"place"] valueForKey:@"id"]
                                      parameters:@{@"fields": @"name,location"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            
            //self.locationName = [result valueForKey:@"name"];
            
            self.latitude = [[result valueForKey:@"location"] valueForKey:@"latitude"];
            self.longitude = [[result valueForKey:@"location"] valueForKey:@"longitude"];
            
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.2;
            span.longitudeDelta=0.2;
            
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);;
            region.span=span;
            region.center=location;
            
            //if(addAnnotation != nil) {
            //    [mapView removeAnnotation:addAnnotation];
            //    [addAnnotation release];
            //    addAnnotation = nil;
            //}
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = location;
            
            [self.mapView addAnnotation:annotation];
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
        }];
    }];
    
    
    //Скрываем клавиатуру
    //MKCoordinateRegion region;
    //MKCoordinateSpan span;
    //span.latitudeDelta=0.2;
    //span.longitudeDelta=0.2;
    
    //CLLocationCoordinate2D location = [self addressLocation];
    //region.span=span;
    //region.center=location;
    /*if(addAnnotation != nil) {
        [mapView removeAnnotation:addAnnotation];
        [addAnnotation release];
        addAnnotation = nil;
    }
    addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
    [mapView addAnnotation:addAnnotation];
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];*/
}

//-(CLLocationCoordinate2D) addressLocation {
    /*NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                           [addressField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Отображение ошибки
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;*/
//}


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
