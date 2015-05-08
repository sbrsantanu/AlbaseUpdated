//
//  DirectionViewController.h
//  Albase
//
//  Created by Mac on 26/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DirectionViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property (assign) float Currentlat;
@property (assign) float Currentlong;
@property (assign) float Destinationlat;
@property (assign) float DestinationLong;

@end
