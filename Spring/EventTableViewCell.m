//
//  EventTableViewCell.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize userLabel = _userLabel;
@synthesize messageLabel = _messageLabel;
@synthesize imageView = _imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
