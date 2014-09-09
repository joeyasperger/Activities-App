//
//  GRSonnetRootTableCellView.m
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import "GRSonnetRootTableCellView.h"

#import "GRSonnetRootTableCell.h"
#import "GRPlistModel.h"
#import "GRSonnet.h"

@interface GRSonnetRootTableCellView ()

@property(nonatomic, retain)UILabel *sonetTextLabel;
@property(nonatomic, retain)UILabel *leftSideLabel;

@end


@implementation GRSonnetRootTableCellView

@synthesize sonetTextLabel;
@synthesize leftSideLabel;
@synthesize cell;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        
        sonetTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sonetTextLabel.opaque = YES;
        sonetTextLabel.backgroundColor = [UIColor clearColor];
		sonetTextLabel.font = [UIFont fontWithName:@"Zapfino" size:10];
		sonetTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        sonetTextLabel.minimumFontSize = 8;
        sonetTextLabel.textAlignment = UITextAlignmentCenter;
        sonetTextLabel.adjustsFontSizeToFitWidth = YES;
        sonetTextLabel.numberOfLines = 3;
		sonetTextLabel.text = @"Sonet empty";
        [self addSubview:sonetTextLabel];
        
        leftSideLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        leftSideLabel.opaque = YES;
        leftSideLabel.backgroundColor = [UIColor clearColor];
		sonetTextLabel.font = [UIFont fontWithName:@"Zapfino" size:12];
		leftSideLabel.lineBreakMode = UILineBreakModeWordWrap;
        leftSideLabel.minimumFontSize = 9;
        leftSideLabel.textAlignment = UITextAlignmentCenter;
        leftSideLabel.adjustsFontSizeToFitWidth = YES;
        leftSideLabel.numberOfLines = 1;
		leftSideLabel.text = @"Left Empty";
        [self addSubview:leftSideLabel];
    }
    return self;
}

- (BOOL)isHighlighted
{
    return highlighted;
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) 
    {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}

-(GRSonnet *)sonnet;
{
    return sonnet; 
}
-(void)setSonnet:(GRSonnet *)aSonnet;
{
    if (sonnet != aSonnet) 
    {
        [aSonnet retain];
        [sonnet release];
        sonnet = aSonnet;
        
        //puts the right text in the labels and lays stuff out
        [self layoutSubviews];
    }
}

- (void)layoutSubviews;
{
    self.sonetTextLabel.text = [sonnet text];
    self.leftSideLabel.text = [sonnet romanNumeral];
    UIColor *mainTextColor = nil;
    
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
        //self.imageView.backgroundColor = [UIColor redColor];
	}
	else {
		mainTextColor = [UIColor blackColor];
		//self.backgroundColor = [UIColor whiteColor];
        //self.imageView.backgroundColor = [UIColor whiteColor];
	}
    
    self.sonetTextLabel.textColor = mainTextColor;
    self.leftSideLabel.textColor = mainTextColor;
    
    CGRect cellViewFrame = self.frame;
    CGRect sonetTextLabelFrame = CGRectZero;
    CGRect leftSideLabelFrame = CGRectZero;
    CGFloat padding = 4.0;
    
    CGSize sizedToFit = [self.leftSideLabel.text sizeWithFont:self.leftSideLabel.font];
    
    //CGSize sizedToFit = [@"XXXXXX" sizeWithFont:self.leftSideLabel.font];
    
    leftSideLabelFrame.size.height = cellViewFrame.size.height;
    leftSideLabelFrame.size.width = sizedToFit.width + 6.0; // the font I use is slanted and needs a little room in places
    leftSideLabelFrame.origin.x = cellViewFrame.origin.x + padding;
    leftSideLabelFrame.origin.y = cellViewFrame.origin.y + padding;
    leftSideLabel.frame = leftSideLabelFrame;
//    leftSideLabel.backgroundColor = [UIColor redColor];
    
    sonetTextLabelFrame.origin.x = leftSideLabelFrame.origin.x + leftSideLabelFrame.size.width + padding;
    sonetTextLabelFrame.origin.y = cellViewFrame.origin.y;
    sonetTextLabelFrame.size.width = cellViewFrame.size.width - leftSideLabelFrame.size.width - (padding * 2.0f) - 6;
    sonetTextLabelFrame.size.height = leftSideLabelFrame.size.height;
    sonetTextLabel.frame = sonetTextLabelFrame;
//    sonetTextLabel.backgroundColor = [UIColor greenColor];
}

//=========================================================== 
//  sonetTextFont 
//=========================================================== 
- (UIFont *)sonetTextFont
{
    //NSLog(@"in -sonetTextFont, returned sonetTextFont = %@", sonetTextFont);
    return [self.sonetTextLabel font]; 
}
- (void)setSonetTextFont:(UIFont *)aSonetTextFont
{
    //NSLog(@"in -setSonetTextFont:, old value of sonetTextFont: %@, changed to: %@", 
    [self.sonetTextLabel setFont:aSonetTextFont];
}

//=========================================================== 
//  leftSideLabelFont 
//=========================================================== 
- (UIFont *)leftSideLabelFont
{
    //NSLog(@"in -leftSideLabelFont, returned leftSideLabelFont = %@", leftSideLabelFont);
    return [self.leftSideLabel font]; 
}
- (void)setLeftSideLabelFont:(UIFont *)aLeftSideLabelFont
{
    //NSLog(@"in -setLeftSideLabelFont:, old value of leftSideLabelFont: %@, changed to: %@", leftSideLabelFont, aLeftSideLabelFont);
    [self.leftSideLabel setFont:aLeftSideLabelFont];
}

- (void)dealloc {
    [sonnet release]; sonnet = nil;
    [cell release]; cell = nil;
    [leftSideLabel release]; leftSideLabel = nil;
    [sonetTextLabel release]; sonetTextLabel = nil;
    [super dealloc];
}


@end
