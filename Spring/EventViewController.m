//
//  EventViewController.m
//  Spring
//
//  Created by Joseph Asperger on 11/8/14.
//
//

#import "EventViewController.h"
#import "EventHeaderCell.h"

@implementation EventViewController

-(void) viewDidLoad{
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 163;
    }
    else{
        return 44;
    }
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        static NSString *simpleTableIdentifier = @"EventHeaderCell";
        
        EventHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        
        PFUser *creator = self.event[@"creator"];
        PFObject *activity = self.event[@"activity"];
        
        cell.nameLabel.text = self.event[@"name"];
        [cell.nameLabel sizeToFit];
        NSDate *date = self.event[@"time"];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        cell.timeLabel.text = [dateFormatter stringFromDate:date];
        cell.creatorNameLabel.text = creator[@"displayName"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1){
        static NSString *simpleTableIdentifier = @"EventInterestCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        return nil;
    }
}


@end
