#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GRSonnetRootTableCellView;
@class GRPlistModel;
@class GRSonnet;

@interface GRSonnetRootTableCell : UITableViewCell {
    GRSonnetRootTableCellView *view;
    GRSonnet *sonnet;
}

@property(nonatomic, retain)GRSonnet *sonnet;
@property(nonatomic, retain)GRSonnetRootTableCellView *view;
@property(nonatomic, retain)UIFont *sonnetTextFont;
@property(nonatomic, retain)UIFont *leftSideLabelFont;

@end
