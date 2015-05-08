//
//  OCRMapViewViewController.m
//  Albase
//
//  Created by Mac on 28/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRMapViewViewController.h"
#import "UIColor+HexColor.h"
#import "MFSideMenu.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SPGooglePlacesAutocomplete.h"
#import "DirectionViewController.h"


#import "P2MSMapViewController.h"
#import "P2MSGlobalFunctions.h"
#import "P2MSMapHelper.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface OCRMapViewViewController ()
{
    GMSMapView *mapView_;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
}
@property (assign) float DescLat;
@property (assign) float DescLong;
@end

@implementation OCRMapViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self=(IsIphone5)?[super initWithNibName:@"SPGooglePlacesAutocompleteDemoViewController" bundle:nil]:[super initWithNibName:@"SPGooglePlacesAutocompleteDemoViewController" bundle:nil];
        searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyDtRdNIuvkvb3VOPRgiuaCaMYFFBPivXnY"];
        shouldBeginEditing = YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.searchDisplayController.searchBar.placeholder = @"Search or Address";
    //[[self.navigationController navigationBar] setHidden:YES];
    
    UIView *HeaderView = (UIView *)[self.view viewWithTag:110];
    [HeaderView setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    UILabel *Titlelabel = (UILabel *)[self.view viewWithTag:888];
    [Titlelabel setText:@"Root"];
    [Titlelabel setTextColor:[UIColor whiteColor]];
    [Titlelabel setFont:[UIFont fontWithName:@"Helvetica" size:18.0f]];
    
    UIButton *SetButton = (UIButton *)[self.view viewWithTag:111];
    [SetButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *SetButton1 = (UIButton *)[self.view viewWithTag:116];
    [SetButton1 addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view bringSubviewToFront:HeaderView];
    
    self.LocationManager = [[CLLocationManager alloc] init];
    [self.LocationManager setDelegate:self];
    [self.LocationManager requestWhenInUseAuthorization];
    [self.LocationManager requestAlwaysAuthorization];
    [self.LocationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.LocationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.LocationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setDelegate:self];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    /*
    
    // API za koordinate zadanog grada
    NSString* city = @"Kolkata";
    NSString* serverPath = [[NSString alloc] initWithFormat:@("https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyCbQwlpEl2MRB-il9MljyU5wCcR8fOXEfQ"), city];
    
    NSLog(@"serverPath --- %@",serverPath);
    
    NSURL* serverUrl = [[NSURL alloc] initWithString:serverPath];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:serverUrl];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               latitude = [[[[[responseDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"]valueForKey:@"lat" ] doubleValue];
                           }];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               longitude = [[[[[responseDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"]valueForKey:@"lng" ] doubleValue];
                           }];
    
    NSLog(@"latitude & longitude ==== %f ***** %f",latitude,longitude);
     
     */
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    CLLocationCoordinate2D location;
    location.latitude = self.LocationManager.location.coordinate.latitude;
    location.longitude = self.LocationManager.location.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [mapView setRegion:region animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locations array error -- %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   // CLLocation *LocationManager = [locations lastObject];
    [self.LocationManager stopUpdatingLocation];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        NSLog(@"Menu bar button prassed..");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return searchResultPlaces[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)recenterMapToPlacemark:(CLPlacemark *)placemark {
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    
    region.span = span;
    region.center = placemark.location.coordinate;
    
    [self.mapView setRegion:region];
}

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemark addressString:(NSString *)address {
    [self.mapView removeAnnotation:selectedPlaceAnnotation];
    
    selectedPlaceAnnotation = [[MKPointAnnotation alloc] init];
    selectedPlaceAnnotation.coordinate = placemark.location.coordinate;
    selectedPlaceAnnotation.title = address;
    [self.mapView addAnnotation:selectedPlaceAnnotation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not map selected Place"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else if (placemark) {
            
            _DescLat = placemark.location.coordinate.latitude;
            _DescLong = placemark.location.coordinate.longitude;
            
            P2MSMapViewController *mapViewC = [[P2MSMapViewController alloc]initWithNibName:nil bundle:nil];
            UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:mapViewC];
            [navCtrl setNavigationBarHidden:YES animated:NO];
            [mapViewC setDefaultLocation:addressString withCoordinate:CLLocationCoordinate2DMake(_DescLat, _DescLong)];
            mapViewC.mapType = MAP_TYPE_GOOGLE;
            mapViewC.mapAPISource = MAP_API_SOURCE_GOOGLE;
            mapViewC.allowDroppedPin = YES;
            [self.navigationController pushViewController:mapViewC animated:YES];
            
          /*  [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
            [self recenterMapToPlacemark:placemark];
            [self.searchDisplayController setActive:NO];
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
           
           */
        }
    }];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    searchQuery.location = self.mapView.userLocation.coordinate;
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
        [self.mapView removeAnnotation:selectedPlaceAnnotation];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

#pragma mark -
#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapViewIn viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (mapViewIn != self.mapView || [annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *annotationIdentifier = @"SPGooglePlacesAutocompleteAnnotation";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout = YES;
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [detailButton addTarget:self action:@selector(annotationDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Whenever we've dropped a pin on the map, immediately select it to present its callout bubble.
    [self.mapView selectAnnotation:selectedPlaceAnnotation animated:YES];
}

- (void)annotationDetailButtonPressed:(id)sender {
    
    P2MSMapViewController *mapViewC = [[P2MSMapViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navCtrl = [[UINavigationController alloc]initWithRootViewController:mapViewC];
    [navCtrl setNavigationBarHidden:YES animated:NO];
    [mapViewC setDefaultLocation:@"Jadavpur University" withCoordinate:CLLocationCoordinate2DMake(_DescLat, _DescLong)];
    mapViewC.mapType = MAP_TYPE_GOOGLE;
    mapViewC.mapAPISource = MAP_API_SOURCE_GOOGLE;
    mapViewC.allowDroppedPin = YES;
    [self.navigationController pushViewController:mapViewC animated:YES];
   /*
    DirectionViewController *DirectionView = [[DirectionViewController alloc] initWithNibName:@"DirectionViewController" bundle:nil];
    DirectionView.Destinationlat = _DescLat;
    DirectionView.DestinationLong = _DescLong;
    [self.navigationController pushViewController:DirectionView animated:YES];
    */
}

@end
