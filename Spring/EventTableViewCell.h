//
//  EventTableViewCell.h
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
