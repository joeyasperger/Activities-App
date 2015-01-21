//
//  EventTableViewCell.m
//  Spring
//
//  Created by Joseph Asperger on 9/6/14.
//
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

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

- (void)setFrame:(CGRect)frame {
    int inset = 10;
    int heightInset = 0;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    frame.origin.y += heightInset;
    frame.size.height -= 2 * heightInset;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
