//
//  OCRMapViewViewController.h
//  Albase
//
//  Created by Mac on 28/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OCRGlobalMethods.h"
@class SPGooglePlacesAutocompleteQuery;

@interface OCRMapViewViewController : OCRGlobalMethods<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate,UISearchBarDelegate>
{
    CLLocationManager *locationManager;
    NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    MKPointAnnotation *selectedPlaceAnnotation;
    
    BOOL shouldBeginEditing;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) CLLocationManager *LocationManager;
@end
