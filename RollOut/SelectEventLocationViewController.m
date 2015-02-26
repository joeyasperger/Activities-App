//
//  SelectEventLocationViewController.m
//  Spring
//
//  Created by Joseph Asperger on 11/11/14.
//
//

#import "SelectEventLocationViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface SelectEventLocationViewController ()

@property GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property double latitude;
@property double longitude;
@property GMSMarker *eventLocationMarker;

@end

@implementation SelectEventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    self.latitude = 37.43;
    self.longitude = -122.17;
    if (self.passedLocation){
        self.latitude = self.location.latitude;
        self.longitude = self.location.longitude;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:13];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(90, 0, 0, 0);
    
    self.mapView.padding = mapInsets;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    [self.view insertSubview:self.mapView atIndex:0];
    self.mapView.delegate = self;
    self.eventLocationMarker = [GMSMarker new];
    self.eventLocationMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    self.eventLocationMarker.position = CLLocationCoordinate2DMake(self.latitude , self.longitude);
    self.eventLocationMarker.map = self.mapView;
    self.mapView.selectedMarker = self.eventLocationMarker;
    self.eventLocationMarker.title = @"Event Location";
    self.eventLocationMarker.draggable = YES;
}

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    int searchDistance = 50000;
    CLLocationCoordinate2D currentMapLoc = self.mapView.camera.target;
    NSString *googleAPIKey = @"AIzaSyAK-qDZMj2bO2itJk_c16o09H23WZaiJO8";
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&keyword=%@&radius=%@&sensor=false&key=%@", currentMapLoc.latitude, currentMapLoc.longitude, searchBar.text,[NSString stringWithFormat:@"%i", searchDistance], googleAPIKey];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *googleRequestURL = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL options:kNilOptions error:&error];
        if (error){
            NSLog(@"%@", error.userInfo[@"error"]);
        }
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    [searchBar resignFirstResponder];
}

-(BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    [self hideKeyboard];
    if (marker != self.eventLocationMarker){
        [self resetMarkerColor:self.eventLocationMarker];
        // select new marker and set its color to green
        self.eventLocationMarker = marker;
        mapView.selectedMarker = marker;
        mapView.selectedMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    }
    mapView.selectedMarker = marker;
    return YES;
}

-(void) mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    [self hideKeyboard];
    if (marker != self.eventLocationMarker){
        [self resetMarkerColor:self.eventLocationMarker];
        // select new marker and set its color to green
        self.eventLocationMarker = marker;
        mapView.selectedMarker = marker;
        mapView.selectedMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    }
    marker.title = @"Event Location";
    marker.snippet = nil;
    mapView.selectedMarker = marker;
}

-(void) mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    [self hideKeyboard];
}

-(void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self hideKeyboard];
}

-(GMSMarker*) resetMarkerColor:(GMSMarker*)marker{
    if ([marker.title  isEqual: @"Event Location"]){
        marker.map = nil;
        return nil;
    }
    GMSMarker *newMarker = [GMSMarker new];
    newMarker.position = marker.position;
    newMarker.title = marker.title;
    newMarker.snippet = marker.snippet;
    marker.map = nil; //remove old selected marker from map
    newMarker.map = self.mapView;
    newMarker.draggable = YES;
    return newMarker;
}

-(void) hideKeyboard{
    [self.searchBar resignFirstResponder];
}

-(void) fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    if (responseData){
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions
                              error:&error];
        if (error){
            NSLog(@"%@", error.userInfo[@"error"]);
        }else if ([json objectForKey:@"error_message"] != nil){
            NSString *error = [json objectForKey:@"error_message"];
            NSLog(@"%@", error);
        }
        else{
            //success!
            //NSLog(@"Google Data: %@", places);
            BOOL didSetSelected = NO;
            [self.mapView clear];
            NSArray* places = [json objectForKey:@"results"];
            for (NSDictionary *place in places){
                NSString *name = place[@"name"];
                NSDictionary *geometry = place[@"geometry"];
                NSDictionary *location = geometry[@"location"];
                double longitude = [location[@"lng"] doubleValue];
                double latitude = [location[@"lat"] doubleValue];
                NSString *address = place[@"vicinity"];
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(latitude , longitude);
                marker.title = name;
                marker.snippet = address;
                marker.draggable = YES;
                marker.map = self.mapView;
                if (!didSetSelected){
                    self.eventLocationMarker = marker;
                    self.mapView.selectedMarker = marker;
                    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                    didSetSelected = YES;
                    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)];
                    [self.mapView animateWithCameraUpdate:update];
                }
            }
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    NSString *locationName = nil;
    if (![self.eventLocationMarker.title isEqualToString:@"Event Location"]){
        locationName = self.eventLocationMarker.title;
    }
    [self.delegate recieveLocation:self.eventLocationMarker.position name:locationName];
}

@end
