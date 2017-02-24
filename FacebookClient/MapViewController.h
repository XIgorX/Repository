//
//  MapViewController.h
//  FacebookClient
//
//  Created by Igor on 19.02.17.
//  Copyright © 2017 Igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (retain, nonatomic) NSString *photoID;

@property (retain, nonatomic) NSString *latitude;
@property (retain, nonatomic) NSString *longitude;

//@property (retain, nonatomic) NSString *locationName;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil photoID:(NSString *)photoID bundle:(NSBundle *)nibBundleOrNil;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

//-(CLLocationCoordinate2D) addressLocation;

@end
