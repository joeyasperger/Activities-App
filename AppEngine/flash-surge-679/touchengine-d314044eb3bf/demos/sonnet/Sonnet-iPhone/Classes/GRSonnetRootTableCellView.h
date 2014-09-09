//
//  GRSonnetRootTableCellView.h
//  Sonnet
//
//  Created by Jonathan Saggau on 11/9/08.
//  Copyright 2008 Jonathan Saggau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GRPlistModel;
@class GRSonnetRootTableCell;
@class GRSonnet;

@interface GRSonnetRootTableCellView : UIView {
    GRSonnet *sonnet;
    BOOL highlighted;
//    BOOL editing;
    GRSonnetRootTableCell *cell;
@private
    UILabel *sonetTextLabel;
    UILabel *leftSideLabel;
}

@property(nonatomic, retain)GRSonnet *sonnet;
@property(nonatomic, retain)UIFont *sonetTextFont;
@property(nonatomic, retain)UIFont *leftSideLabelFont;

@property(nonatomic, getter=isHighlighted) BOOL highlighted;
@property(nonatomic, retain)GRSonnetRootTableCell *cell;


@end
