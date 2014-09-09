#import "GRSonnetRootTableCell.h"
#import "GRSonnetRootTableCellView.h"
#import "GRPlistModel.h"

@implementation GRSonnetRootTableCell

@synthesize sonnet, view;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) 
    {
        
        UIImage *bkgd = [UIImage imageNamed:@"littleBackground.png"];
        UIImageView *bkgdView = [[UIImageView alloc] initWithFrame:frame];
        [bkgdView setImage:bkgd];
        self.backgroundView = bkgdView;
        [bkgdView release];
        
		CGRect contentFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		self.view = [[GRSonnetRootTableCellView alloc] initWithFrame:contentFrame];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:self.view];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        view.cell = self;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    [view setHighlighted:selected];
}

- (void)dealloc {
    [view release]; view = nil;
    [sonnet release]; sonnet = nil;
	[super dealloc];
}

-(GRSonnet *)sonnet;
{
    return [self.view sonnet];
}

-(void)setSonnet:(GRSonnet *)aSonnet;
{
    [self.view setSonnet: aSonnet];
}

//=========================================================== 
//  sonetTextFont 
//=========================================================== 
- (UIFont *)sonnetTextFont
{
    //NSLog(@"in -sonetTextFont, returned sonetTextFont = %@", sonetTextFont);
    return [self.view sonetTextFont];
}
- (void)setSonnetTextFont:(UIFont *)aSonetTextFont
{
    //NSLog(@"in -setSonetTextFont:, old value of sonetTextFont: %@, changed to: %@", sonetTextFont, aSonetTextFont);
    [self.view setSonetTextFont:aSonetTextFont];
}

//=========================================================== 
//  leftSideLabelFont 
//=========================================================== 
- (UIFont *)leftSideLabelFont
{
    //NSLog(@"in -leftSideLabelFont, returned leftSideLabelFont = %@", leftSideLabelFont);
    return [self.view leftSideLabelFont]; 
}
- (void)setLeftSideLabelFont:(UIFont *)aLeftSideLabelFont
{
    //NSLog(@"in -setLeftSideLabelFont:, old value of leftSideLabelFont: %@, changed to: %@", leftSideLabelFont, aLeftSideLabelFont);
    [self.view setLeftSideLabelFont:aLeftSideLabelFont];
}


@end
