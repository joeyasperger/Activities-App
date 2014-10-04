//
//  PrivacyPickerViewController.h
//  Spring
//
//  Created by Joseph Asperger on 10/2/14.
//
//

#import <UIKit/UIKit.h>

@protocol EventPrivacyDelegate

- (void) recievePrivacySettings:(NSInteger) privacyType;

@end

@interface PrivacyPickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property id<EventPrivacyDelegate> delegate;
@property NSInteger initialSelection;

@end
