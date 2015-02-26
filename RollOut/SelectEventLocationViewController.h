//
//  SelectEventLocationViewController.h
//  Spring
//
//  Created by Joseph Asperger on 11/11/14.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol SelectEventLocationDelegate

- (void) recieveLocation:(CLLocationCoordinate2D) location;

@end

@interface SelectEventLocationViewController : UIViewController<UISearchBarDelegate, GMSMapViewDelegate>

@property id<SelectEventLocationDelegate> delegate;
@property CLLocationCoordinate2D location; //for location to be passed through segue
@property BOOL passedLocation; // says whether the a location was passed through the segue
@end


