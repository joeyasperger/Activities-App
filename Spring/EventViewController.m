//
//  EventViewController.m
//  Spring
//
//  Created by Joseph Asperger on 11/8/14.
//
//

#import "EventViewController.h"
#import "EventHeaderCell.h"
#import "EventInterestCell.h"
#import "EventWritePostCell.h"
#import "EventPostCell.h"

#define WRITE_POST_SECTION 2
#define DISPLAY_POSTS_SECTION_START 3

@interface EventViewController ()

@property UILabel *interestLabel;
@property UIButton *joinButton;
@property UITextField *postField;
@property BOOL isWritingPost;
@property NSArray *posts;
@property BOOL didLoadPosts;

@end

@implementation EventViewController

-(void) viewDidLoad{
    self.navigationItem.title = self.event[@"displayName"];
    //UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //[self.tableView addGestureRecognizer:gestureRecognizer];
    [self loadPosts];
}

- (void) loadPosts{
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"EventPost"];
    [postsQuery whereKey:@"event" equalTo:self.event];
    [postsQuery includeKey:@"user"];
    [postsQuery orderByDescending:@"createdAt"];
    [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            self.posts = objects;
            self.didLoadPosts = YES;
            [self.tableView reloadData];
        }
    }];
}

-(void) joinButtonPressed{
    [self.joinButton setImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateNormal];
    [self.joinButton setTitle:@"Joined" forState:UIControlStateNormal];
    self.joinButton.userInteractionEnabled = NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == WRITE_POST_SECTION){
        if (!self.isWritingPost){
            self.isWritingPost = YES;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(void) hideKeyboard{
    [self.postField resignFirstResponder];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,460)];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.didLoadPosts){
        return 3;
    }
    else{
        return 3 + [self.posts count];
    }
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 163;
    }
    else if (indexPath.section == 1){
        return 44;
    }
    else if (indexPath.section == WRITE_POST_SECTION){
        if (self.isWritingPost){
            return 70;
        }else{
            return 44;
        }
    }
    else{
        return 60;
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
        [cell.activityButton setTitle:activity[@"name"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1){
        static NSString *simpleTableIdentifier = @"EventInterestCell";
        
        EventInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.joinButton = cell.joinButton;
        self.interestLabel = cell.interestLabel;
        self.interestLabel.text = [NSString stringWithFormat:@"%ld People Interested", [self.event[@"numberInterested"] integerValue]];
        [self.joinButton addTarget:self action:@selector(joinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section == WRITE_POST_SECTION){
        if (!self.isWritingPost){
            static NSString *simpleTableIdentifier = @"EventPostButtonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            return cell;
        }
        else{
            EventWritePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventWritePostCell" forIndexPath:indexPath];
            self.postField = cell.postField;
            self.postField.delegate = self;
            [self.postField becomeFirstResponder];
            return cell;
        }
    }
    else if (indexPath.section >= DISPLAY_POSTS_SECTION_START){
        EventPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventPostCell" forIndexPath:indexPath];
        PFObject *post = self.posts[indexPath.section - DISPLAY_POSTS_SECTION_START];
        cell.postLabel.text = post[@"content"];
        return cell;
    }
    else{
        return nil;
    }
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section >= DISPLAY_POSTS_SECTION_START){
        PFObject *post = self.posts[section - DISPLAY_POSTS_SECTION_START];
        PFUser *user = post[@"user"];
        return user[@"displayName"];
        return nil;
    }
    else{
        return nil;
    }
}

-(void) textFieldDidChange:(UITextField*)textField{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    PFObject *eventPost = [PFObject objectWithClassName:@"EventPost"];
    eventPost[@"user"] = [PFUser currentUser];
    eventPost[@"event"] = self.event;
    eventPost[@"content"] = textField.text;
    self.isWritingPost = NO;
    [textField resignFirstResponder];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:WRITE_POST_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [eventPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [self loadPosts];
        }
    }];
    [textField setText:@""];
    return NO;
}


@end
