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

@end

@implementation SelectEventLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.latitude = 37.43;
    self.longitude = -122.17;
    if (self.passedLocation){
        self.latitude = self.location.latitude;
        self.longitude = self.location.longitude;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.latitude longitude:self.longitude zoom:17];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    UIEdgeInsets mapInsets = UIEdgeInsetsMake(90, 0, 0, 0);
    self.mapView.padding = mapInsets;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.compassButton = YES;
    [self.view insertSubview:self.mapView atIndex:0];
    self.mapView.delegate = self;
    
    UIImage *markerImage = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    UIImageView *pinView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - markerImage.size.width/2, self.view.frame.size.height/2, markerImage.size.width, markerImage.size.height)];
    pinView.image = markerImage;
    [self.view addSubview:pinView];
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
    return NO;
}


-(void) mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    [self hideKeyboard];
}

-(void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self hideKeyboard];
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
            //NSLog(@"Google Data: %@", places);
            BOOL didSetCamera = NO;
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
                if (!didSetCamera){
                    self.mapView.selectedMarker = marker;
                    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude)];
                    [self.mapView animateWithCameraUpdate:update];
                    didSetCamera = YES;
                }
            }
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    NSString *locationName = nil;
    [self.delegate recieveLocation:self.mapView.camera.target name:locationName];

}

@end
