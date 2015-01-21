//
//  SelectEventLocationViewController.m
//  Spring
//
//  Created by Joseph Asperger on 11/11/14.
//
//

#import "SelectEventLocationViewController.h"


@interface SelectEventLocationViewController ()

@property GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property double latitude;
@property double longitude;

@end

@implementation SelectEventLocationViewController

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    self.latitude = 37.43;
    self.longitude = -122.17;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude
                                                            longitude:self.longitude
                                                                 zoom:13];
    //self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(90, 0, 0, 0);
    
    self.mapView.padding = mapInsets;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    //self.view = self.mapView;
    [self.view insertSubview:self.mapView atIndex:0];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    int searchDistance = 50000;
    CLLocationCoordinate2D currentMapLoc = self.mapView.camera.target;
    NSString *googleAPIKey = @"AIzaSyAK-qDZMj2bO2itJk_c16o09H23WZaiJO8";
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&keyword=%@&radius=%@&sensor=false&key=%@", currentMapLoc.latitude, currentMapLoc.longitude, searchBar.text,[NSString stringWithFormat:@"%i", searchDistance], googleAPIKey];
    NSLog(@"%@", url);
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

-(void)fetchedData:(NSData *)responseData {
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
                marker.map = self.mapView;
                if (!didSetSelected){
                    self.mapView.selectedMarker = marker;
                    didSetSelected = YES;
                    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)];
                    [self.mapView animateWithCameraUpdate:update];
                }
            }
        }
    }
}

@end
