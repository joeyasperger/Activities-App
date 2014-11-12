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

@end

@implementation SelectEventLocationViewController

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    //self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(90, 0, 0, 0);
    
    self.mapView.padding = mapInsets;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    //self.view = self.mapView;
    [self.view insertSubview:self.mapView atIndex:0];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
}

@end
