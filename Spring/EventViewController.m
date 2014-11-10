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

@interface EventViewController ()

@property UILabel *interestLabel;
@property UIButton *joinButton;
@property UITextField *postField;
@property BOOL isWritingPost;

@end

@implementation EventViewController

-(void) viewDidLoad{
    self.navigationItem.title = self.event[@"displayName"];
}


-(void) joinButtonPressed{
    [self.joinButton setImage:[UIImage imageNamed:@"Checkmark"] forState:UIControlStateNormal];
    [self.joinButton setTitle:@"Joined" forState:UIControlStateNormal];
    self.joinButton.userInteractionEnabled = NO;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2){
        if (!self.isWritingPost){
            self.isWritingPost = YES;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

/*-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return YES; }


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES; }


- (void)keyboardWillShow:(NSNotification *)notification
{
    //Assign new frame to your view
    NSDictionary *info = [notification userInfo];
    CGRect endRect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginRect = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSInteger animationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSNumber *animationDuration = info[UIKeyboardAnimationDurationUserInfoKey];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[animationDuration doubleValue]];
    CGRect oldFrame = self.tableView.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y-endRect.size.height, oldFrame.size.width, oldFrame.size.height-endRect.size.height);
    [UIView setAnimationCurve:animationCurve];
    CGSize contentsize = self.tableView.contentSize;
    //[self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    [self.view setFrame:newFrame];
    [UIView commitAnimations];
    
}*/

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,320,460)];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
    else{
        if (self.isWritingPost){
            return 70;
        }else{
            return 44;
        }
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
    else if (indexPath.section == 2){
        if (!self.isWritingPost){
            static NSString *simpleTableIdentifier = @"EventPostButtonCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
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
    else{
        return nil;
    }
}


@end
