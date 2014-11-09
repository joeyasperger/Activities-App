//
//  EventHeaderCell.h
//  Spring
//
//  Created by Joseph Asperger on 11/8/14.
//
//

#import <UIKit/UIKit.h>

@interface EventHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
